module ValidationAndFormatConstants
  module SaveFile
    Headers = %w[lastName firstName dateOfBirth driverID entitlements errors].freeze
  end

  module DriverId
    Required = true
    MonthFormat = '%m'.freeze
    YearFormat = '%y'.freeze
    ReplacementCharacter = 'X'.freeze
  end

  module Names
    LastNameRequired = true
    FirstNameRequired = false
  end

  module DOB
    Required = true
    UpperAge = 100
    LowerAge = 15
    OutputFormat = '%d, %b, %Y'.freeze
  end

  module Entitlements
    Required = true
    FieldsMap = { 'A' => 'Motorbike',
                  'B' => 'Car',
                  'C' => 'Lorry',
                  'D' => 'Bus' }.freeze
  end
end
