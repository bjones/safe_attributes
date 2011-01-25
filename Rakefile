require 'rubygems'
require 'bundler'
begin 
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

version = File.exist?('VERSION') ? File.read('VERSION') : ""

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "safe_attributes"
  gem.version = version
  gem.homepage = "http://github.com/bjones/safe_attributes"
  gem.license = "MIT"
  gem.summary = %Q{Useful for legacy database support, adds support for reserved word column names with ActiveRecord}
  gem.description = %Q{Better support for legacy database schemas for ActiveRecord, such as columns named class, or any other name that conflicts with an instance method of ActiveRecord.}
  gem.email = "cbj@gnu.org"
  gem.authors = ["Brian Jones"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "SafeAttributes #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
