Sequel.migration do
  change do
    create_table(:entries) do
      primary_key :id
      Integer :group_id
      DateTime :date
      column :data, :json, default: Sequel.pg_json({})
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
