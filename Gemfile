source "http://rubygems.org"

# Kind of hacky, supposed to be cleaner with bundler 1.1 later
if ENV.has_key?('SA_WITH_3_0')
  gem 'activesupport', '~> 3.0.0'
  gem 'activerecord', '~> 3.0.0'
else
  gem 'activesupport', '>= 3.0.0'
  gem 'activerecord', '>= 3.0.0'
end

group :development do
  gem 'jeweler', '>= 1.5.2'
  gem 'rake', '>= 0.8.7'
  gem 'rdoc'
  gem 'rspec', '>= 2.3.0'
  gem 'rcov'
  platform :ruby do
    gem 'sqlite3', '>= 1.3.4'
  end
  platform :jruby do
    gem 'activerecord-jdbcsqlite3-adapter'
    gem 'jruby-openssl'
  end
end
