require File.expand_path(File.dirname(__FILE__) + '/test_helper')

# reopen the module and make methods public for testing
module ImportFu
  module ClassMethods
    public :create_csv_tempfile_for
    public :build_load_data_infile_statement
  end 
end 

class ImportFuTest < Test::Unit::TestCase
  
  def setup 
    rebuild_model
  end     
  
  def test_should_respond_to_import
    assert Foo.respond_to?(:import)
  end
  
  def test_should_create_a_temp_file_with_the_csv_content
    # columns = [:name, :size]
    values = [["toto", "32"],
              ["tata", "33"]]
  
    file = Foo.create_csv_tempfile_for(values)
    
    assert_equal IO.read(file.path), IO.read(fixtures('foos.csv'))
  end
  
  def test_should_import_data_form_array
    columns = [:name, :size]
    values = [["toto", "32"],
              ["tata", "33"]]
    
    Foo.import columns, values
    
    assert_equal 2, Foo.count
    assert_not_nil Foo.find_by_name_and_size('toto', 32)
    assert_not_nil Foo.find_by_name_and_size('tata', 33)
  end
  
  def test_should_import_data_form_array_with_timestamps
    columns = [:name, :size]
    values = [["toto", "32"]]
    
    Foo.import columns, values
    
    assert_kind_of Time, Foo.find_by_name_and_size('toto', 32).created_at
    assert_kind_of Time, Foo.find_by_name_and_size('toto', 32).updated_at
  end
  
  def test_should_import_data_form_array_without_timestamps
    columns = [:name, :size]
    values = [["toto", "32"]]
    
    Foo.import columns, values, :timestamps => false
    
    assert_nil Foo.find_by_name_and_size('toto', 32).created_at
    assert_nil Foo.find_by_name_and_size('toto', 32).updated_at
  end
  
  def test_should_import_data_form_array_and_format_value
    columns = [:name, :size, :created_at, :updated_at]
    values = [["toto", "32", Time.now.utc, Time.now.utc]]
    
    Foo.import columns, values, :timestamps => false, :format => true
    
    assert_kind_of Time, Foo.find_by_name_and_size('toto', 32).created_at
    assert_kind_of Time, Foo.find_by_name_and_size('toto', 32).updated_at
  end
  
  def test_should_replace_imported_data_form_array
    Foo.create(:name => 'toto', :size => '32')
    Foo.create(:name => 'tata', :size => '33')
    
    columns = [:id, :name, :size]
    values = [["1", "toto", "1000"],
              ["2", "tata", "1001"]]
    
    Foo.import columns, values, :replace => true
    
    assert_equal 2, Foo.count
    
    assert_nil Foo.find_by_name_and_size('toto', 32)
    assert_nil Foo.find_by_name_and_size('tata', 33)
    assert_not_nil Foo.find_by_name_and_size('toto', 1000)
    assert_not_nil Foo.find_by_name_and_size('tata', 1001)
  end

  def test_should_import_data_form_csv
    columns = [:name, :size]
    values = [["toto", "32"],
              ["tata", "33"]]
    
    Foo.import columns, fixtures('foos.csv')
    
    assert_equal 2, Foo.count
    assert_not_nil Foo.find_by_name_and_size('toto', 32)
    assert_not_nil Foo.find_by_name_and_size('tata', 33)
  end
  
  def test_should_generate_the_correct_default_import_statement
    expected = "LOAD DATA  INFILE 'fake.csv' IGNORE INTO TABLE foos FIELDS TERMINATED BY ',' ENCLOSED BY '\"' (col1,col2);"
    assert_equal expected, Foo.build_load_data_infile_statement('fake.csv', [:col1,:col2]) 
  end
  
  def test_should_generate_the_correct_import_statement_with_locale
    expected = "LOAD DATA LOCAL INFILE 'fake.csv' IGNORE INTO TABLE foos FIELDS TERMINATED BY ',' ENCLOSED BY '\"' (col1,col2);"
    assert_equal expected, Foo.build_load_data_infile_statement('fake.csv', [:col1,:col2], :local => true) 
  end
  
  def test_should_generate_the_correct_import_statement_with_replace
    expected = "LOAD DATA  INFILE 'fake.csv' REPLACE INTO TABLE foos FIELDS TERMINATED BY ',' ENCLOSED BY '\"' (col1,col2);"
    assert_equal expected, Foo.build_load_data_infile_statement('fake.csv', [:col1,:col2], :replace => true) 
  end 
  
end