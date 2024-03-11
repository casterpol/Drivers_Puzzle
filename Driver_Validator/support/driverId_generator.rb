# frozen_string_literal: true

module DriverId

  # @param driver [Object]
  # calls module methods to generate id and uses .join to join them into one string
  # @returns [String]
  def self.generate(driver:)
    [last_name(name: driver.lastName),
     first_name_initial(name: driver.firstName),
     date_of_birth(dob: driver.dateOfBirth, date_format: ValidationAndFormatConstants::DriverId::MONTH_FORMAT),
     date_of_birth(dob: driver.dateOfBirth, date_format: ValidationAndFormatConstants::DriverId::YEAR_FORMAT)].join
  end

  # @param name [String]
  # checks if @param is empty
  # either adds the replacement character * 4, or passes name through a while loop
  # while loop takes @param, gsub removes hyphens and apostrophes then checks length
  # returns [String] first 4 characters, gsub used on return to remove hyphen and apostrophe
  def self.last_name(name:)
    if name.empty?
      ValidationAndFormatConstants::DriverId::REPLACEMENT_CHARACTER * 4
    else
      while name.gsub(/[-']/, '').length < 4
        name += ValidationAndFormatConstants::DriverId::REPLACEMENT_CHARACTER
      end
      name.gsub(/[-']/, '')[0..3].upcase
    end
  end

  # @param name [String]
  # @return [String] replacement character or @param first character
  def self.first_name_initial(name:)
    if name.empty?
      ValidationAndFormatConstants::DriverId::REPLACEMENT_CHARACTER
    else
      name[0].upcase
    end
  end

  # @params dob [String], date_format [String]
  # uses Date.parse to convert @param dob to desired format, as per brief
  # @rescue will catch and @return specific Date::Error
  # @return [String] in desired format
  def self.date_of_birth(dob:, date_format:)
    Date.parse(dob).strftime(date_format) unless dob.empty?
  rescue Date::Error
    "Date of birth is not in a valid format: #{dob}"
  end
end
