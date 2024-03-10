# frozen_string_literal: true

require 'capitalize_names'
require 'colorize'
require 'csv'
require 'date'
require 'fileutils'

require_relative 'support/validation_and_format_constants'
require_relative 'support/driver'
require_relative 'support/formatters'
require_relative 'support/driverId_generator'
require_relative 'support/validation'
require_relative 'support/file_helper'

def validate_driver_records(file_name:)
  drivers = FileHelper.read_csv(file_name: file_name)
  valid, invalid = Validation.validate_list(driver_list: drivers)

  FileHelper.save_to_csv(save_file_name: 'VALID', data: valid)
  FileHelper.save_to_csv(save_file_name: 'INVALID', data: invalid)

  print "\nValid drivers: #{valid.count}\nInvalid drivers: #{invalid.count}\nTotal drivers checked: #{drivers.count}\n".colorize(:blue)
  FileHelper.count_errors(data: invalid)
end

validate_driver_records(file_name: 'Driver_Validator/data/drivers.csv')
