system 'rm Gemfile' if File.exist?('Gemfile')
File.write('Gemfile', <<-GEMFILE)
  source 'https://rubygems.org'
GEMFILE

system 'bundle install'

require 'bundler'
Bundler.setup(:default)

require 'minitest/autorun'
require 'logger'

require './league_table.rb'

describe LeagueTable do

  # your specs

end
