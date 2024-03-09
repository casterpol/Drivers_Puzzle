# frozen_string_literal: true

module ValidationAndFormatConstants
  module SaveFile
    Headers = %w[lastName firstName dateOfBirth driverID entitlements errors].freeze
  end

  module DriverId
    Required = true
    MonthFormat = '%m'
    YearFormat = '%y'
    ReplacementCharacter = 'X'
  end

  module Names
    LastNameRequired = true
    FirstNameRequired = false
  end

  module DOB
    Required = true
    UpperAge = 100
    LowerAge = 15
    OutputFormat = '%d, %b, %Y'
  end

  module Entitlements
    Required = true
    FieldsMap = { 'A' => 'Motorbike',
                  'B' => 'Car',
                  'C' => 'Lorry',
                  'D' => 'Bus' }.freeze
  end
end
