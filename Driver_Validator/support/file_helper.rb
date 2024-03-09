# frozen_string_literal: true

module FileHelper
  def self.read_csv(file_name:)
    raise StandardError, "Unable to find csv file to load: #{file_name}" unless File.exist?(file_name)

    CSV.parse(File.read(file_name), headers: true).map(&:to_h)
  end

  def self.save_to_csv(save_file_name:, data:)
    string_arr = transform_object_to_array(data: data)
    begin
      # creates file path if it doesnt already exist
      FileUtils.mkdir_p('Driver_Validator/results/') unless File.directory?('Driver_Validator/results/')

      CSV.open("Driver_Validator/results/#{save_file_name}.csv", 'w',
               write_headers: true, headers: ValidationAndFormatConstants::SaveFile::Headers) do |line|
        string_arr.each { |person| line << person }
      end
    rescue Errno::ENOENT => e
      raise "Unable to save csv file:\n#{e}".colorize(:color => :red, :mode => :bold)
    else
      puts "File: #{save_file_name} has been saved in Results directory".colorize(:green)
    end
  end

  def self.transform_object_to_array(data:)
    data.map(&:convert_to_string_arr)
  end

  def self.count_errors(data:)
    error_count = {}
    errors_array = data.map(&:errors)

    errors_array.each do |error|
      error.each_key do |key|
        error_count[key] ||= 0
        error_count[key] += 1
      end
    end

    puts "\nThe following is a total count of all the individual errors:\nPlease note that some drivers have more than 1 validation error"
    error_count.each { |key, value| puts "#{key}: #{value}".colorize(:blue) }
  end
end
