# -*- mode: ruby; coding: utf-8 -*-
source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'nokogiri'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'pry-byebug'
  gem 'pronto'
  gem 'pronto-flay', require: false
  gem 'pronto-rubocop', require: false
  gem 'rspec'
end
