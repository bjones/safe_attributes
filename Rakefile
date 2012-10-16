require 'bundler/gem_tasks'
require 'appraisal'
require 'safe_attributes/version'
require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "SafeAttributes #{SafeAttributes::VERSION::STRING}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('NEWS*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
