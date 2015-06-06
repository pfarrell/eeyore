Sequel.migration do
  change do
    create_table(:entries) do
      primary_key :id
      String :group
      String :type
      DateTime :date
      column :data, :json, default: Sequel.pg_json({})
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
