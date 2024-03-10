# frozen_string_literal: true

require 'capitalize_names'
require 'colorize'
require 'csv'
require 'date'
require 'simplecov'
require 'simplecov-console'
require 'simplecov_json_formatter'

require_relative '../Driver_Validator/support/validation_and_format_constants'
require_relative '../Driver_Validator/support/driver'
require_relative '../Driver_Validator/support/driverId_generator'
require_relative '../Driver_Validator/support/file_helper'
require_relative '../Driver_Validator/support/formatters'
require_relative '../Driver_Validator/support/validation'


SimpleCov.formatter = SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::JSONFormatter,
    SimpleCov::Formatter::Console
  ]
)
SimpleCov.minimum_coverage 80
SimpleCov.start do
  add_filter '../spec'
end


RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
