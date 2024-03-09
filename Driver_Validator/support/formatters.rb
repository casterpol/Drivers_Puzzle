# frozen_string_literal: true

module DriverFormat
  def self.format_all(driver:)
    driver.firstName = name_format(name: driver.firstName)
    driver.lastName = name_format(name: driver.lastName)
    driver.driverID = driverId_format(driverid: driver.driverID)
    driver.dateOfBirth = dob_format(dob: driver.dateOfBirth)
    driver.entitlements = entitlements_format(entitlements: driver.entitlements)
    driver
  end

  def self.name_format(name:)
    CapitalizeNames.capitalize(name)
  # possible edge cases: D'amore, Dubuque and VonRueden, this spelling is not consistent (google searched), this is what is returned when using the capitalize-names gem
  end

  def self.driverId_format(driverid:)
    driverid.upcase
  end

  def self.dob_format(dob:)
    Date.parse(dob).strftime(ValidationAndFormatConstants::DOB::OutputFormat)
  end

  def self.entitlements_format(entitlements:)
    output = []
    entitlements.sort.each { |key| output << ValidationAndFormatConstants::Entitlements::FieldsMap[key] }
    output.join(', ')
  end

  def self.format_to_array(field:, remove_unwanted_char: false)
    field.gsub!(/[^0-9A-Za-z\-']/, '') if remove_unwanted_char
    field.split('')
  end
end
