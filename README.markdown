# ImportFu

This gem add bulk import functionality to ActiveRecord model using the fast [MySQL's 'LOAD DATA INFILE'](http://dev.mysql.com/doc/refman/5.0/en/load-data.html) feature.
This gem code is greatly coming from the [import_with_load_data_in_file](http://github.com/paolodona/import_with_load_data_in_file/tree) plugin.

## Installation

Install the gem from github

    gem install guillaumegentil-import_fu --source http://gems.github.com
    
Add the gem in your Rails environment.rb file:

    config.gem "guillaumegentil-import_fu", :lib => "import_fu", :source => "http://gems.github.com"
    
Include import_fu in your ActiveRecord Model:

    class Foo < ActiveRecord::Base
      include ImportFu
    end
    
## Usage

Import from an array of values

    columns = [:name, :size]
    values = [["toto", "32"],
              ["tata", "33"]]
    
    Foo.import columns, values

Import from a csv file (MySQL need to have access on this file)

    columns = [:name, :size]
    
    Foo.import columns, '/path/of/an/csv'
    
### Options

By default ImportFu add timestamps values (Time.now.utc) when importing from an array, this can be canceled with:

    Foo.import columns, values, :timestamps => false
    
By default ImportFu do NOT reformat values passed in the array (like Time or Data value), if you want the reformat use:

    Foo.import columns, values, :format => true
    
By default ImportFu do NOT replace already existing values in database and ignore it (like values with an id already used), if you want the replace behavior use:

    Foo.import columns, values, :replace => true
    
If your Rails app and your MySQL database are on the same machine, you can speed up the import by passing:

    Foo.import columns, values, :local => true

## Author

Thibaud Guillaume-Gentil