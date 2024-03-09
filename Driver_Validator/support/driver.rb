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

  def format_output
    DriverFormat.format_all(driver: self)
  end
end
