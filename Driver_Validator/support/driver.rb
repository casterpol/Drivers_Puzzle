# frozen_string_literal: true
class Driver
  attr_accessor :driverID, :firstName, :lastName, :dateOfBirth, :entitlements, :errors

  def initialize(driver:)
    @lastName = driver['lastName']
    @firstName = driver['firstName']
    @dateOfBirth = driver['dateOfBirth']
    @driverID = driver['driverID']
    @entitlements = driver['entitlements']
    @errors = {}
  end

  def convert_to_string_arr
    self.instance_variables.map{ |attribute| self.instance_variable_get(attribute).to_s }
  end

  def entitlements_to_arr
    self.entitlements = DriverFormat.format_to_array(field: self.entitlements, remove_unwanted_char: true)
  end

  def validate_fields
    # calls relevant validation and updates error fiels
    self.errors['First Name'] = Validation.name(name: self.firstName, field: 'First Name', required: ValidationAndFormatConstants::Names::FIRST_NAME_REQUIRED)
    self.errors['Last Name'] = Validation.name(name: self.lastName, field: 'Last Name', required: ValidationAndFormatConstants::Names::LAST_NAME_REQUIRED)
    self.errors['Date of birth'] = Validation.dob(dob: self.dateOfBirth)
    self.errors['DriverId'] = Validation.driver_id(driver: self)
    self.errors['Entitlements'] = Validation.entitlements(entitlements: self.entitlements)

    # compact handles and removes any nil value fields
    self.errors.compact!
  end

  def generate_driverId
    DriverId.generate(driver: self)
  end
  def format_output
    DriverFormat.format_all(driver: self)
  end
end
