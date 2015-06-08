Sequel.migration do
  change do
    alter_table(:tags) do
      add_index [:tag]
    end
  end
end
