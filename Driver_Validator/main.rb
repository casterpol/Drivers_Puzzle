require 'csv'
require 'date'
require 'active_support/all'

require_relative 'data/validation_and_format_constants'
require_relative 'support/driver'
require_relative 'support/formatters'
require_relative 'support/driverId_validation'
require_relative 'support/validation'
require_relative 'support/file_helper'

def validate_driver_records(file_name:)
  drivers = FileHelper.read_csv(file_name: file_name)

  valid, invalid = Validation.validator(driver_list: drivers)

  print "Total Valid drivers: #{valid.count}\nTotal Invalid drivers: #{invalid.count}\n\n"

  FileHelper.save_to_csv(save_file_name: 'VALID', data: valid)
  FileHelper.save_to_csv(save_file_name: 'INVALID', data: invalid)
  FileHelper.count_errors(data: invalid)
end

validate_driver_records(file_name: 'Driver_Validator/data/drivers.csv')
