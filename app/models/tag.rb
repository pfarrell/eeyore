class Tag < Sequel::Model
  many_to_many :entries
  many_to_one :group
end
