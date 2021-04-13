CREATE OR REPLACE PACKAGE BODY ebr_tool AS

    PROCEDURE rename_table (
        table_name_in      IN  user_tables.table_name%TYPE,
        new_table_name_in  IN  user_tables.table_name%TYPE
    ) AS
        c_prog_name  VARCHAR2(100) := 'rename_table';
        l_sql        VARCHAR2(25000);
        l_suffix     VARCHAR2(4)   := '_EBR';
    BEGIN
        print_debug(c_prog_name
                    || ':'
                    || ' Input parameter table_name_in: '
                    || table_name_in);
        print_debug(c_prog_name
                    || ':'
                    || ' Input parameter new_table_name_in: '
                    || new_table_name_in);
        IF table_name_in IS NULL THEN
            print_debug(c_prog_name
                        || ':'
                        || ' Input parameter is incorrect.');
            raise_application_error(-20001, 'Table name should be specified');
        ELSE 
		    IF NOT (ebr_tool.check_object_exists(object_type_in => 'TABLE',
                                                 object_name_in => table_name_in)) THEN
			        print_debug(c_prog_name
                                || ':'
                                || ' Table '||table_name_in||' does not exist.');
                    raise_application_error(-20002, ' Table '||table_name_in||' does not exists.');	
            END IF;
        END IF;

	    IF new_table_name_in IS NOT NULL THEN
		
            IF (ebr_tool.check_object_exists(object_type_in => 'TABLE',
                                                 object_name_in => new_table_name_in)) THEN
                print_debug(c_prog_name
                                    || ':'
                                    || ' Table '||new_table_name_in||' exists, renaming is not possible');
                raise_application_error(-20003, ' Table '||new_table_name_in||' exists, renaming is not possible');
			END IF;
			
			l_sql := 'ALTER TABLE '
                             || table_name_in
                             || ' RENAME TO '
                             || new_table_name_in;
		ELSE 
		    l_sql := 'ALTER TABLE '
			         || table_name_in
			         || ' RENAME TO '
			         || table_name_in
			         || l_suffix;
		END IF;	
        
    EXCEPTION
        WHEN OTHERS THEN
            print_debug(c_prog_name || ': Unexpected exception');
            RAISE;
    END rename_table;

    PROCEDURE create_view (
        table_name_in  IN  user_tables.table_name%TYPE,
        view_name_in   IN  user_views.view_name%TYPE
    ) AS
        c_prog_name     VARCHAR2(100) := 'create_view';
		l_sql           VARCHAR2(25000);
		l_column_list   VARCHAR2(25000);
		CURSOR l_cur_columns_list (table_name user_tables.table_name%TYPE)
          IS
            SELECT column_name 
	        FROM user_tab_columns 
	        WHERE table_name = table_name;
			
    BEGIN
        print_debug(c_prog_name
                    || ':'
                    || ' Input parameter table_name_in: '
                    || table_name_in);
		print_debug(c_prog_name
                    || ':'
                    || ' Input parameter view_name_in: '
                    || view_name_in);

        IF table_name_in IS NULL THEN
            print_debug(c_prog_name
                        || ':'
                        || ' Input parameter table_name_in is NULL.');
            raise_application_error(-20001, 'Table name should be specified.');
        END IF;

        IF view_name_in IS NULL THEN
            print_debug(c_prog_name
                        || ':'
                        || ' Input parameter view_name_in is NULL.');
            raise_application_error(-20002, 'View name should be specified.');
        END IF;
		
		l_sql := 'CREATE OR REPLACE EDITIONABLE VIEW '||view_name_in|| ' AS SELECT ';
				
        SELECT LISTAGG(column_name, ', ') "Column_list"
        INTO l_column_list
        FROM  user_tab_columns 
        WHERE table_name = table_name_in;
		
		l_sql := l_sql || l_column_list || ' FROM ' || table_name_in;

        print_debug(c_prog_name
                    || ': Sql to execute: '
                    || l_sql);
        --EXECUTE IMMEDIATE l_sql;
    EXCEPTION
        WHEN OTHERS THEN
            print_debug(c_prog_name || ': Unexpected exception');
            RAISE;
    END create_view;

    FUNCTION check_object_exists (
        object_type_in  IN  user_objects.object_type%TYPE,
        object_name_in  IN  user_objects.object_name%TYPE
    ) RETURN BOOLEAN AS
        c_prog_name      VARCHAR2(100) := 'check_object_exists';
        l_object_exists  INTEGER;
    BEGIN
        print_debug(c_prog_name
                    || ':'
                    || ' Input parameter object_type_in: '
                    || object_type_in);
        print_debug(c_prog_name
                    || ':'
                    || ' Input parameter object_name_in: '
                    || object_name_in);
        IF (
            object_type_in IS NOT NULL
            AND object_name_in IS NOT NULL
        ) THEN
            SELECT
                COUNT(1)
            INTO l_object_exists
            FROM
                user_objects o
            WHERE
                    o.object_type = upper(object_type_in)
                AND o.object_name = upper(object_name_in);

            IF l_object_exists > 0 THEN
                print_debug(c_prog_name
                            || ':'
                            || ' Object '
                            || object_name_in
                            || ' type '
                            || object_type_in
                            || ' exists.');

                RETURN true;
            ELSE
                print_debug(c_prog_name
                            || ':'
                            || ' Object '
                            || object_name_in
                            || ' type '
                            || object_type_in
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
        message_in IN VARCHAR2
    ) AS
        c_prog_name  VARCHAR2(100) := 'print_debug';
        l_debug_on   BOOLEAN := true;
    BEGIN
        IF l_debug_on THEN
            dbms_output.put_line(message_in);
        END IF;
    END print_debug;
	
    PROCEDURE run_renaming  
	AS
        c_prog_name  VARCHAR2(100) := 'run_renaming';
        l_table_name VARCHAR2(100);
		l_view_name VARCHAR2(100);
		CURSOR l_cur_tables_list 
          IS
            SELECT table_name 
	        FROM ebr_list;
    BEGIN
	    FOR l_cur_tables_list_rec in l_cur_tables_list 
            LOOP
                EBR_TOOL.rename_table (l_cur_tables_list_rec.table_name,l_cur_tables_list_rec.table_name||'_EBR');
				EBR_TOOL.create_view (l_cur_tables_list_rec.table_name||'_EBR',l_cur_tables_list_rec.table_name);
            END LOOP;
			
        DBMS_UTILITY.compile_schema(schema => 'VMSCM', compile_all => false);
		
    END run_renaming;	

END ebr_tool;