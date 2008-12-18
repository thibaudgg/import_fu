require 'fastercsv'

# be careful, there's no validation or escaping here!
module ImportFu
  
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    
    def import(*args)
      options = { :local => false, :replace => false, :timestamps => true, :format => false }
      options.merge!(args.pop) if args.last.is_a? Hash
      
      columns = args.first
      if args.last.is_a? Array # Array of values
        columns += [:created_at, :updated_at] if options[:timestamps]
        csv_tempfile = create_csv_tempfile_for(args.last, options)
        csv_path = csv_tempfile.path
      else # path of an existing csv
        csv_path = args.last
      end
      
      load_data_infile_sql = build_load_data_infile_statement(csv_path, columns, options)
      ActiveRecord::Base.connection.execute(load_data_infile_sql)
      
      csv_tempfile.delete if csv_tempfile
    end
    
    protected
    
    def create_csv_tempfile_for(values, options = {})
      # change permissions on tmpdir
      File.new(Dir::tmpdir).chmod(0755) rescue nil
      # create tempfile
      csv_tempfile = Tempfile.new('ImportFu')
      csv_tempfile.chmod(0644)
      # write csv in tempfile
      FasterCSV.open(csv_tempfile.path, "w") do |csv|
        values.each do |column_values|
          column_values.map! { |value| format_value(value) } if options[:format]
          if options[:timestamps]
            csv << (column_values + [Time.now.utc.to_s(:db), Time.now.utc.to_s(:db)])
          else
            csv << column_values
          end
        end
      end
      csv_tempfile
    end 
    
    def format_value(value)
      case value.class.to_s
      when "Time", "Date"
        value.to_s(:db)
      when 'NilClass'
        'NULL'
      else
        value.to_s
      end
    end
    
    def build_load_data_infile_statement(csv_path, columns, options = {})
      local = options[:local] ? 'LOCAL' : ''
      replace = options[:replace] ? 'REPLACE' : 'IGNORE'
      charset = options[:charset] || 'UTF8'
      column_list = columns.map(&:to_s).join(',')
      
      "LOAD DATA #{local} INFILE '#{csv_path}' #{replace} INTO TABLE #{table_name} CHARACTER SET #{charset} FIELDS TERMINATED BY ',' ENCLOSED BY '\"' (#{column_list});"
    end
    
  end
end