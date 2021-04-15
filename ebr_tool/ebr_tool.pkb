CREATE OR REPLACE PACKAGE BODY ebr_tool AS

    PROCEDURE rename_table (
        p_table_name_in      IN  user_tables.table_name%TYPE,
        p_new_table_name_in  IN  user_tables.table_name%TYPE
    ) AS

        c_prog_name  VARCHAR2(100) := 'rename_table';
        l_sql        VARCHAR2(25000);
        l_suffix     VARCHAR2(4) := '_EBRT';
    BEGIN
        print_debug(c_prog_name
                    || ':'
                    || ' Input parameter table_name_in: '
                    || p_table_name_in);
        print_debug(c_prog_name
                    || ':'
                    || ' Input parameter new_table_name_in: '
                    || p_new_table_name_in);
        IF p_table_name_in IS NULL THEN
            print_debug(c_prog_name
                        || ':'
                        || ' Input parameter is incorrect.');
            raise_application_error(-20001, 'Table name should be specified');
        ELSE
            IF NOT ( ebr_tool.check_object_exists(p_object_type_in => 'TABLE', p_object_name_in => p_table_name_in) ) THEN
                print_debug(c_prog_name
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
                print_debug(c_prog_name
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

        print_debug(c_prog_name
                    || ': Sql to run :'
                    || l_sql);
        EXECUTE IMMEDIATE l_sql;
        print_debug(c_prog_name
                    || ': The table '
                    || p_table_name_in
                    || ' was renamed.');
    EXCEPTION
        WHEN OTHERS THEN
            print_debug(c_prog_name || ': Unexpected exception');
            RAISE;
    END rename_table;

    PROCEDURE create_view (
        p_table_name_in  IN  user_tables.table_name%TYPE,
        p_view_name_in   IN  user_views.view_name%TYPE
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
        print_debug(c_prog_name
                    || ':'
                    || ' Input parameter table_name_in: '
                    || p_table_name_in);
        print_debug(c_prog_name
                    || ':'
                    || ' Input parameter view_name_in: '
                    || p_view_name_in);
        IF p_table_name_in IS NULL THEN
            print_debug(c_prog_name
                        || ':'
                        || ' Input parameter table_name_in is NULL.');
            raise_application_error(-20001, 'Table name should be specified.');
        END IF;

        IF p_view_name_in IS NULL THEN
            print_debug(c_prog_name
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
        print_debug(c_prog_name
                    || ': Sql to execute: '
                    || l_sql);
        EXECUTE IMMEDIATE l_sql;
        print_debug(c_prog_name
                    || ': The view '
                    || p_view_name_in
                    || ' was created.');
    EXCEPTION
        WHEN OTHERS THEN
            print_debug(c_prog_name || ': Unexpected exception');
            RAISE;
    END create_view;

    FUNCTION check_object_exists (
        p_object_type_in  IN  user_objects.object_type%TYPE,
        p_object_name_in  IN  user_objects.object_name%TYPE
    ) RETURN BOOLEAN AS
        c_prog_name      VARCHAR2(100) := 'check_object_exists';
        l_object_exists  INTEGER;
    BEGIN
        print_debug(c_prog_name
                    || ':'
                    || ' Input parameter object_type_in: '
                    || p_object_type_in);
        print_debug(c_prog_name
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
                print_debug(c_prog_name
                            || ':'
                            || ' Object '
                            || p_object_name_in
                            || ' type '
                            || p_object_type_in
                            || ' exists.');

                RETURN true;
            ELSE
                print_debug(c_prog_name
                            || ':'
                            || ' Object '
                            || p_object_name_in
                            || ' type '
                            || p_object_type_in
                            || ' does not exist.');

                RETURN false;
            END IF;

        ELSE
            print_debug(c_prog_name
                        || ':'
                        || ' Input parameters are incorrect.');
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            print_debug(c_prog_name || ': Unexpected exception');
            RAISE;
            RETURN NULL;
    END check_object_exists;

    PROCEDURE print_debug (
        p_message_in IN VARCHAR2
    ) AS
        c_prog_name  VARCHAR2(100) := 'print_debug';
        l_debug_on   BOOLEAN := false;
    BEGIN
        IF l_debug_on THEN
            dbms_output.put_line(p_message_in);
        END IF;
    END print_debug;

    PROCEDURE run_renaming AS

        c_prog_name   VARCHAR2(100) := 'run_renaming';
        l_table_name  VARCHAR2(100);
        l_view_name   VARCHAR2(100);
        CURSOR l_cur_tables_list IS
        SELECT
            table_name
        FROM
            ebr_list;

    BEGIN
        FOR l_cur_tables_list_rec IN l_cur_tables_list LOOP
            ebr_tool.rename_table(l_cur_tables_list_rec.table_name, l_cur_tables_list_rec.table_name || '_EBRT');
            ebr_tool.create_view(l_cur_tables_list_rec.table_name || '_EBRT', l_cur_tables_list_rec.table_name);
        END LOOP;

        dbms_utility.compile_schema(schema => user, compile_all => false);
    END run_renaming;

    PROCEDURE run_rollback AS

        c_prog_name   VARCHAR2(100) := 'run_rollback';
        l_table_name  VARCHAR2(100);
        l_view_name   VARCHAR2(100);
        l_sql         VARCHAR2(25000);
        
        CURSOR l_cur_tables_list IS
        SELECT
            table_name
        FROM
            ebr_list;

    BEGIN
        FOR l_cur_tables_list_rec IN l_cur_tables_list LOOP

            IF ( ebr_tool.check_object_exists('VIEW', l_cur_tables_list_rec.table_name) ) THEN
                
                print_debug(c_prog_name
                            || ': View '
                            || l_cur_tables_list_rec.table_name
                            || ' exists, dropping');
                l_sql :=  'DROP VIEW ' || l_cur_tables_list_rec.table_name;
                print_debug(c_prog_name
                            || ': Sql to run :'
                            || l_sql);
                EXECUTE IMMEDIATE l_sql;
            END IF;

            IF ( ebr_tool.check_object_exists('TABLE', l_cur_tables_list_rec.table_name || '_EBRT') ) THEN
                ebr_tool.rename_table(l_cur_tables_list_rec.table_name || '_EBRT', l_cur_tables_list_rec.table_name);
            END IF;

        END LOOP;

        dbms_utility.compile_schema(schema => user, compile_all => false);
    END run_rollback;

END ebr_tool;