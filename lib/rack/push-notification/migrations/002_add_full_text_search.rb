Sequel.migration do
  up do
    add_column :push_notification_devices, :tsv, 'TSVector'
    add_index :push_notification_devices, :tsv, type: "GIN"
    create_trigger :push_notification_devices, :tsv, :tsvector_update_trigger,
      args: [:tsv, :'pg_catalog.english', :token, :alias, :locale, :timezone],
      events: [:insert, :update],
      each_row: true
  end

  down do
    drop_column :push_notification_devices, :tsv
    drop_index :push_notification_devices, :tsv
    drop_trigger :push_notification_devices, :tsv
  end
end
