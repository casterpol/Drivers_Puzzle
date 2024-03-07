module FileHelper
  def self.read_csv(file_name:)
    begin
      CSV.parse(File.read(file_name), headers: true).map(&:to_h)
    rescue Errno::ENOENT => e
      raise ("Unable to find csv file to load: #{file_name.colorize(:color => :red, :mode => :bold)}\nError:#{e}")
    end
  end

  def self.format_array(array:, format_key:)
    array.each do |object|
      object[format_key].gsub!(/[^0-9A-Za-z]/, '')
      object[format_key] = object[format_key].split('')
    end
    array
  end

  def self.save_to_csv(save_file_name:, data:)
    string_arr = transform_object_to_array(data: data)
    begin
      CSV.open("Driver_Validator/results/#{save_file_name}.csv", 'w',
               write_headers: true, headers: ValidationAndFormatConstants::SaveFile::Headers) do |line|
        string_arr.each { |person| line << person }
      end
    rescue Errno::ENOENT => e
      raise ("Unable to save csv file:\n#{e}")
    else
      puts ("File: #{save_file_name} has been saved in Results directory")
    end
  end

  def self.transform_object_to_array(data:)
    data.map(&:convert_to_string_arr)
  end
end
