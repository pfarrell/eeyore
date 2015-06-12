class Report
  def self.errors(group)
    error_tag = Tag.find(group: group, tag: "ERROR")
    debug_tag = Tag.find(group: group, tag: "DEBUG")
    errors=[]
    unique_errors={}
    error_tag.entries.map{|entry| unique_errors[entry.data["listing_id"]] = 0} 
    unique_errors.each do |listing_id,v| 
      id_tag = Tag.find(group: group, tag: listing_id)
      row = {listing_id: listing_id}
      row[:errors] = Entry.search_tags([id_tag, error_tag]).all.size 
      row[:successes] = Entry.search_tags([id_tag, debug_tag]).all.size 
      errors << row
    end
    errors
  end
end
