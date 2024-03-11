# frozen_string_literal: true

module Validation
  # @param driver_list [Array]
  # creates empty arrays calld valid / invalid
  # iterates over the @param array, creates driver object
  # calls method entitlements_to_arr to update entitlement field into array
  # calls validate_fields method to update driver.errors
  # checks if errors are present the passes the driver object to the relevant array
  # @returns [Array],  both valid and invalid
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

  # @params name [String], field [String], required [Boolean]
  # checks if name is empty, and if it is required
  # if not empty, match checks only valid characters are present
  # regex: ^[a-zA-Z]+ from start, any character A-Z, any number of
  # regex: [\-']? 1 of either
  # regex: [a-zA-Z]+$ any character A-Z, any number of to end of string
  # @return [String, nil]
  def self.name(name:, field:, required:)
    if name.empty?
      if required == true
        "#{field} empty, #{field} is a required field"
      end
    elsif name.match(/^[a-zA-Z]+[\-']?[a-zA-Z]+$/).nil?
      "Invalid characters found: #{name.gsub(/[a-zA-Z\-']/, '')}"
    end
  end

  # @param dob [String]
  # checks if @param is empty and if it is required
  # rescue Date::Error will catch and Date.parse errors
  # @return [String], with specific error message as per brief
  def self.dob(dob:)
    case
    when dob.empty? && ValidationAndFormatConstants::DOB::REQUIRED == true
      'Date of birth empty'
    when dob.empty?
      # If DOB required flag is turned to false, this empty statement allows the empty field to pass as no checks could be done
      nil
    else
      begin driver_dob = Date.parse(dob)
        if driver_dob > Date.today
          'Date of birth must not be in the future'
        elsif driver_dob < Date.today.prev_year(ValidationAndFormatConstants::DOB::UPPER_AGE)
          "Driver cannot be over #{ValidationAndFormatConstants::DOB::UPPER_AGE} years of age"
        elsif driver_dob > Date.today.prev_year(ValidationAndFormatConstants::DOB::LOWER_AGE)
          "Driver cannot be under #{ValidationAndFormatConstants::DOB::LOWER_AGE} years of age"
        end
      rescue Date::Error
        "Date of birth is not in a valid format: #{dob}"
      end
    end
  end

  # @param driver [Object]
  # checks if @param is empty and if it is required
  # regex: ^[a-zA-Z]{5} start of string, any A-Z, 5 of
  # regex: (0[1-9]|1[0-2]) capture group, 0 with 1 to 9, or, 1 with 0 to 2
  # regex: \d{2}$ any digit, 2 of, end of string
  # match checks @param looks like a driverId, as per brief
  # driver.generate_driverId creates a driverid based on the driver object
  # generated_id is validated against the driverID passed in, as per brief
  # @return [String, nil]
  def self.driver_id(driver:)
    case
    when driver.driverID.empty? && ValidationAndFormatConstants::DriverId::REQUIRED == true
      'DriverId empty'
    when driver.driverID.empty?
      # If driverID required flag is turned to false, this empty statement allows the empty field to pass as no checks could be done
      nil
    else
      # check driverId matches pattern
      if driver.driverID.match(/^[a-zA-Z]{5}(0[1-9]|1[0-2])\d{2}$/)
        # If pattern does match, have driver class generate a driverId off known details and check it against the given ID
        error_output = ''
        generated_Id = driver.generate_driverId

        # error output string is concatenated using unless statements
        # unless statements check the component parts of the driverId and return a customer error messag
        error_output += "Last name incorrect, generated last name is: #{generated_Id[0..3]}. " unless generated_Id[0..3] == driver.driverID[0..3]
        error_output += "First name incorrect, generated first initial is: #{generated_Id[4]}. " unless generated_Id[4] == driver.driverID[4]
        error_output += "Month incorrect, generated month is: #{generated_Id[5..6]}. " unless generated_Id[5..6] == driver.driverID[5..6]
        error_output += "Year incorrect, generated year is: #{generated_Id[7..8]}. " unless generated_Id[7..8] == driver.driverID[7..8]

        # returns nil if no errors have been found
        error_output.empty? ? nil : error_output
      else
        'DriverId pattern incorrect'
      end
    end
  end

  # @param entitlements [Array]
  # checks if @param is empty and if it is required
  # creates code_errors [Array]
  # iterates over entitlements [Array], using 'char'
  # ValidationAndFormatConstants::Entitlements::FIELDS_MAP [Hash]
  # checks the 'char' is included in the entitlements::FIELD_MAP using unless, if not present, adds 'char' to code_errors
  # @return [String, nil]
  def self.entitlements(entitlements:)
    case
    when entitlements.empty? && ValidationAndFormatConstants::Entitlements::REQUIRED == true
      'Entitlements empty'
    when entitlements.empty?
      # If entitlements required flag is turned to false, this empty statement allows the empty field to pass as no checks could be done
      nil
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
