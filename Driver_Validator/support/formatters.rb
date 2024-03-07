module DriverFormat
  def self.formatAll(driver:)
    driver.firstName = nameFormat(name: driver.firstName)
    driver.lastName = nameFormat(name: driver.lastName)
    driver.driverID = driverIdFormat(driverid: driver.driverID)
    driver.dateOfBirth = dobFormat(dob: driver.dateOfBirth)
    driver.entitlements = entitlementsFormat(entitlements: driver.entitlements)
  end

  def self.nameFormat(name:)
    name.titleize
  end

  def self.driverIdFormat(driverid:)
    driverid.upcase
  end

  def self.dobFormat(dob:)
    Date.parse(dob).strftime(ValidationAndFormatConstants::DOB::OutputFormat)
  end

  def self.entitlementsFormat(entitlements:)
    output = []
    entitlements.sort.each { |key| output << ValidationAndFormatConstants::Entitlements::FieldsMap[key] }
    output.join(', ')
  end
end
