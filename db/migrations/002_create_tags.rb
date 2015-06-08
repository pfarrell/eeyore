Sequel.migration do
  change do
    create_table(:tags) do
      primary_key :id
      String :tag
      Integer :group_id
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
