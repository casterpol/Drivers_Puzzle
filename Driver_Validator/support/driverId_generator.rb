# frozen_string_literal: true

module DriverId
  def self.generate(driver:)
    [last_name(name: driver.lastName),
     first_name_initial(name: driver.firstName),
     date_of_birth(dob: driver.dateOfBirth, date_format: ValidationAndFormatConstants::DriverId::MONTH_FORMAT),
     date_of_birth(dob: driver.dateOfBirth, date_format: ValidationAndFormatConstants::DriverId::YEAR_FORMAT)].join
  end

  def self.last_name(name:)
    if name.empty?
      ValidationAndFormatConstants::DriverId::REPLACEMENT_CHARACTER * 4
    else
      name += ValidationAndFormatConstants::DriverId::REPLACEMENT_CHARACTER while name.gsub(/[-']/, '').length < 4
      name.gsub(/[-']/, '')[0..3].upcase
    end
  end

  def self.first_name_initial(name:)
    if name.empty?
      ValidationAndFormatConstants::DriverId::REPLACEMENT_CHARACTER
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
