class Group < Sequel::Model
  one_to_many :entries
  one_to_many :tags
end
