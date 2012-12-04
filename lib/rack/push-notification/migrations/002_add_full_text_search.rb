Sequel.migration do
  up do
    add_column :devices, :tsv, 'TSVector'

    run %{
      CREATE INDEX tsv_GIN ON devices \
        USING GIN(tsv);
    }

    run %{
      CREATE TRIGGER TS_tsv \
        BEFORE INSERT OR UPDATE ON devices \
      FOR EACH ROW EXECUTE PROCEDURE \
        tsvector_update_trigger(tsv, 'pg_catalog.english', token, alias, locale, timezone);
    }
  end

  down do
    drop_column :devices, :tsv
    drop_index :devices, :tsv_GIN
    drop_trigger :devices, :TS_tsv
  end
end
