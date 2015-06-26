require 'liquid'
require 'sass'
require 'yaml'

class PreviewGenerator

  def initialize
    @header = File.open("lib/resources/header.html", "rb").read
    @footer = File.open("lib/resources/footer.html", "rb").read
    @data = YAML.load_file('lib/data.yaml')
  end

  def generate
    puts '------------------------'
    Dir.entries('invoice_designs').select {|entry| !(entry =='.' || entry == '..') }.each do |d|
      generate_preview d
      puts '------------------------'
    end
  end


  private

  def generate_preview(invoice_name)
    puts "Generating previews for '#{invoice_name}'"
    begin
      source_html = File.open("invoice_designs/#{invoice_name}/invoice.html", "rb").read
      source_scss = File.open("invoice_designs/#{invoice_name}/invoice.scss", "rb").read
    rescue Exception => e
      puts ' Error: could not open invoice.html'
      puts ' ' + e.message
      return
    end

    # HTML
    begin
      output_html = Liquid::Template.parse(@header + source_html + @footer).render 'Invoice' => @data
      puts output_html
    rescue Exception => e
      puts ' Error: could not parse html'
      puts ' ' +e.message
      return
    end


    # CSS
    begin
      engine = Sass::Engine.new(source_scss, :syntax => :scss)
      output_css = engine.render
    rescue Exception => e
      puts ' Error: could not parse css'
      puts ' ' +e.message
      return
    end


    output_invoice invoice_name, output_html, output_css

    puts ' DONE'
  end

  def output_invoice(invoice_name, html, css)
    dir = "invoice_previews/#{invoice_name}/"
    Dir.mkdir(dir) unless Dir.exist?(dir)
    File.write(dir + 'invoice.html', html)
    File.write(dir + 'invoice.css', css)
  end

end