require 'rspec'
require 'fileutils'

EXAMPLE_FOLDER = File.expand_path('../example', __FILE__)

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter = :documentation

  config.before(:each) do
    FileUtils.rm_rf(EXAMPLE_FOLDER)
    FileUtils.mkdir_p(EXAMPLE_FOLDER)
  end
end
