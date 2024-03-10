# frozen_string_literal: true

module ValidationAndFormatConstants
  module SaveFile
    HEADERS = %w[lastName firstName dateOfBirth driverID entitlements errors].freeze
  end

  module DriverId
    REQUIRED = true
    MONTH_FORMAT = '%m'
    YEAR_FORMAT = '%y'
    REPLACEMENT_CHARACTER = 'X'
  end

  module Names
    LAST_NAME_REQUIRED = true
    FIRST_NAME_REQUIRED = false
  end

  module DOB
    REQUIRED = true
    UPPER_AGE = 100
    LOWER_AGE = 15
    OUTPUT_FORMAT = '%d, %b, %Y'
  end

  module Entitlements
    REQUIRED = true
    FIELDS_MAP = { 'A' => 'Motorbike',
                  'B' => 'Car',
                  'C' => 'Lorry',
                  'D' => 'Bus' }.freeze
  end
end
