class Entry < Sequel::Model
  many_to_one  :group
  many_to_many :tags

  def self.search_tags(tags)
    query = Entry
    tags.each do |tag|
      query = query.filter(tags: tag)
    end
    query
  end
end
