RSpec.describe Driver do
  before(:each) do
    test_drivers = [{ 'lastName' => 'lewis', 'firstName' => 'paul', 'dateOfBirth' => '1984-06-01', 'driverID' => 'LEWIP0684', 'entitlements' => '["C", "D", "A"]' },
                    { 'lastName' => '', 'firstName' => '', 'dateOfBirth' => '', 'driverID' => '', 'entitlements' => '' },
                    { 'lastName' => 'jones', 'firstName' => 'P@u7', 'dateOfBirth' => '2000/31/1', 'driverID' => 'FDSJONEP0684', 'entitlements' => '["X", "A"]' }]
    @data = []
    test_drivers.each { |driver| @data << Driver.new(driver: driver) }
    @data.each { |driver| driver.entitlements_to_arr }
  end

  context 'validates name meets criteria' do
    it 'is a required field' do
      expect(Validation.name(name: @data[0].firstName, field: 'first name', required: true)).to eq nil
      expect(Validation.name(name: @data[1].firstName, field: 'first name', required: true)).to eq('first name empty, first name is a required field')
    end

    it 'is not a required field' do
      expect(Validation.name(name: @data[0].firstName, field: 'first name', required: false)).to eq nil
      expect(Validation.name(name: @data[1].firstName, field: 'first name', required: false)).to eq nil
      expect(Validation.name(name: @data[2].firstName, field: 'first name', required: false)).to eq('Invalid characters found: @7')
    end
  end

  context 'validates date of birth meets criteria'do
    it 'is a required field' do
      stub_const('ValidationAndFormatConstants::DOB::REQUIRED', true)
      expect(Validation.dob(dob: @data[0].dateOfBirth)).to eq nil
      expect(Validation.dob(dob: @data[1].dateOfBirth)).to eq('Date of birth empty')
      expect(Validation.dob(dob: @data[2].dateOfBirth)).to eq('Date of birth is not in a valid format: 2000/31/1')
    end

    it 'is not a required field' do
      stub_const('ValidationAndFormatConstants::DOB::REQUIRED', false)
    end
  end

  context 'validates driverId meets criteria' do
    it 'parses a valid id' do
      expect(DriverId).to receive(:validate).with(driverid: @data[0].driverID, firstname: @data[0].firstName, lastname: @data[0].lastName, dob: @data[0].dateOfBirth).and_return nil
      Validation.driver_id(driverid: @data[0].driverID, firstname: @data[0].firstName, lastname: @data[0].lastName, dob: @data[0].dateOfBirth)
    end

    it 'is a required field and checks if it is empty and the pattern' do
      stub_const('ValidationAndFormatConstants::DriverId::REQUIRED', true)
      expect(Validation.driver_id(driverid: @data[0].driverID, firstname: @data[0].firstName, lastname: @data[0].lastName, dob: @data[0].dateOfBirth)).to eq nil
      expect(Validation.driver_id(driverid: @data[1].driverID, firstname: @data[1].firstName, lastname: @data[1].lastName, dob: @data[1].dateOfBirth)).to eq('DriverId empty')
      expect(Validation.driver_id(driverid: @data[2].driverID, firstname: @data[2].firstName, lastname: @data[2].lastName, dob: @data[2].dateOfBirth)).to eq('DriverId pattern incorrect')
    end

    it 'is not a required field' do
      stub_const('ValidationAndFormatConstants::DriverId::REQUIRED', false)
      expect(Validation.driver_id(driverid: @data[0].driverID, firstname: @data[0].firstName, lastname: @data[0].lastName, dob: @data[0].dateOfBirth)).to eq nil
      expect(Validation.driver_id(driverid: @data[1].driverID, firstname: @data[1].firstName, lastname: @data[1].lastName, dob: @data[1].dateOfBirth)).to eq nil
      expect(Validation.driver_id(driverid: @data[2].driverID, firstname: @data[2].firstName, lastname: @data[2].lastName, dob: @data[2].dateOfBirth)).to eq('DriverId pattern incorrect')
    end
  end

  context 'validates name meets criteria' do
    it 'is a required field and checks if it is empty and meets criteria' do
      stub_const('ValidationAndFormatConstants::Entitlements::REQUIRED', true)
      expect(Validation.entitlements(entitlements: @data[0].entitlements)).to eq nil
      expect(Validation.entitlements(entitlements: @data[1].entitlements)).to eq('Entitlements empty')
      expect(Validation.entitlements(entitlements: @data[2].entitlements)).to eq("Incorrect entitlements: [\"X\"]")
    end

    it 'is not required field and checks if it is empty and meets criteria' do
      stub_const('ValidationAndFormatConstants::Entitlements::REQUIRED', false)
      expect(Validation.entitlements(entitlements: @data[0].entitlements)).to eq nil
      expect(Validation.entitlements(entitlements: @data[1].entitlements)).to eq nil
      expect(Validation.entitlements(entitlements: @data[2].entitlements)).to eq("Incorrect entitlements: [\"X\"]")
    end
  end

end

