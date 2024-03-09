# frozen_string_literal: true

module DriverId
  def self.validate(driverid:, firstname:, lastname:, dob:)
    generated_first_name = first_name_initial(name: firstname)
    generated_last_name = last_name(name: lastname)
    generated_month = month(dob: dob)
    generated_year = year(dob: dob)

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

  def self.month(dob:)
    Date.parse(dob).strftime(ValidationAndFormatConstants::DriverId::MonthFormat) unless dob.empty?
  end

  def self.year(dob:)
    Date.parse(dob).strftime(ValidationAndFormatConstants::DriverId::YearFormat) unless dob.empty?
  end
end
