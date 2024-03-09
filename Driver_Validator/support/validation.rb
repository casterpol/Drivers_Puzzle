# frozen_string_literal: true

module Validation
  def self.validator(driver_list:)
    valid = []
    invalid = []

    driver_list.each do |row|
      driver = Driver.new(driver: row)
      driver.entitlements_to_arr

      driver.errors['First Name'] = Validation.name(name: driver.firstName, field: 'First Name', required: ValidationAndFormatConstants::Names::FirstNameRequired)
      driver.errors['Last Name'] = Validation.name(name: driver.lastName, field: 'Last Name', required: ValidationAndFormatConstants::Names::LastNameRequired)
      driver.errors['Date of birth'] = Validation.dob(dob: driver.dateOfBirth)
      driver.errors['DriverId'] = Validation.driver_id(driverid: driver.driverID,firstname: driver.firstName, lastname: driver.lastName, dob: driver.dateOfBirth)
      driver.errors['Entitlements'] = Validation.entitlements(entitlements: driver.entitlements)

      # compact handles and removes any nil value fields
      driver.errors.compact!

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
    when dob.empty? && ValidationAndFormatConstants::DOB::Required == true
      'Date of birth empty'
    when dob.empty?
      # If DOB required flag is turned to false, this empty statement allows the empty field to pass as no checks could be done
    else
      begin
        driver_dob = Date.parse(dob)

        if driver_dob > Date.today
          'Date of birth must not be in the future'
        elsif driver_dob.year.digits.length != 4
          'Date of birth century is not present'
        elsif driver_dob < Date.today.prev_year(ValidationAndFormatConstants::DOB::UpperAge)
          'Driver cannot be over 100 years of age'
        elsif driver_dob > Date.today.prev_year(ValidationAndFormatConstants::DOB::LowerAge)
          'Driver cannot be under 15 years of age'
        end
      rescue Exception
        'Date of birth is not in a valid format'
      end
    end
  end

  def self.driver_id(driverid:, firstname:, lastname:, dob:)
    case
    when driverid.empty? && ValidationAndFormatConstants::DriverId::Required == true
      'DriverId empty'
    when driverid.empty?
      # If driverID required flag is turned to false, this empty statement allows the empty field to pass as no checks could be done
    else
      if driverid.match(/^[a-zA-Z]{5}(0[1-9]|1[0-2])\d{2}$/)
        DriverId.validate(driverid: driverid, firstname: firstname, lastname: lastname, dob: dob)
      else
        'DriverId pattern incorrect'
      end
    end
  end

  def self.entitlements(entitlements:)
    case
    when entitlements.empty? && ValidationAndFormatConstants::Entitlements::Required == true
      'Entitlements empty'
    when entitlements.empty?
      # If entitlements required flag is turned to false, this empty statement allows the empty field to pass as no checks could be done
    else
      code_errors = []
      entitlements.each do | char |
        unless ValidationAndFormatConstants::Entitlements::FieldsMap.include? char
          code_errors << char
        end
      end
      unless code_errors.empty?
        "Incorrect entitlements: #{code_errors}"
      end
    end
  end

end
