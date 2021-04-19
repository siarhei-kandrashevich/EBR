CREATE OR REPLACE PACKAGE BODY ebr_tool AS

 /*   PROCEDURE rename_table (
        p_table_name_in      IN  user_tables.table_name%TYPE,
        p_new_table_name_in  IN  user_tables.table_name%TYPE,
        p_ebr_tool_bucket_id IN ebr_tool_bucket.id%TYPE,
        p_run_date           IN DATE
    ) AS

        c_prog_name  VARCHAR2(100) := 'rename_table';
        l_sql        VARCHAR2(25000);
        l_suffix     VARCHAR2(4) := '_EBR';
    BEGIN
        log_message(c_prog_name
                    || ':'
                    || ' Input parameter table_name_in: '
                    || p_table_name_in);
        log_message(c_prog_name
                    || ':'
                    || ' Input parameter new_table_name_in: '
                    || p_new_table_name_in);
        IF p_table_name_in IS NULL THEN
            log_message(c_prog_name
                        || ':'
                        || ' Input parameter is incorrect.');
            raise_application_error(-20001, 'Table name should be specified');
        ELSE
            IF NOT ( ebr_tool.check_object_exists(p_object_type_in => 'TABLE', p_object_name_in => p_table_name_in) ) THEN
                log_message(c_prog_name
                            || ':'
                            || ' Table '
                            || p_table_name_in
                            || ' does not exist.');
                raise_application_error(-20002, ' Table '
                                                || p_table_name_in
                                                || ' does not exists.');
            END IF;
        END IF;

        IF p_new_table_name_in IS NOT NULL THEN
            IF ( ebr_tool.check_object_exists(p_object_type_in => 'TABLE', p_object_name_in => p_new_table_name_in) ) THEN
                log_message(c_prog_name
                            || ':'
                            || ' Table '
                            || p_new_table_name_in
                            || ' exists, renaming is not possible');
                raise_application_error(-20003, ' Table '
                                                || p_new_table_name_in
                                                || ' exists, renaming is not possible');
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

        log_message(c_prog_name
                    || ': Sql to run :'
                    || l_sql);
        EXECUTE IMMEDIATE l_sql;
        log_message(c_prog_name
                    || ': The table '
                    || p_table_name_in
                    || ' was renamed.');
    EXCEPTION
        WHEN OTHERS THEN
            log_message(c_prog_name || ': Unexpected exception');
            RAISE;
    END rename_table;

    PROCEDURE create_view (
        p_table_name_in      IN user_tables.table_name%TYPE,
        p_view_name_in       IN user_views.view_name%TYPE,
        p_ebr_tool_bucket_id IN ebr_tool_bucket.id%TYPE,
        p_run_date           IN DATE
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
        log_message(c_prog_name
                    || ':'
                    || ' Input parameter table_name_in: '
                    || p_table_name_in);
        log_message(c_prog_name
                    || ':'
                    || ' Input parameter view_name_in: '
                    || p_view_name_in);
        IF p_table_name_in IS NULL THEN
            log_message(c_prog_name
                        || ':'
                        || ' Input parameter table_name_in is NULL.');
            raise_application_error(-20001, 'Table name should be specified.');
        END IF;

        IF p_view_name_in IS NULL THEN
            log_message(c_prog_name
                        || ':'
                        || ' Input parameter view_name_in is NULL.');
            raise_application_error(-20002, 'View name should be specified.');
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
        log_message(c_prog_name
                    || ': Sql to execute: '
                    || l_sql);
        EXECUTE IMMEDIATE l_sql;
        log_message(c_prog_name
                    || ': The view '
                    || p_view_name_in
                    || ' was created.');
    EXCEPTION
        WHEN OTHERS THEN
            log_message(c_prog_name || ': Unexpected exception');
            RAISE;
    END create_view;

    FUNCTION check_object_exists (
        p_object_type_in     IN user_objects.object_type%TYPE,
        p_object_name_in     IN user_objects.object_name%TYPE,
        p_ebr_tool_bucket_id IN ebr_tool_bucket.id%TYPE,
        p_run_date           IN DATE
    ) RETURN BOOLEAN AS
        c_prog_name      VARCHAR2(100) := 'check_object_exists';
        l_object_exists  INTEGER;
    BEGIN
        log_message(c_prog_name
                    || ':'
                    || ' Input parameter object_type_in: '
                    || p_object_type_in);
        log_message(c_prog_name
                    || ':'
                    || ' Input parameter object_name_in: '
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
                log_message(c_prog_name
                            || ':'
                            || ' Object '
                            || p_object_name_in
                            || ' type '
                            || p_object_type_in
                            || ' exists.');

                RETURN true;
            ELSE
                log_message(c_prog_name
                            || ':'
                            || ' Object '
                            || p_object_name_in
                            || ' type '
                            || p_object_type_in
                            || ' does not exist.');

                RETURN false;
            END IF;

        ELSE
            log_message(c_prog_name
                        || ':'
                        || ' Input parameters are incorrect.');
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            log_message(c_prog_name || ': Unexpected exception');
            RAISE;
            RETURN NULL;
    END check_object_exists;*/

    PROCEDURE log_message (
        p_ebr_tool_bucket_id  IN  INTEGER,
        p_message_date        IN  DATE,
        p_message_source      IN  VARCHAR2,
        p_message_type        IN  VARCHAR2,
        p_log_message         IN  VARCHAR2
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
            p_ebr_tool_bucket_id,
            p_message_date,
            p_message_source,
            p_message_type,
            p_log_message
        );

    END log_message;

    PROCEDURE run_renaming (p_ebr_tool_bucket_name IN ebr_tool_bucket.bucket_name%TYPE) 
    AS
        c_prog_name   VARCHAR2(100) := 'run_renaming';
        c_run_date    DATE := sysdate;
        l_ebr_tool_bucket_id  ebr_tool_bucket.id%TYPE;
        l_table_name  VARCHAR2(100);
        l_view_name   VARCHAR2(100);
        CURSOR l_cur_tables_list IS
        SELECT
            table_name
        FROM
            ebr_list;

    BEGIN
        SELECT id 
        INTO l_ebr_tool_bucket_id
        FROM ebr_tool_bucket
        WHERE UPPER(bucket_name) = UPPER(p_ebr_tool_bucket_name);
        
        IF l_ebr_tool_bucket_id IS NOT NULL THEN 
            BEGIN
                FOR l_cur_tables_list_rec IN l_cur_tables_list LOOP
                    --ebr_tool.rename_table(l_cur_tables_list_rec.table_name, l_cur_tables_list_rec.table_name || '_EBR');
                    --ebr_tool.create_view(l_cur_tables_list_rec.table_name || '_EBR', l_cur_tables_list_rec.table_name);
                    NULL;
                END LOOP;
            END;

            dbms_utility.compile_schema(schema => user, compile_all => false);
        
        ELSE 
            log_message(NULL,c_run_date,c_prog_name,'Error','The bucket '||p_ebr_tool_bucket_name||' does not exists.');
        END IF;
    END run_renaming;

    PROCEDURE run_rollback (p_ebr_tool_bucket_name IN ebr_tool_bucket.bucket_name%TYPE) 
    AS

        c_prog_name           VARCHAR2(100) := 'run_rollback';
        c_run_date            DATE := sysdate;
        l_ebr_tool_bucket_id  ebr_tool_bucket.id%TYPE;
        l_table_name          VARCHAR2(100);
        l_view_name           VARCHAR2(100);
        l_sql                 VARCHAR2(25000);
        CURSOR l_cur_tables_list IS
        SELECT
            table_name
        FROM
            ebr_list;

    BEGIN
        
        /*SELECT ebr_tool_bucket_id 
        INTO l_ebr_tool_bucket_id
        FROM ebr_tool_bucket
        WHERE UPPER(bucket_name) = UPPER(p_ebr_tool_bucket_name);
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

END ebr_tool;