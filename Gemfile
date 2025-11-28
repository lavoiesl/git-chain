# frozen_string_literal: true

source 'https://rubygems.org'

# None of these can actually be used in a development copy of dev
# They are all for CI and tests
# `dev` uses no gems

gem 'logger'

group :development, :test do
  gem 'base64'
  gem 'benchmark'
  gem 'ostruct'
  gem 'rake'
  gem 'rubocop'
  gem 'rubocop-minitest'
  gem 'rubocop-performance'
  gem 'rubocop-rake'
end

group :test do
  gem 'minitest', '>= 5.0.0', require: false
  gem 'minitest-reporters', require: false
  gem 'mocha', require: false
end
