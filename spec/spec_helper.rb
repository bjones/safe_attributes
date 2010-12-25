$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
gem 'activerecord', '>= 3.0.0'
require 'active_record'
gem 'activesupport', '>= 3.0.0'
require 'active_support'

require 'safe_attributes'
require 'rspec'
require 'rspec/autorun'

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3", 
  :database => "#{root}/db/safeattributes.db"
)

RSpec.configure do |config|
end

