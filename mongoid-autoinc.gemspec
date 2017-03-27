# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'autoinc/version'

Gem::Specification.new do |s|
  s.name         = 'mongoid-autoinc'
  s.version      = Mongoid::Autoinc::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = ['Robert Beekman', 'Steven Weller', 'Jacob Vosmaer']
  s.email        = %w(robert@80beans.com steven@80beans.com jacob@80beans.com)
  s.homepage     = 'https://github.com/suweller/mongoid-autoinc'
  s.summary      = %q(Add auto incrementing fields to mongoid documents)
  s.description  = %q(Think auto incrementing field from SQL for mongoid.)
  s.files        = Dir.glob("lib/**/*") + %w(README.md)
  s.license      = 'MIT'
  s.executables  = s.files.grep(%r(^bin/)) { |f| File.basename(f) }
  s.test_files   = s.files.grep(%r(^(test|spec|features)/))
  s.require_path = 'lib'

  s.add_dependency 'mongoid', '~> 6.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'foreman'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry'
end
