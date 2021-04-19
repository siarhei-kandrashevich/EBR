CREATE OR REPLACE PACKAGE BODY ebr_tool AS

    PROCEDURE rename_table (
        p_table_name_in          IN  user_tables.table_name%TYPE,
        p_new_table_name_in      IN  user_tables.table_name%TYPE,
        p_ebr_tool_bucket_id_in  IN  ebr_tool_bucket.id%TYPE,
        p_run_date_in            IN  DATE
    ) AS

        c_prog_name  VARCHAR2(100) := 'rename_table';
        l_sql        VARCHAR2(25000);
        l_suffix     VARCHAR2(4) := '_EBR';
    BEGIN
        log_message(p_ebr_tool_bucket_id_in, p_run_date_in, c_prog_name, 'INFO',
                   'Start renaming for : p_table_name_in='
                   || p_table_name_in
                   || '; p_new_table_name_in='
                   || p_new_table_name_in);

        IF p_table_name_in IS NULL THEN
            raise_application_error(c_undefined_value, 'Table name should be specified');
        ELSE
            IF NOT ( ebr_tool.check_object_exists('TABLE', p_table_name_in, p_ebr_tool_bucket_id_in, p_run_date_in) ) THEN
                raise_application_error(c_incorrect_object_name,
                                       ' Table '
                                       || p_table_name_in
                                       || ' does not exists.');
            END IF;
        END IF;

        IF p_new_table_name_in IS NOT NULL THEN
            IF ( ebr_tool.check_object_exists('TABLE', p_new_table_name_in, p_ebr_tool_bucket_id_in, p_run_date_in) ) THEN
                raise_application_error(c_object_exists, ' Table '
                                                         || p_new_table_name_in
                                                         || ' exists, renaming is not possible.');
            END IF;

            l_sql := 'ALTER TABLE '
                     || p_table_name_in
                     || ' RENAME TO '
                     || p_new_table_name_in;
        ELSE
            l_sql := 'ALTER TABLE '
                     || p_table_name_in
                     || ' RENAME TO '
                     || p_table_name_in
                     || l_suffix;
        END IF;

        log_message(p_ebr_tool_bucket_id_in, p_run_date_in, c_prog_name, 'WARNING', l_sql);
        EXECUTE IMMEDIATE l_sql;
        log_message(p_ebr_tool_bucket_id_in, p_run_date_in, c_prog_name, 'INFO',
                   'The table has been renamed from '
                   || p_table_name_in
                   || ' to '
                   || p_new_table_name_in);

    EXCEPTION
        WHEN e_incorrect_object_name THEN
            log_message(p_ebr_tool_bucket_id_in, p_run_date_in, c_prog_name, 'ERROR', sqlerrm);
            change_status(p_table_name_in, 'Failed', 'The table name is incorrect', p_ebr_tool_bucket_id_in, p_run_date_in);
            RAISE e_incorrect_object_name;
        WHEN e_undefined_value THEN
            log_message(p_ebr_tool_bucket_id_in, p_run_date_in, c_prog_name, 'ERROR', sqlerrm);
            RAISE e_undefined_value;
        WHEN e_object_exists THEN
            log_message(p_ebr_tool_bucket_id_in, p_run_date_in, c_prog_name, 'ERROR', sqlerrm);
            change_status(p_table_name_in, 'Failed', 'The table with this new name exists', p_ebr_tool_bucket_id_in,
                         p_run_date_in);
            RAISE e_object_exists;
        WHEN OTHERS THEN
            log_message(p_ebr_tool_bucket_id_in, p_run_date_in, c_prog_name, 'ERROR', sqlerrm);
            change_status(p_table_name_in, 'Failed', 'Unexpected error', p_ebr_tool_bucket_id_in, p_run_date_in);
            RAISE;
    END rename_table;

    PROCEDURE create_view (
        p_table_name_in          IN  user_tables.table_name%TYPE,
        p_view_name_in           IN  user_views.view_name%TYPE,
        p_ebr_tool_bucket_id_in  IN  ebr_tool_bucket.id%TYPE,
        p_run_date_in            IN  DATE
    ) AS

        c_prog_name    VARCHAR2(100) := 'create_view';
        l_sql          VARCHAR2(25000);
        l_column_list  VARCHAR2(25000);
        CURSOR l_cur_columns_list (
            table_name user_tables.table_name%TYPE
        ) IS
        SELECT
            column_name
        FROM
            user_tab_columns
        WHERE
            table_name = table_name;

    BEGIN
        log_message(p_ebr_tool_bucket_id_in, p_run_date_in, c_prog_name, 'INFO',
                   'Start renaming for : p_table_name_in='
                   || p_table_name_in
                   || '; p_view_name_in='
                   || p_view_name_in);

        IF p_table_name_in IS NULL THEN
            raise_application_error(c_undefined_value, 'Table name should be specified');
        END IF;
        IF p_view_name_in IS NULL THEN
            raise_application_error(c_undefined_value, 'View name should be specified');
        END IF;
        IF NOT ( ebr_tool.check_object_exists('TABLE', p_table_name_in, p_ebr_tool_bucket_id_in, p_run_date_in) ) THEN
            raise_application_error(c_incorrect_object_name,
                                   ' Table '
                                   || p_table_name_in
                                   || ' does not exists.');
        END IF;

        IF ( ebr_tool.check_object_exists('VIEW', p_view_name_in, p_ebr_tool_bucket_id_in, p_run_date_in) ) THEN
            raise_application_error(c_object_exists, ' View '
                                                     || p_view_name_in
                                                     || ' exists, creating is not possible.');
        END IF;

        l_sql := 'CREATE OR REPLACE EDITIONABLE VIEW '
                 || p_view_name_in
                 || ' AS SELECT ';
        SELECT
            listagg(column_name, ', ') "Column_list"
        INTO l_column_list
        FROM
            user_tab_columns
        WHERE
            table_name = p_table_name_in;

        l_sql := l_sql
                 || l_column_list
                 || ' FROM '
                 || p_table_name_in;
        log_message(p_ebr_tool_bucket_id_in, p_run_date_in, c_prog_name, 'WARNING', l_sql);
        EXECUTE IMMEDIATE l_sql;
        log_message(p_ebr_tool_bucket_id_in, p_run_date_in, c_prog_name, 'INFO',
                   'The view '
                   || p_view_name_in
                   || ' has been created for '
                   || p_table_name_in
                   || ' table.');

    EXCEPTION
        WHEN e_incorrect_object_name THEN
            log_message(p_ebr_tool_bucket_id_in, p_run_date_in, c_prog_name, 'ERROR', sqlerrm);
            change_status(p_table_name_in, 'Failed', 'The table name is incorrect', p_ebr_tool_bucket_id_in, p_run_date_in);
            RAISE e_incorrect_object_name;
        WHEN e_undefined_value THEN
            log_message(p_ebr_tool_bucket_id_in, p_run_date_in, c_prog_name, 'ERROR', sqlerrm);
            RAISE e_undefined_value;
        WHEN e_object_exists THEN
            log_message(p_ebr_tool_bucket_id_in, p_run_date_in, c_prog_name, 'ERROR', sqlerrm);
            change_status(p_table_name_in, 'Failed', 'The view exists', p_ebr_tool_bucket_id_in, p_run_date_in);
            RAISE e_object_exists;
        WHEN OTHERS THEN
            log_message(p_ebr_tool_bucket_id_in, p_run_date_in, c_prog_name, 'ERROR', sqlerrm);
            change_status(p_table_name_in, 'Failed', 'Unexpected error', p_ebr_tool_bucket_id_in, p_run_date_in);
            RAISE;
    END create_view;

    FUNCTION check_object_exists (
        p_object_type_in         IN  user_objects.object_type%TYPE,
        p_object_name_in         IN  user_objects.object_name%TYPE,
        p_ebr_tool_bucket_id_in  IN  ebr_tool_bucket.id%TYPE,
        p_run_date_in            IN  DATE
    ) RETURN BOOLEAN AS
        c_prog_name      VARCHAR2(100) := 'check_object_exists';
        l_object_exists  INTEGER;
    BEGIN
        log_message(p_ebr_tool_bucket_id_in, p_run_date_in, c_prog_name, 'INFO',
                   'Checking if object exists for: p_object_type_in='
                   || p_object_type_in
                   || '; p_object_name_in='
                   || p_object_name_in);

        IF (
            p_object_type_in IS NOT NULL
            AND p_object_name_in IS NOT NULL
        ) THEN
            SELECT
                COUNT(1)
            INTO l_object_exists
            FROM
                user_objects o
            WHERE
                    o.object_type = upper(p_object_type_in)
                AND o.object_name = upper(p_object_name_in);

            IF l_object_exists > 0 THEN
                RETURN true;
            ELSE
                RETURN false;
            END IF;
        ELSE
            raise_application_error(c_undefined_value, 'Table name and object type should be specified');
        END IF;

    EXCEPTION
        WHEN e_undefined_value THEN
            log_message(p_ebr_tool_bucket_id_in, p_run_date_in, c_prog_name, 'ERROR', sqlerrm);
        WHEN OTHERS THEN
            log_message(p_ebr_tool_bucket_id_in, p_run_date_in, c_prog_name, 'ERROR', sqlerrm);
            RAISE;
    END check_object_exists;

    PROCEDURE log_message (
        p_ebr_tool_bucket_id_in  IN  INTEGER,
        p_message_date_in        IN  DATE,
        p_message_source_in      IN  VARCHAR2,
        p_message_type_in        IN  VARCHAR2,
        p_log_message_in         IN  VARCHAR2
    ) AS
        c_prog_name VARCHAR2(100) := 'log_message';
    BEGIN
        INSERT INTO ebr_tool_log (
            ebr_tool_bucket_id,
            message_date,
            message_source,
            message_type,
            log_message
        ) VALUES (
            p_ebr_tool_bucket_id_in,
            p_message_date_in,
            p_message_source_in,
            p_message_type_in,
            p_log_message_in
        );
        
        commit;
        
    END log_message;

    PROCEDURE run_renaming (
        p_ebr_tool_bucket_name_in IN ebr_tool_bucket.bucket_name%TYPE
    ) AS

        c_prog_name           VARCHAR2(100) := 'run_renaming';
        c_run_date            DATE := sysdate;
        l_ebr_tool_bucket_id  ebr_tool_bucket.id%TYPE;
        l_table_name          VARCHAR2(100);
        l_view_name           VARCHAR2(100);
        CURSOR l_cur_tables_list IS
        SELECT
            table_name,
            new_table_name,
            view_name
        FROM
            ebr_tool_table
        WHERE
            ebr_tool_bucket_id = l_ebr_tool_bucket_id
            AND status = 'Proposed'
        ORDER BY ID;

    BEGIN
        SELECT
            id
        INTO l_ebr_tool_bucket_id
        FROM
            ebr_tool_bucket
        WHERE
            upper(bucket_name) = upper(p_ebr_tool_bucket_name_in);

        log_message(l_ebr_tool_bucket_id, c_run_date, c_prog_name, 'INFO', 'Start renaming for bucket: ' || p_ebr_tool_bucket_name_in);
        
        IF l_ebr_tool_bucket_id IS NOT NULL THEN
            BEGIN
                FOR l_cur_tables_list_rec IN l_cur_tables_list LOOP
                    change_status(l_cur_tables_list_rec.table_name, 'In Progress',
                                 'Started procces renaming',
                                 l_ebr_tool_bucket_id,
                                 c_run_date);
                    rename_table(l_cur_tables_list_rec.table_name,
                                l_cur_tables_list_rec.new_table_name,
                                l_ebr_tool_bucket_id,
                                c_run_date);
                    create_view(l_cur_tables_list_rec.new_table_name,
                               l_cur_tables_list_rec.view_name,
                               l_ebr_tool_bucket_id,
                               c_run_date);
                    change_status(l_cur_tables_list_rec.table_name, 'Completed',
                                 'The table is renamed',
                                 l_ebr_tool_bucket_id,
                                 c_run_date);
                END LOOP;
            END;

            dbms_utility.compile_schema(schema => user, compile_all => false);
            
            log_message(l_ebr_tool_bucket_id, c_run_date, c_prog_name, 'INFO', 'All invalid objects have beed recompiled for schema ' || user);
            
        END IF;

    EXCEPTION
        WHEN no_data_found THEN
            log_message(NULL, c_run_date, c_prog_name, 'ERROR',
                       'The bucket '
                       || p_ebr_tool_bucket_name_in
                       || ' does not exists. '
                       || sqlerrm);
        WHEN OTHERS THEN
            log_message(NULL, c_run_date, c_prog_name, 'ERROR', sqlerrm);
    END run_renaming;

    PROCEDURE run_rollback (
        p_ebr_tool_bucket_name_in IN ebr_tool_bucket.bucket_name%TYPE
    ) AS

        c_prog_name           VARCHAR2(100) := 'run_rollback';
        c_run_date            DATE := sysdate;
        l_ebr_tool_bucket_id  ebr_tool_bucket.id%TYPE;
        l_table_name          VARCHAR2(100);
        l_view_name           VARCHAR2(100);
        l_sql                 VARCHAR2(25000);
        CURSOR l_cur_tables_list IS
        SELECT
            table_name,
            new_table_name,
            view_name
        FROM
            ebr_tool_table
        WHERE
            ebr_tool_bucket_id = l_ebr_tool_bucket_id;

    BEGIN
        
        /*SELECT ebr_tool_bucket_id 
        INTO l_ebr_tool_bucket_id
        FROM ebr_tool_bucket
        WHERE UPPER(bucket_name) = UPPER(p_ebr_tool_bucket_name_in);
        ------------------------  TO DO --------------------------------------------
        IF l_ebr_tool_bucket_id IS NOT NULL THEN 
        BEGIN
        
            FOR l_cur_tables_list_rec IN l_cur_tables_list LOOP
                IF ( ebr_tool.check_object_exists('VIEW', l_cur_tables_list_rec.table_name) ) THEN
                    log_message(c_prog_name
                                || ': View '
                                || l_cur_tables_list_rec.table_name
                                || ' exists, dropping');
                    l_sql := 'DROP VIEW ' || l_cur_tables_list_rec.table_name;
                    log_message(c_prog_name
                                || ': Sql to run :'
                                || l_sql);
                    EXECUTE IMMEDIATE l_sql;
                END IF;
            
                IF ( ebr_tool.check_object_exists('TABLE', l_cur_tables_list_rec.table_name || '_EBR') ) THEN
                    ebr_tool.rename_table(l_cur_tables_list_rec.table_name || '_EBR', l_cur_tables_list_rec.table_name);
                END IF;
            
            END LOOP;
            
            dbms_utility.compile_schema(schema => user, compile_all => false);
        ELSE 
            NULL;
            
        END IF;   */
                                                                                                                        NULL;
    END run_rollback;

    PROCEDURE change_status (
        p_table_name_in          IN  user_tables.table_name%TYPE,
        p_new_status             IN  ebr_tool_table.status%TYPE,
        p_description            IN  ebr_tool_table.description%TYPE,
        p_ebr_tool_bucket_id_in  IN  ebr_tool_bucket.id%TYPE,
        p_run_date_in            IN  DATE
    ) AS
        c_prog_name VARCHAR2(100) := 'change_status';
    BEGIN
        log_message(p_ebr_tool_bucket_id_in, p_run_date_in, c_prog_name, 'INFO',
                   'Start updating status for : p_table_name_in='
                   || p_table_name_in
                   || '; p_new_status='
                   || p_new_status
                   || '; p_description='
                   || p_description);

        UPDATE ebr_tool_table
        SET
            status = p_new_status,
            description = p_description,
            last_update = p_run_date_in
        WHERE
                table_name = p_table_name_in
            AND ebr_tool_bucket_id = p_ebr_tool_bucket_id_in;

    END;

END ebr_tool;