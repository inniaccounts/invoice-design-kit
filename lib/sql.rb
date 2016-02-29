# Just a helper for internal use at iA
# Templates are stored in a SQL database, this creates commands for us...

def sql_update(id, theme)
  puts "UPDATE InvoiceTemplate SET"
  puts "Name='#{get_name(theme)}', "
  puts "SCSS='#{sanitise(theme,'style.scss')}', "
  puts "Header='#{sanitise(theme,'header.html')}', "
  puts "Body='#{sanitise(theme,'body.html')}', "
  puts "Footer='#{sanitise(theme,'footer.html')}'"
  puts "WHERE id=#{id};"
end

def sql_insert(theme)
  puts "INSERT INTO InvoiceTemplate (Name,SCSS,Header,Body,Footer) VALUES ("
  puts "'#{get_name(theme)}',"
  puts "'#{sanitise(theme,'style.scss')}',"
  puts "'#{sanitise(theme,'header.html')}',"
  puts "'#{sanitise(theme,'body.html')}',"
  puts "'#{sanitise(theme,'footer.html')}')"
end

def get_name(theme)
  source = File.open("invoice_designs/#{theme}/style.scss", "rb").read
  source.match(/\$name: *?'(.*?)'/m)[1]
end

def sanitise(theme, file)
  source = File.open("invoice_designs/#{theme}/#{file}", "rb").read
  #source.gsub("'", %q(\\\'))
  source.gsub("'","''")
end