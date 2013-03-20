Sequel.migration do
  up do
    add_column :devices, :tsv, 'TSVector'
    add_index :devices, :tsv, type: "GIN"
    create_trigger :devices, :tsv, :tsvector_update_trigger, 
      args: [:tsv, :'pg_catalog.english', :token, :alias, :locale, :timezone], 
      events: [:insert, :update], 
      each_row: true
  end

  down do
    drop_column :devices, :tsv
    drop_index :devices, :tsv
    drop_trigger :devices, :tsv
  end
end
