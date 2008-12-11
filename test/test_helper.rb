require 'rubygems'
require 'test/unit'
require 'active_record'
require 'import_fu'

# gem install redgreen for colored test output
begin require 'redgreen'; rescue LoadError; end

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection(config['test'])

def rebuild_model
  ActiveRecord::Base.connection.create_table :foos, :force => true do |t|
    t.string :name
    t.integer :size
    t.timestamps
  end
  
  ActiveRecord::Base.send(:include, ImportFu)
  Object.send(:remove_const, "Foo") rescue nil
  Object.const_set("Foo", Class.new(ActiveRecord::Base))
  Foo.class_eval do
    include ImportFu
  end
end

def fixtures(path)
  "#{File.expand_path(File.dirname(__FILE__))}/fixtures/#{path}"
end