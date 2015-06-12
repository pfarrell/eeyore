class Hash
  require 'csv'
  #
  #Options: 
  #* include_column_titles: true/false. default true
  #* Other options are forwarded to CSV.generate
  def to_csv(options={})
    CSV.generate(options) do |csv|
      csv << self.values.map{|v| v.to_csv}
    end
  end 

end
