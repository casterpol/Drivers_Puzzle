# frozen_string_literal: true

module DriverFormat
  # @param driver [Object]
  # calls each formatter and updates @param attributes [Strings]
  # @return driver [Object]
  def self.format_all(driver:)
    driver.firstName = name_format(name: driver.firstName)
    driver.lastName = name_format(name: driver.lastName)
    driver.driverID = driverId_format(driverid: driver.driverID)
    driver.dateOfBirth = dob_format(dob: driver.dateOfBirth)
    driver.entitlements = entitlements_format(entitlements: driver.entitlements)
    driver
  end

  # @param name [String]
  # uses gem CapitalizeNames, method capitalize, to titlecase names
  # this gem can handle names like O'Connell and McGlynn and correctly titleize them
  # @return [String]
  def self.name_format(name:)
    CapitalizeNames.capitalize(name)
  # possible edge cases: D'amore, Dubuque and VonRueden, this spelling is not consistent (google searched), this is what is returned when using the capitalize-names gem
  end

  # @param driverid [String]
  # @return @param [String] upcase
  def self.driverId_format(driverid:)
    driverid.upcase
  end

  # @param dob [String]
  # @return [String], in date format, as per brief
  def self.dob_format(dob:)
    Date.parse(dob).strftime(ValidationAndFormatConstants::DOB::OUTPUT_FORMAT)
  end

  # @param entitlements [Array of strings]
  # creates output array
  # iterates through @param array
  # uses entitlements::FIELDS_MAP [Hash] to return value from key
  # pushes hash value into output array
  # uses join with [', '] to convert array to [String], using [', ']
  # @returns [String]
  def self.entitlements_format(entitlements:)
    output = []
    entitlements.sort.each { |key| output << ValidationAndFormatConstants::Entitlements::FIELDS_MAP[key] }
    output.join(', ')
  end

  # @params field [String], remove_unwanted_char [Boolean] defaults to false
  # this method splits any string to an array
  # var temp_field [String] is assigned using conditional if
  # regex [^], character class, match expect the following tokens, 0-9A-Za-z\-'
  # gsub substitutes any matches with nothing
  # @return [Array]
  def self.format_to_array(field:, remove_unwanted_char: false)
    temp_field = if remove_unwanted_char
                   field.gsub(/[^0-9A-Za-z\-']/, '')
                 else
                   field
                 end
    temp_field.split('')
  end
end
