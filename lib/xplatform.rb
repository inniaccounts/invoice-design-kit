# Script to weed out x-platform issues
# Specifically rendering on OSX and Windows is very different

require_relative 'preview_generator'
Dir.chdir 'xplatform'

# Check on both
#   OK  Margins work

# Investigation into headers:
#   Set the height of the header body to the same as margin-top - i.e. 10cm
#   But doing so means there's an extra margin at the top of the page
#     http://stackoverflow.com/questions/15299869/header-height-and-positioning-header-from-top-of-page-in-wkhtmltopdf
#     Suggests 1.33 height
#   So
#     pdf_settings[:margin_top] = '10cm'
#     height:13.33cm;
#   BUT
#     Still inconsistant
#       Windows margins are about 10px smaller than non-windows
#   CONCLUSION
#     pdf_settings[:margin_top] is always consistent between windows and non windows
#       it determines the start of the body
#     body#header-body height changes between windows and non windows
#   THEREFORE - rough rule of thumb
#     Set pdf_settings[:margin_top] to (body#header-body height - 2cm) + required margin
#     e.g.

puts "Platform:    #{is_windows? ? 'Windows' : 'Not Windows'}"
puts "Ruby:        #{RUBY_VERSION }p#{ RUBY_PATCHLEVEL }"
#puts "PDF kit:  #{PDFKit::VERSION}"
puts "wkhtmltopdf: #{PDFKit.configuration.wkhtmltopdf}"
out = `#{PDFKit.configuration.wkhtmltopdf} -V`
puts "    version: #{out.match(/wkhtmltopdf (.*)/m)[1]}"



pdf_settings = Hash.new
pdf_settings[:page_size] = 'A4'
pdf_settings[:orientation] = 'Portrait'
pdf_settings[:margin_top] = '20cm'
pdf_settings[:margin_right] = '1cm'
pdf_settings[:margin_bottom] = '1cm'
pdf_settings[:margin_left] = '1cm'
# pdf_settings[:zoom] = 1.33
#pdf_settings[:disable_smart_shrinking] = true
if !is_windows?
  # Windows is generally 96dpi, non-windows 72dpi
  pdf_settings[:zoom] = 0.75
end

pdf_settings[:header_html] = './test-header.html'

kit = PDFKit.new(File.new('./test.html'), pdf_settings)
kit.to_file("./test-#{is_windows? ? 'windows' : 'not-windows'}.pdf")
