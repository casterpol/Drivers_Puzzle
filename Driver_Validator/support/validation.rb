# frozen_string_literal: true

module Validation
  def self.validate_list(driver_list:)
    valid = []
    invalid = []

    driver_list.each do |person|
      driver = Driver.new(driver: person)
      driver.entitlements_to_arr
      driver.validate_fields

      if driver.errors.empty?
        driver.format_output
        valid << driver
      else
        invalid << driver
      end
    end

    return valid, invalid
  end

  def self.name(name:, field:, required:)
    if name.empty?
      if required == true
        "#{field} empty, #{field} is a required field"
      end
    elsif name.match(/^[a-zA-Z\-']+$/).nil?
      "Invalid characters found: #{name.gsub(/[a-zA-Z\-']/, '')}"
    end
  end

  def self.dob(dob:)
    case
    when dob.empty? && ValidationAndFormatConstants::DOB::REQUIRED == true
      'Date of birth empty'
    when dob.empty?
      # If DOB required flag is turned to false, this empty statement allows the empty field to pass as no checks could be done
    else
      begin driver_dob = Date.parse(dob)
        if driver_dob > Date.today
          'Date of birth must not be in the future'
        elsif driver_dob.year.digits.length != 4
          'Date of birth century is not present'
        elsif driver_dob < Date.today.prev_year(ValidationAndFormatConstants::DOB::UPPER_AGE)
          'Driver cannot be over 100 years of age'
        elsif driver_dob > Date.today.prev_year(ValidationAndFormatConstants::DOB::LOWER_AGE)
          'Driver cannot be under 15 years of age'
        end
      rescue Date::Error
        "Date of birth is not in a valid format: #{dob}"
      end
    end
  end

  def self.driver_id(driver:)
    case
    when driver.driverID.empty? && ValidationAndFormatConstants::DriverId::REQUIRED == true
      'DriverId empty'
    when driver.driverID.empty?
      # If driverID required flag is turned to false, this empty statement allows the empty field to pass as no checks could be done
    else
      # check driverId matches pattern
      if driver.driverID.match(/^[a-zA-Z]{5}(0[1-9]|1[0-2])\d{2}$/)
        # If pattern does match, have driver class generate a driverId off known details and check it against the given ID
        error_output = ''
        generated_Id = driver.generate_driverId

        # error output string is concatenated using unless statements
        # unless statements check the component parts of the driverId and return a customer error message
        error_output += "First name incorrect, generated first initial is: #{generated_Id[4]}. " unless generated_Id[4] == driver.driverID[4]
        error_output += "Last name incorrect, generated last name is: #{generated_Id[0..3]}. " unless generated_Id[0..3] == driver.driverID[0..3]
        error_output += "Month incorrect, generated month is: #{generated_Id[5..6]}. " unless generated_Id[5..6] == driver.driverID[5..6]
        error_output += "Year incorrect, generated year is: #{generated_Id[7..8]}. " unless generated_Id[7..8] == driver.driverID[7..8]

        # returns nil if no errors have been found
        error_output.empty? ? nil : error_output
      else
        'DriverId pattern incorrect'
      end
    end
  end

  def self.entitlements(entitlements:)
    case
    when entitlements.empty? && ValidationAndFormatConstants::Entitlements::REQUIRED == true
      'Entitlements empty'
    when entitlements.empty?
      # If entitlements required flag is turned to false, this empty statement allows the empty field to pass as no checks could be done
    else
      code_errors = []
      entitlements.each do | char |
        unless ValidationAndFormatConstants::Entitlements::FIELDS_MAP.include? char
          code_errors << char
        end
      end
      unless code_errors.empty?
        "Incorrect entitlements: #{code_errors}"
      end
    end
  end

end
