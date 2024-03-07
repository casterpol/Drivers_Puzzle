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

  def generate_driverId
    DriverIdFactory.build(driver: self)
  end

  def convert_to_string_arr
    self.instance_variables.map{ |attribute| self.instance_variable_get(attribute).to_s }
  end

  def format_output
    DriverFormat.formatAll(driver: self)
  end
end