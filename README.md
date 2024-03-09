# Drivers_Puzzle

## Setup
#### Gemfile
This project uses ruby gems, run the following commmand from the root file to install the gem locally:
```
bundle install
```

### How to run
If you are using Rubymine IDE, you can open the file main.rb file and press the play button.
Alternatively, you can run the following cli command from root:
````shell
ruby Driver_Validator/main.rb
````

### Rspec unit tests
This pack includes unit tests, the tests have been build and run using rspec. to run the tests use the following command from root:
````shell
bundle exec rspec 
````

### There are support folders called:
#### data
* drivers.csv = (main data set)
* validation_and_format_constants.rb = hardcoded constants in a central place for easy updating


#### support
* driver.rb = creates "driver" object
* driverId_validation.rb = specific validation for the driverId, conatins methods that create each portion to check against
* file_helpers.rb = module containing methods to interact with csv files
* formatters.rb = contains methods that format the output of the data and also a method specific to convert strings into an array,
  this method converts the entitlements string into an array for easier interaction.
* validation.rb = contains the main validation method 'validator', this method is the central point and calls the other validation methods as required 


#### Results folder
This folder will not exist on cloning, however it will generate itself when the save_to_csv method is called. 

### Spec folder
This folder contains all the unit tests which are written in rspec. simple cov as been used to collate and feedback coverage information.

