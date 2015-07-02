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

