Sequel.migration do
  up do
    create_table :devices do
      primary_key :id

      column :token,      :varchar, empty: false, unique: true
      column :alias,      :varchar 
      column :badge,      :int4,    null: false, default: 0
      column :locale,     :varchar
      column :language,   :varchar
      column :timezone,   :varchar, empty: false, default: 'UTC'
      column :ip_address, :inet
      column :lat,        :float8
      column :lng,        :float8
      column :tags,       :'text[]'

      index :token
      index :alias
      index [:lat, :lng]
    end
  end
  
  down do
    drop_table :devices
  end
end
