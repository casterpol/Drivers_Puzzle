module Validation
  def self.validator(driver_list:)
    valid = []
    invalid = []

    driver_list.each do |row|
      driver = Driver.new(driver: row)
      Validation.name(driver: driver, name: driver.firstName, field: 'First Name', required: ValidationAndFormatConstants::Names::FirstNameRequired)
      Validation.name(driver: driver, name: driver.lastName, field: 'Last Name', required: ValidationAndFormatConstants::Names::LastNameRequired)
      Validation.dob(driver: driver)
      Validation.driverId(driver: driver)
      Validation.entitlements(driver: driver)

      if driver.errors.empty?
        driver.format_output
        valid << driver
        else
          invalid << driver
      end
    end

    return valid, invalid
  end

  def self.name(driver:, name:, field:, required:)
    if name.empty?
      if required == true
        driver.errors[field] = "#{field} empty, #{field} is a required field"
      end
    elsif name.match(/^[a-zA-Z\-']+$/).nil?
      driver.errors[field] = "Invalid characters found: #{name.gsub(/[a-zA-Z\-']/, '')}"
    end
  end

  def self.dob(driver:)
    case
    when driver.dateOfBirth.empty? && ValidationAndFormatConstants::DOB::Required == true
      driver.errors['Date of birth'] = "Date of birth empty"
    when driver.dateOfBirth.empty?
      # If DOB required flag is turned to false, this empty statement allows the empty field to pass as no checks could be done
    else
      today = Date.today
      driverDOB = Date.parse(driver.dateOfBirth)

      if driverDOB > today
        driver.errors['Date of birth'] = "Date of birth must not be in the future"
      elsif driverDOB.year.digits.length != 4
        driver.errors['Date of birth'] = "Date of birth century is not present"
      elsif driverDOB < today - ValidationAndFormatConstants::DOB::UpperAge.years
        driver.errors['Date of birth'] = "Driver cannot be over 100 years of age"
      elsif driverDOB > today - ValidationAndFormatConstants::DOB::LowerAge.years
        driver.errors['Date of birth'] = "Driver cannot be under 15 years of age"
      end
    end
  end

  def self.driverId(driver:)
    case
    when driver.driverID.empty? && ValidationAndFormatConstants::DriverId::Required == true
      driver.errors['DriverId'] = "DriverId empty"
    when driver.driverID.empty?
      # If driverID required flag is turned to false, this empty statement allows the empty field to pass as no checks could be done
    else
      if !driver.driverID.match(/^[a-zA-Z]{5}\d{4}$/)
        driver.errors['DriverId'] = 'DriverId pattern incorrect'
      else
        DriverId.validate(driver: driver)
      end
    end
  end

  def self.entitlements(driver:)
    case
    when driver.entitlements.empty? && ValidationAndFormatConstants::Entitlements::Required == true
      driver.errors['Entitlements'] = "Entitlements empty"
    when driver.entitlements.empty?
      # If entitlements required flag is turned to false, this empty statement allows the empty field to pass as no checks could be done
    else
      code_errors = []
      driver.entitlements.each do | char |
        unless ValidationAndFormatConstants::Entitlements::ValidFields.include? char
          code_errors << char
        end
      end
      unless code_errors.empty?
        driver.errors['Entitlements'] = "Incorrect entitlements: #{code_errors}"
      end
    end
  end

end
