RSpec.describe DriverId do
  context 'Validate method updates error field if error if one is found' do
    before(:each) do
      test_driver = { 'lastName' => 'lewis', 'firstName' => 'paul', 'dateOfBirth' => '1984-06-01',
                      'driverID' => 'LEWIP0684', 'entitlements' => '["C", "D", "A"]' }
      @driver = Driver.new(driver: test_driver)
    end

    error_map = {
      'LEWIX0684' => 'First name incorrect, generated first name is: P',
      'TESTP0684' => 'Last name incorrect, generated last name is: LEWI',
      'LEWIP1084' => 'Month incorrect, generated month is: 06',
      'LEWIP0694' => 'Year incorrect, generated year is: 84',
      'LEWIP0684' => nil
    }
    error_map.each do |new_id, error_response|
      it 'returns error if first name initial value is incorrect' do
        @driver.driverID = new_id
        expect(DriverId.validate(driverid: new_id, firstname: @driver.firstName, lastname: @driver.lastName, dob: @driver.dateOfBirth)).to eq(error_response)
      end
    end
  end

  context 'First name and last name generator:' do
    name_data = { 'Lewis' => 'LEWI', 'Ray' => 'RAYX', 'Bo' => 'BOXX', 'A' => 'AXXX', '' => 'XXXX' }
    name_data.each do |input, expected_output|

      it 'generates a 4 character last name to use to validate against' do
        expect(DriverId.last_name(name: input)).to eq(expected_output)
      end

      it 'generates a single capital letter, or an "X" if name is ommitted' do
        expect(DriverId.first_name_initial(name: input)[0]).to eq(expected_output[0])
      end
    end
  end

  context 'Month and Year generator:' do
    month_data = { '16/2/1983' => '02', '1/12/2024' => '12', '01-10-2019' => '10', '1994/3/5' => '03',
'1988-06-25' => '06' }
    year_data = { '16/2/1983' => '83', '1/12/2024' => '24', '01-10-2019' => '19', '1994/3/5' => '94',
'1988-06-25' => '88' }

    month_data.each do |input, expected_output|

      it 'generates a month consisting of 2 digits' do
        expect(DriverId.date_of_birth(dob: input, date_format: ValidationAndFormatConstants::DriverId::MONTH_FORMAT)).to eq(expected_output)
      end
    end

    year_data.each do |input, expected_output|
      it 'generates a year consisting of 2 digits' do
        expect(DriverId.date_of_birth(dob: input, date_format: ValidationAndFormatConstants::DriverId::YEAR_FORMAT)).to eq(expected_output)
      end
    end
  end

end
