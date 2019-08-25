#!/usr/bin/env ruby

require 'nokogiri'

unless File.exist?('coverage/index.html')
  warn 'Error: coverage/index.html dose not exist.'
  exit 1
end

html_doc = File.open('coverage/index.html') { |f| Nokogiri::HTML(f) }

binding.pry
