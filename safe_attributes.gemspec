# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "safe_attributes/version"

Gem::Specification.new do |s|
  s.name = "safe_attributes"
  s.version = SafeAttributes::VERSION::STRING

  s.required_rubygems_version = '>= 1.8.10'
  s.authors = ["Brian Jones"]
  s.date = Time.now.utc.strftime("%Y-%m-%d")
  s.summary = "Useful for legacy database support, adds support for reserved word column names with ActiveRecord"
  s.description = "Better support for legacy database schemas for ActiveRecord, such as columns named class, or any other name that conflicts with an instance method of ActiveRecord."
  s.email = "cbjones1@gmail.com"
  s.homepage = "http://github.com/bjones/safe_attributes"
  s.files = Dir.glob("{lib,spec}/**/*") + %w(README.rdoc NEWS.rdoc LICENSE Rakefile Gemfile Appraisals safe_attributes.gemspec)
  s.test_files = Dir.glob("{spec}/**/*")
  s.require_paths = ["lib"]
  s.licenses = ["MIT"]

  s.add_runtime_dependency(%q<activerecord>, [">= 3.0.0"])

  s.add_development_dependency(%q<rake>, [">= 0.8.7"])
  s.add_development_dependency(%q<rdoc>, [">= 0"])
  s.add_development_dependency(%q<rspec>, [">= 2.3.0"])
end

