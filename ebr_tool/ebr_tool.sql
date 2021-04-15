CREATE OR REPLACE 
PACKAGE EBR_TOOL AUTHID CURRENT_USER AS

e_incorrect_object_name EXCEPTION;

PRAGMA EXCEPTION_INIT(e_incorrect_object_name, -20011);

c_debug_on  BOOLEAN := TRUE;

---------------------------------------------------------------------------------
-- Name        : rename_table (Public procedure)
-- Description : This procdure will rename the table 
-- Notes       : none
-- Parameters  : INPUT
--              - Table Name 
--              - New Table Name 
--             : OUTPUT
--                 None
-- Example: 1. EXECUTE ebr_tool.rename_table ('CMS_ACCT_GIFT','CMS_ACCT_GIFT_EBR');
-- Returns     : none
-- Created On  : 09/04/2021
-- Created By  : Siarhei Kandrashevich
---------------------------------------------------------------------------------	

PROCEDURE rename_table(p_table_name_in IN USER_TABLES.TABLE_NAME%TYPE,
                       p_new_table_name_in IN USER_TABLES.TABLE_NAME%TYPE);

---------------------------------------------------------------------------------
-- Name        : create_view (Public procedure)
-- Description : This procdure will create view based on table name 
-- Notes       : none
-- Parameters  : INPUT
--              - Table Name  
--              - View Name
--             : OUTPUT
--                 None
-- Example: 1. EXECUTE ebr_tool.create_view ('CMS_ACCT_GIFT');
-- Returns     : none
-- Created On  : 09/04/2021
-- Created By  : Siarhei Kandrashevich
---------------------------------------------------------------------------------

PROCEDURE create_view(p_table_name_in IN USER_TABLES.TABLE_NAME%TYPE,
                      p_view_name_in IN USER_VIEWS.VIEW_NAME%TYPE);

---------------------------------------------------------------------------------
-- Name        : check_object_exists (Public function)
-- Description : This function will check if object exists 
-- Notes       : none
-- Parameters  : INPUT
--              - Object type  
--              - Object name
--             : OUTPUT
--              - Boolean 
-- Example: 1. SELECT  check_object_exists('TABLE','CMS_ACCT_GIFT') FROM Dual;
-- Returns     : none
-- Created On  : 09/04/2021
-- Created By  : Siarhei Kandrashevich
---------------------------------------------------------------------------------

FUNCTION check_object_exists(p_object_type_in IN USER_OBJECTS.OBJECT_TYPE%TYPE,
                             p_object_name_in IN USER_OBJECTS.OBJECT_NAME%TYPE)
    RETURN BOOLEAN;

---------------------------------------------------------------------------------
-- Name        : print_debug (Public procedure)
-- Description : This procedure will print a message in log in case debug is on 
-- Notes       : none
-- Parameters  : INPUT
--              - Message  
--              - Object name
--             : OUTPUT
--              - none 
-- Example: 1. EXECUTE ebr_tool.print_debug ('Hello world');
-- Returns     : none
-- Created On  : 09/04/2021
-- Created By  : Siarhei Kandrashevich
---------------------------------------------------------------------------------

PROCEDURE print_debug(p_message_in IN VARCHAR2);

---------------------------------------------------------------------------------
-- Name        : run_renaming (Public procedure)
-- Description : This procedure will start process of renaming for list of tables  
-- Notes       : none
-- Parameters  : INPUT
--              - none 
--             : OUTPUT
--              - none 
-- Example: 1. EXECUTE ebr_tool.run_renaming;
-- Returns     : none
-- Created On  : 09/04/2021
-- Created By  : Siarhei Kandrashevich
---------------------------------------------------------------------------------

PROCEDURE run_renaming;

---------------------------------------------------------------------------------
-- Name        : run_rollback (Public procedure)
-- Description : This procedure will start process of dropping views and renam tables
-- Notes       : none
-- Parameters  : INPUT
--              - none 
--             : OUTPUT
--              - none 
-- Example: 1. EXECUTE ebr_tool.run_rollback;
-- Returns     : none
-- Created On  : 09/04/2021
-- Created By  : Siarhei Kandrashevich
---------------------------------------------------------------------------------

PROCEDURE run_rollback;

END EBR_TOOL;

