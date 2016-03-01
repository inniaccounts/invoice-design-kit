# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require_relative 'lib/app'

task :default => [:generate_previews]

desc 'Generates invoice previews'
task :generate_previews do
  pg = PreviewGenerator.new
  pg.generate
end

desc 'Generates invoice QA previews. Pass invoice name as last arg to preview single invoice'
task :qa do
  # Swallow arguments - see http://cobwwweb.com/4-ways-to-pass-arguments-to-a-rake-task
  ARGV.each { |a| task a.to_sym do ; end }

  pg = PreviewGenerator.new
  pg.generate_qa ARGV[1]
end

task :sql do
  sql_update 4, 'classic'
  sql_update 5, 'blend'
#  sql_update 6, 'stripe'
  sql_insert 'stripe'
end