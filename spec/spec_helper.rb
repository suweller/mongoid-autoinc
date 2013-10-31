require 'rubygems'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require "mongoid"
require "autoinc"

Mongoid.configure do |config|
  config.connect_to('mongoid_autoinc_test')
end

require "models"

RSpec.configure do |config|
  config.mock_with :rspec
  config.after :suite do
    Mongoid.purge!
  end
end
