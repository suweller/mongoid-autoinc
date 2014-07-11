require 'rubygems'
require 'mongoid'
Mongoid.configure { |config| config.connect_to('mongoid_autoinc_test') }

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'autoinc'
require 'models'

RSpec.configure do |config|
  config.mock_with :rspec
  config.after(:suite) { Mongoid.purge! }
end
