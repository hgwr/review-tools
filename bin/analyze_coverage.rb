#!/usr/bin/env ruby

require 'nokogiri'
require 'pry-byebug'

unless File.exist?('coverage/index.html')
  warn 'Error: coverage/index.html dose not exist.'
  exit 1
end

html_doc = File.open('coverage/index.html') { |f| Nokogiri::HTML(f) }

a_tags = html_doc.css('a[title="app/controllers/new_top_controller.rb"]')

file_id = a_tags.first['href'].sub(/^#/, '')

source_tables = html_doc.css("div.source_table\##{file_id}")

source_tables.css('li').each do |li|
  linenumber = li['data-linenumber']
  case li['class']
  when 'missed'
    printf '%05d x ', linenumber
  when 'covered'
    printf '%05d o ', linenumber
  else
    printf '%05d   ', linenumber
  end
  puts li.css('code').text
end

binding.pry

puts file_id
