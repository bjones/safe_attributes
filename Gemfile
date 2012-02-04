source "http://rubygems.org"

# Kind of hacky, supposed to be cleaner with bundler 1.1 later
if ENV.has_key?('SA_WITH_3_0')
  gem 'activesupport', '~> 3.0.0'
  gem 'activerecord', '~> 3.0.0'
elsif ENV.has_key?('SA_WITH_3_1')
  gem 'activesupport', '~> 3.1.0'
  gem 'activerecord', '~> 3.1.0'
else
  gem 'activesupport', '>= 3.0.0'
  gem 'activerecord', '>= 3.0.0'
end

platform :mri do
  gem 'simplecov', :require => false, :group => :test
end

group :development do
  gem 'jeweler', '>= 1.5.2'
  gem 'rake', '>= 0.8.7'
  gem 'rdoc'
  gem 'rspec', '>= 2.3.0'

  platform :ruby do
    gem 'sqlite3', '>= 1.3.4'
  end
  platform :jruby do
    gem 'activerecord-jdbcsqlite3-adapter'
    gem 'jruby-openssl'
  end
  # For debugging under ruby 1.9 special gems are needed
#  gem 'ruby-debug19', :platform => :mri
#  gem 'ruby-debug-base19', '>=0.11.26'
#  gem 'linecache19', '>=0.5.13'
end
