class Sequel::Dataset
    require 'csv'
    #
    #Options: 
    #* include_column_titles: true/false. default true
    #* Other options are forwarded to CSV.generate
    def to_csv(options={})
      include_column_titles = options.delete(:include_column_titles){true}  #default: true
      n = naked
      cols = n.columns
      csv_string = CSV.generate(options) do |csv|
        csv << cols if include_column_titles
        n.each{|r| csv << cols.collect{|c| r[c] } }
      end
      csv_string
    end 
end
