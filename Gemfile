source "http://rubygems.org"

gem 'activesupport', '~> 3.0.0'
gem 'activerecord', '~> 3.0.0'

group :development do
  gem 'jeweler', '>= 1.5.2'
  gem 'rake', '>= 0.8.7'
  gem 'rspec', '>= 2.3.0'
  gem 'rcov'
  platform :ruby do
    gem 'sqlite3-ruby'
  end
  platform :jruby do
    gem 'activerecord-jdbcsqlite3-adapter'
    gem 'jruby-openssl'
  end
end
