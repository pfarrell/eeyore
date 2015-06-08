Sequel.migration do
  change do
    create_table(:entries_tags) do
      primary_key :id
      Integer :entry_id
      Integer :tag_id
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
