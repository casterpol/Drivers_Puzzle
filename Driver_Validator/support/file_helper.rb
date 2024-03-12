# frozen_string_literal: true

module FileHelper
  # @param file_name [String]
  # @raise StandardError if file does not exist
  # return [Array]
  def self.read_csv(file_name:)
    raise StandardError, "Unable to find csv file to load: #{file_name}" unless File.exist?(file_name)

    CSV.parse(File.read(file_name), headers: true).map(&:to_h)
  end

  # @params saver_file_name [String], data[Array]
  # @param data iterates using map, calling method convert_to_string_arr
  # FileUtils.mkdir ensures results folder is presnt, or generates one
  # headers passed in using ValidationAndFormatConstants::SaveFile::HEADERS
  # @rescue will catch any file errors and @raise error
  # @returns csv file, comma delimited
  def self.save_to_csv(save_file_name:, data:)
    string_arr = data.map(&:convert_to_string_arr)
    begin
      # creates file path if it doesnt already exist
      FileUtils.mkdir_p('Driver_Validator/results/') unless File.directory?('Driver_Validator/results/')

      CSV.open("Driver_Validator/results/#{save_file_name}.csv", 'w',
               write_headers: true, headers: ValidationAndFormatConstants::SaveFile::HEADERS) do |line|
        string_arr.each { |person| line << person }
      end
    rescue Errno::ENOENT => e
      raise "Unable to save csv file:\n#{e}".colorize(:color => :red, :mode => :bold)
    else
      puts "File: #{save_file_name} has been saved in Results directory".colorize(:green)
    end
  end
end
