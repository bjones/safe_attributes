$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'bundler'
Bundler.setup(:default, :development)

require 'active_record'
require 'active_support'
require 'safe_attributes'
require 'rspec'
require 'rspec/autorun'

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
ActiveRecord::Base.establish_connection(
  :adapter => (RUBY_PLATFORM == 'java') ? "jdbcsqlite3" : "sqlite3", 
  :database => "#{root}/db/safeattributes.db"
)

RSpec.configure do |config|
end

