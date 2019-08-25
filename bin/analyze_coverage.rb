#!/usr/bin/env ruby

require 'nokogiri'
require 'pry'

unless File.exist?('coverage/index.html')
  warn 'Error: coverage/index.html dose not exist.'
  exit 1
end

html_doc = File.open('coverage/index.html') { |f| Nokogiri::HTML(f) }

if ARGV.length != 4 || ARGV[0] != 'into' || ARGV[2] != 'from'
  warn 'Usage: analyze_coverage.rb into milestone/abc from feature/cde'
  exit 1
end

dst_branch = ARGV[1]
src_branch = ARGV[3]

`git diff --name-only #{dst_branch}..#{src_branch}`.split("\n").each do |file_name|

  next unless file_name =~ /\.rb\z/

  puts "\n========== #{file_name} =========="

  a_tags = html_doc.css(%Q(a[title="#{file_name}"]))

  if a_tags.length == 0
    puts "  no results"
    next
  end

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
      printf '%05d x ', linenumber
    end
    puts li.css('code').text
  end

end
