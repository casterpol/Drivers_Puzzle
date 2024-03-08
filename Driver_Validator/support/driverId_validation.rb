module DriverId
  def self.validate(driver:)
    #  Create Duplicate var's to generate the DriverId parts with
    temp_first_name = driver.firstName.dup
    temp_last_name = driver.lastName.dup
    temp_dob = driver.dateOfBirth.dup

    generated_first_name = first_name_initial(name: temp_first_name)
    generated_last_name = last_name(name: temp_last_name)
    generated_month = month(dob: temp_dob)
    generated_year = year(dob: temp_dob)

    if generated_first_name != driver.driverID[4]
      driver.errors['DriverId'] = "First name incorrect, generated first name is: #{generated_first_name}"
    end

    if generated_last_name != driver.driverID[0..3]
      driver.errors['DriverId'] = "Last name incorrect, generated last name is: #{generated_last_name}"
    end

    if generated_month != driver.driverID[5..6]
      driver.errors['DriverId'] = "Month incorrect, generated month is: #{generated_month}"
    end

    if generated_year != driver.driverID[7..8]
      driver.errors['DriverId'] = "Year incorrect, generated year is: #{generated_year}"
    end
  end

  def self.last_name(name:)
    if name.empty?
      ValidationAndFormatConstants::DriverId::ReplacementCharacter * 4
    else
      name << ValidationAndFormatConstants::DriverId::ReplacementCharacter while name.gsub(/[-']/, '').length < 4
      name.gsub(/[-']/, '')[0..3].upcase
    end
  end

  def self.first_name_initial(name:)
    if name.empty?
      ValidationAndFormatConstants::DriverId::ReplacementCharacter
    else
      name[0].upcase
    end
  end

  def self.month(dob:)
    Date.parse(dob).strftime(ValidationAndFormatConstants::DriverId::MonthFormat) unless dob.empty?
  end

  def self.year(dob:)
    Date.parse(dob).strftime(ValidationAndFormatConstants::DriverId::YearFormat) unless dob.empty?
  end
end
