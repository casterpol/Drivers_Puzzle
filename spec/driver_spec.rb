RSpec.describe Driver do
  before(:each) do
    test_driver = { 'lastName' => 'lewis', 'firstName' => 'paul', 'dateOfBirth' => '1984-06-01', 'driverID' => 'LEWIP0684', 'entitlements' => "[\"C\", \"D\", \"A\"]" }
    @driver = Driver.new(driver: test_driver)
  end

  it 'takes in hash and sets fields on initialisation' do
    expect(@driver.lastName).to eq('lewis')
    expect(@driver.firstName).to eq('paul')
    expect(@driver.dateOfBirth).to eq('1984-06-01')
    expect(@driver.driverID).to eq('LEWIP0684')
    expect(@driver.entitlements).to eq('["C", "D", "A"]')
  end

  it 'converts hash to array of strings when convert_to_string_arr method is called' do
    expect(@driver.convert_to_string_arr).to eq(['lewis', 'paul', '1984-06-01', 'LEWIP0684', "[\"C\", \"D\", \"A\"]", '{}'])
  end

  it 'converts entitlements to array when entitlements_to_arr method is called' do
    expect(@driver.entitlements_to_arr).to eq( ['C', 'D', 'A'] )
  end

  it 'calls "DriverFormat.format_all" when format all method is used' do
    expect(DriverFormat).to receive(:format_all).and_return(nil)
    @driver.format_output
  end
end
