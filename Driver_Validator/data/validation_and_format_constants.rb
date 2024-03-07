module ValidationAndFormatConstants
  module SaveFile
    Headers = %w[lastName firstName dateOfBirth driverID entitlements errors]
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
    ValidFields = %w[A B C D]
    FieldsMap = {
      'A' => 'Motorbike',
      'B' => 'Car',
      'C' => 'Lorry',
      'D' => 'Bus'
    }
  end
end
