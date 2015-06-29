require 'liquid'
require 'sass'
require 'yaml'
require 'pdfkit'

class PreviewGenerator

  def initialize
    @header = File.open("lib/resources/header.html", "rb").read
    @footer = File.open("lib/resources/footer.html", "rb").read
    @data = YAML.load_file('lib/data.yaml')

    if true # multi-page invoice
      lines = Array.new
      50.times do
        @data['Lines'].each do |l|
          lines << l.dup
        end
      end
      @data['Lines'] = lines
    end
  end

  def generate
    Dir.mkdir('invoice_previews') unless Dir.exist?('invoice_previews')

    puts '------------------------'
    Dir.entries('invoice_designs').select {|entry| !(entry =='.' || entry == '..') }.each do |d|
      generate_preview d
      puts '------------------------'
    end
  end


  private

  def generate_preview(invoice_name)
    puts "Generating previews for '#{invoice_name}'"
    dir = "invoice_previews/#{invoice_name}/"
    Dir.mkdir(dir) unless Dir.exist?(dir)

    css = generate_css invoice_name
    html = generate_html invoice_name
    generate_pdf invoice_name if html && css

    puts ' DONE'
  end

  def generate_css(invoice_name)
    # CSS
    begin
      source_scss = File.open("invoice_designs/#{invoice_name}/invoice.scss", "rb").read
      engine = Sass::Engine.new(source_scss, :syntax => :scss)
      output_css = engine.render
      dir = "invoice_previews/#{invoice_name}/"
      File.write(dir + 'invoice.css', output_css)
    rescue Exception => e
      puts ' Error: could not parse css'
      puts ' ' +e.message
      return
    end
    output_css
  end


  def generate_html(invoice_name)
    begin
      source_html = File.open("invoice_designs/#{invoice_name}/invoice.html", "rb").read
      output_html = Liquid::Template.parse(@header + source_html + @footer).render 'Invoice' => @data
      dir = "invoice_previews/#{invoice_name}/"
      File.write(dir + 'invoice.html', output_html)
    rescue Exception => e
      puts ' Error: could not parse html'
      puts ' ' +e.message
      return
    end
    output_html
  end

  def generate_pdf(invoice_name)
    kit = PDFKit.new(File.open("invoice_previews/#{invoice_name}/invoice.html", "rb").read, {        :page_size => 'A4',
                                                                                                     :margin_top => '1cm',
                                                                                                     :margin_right => '1cm',
                                                                                                     :margin_bottom => '1cm',
                                                                                                     :margin_left => '1cm',})
    kit.stylesheets << "invoice_previews/#{invoice_name}/invoice.css"
    kit.to_file("invoice_previews/#{invoice_name}/invoice.pdf")
  end


end