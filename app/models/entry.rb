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

  def self.with_tags(group)
    sql = "select e.id, e.date, e.data, array_agg(t.tag) as tags from entries_tags et join entries e on e.id = et.entry_id join tags t on et.tag_id = t.id where t.group_id = ? group by e.id, e.date order by e.date desc"
    DB.fetch(sql, group.id)
  end
end
