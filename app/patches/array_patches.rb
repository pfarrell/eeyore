class Array

  def to_csv
    require 'csv'
    CSV.generate do |csv|
      self.each do |entry|
        csv << entry.values
      end
    end
  end
end
