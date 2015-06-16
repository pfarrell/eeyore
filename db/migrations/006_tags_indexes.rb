Sequel.migration do
  change do
    alter_table(:entries_tags) do
      add_index [:entry_id, :tag_id]
    end
  end
end
