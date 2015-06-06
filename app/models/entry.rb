class Entry < Sequel::Model
  def self.groups
    self.select_group(:group)
  end

  def self.types(group)
    self.select_group(:group, :type).where(group: group)
  end
end
