# frozen_string_literal: true

module DriverId
  def self.validate(driverid:, firstname:, lastname:, dob:)
    generated_first_name = first_name_initial(name: firstname)
    generated_last_name = last_name(name: lastname)
    generated_month = date_of_birth(dob: dob, date_format: ValidationAndFormatConstants::DriverId::MonthFormat)
    generated_year = date_of_birth(dob: dob, date_format: ValidationAndFormatConstants::DriverId::YearFormat)

    if generated_first_name != driverid[4]
      "First name incorrect, generated first name is: #{generated_first_name}"
    elsif generated_last_name != driverid[0..3]
      "Last name incorrect, generated last name is: #{generated_last_name}"
    elsif generated_month != driverid[5..6]
      "Month incorrect, generated month is: #{generated_month}"
    elsif generated_year != driverid[7..8]
      "Year incorrect, generated year is: #{generated_year}"
    end
  end

  def self.last_name(name:)
    if name.empty?
      ValidationAndFormatConstants::DriverId::ReplacementCharacter * 4
    else
      name += ValidationAndFormatConstants::DriverId::ReplacementCharacter while name.gsub(/[-']/, '').length < 4
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

  def self.date_of_birth(dob:, date_format:)
    Date.parse(dob).strftime(date_format) unless dob.empty?
  rescue Date::Error
    "Date of birth is not in a valid format: #{dob}"
  end
end
