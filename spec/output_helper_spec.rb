RSpec.describe OutputHelper do
  context 'using a valid driver object:' do
    before(:each) do
      test_drivers = [{ 'lastName' => 'lewis', 'firstName' => 'paul', 'dateOfBirth' => '1984-06-01', 'driverID' => 'LEWIP0684', 'entitlements' => '["C", "D", "A"]'},
                      { 'lastName' => 'jones', 'firstName' => 'peter', 'dateOfBirth' => '2006-12-07', 'driverID' => 'JONEP0684', 'entitlements' => '["B", "A"]'}]
      @data = []
      test_drivers.each { |driver| @data << Driver.new(driver: driver) }
    end

    it 'returns a count of errors when count_errors method is called' do
      # stops any terminal output of the count
      allow($stdout).to receive(:puts).and_return nil

      #  sense check that count returns 0 if none are present
      expect(OutputHelper.count_errors(data: @data)).to be_empty

      # Add error fields to drivers
      @data[0].errors = { 'DriverId' => 'DriverId pattern incorrect', 'Entitlements' => 'Incorrect entitlements: ["U", "Y"]' }
      @data[1].errors = { 'Last Name' => 'Invalid characters found: 20240213', 'Entitlements' => 'Incorrect entitlements: ["U", "Y"]' }

      expect(OutputHelper.count_errors(data: @data)).to eq({ 'Last Name' => 1, 'DriverId' => 1, 'Entitlements' => 2 })
    end
  end

end
