RSpec.describe DriverFormat do
  before(:each) do
    test_driver = { 'lastName' => 'lewis', 'firstName' => 'paul', 'dateOfBirth' => '1984-06-01', 'driverID' => 'LEWIP0684', 'entitlements' => '["C", "D", "A"]' }
    @driver = Driver.new(driver: test_driver)
    @driver.entitlements = @driver.entitlements_to_arr
  end

  it 'converts entitlements to array when format_output is called' do
    test = DriverFormat
    expect(DriverFormat).to receive(:name_format).and_return(nil).twice
    expect(DriverFormat).to receive(:dob_format).and_return(nil)
    expect(DriverFormat).to receive(:driverId_format).and_return(nil)
    expect(DriverFormat).to receive(:entitlements_format).and_return(nil)

    test.format_all(driver: @driver)
  end

  it 'converts name format to capitalised' do
    expect(DriverFormat.name_format(name: @driver.firstName)).to eq('Paul')
    expect(DriverFormat.name_format(name: @driver.lastName)).to eq('Lewis')
  end

  it 'converts date of birth format' do
    expect(DriverFormat.dob_format(dob: @driver.dateOfBirth)).to eq('01, Jun, 1984')
  end

  it 'converts DriverId format' do
    expect(DriverFormat.driverId_format(driverid: @driver.driverID)).to eq('LEWIP0684')
  end

  it 'converts entitlements to full name from character code' do
    expect(DriverFormat.entitlements_format(entitlements: @driver.entitlements)).to eq('Motorbike, Lorry, Bus')
  end

end
