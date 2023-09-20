do
$$
    declare
        v_table_name text;
    begin
        for v_table_name in (select table_name from information_schema.tables where table_schema = 'public')
            loop
                execute 'truncate table "' || v_table_name || '" cascade';
            end loop;
    end
$$;

commit;