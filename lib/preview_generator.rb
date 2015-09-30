require 'liquid'
require 'sass'
require 'yaml'
require 'pdfkit'
require 'tempfile'
require 'rbconfig'

def is_windows?
  !(RbConfig::CONFIG['host_os'] =~ /mswin|msys|mingw|cygwin|bccwin|wince/).nil?
end

PDFKit.configure do |config|
  config.verbose = true
  if is_windows?
    config.wkhtmltopdf = 'c:\progra~1\wkhtmltopdf\bin\wkhtmltopdf.exe'
  end
end


class PreviewGenerator

  def initialize
    @html_header = File.open("lib/resources/header.html", "rb").read
    @html_footer = File.open("lib/resources/footer.html", "rb").read
    @invoice_data = YAML.load_file('lib/data.yaml')

    if true # multi-page invoice
      lines = Array.new
      50.times do
        @invoice_data['Lines'].each do |l|
          lines << l.dup
        end
      end
      @invoice_data['Lines'] = lines
    end

    if is_windows?
      # There's a risk if you're on windows with a high resolution screen that your
      # dpi will be > 96dpi, the standard for windows. This will cause invoices to be 
      # the wrong size. I've not yet figured out how to get the dpi, so warn for large screens.

        require 'dl' 
        user32 = DL.dlopen("user32")
        setaware = DL::CFunc.new(user32['SetProcessDPIAware'], DL::TYPE_INT)
        r = setaware.call([])
        gsm = DL::CFunc.new(user32['GetSystemMetrics'], DL::TYPE_INT)
        x = gsm.call([0])
        y = gsm.call([1])

        if x >= 2000
          puts 'WARNING TO WINDOWS USERS'
          puts 'You appear to be using a high resolution display'
          puts 'Unless the display is set to 96dpi your invoices may'
          puts 'not preview correctly.'
        end
    end

  end

  def generate
    Dir.mkdir('invoice_previews') unless Dir.exist?('invoice_previews')

    puts '------------------------'
    Dir.entries('invoice_designs').select {|entry| !entry.include?('.') }.each do |d|
      generate_preview d
      puts '------------------------'
    end
  end


  private

  def generate_preview(invoice_name)
    puts "Generating previews for '#{invoice_name}'"
    dir = "invoice_previews/#{invoice_name}/"
    Dir.mkdir(dir) unless Dir.exist?(dir)

    settings = load_and_validate_settings(invoice_name)
    return if !settings

    css = generate_css invoice_name

    header = merge_html invoice_name, :header
    body = merge_html invoice_name, :body
    footer = merge_html invoice_name, :footer

    generate_html_preview invoice_name, header, body, footer
    generate_pdf invoice_name, settings, header, body, footer if body && css

    puts ' DONE'
  end

  def load_and_validate_settings(invoice_name)

    setting_names = %w(name author page-margin-top page-margin-bottom page-margin-left page-margin-right)

    errors = []

    begin
      source = File.open("invoice_designs/#{invoice_name}/style.scss", "rb").read
      settings = Hash.new
      setting_names.each do |sn|
        m = /\$#{sn}:\s*(.*)\s*;/.match(source)
        if m
          settings[sn] = m[1].gsub("'","")
        end
      end
    rescue Exception => e
      errors << ' Error: could not load css'
      errors << ' ' + e.message
      settings = Hash.new
    end

    errors << ' Error: missing name from settings' if !settings.has_key? 'name'
    errors << ' Error: missing author from settings' if !settings.has_key? 'author'

    if errors.length > 0
      puts errors.join("\n")
      return
    end

    # Defaults
    settings['orientation'] = 'Portrait' if !settings.has_key?('orientation')
    settings['page-margin-top'] = '1cm' if !settings.has_key?('page-margin-top')
    settings['page-margin-right'] = '1cm' if !settings.has_key?('page-margin-right')
    settings['page-margin-bottom'] = '1cm' if !settings.has_key?('page-margin-bottom')
    settings['page-margin-left'] = '1cm' if !settings.has_key?('page-margin-left')

    settings
  end

  def generate_css(invoice_name)
    # CSS
    begin
      source_scss = File.open("invoice_designs/#{invoice_name}/style.scss", "rb").read
      engine = Sass::Engine.new(source_scss, :syntax => :scss)
      output_css = engine.render
      dir = "invoice_previews/#{invoice_name}/"
      File.write(dir + 'style.css', output_css)
    rescue Exception => e
      puts ' Error: could not parse css'
      puts ' ' +e.message
      return
    end
    output_css
  end

  def merge_html(invoice_name, part_name)
    # Merges data in to liquify template tags
    # Does not add html headers / footers
    file_name = "invoice_designs/#{invoice_name}/#{part_name.to_s}.html"
    return if !File.exist?(file_name)

    begin
      source_html = File.open(file_name, "rb").read
      output_html = Liquid::Template.parse(source_html).render 'Invoice' => @invoice_data
    rescue Exception => e
      puts " Error: could not parse #{part_name} html"
      puts ' ' +e.message
      return
    end

    output_html
  end

  def generate_html_preview(invoice_name, header, body, footer)
    output_html = @html_header + header + body + footer + @html_footer
    File.write("invoice_previews/#{invoice_name}/invoice.html", output_html)
  end

  def generate_pdf(invoice_name, settings, header, body, footer)

    # Prepare settings for PDFKit, based on settings in invoice SCSS file
    pdf_settings = Hash.new
    pdf_settings[:page_size] = 'A4'
    pdf_settings[:orientation] = settings['orientation']
    pdf_settings[:margin_top] = settings['page-margin-top']
    pdf_settings[:margin_right] = settings['page-margin-right']
    pdf_settings[:margin_bottom] = settings['page-margin-bottom']
    pdf_settings[:margin_left] = settings['page-margin-left']
    # pdf_settings[:zoom] = 1.33

    # Approach:
    #  Create a temp directory
    #  Generate header, footer and body html files, including the html headers / footers - i.e. valid html files
    #  Copy css in to temp directory
    #  Pass the whole lot to wkhtmltopdf
    #  Delete temp dir

    # Set up temp directory
    dir = Dir.mktmpdir

	prefix = "file://"
	prefix += '/' if is_windows?
	
    if header
      File.write("#{dir}/header.html", @html_header + header + @html_footer)
      pdf_settings[:header_html] = "#{prefix}#{dir}/header.html"	  
    end

    if footer
      File.write("#{dir}/footer.html", @html_header + footer + @html_footer)
	  pdf_settings[:footer_html] = "#{prefix}#{dir}/footer.html"	  
    end

    # We'll always have at least a body...
    File.write("#{dir}/body.html", @html_header + body + @html_footer)
    body_path = "#{dir}/body.html"

    # Copy css
    FileUtils.copy("invoice_previews/#{invoice_name}/style.css", "#{dir}/style.css")
    FileUtils.copy("lib/resources/font-awesome.css", "#{dir}/font-awesome.css")


    # Generate PDF
    kit = PDFKit.new(File.new(body_path), pdf_settings)
    kit.to_file("invoice_previews/#{invoice_name}/invoice.pdf")

    # Remove temp dir - fails on windows, let the OS take care of tidying up
    # FileUtils.remove_entry_secure dir
  end


end