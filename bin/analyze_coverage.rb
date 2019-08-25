#!/usr/bin/env ruby

require 'nokogiri'

if ! File.exist?('coverage/index.html')
  STDERR.puts 'Error: coverage/index.html dose not exist.'
  exit 1
end
