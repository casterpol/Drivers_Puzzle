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

  # iterates over each of the driver class attribues
  # @param self
  # @returns the values of each attribute as an array of strings
  def convert_to_string_arr
    self.instance_variables.map{ |attribute| self.instance_variable_get(attribute).to_s }
  end

  # calls DriverFormat.format_to_array method with @params self.entitlements and remove_unwanted_char boolean
  # this method is used to convert the entitlements
  # @returns an [Array of Strings]
  def entitlements_to_arr
    self.entitlements = DriverFormat.format_to_array(field: self.entitlements, remove_unwanted_char: true)
  end

  # calls each of the validation methods
  # @param self
  # each validation method returns [String or nil]
  # uses compact! to remove any nil responses from the errors attribute
  # returns [String] updated errors attribute
  def validate_fields
    # calls relevant validation, as per brief and updates error fields
    self.errors['First Name'] = Validation.name(name: self.firstName, field: 'First Name', required: ValidationAndFormatConstants::Names::FIRST_NAME_REQUIRED)
    self.errors['Last Name'] = Validation.name(name: self.lastName, field: 'Last Name', required: ValidationAndFormatConstants::Names::LAST_NAME_REQUIRED)
    self.errors['Date of birth'] = Validation.dob(dob: self.dateOfBirth)
    self.errors['DriverId'] = Validation.driver_id(driver: self)
    self.errors['Entitlements'] = Validation.entitlements(entitlements: self.entitlements)

    # compact handles and removes any nil value fields
    self.errors.compact!
  end

  # calls DriverID.generate method
  # @param self
  # @returns generated driverId using driver
  def generate_driverId
    DriverId.generate(driver: self)
  end

  # calls DriverFormat.format_all method
  # @param self
  # @returns driver with all attributes formatted as per brief
  def format_output
    DriverFormat.format_all(driver: self)
  end
end
