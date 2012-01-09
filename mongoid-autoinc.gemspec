# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "mongoid-autoinc"
  s.version     = "0.0.2"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Robert Beekman"]
  s.email       = ["robert@80beans.com"]
  s.homepage    = "https://github.com/80beans/mongoid-autoinc"
  s.summary     = %q{Add auto incrementing fields to mongoid documents}
  s.description = %q{Think auto incrementing field from MySQL for mongoid.}
  s.files        = Dir.glob("lib/**/*") + %w(README.rdoc)
  s.require_path = 'lib'

  s.add_dependency 'mongoid'
  s.add_dependency 'bson_ext'
  s.add_dependency 'rspec'
  s.add_dependency 'activesupport'
  s.add_dependency 'rake'
end
