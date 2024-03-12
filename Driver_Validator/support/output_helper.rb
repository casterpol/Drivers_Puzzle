# frozen_string_literal: true

module OutputHelper
  # @param data [Array]
  # iterates through @param and creates error_array [Array]
  # iterates through errors_array, error [Hash]
  # iterates through error [Hash] using the key, counts key as it goes
  # @return [String], with breakdown of the total error_count
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

