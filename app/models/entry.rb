class Entry < Sequel::Model
  many_to_one  :group
  many_to_many :tags
end
