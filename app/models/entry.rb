class Entry < Sequel::Model
  def self.groups
    self.select_group(:group)
  end
end
