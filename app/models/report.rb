class Report
  def self.errors(group)
    error_tag = Tag.find(group: group, tag: "ERROR")
    debug_tag = Tag.find(group: group, tag: "DEBUG")
    errors={}
    error_tag.entries.map{|entry| errors[entry.data["listing_id"]] = []} 
    errors.each do |listing_id,v| 
      id_tag = Tag.find(group: group, tag: listing_id)
      errors[listing_id] << Entry.search_tags([id_tag, error_tag]).all.size 
      errors[listing_id] << Entry.search_tags([id_tag, debug_tag]).all.size 
    end
    errors
  end
end
