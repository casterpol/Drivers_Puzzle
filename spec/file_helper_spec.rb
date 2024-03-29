RSpec.describe FileHelper do

  it 'read.csv method raises an error if the file doesnt exist' do
    msg = 'Unable to find csv file to load: doesnt exist'
    expect { FileHelper.read_csv(file_name: 'doesnt exist') }.to raise_error(StandardError, 'Unable to find csv file to load: doesnt exist')
  end

  context 'using a valid driver object:' do
    before(:each) do
      test_drivers = [{ 'lastName' => 'lewis', 'firstName' => 'paul', 'dateOfBirth' => '1984-06-01', 'driverID' => 'LEWIP0684', 'entitlements' => '["C", "D", "A"]'},
                       { 'lastName' => 'jones', 'firstName' => 'peter', 'dateOfBirth' => '2006-12-07', 'driverID' => 'JONEP0684', 'entitlements' => '["B", "A"]'}]
      @data = []
      test_drivers.each { |driver| @data << Driver.new(driver: driver) }
    end

    it 'saves a files when the save method is called' do
      # stops any terminal output of the count
      allow($stdout).to receive(:puts).and_return nil

      #   do some stuff inhere to make it work!!!!!
      file_name = 'rspec_test'
      file_path = './Driver_Validator/results/rspec_test.csv'

      #  create test file
      FileHelper.save_to_csv(save_file_name: file_name, data: @data)

      expect(File.exist?(file_path)).to be true
      expect(File.empty?(file_path)).to_not be true

      # clear down test file
      File.delete(file_path)
    end
  end
end
