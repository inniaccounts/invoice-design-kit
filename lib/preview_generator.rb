require 'liquid'
require 'sass'
require 'yaml'
require 'pdfkit'
require 'json'
require 'tempfile'

PDFKit.configure do |config|
  config.verbose = true
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
    errors = []

    begin
      settings = File.open("invoice_designs/#{invoice_name}/invoice.json", "rb").read
      settings = JSON.parse(settings)
    rescue Exception => e
      errors << ' Error: could not load json'
      errors << ' ' + e.message
      settings = Hash.new
    end

    errors << ' Error: missing name from json' if !settings.has_key? 'name'
    errors << ' Error: missing author from json' if !settings.has_key? 'author'

    if settings.has_key? 'userSettings'
      es = settings['userSettings'] - %w(font-title font-body color-primary color-secondary)
      if (es).count > 0
        errors << " Error: unknown userSettings in json (#{es.join(', ')})"
      end
    end

    if errors.length > 0
      puts errors.join("\n")
      return
    end

    # Defaults
    settings['orientation'] = 'Portrait' if !settings.has_key?('orientation')
    settings['marginTop'] = '1cm' if !settings.has_key?('marginTop')
    settings['marginRight'] = '1cm' if !settings.has_key?('marginRight')
    settings['marginBottom'] = '1cm' if !settings.has_key?('marginBottom')
    settings['marginLeft'] = '1cm' if !settings.has_key?('marginLeft')

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

    # Prepare settings for PDFKit, based on settings in invoice json file
    pdf_settings = Hash.new
    pdf_settings[:page_size] = 'A4'
    pdf_settings[:orientation] = settings['orientation']
    pdf_settings[:margin_top] = settings['marginTop']
    pdf_settings[:margin_right] = settings['marginRight']
    pdf_settings[:margin_bottom] = settings['marginBottom']
    pdf_settings[:margin_left] = settings['marginLeft']

    # Approach:
    #  Create a temp directory
    #  Generate header, footer and body html files, including the html headers / footers - i.e. valid html files
    #  Copy css in to temp directory
    #  Pass the whole lot to wkhtmltopdf
    #  Delete temp dir

    # Set up temp directory
    dir = Dir.mktmpdir

    if header
      File.write("#{dir}/header.html", @html_header + header + @html_footer)
      pdf_settings[:header_html] = "file://#{dir}/header.html"
    end

    if footer
      File.write("#{dir}/footer.html", @html_header + footer + @html_footer)
      pdf_settings[:footer_html] = "file://#{dir}/footer.html"
    end

    # We'll always have at least a body...
    File.write("#{dir}/body.html", @html_header + body + @html_footer)
    body_path = "#{dir}/body.html"

    # Copy css
    FileUtils.copy("invoice_previews/#{invoice_name}/style.css", "#{dir}/style.css")
    FileUtils.copy("lib/resources/font-awesome.css", "#{dir}/font-awesome.css")
    FileUtils.copy("lib/resources/fontawesome-webfont.ttf", "#{dir}/fontawesome-webfont.ttf")


    # Generate PDF
    kit = PDFKit.new(File.new(body_path), pdf_settings)
    kit.to_file("invoice_previews/#{invoice_name}/invoice.pdf")

    # Remove temp dir
    FileUtils.remove_entry_secure dir
  end


end