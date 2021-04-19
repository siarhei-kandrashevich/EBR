CREATE OR REPLACE 
PACKAGE EBR_TOOL AUTHID CURRENT_USER AS

  c_incorrect_object_name         CONSTANT PLS_INTEGER := -20001;
  e_incorrect_object_name         EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_incorrect_object_name,-20001);

  c_undefined_value               CONSTANT PLS_INTEGER := -20002;
  e_undefined_value               EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_undefined_value,-20002);

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

PROCEDURE rename_table(p_table_name_in         IN  user_tables.table_name%TYPE,
                       p_new_table_name_in     IN  user_tables.table_name%TYPE,
                       p_ebr_tool_bucket_id_in IN ebr_tool_bucket.id%TYPE,
                       p_run_date_in           IN DATE);

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

/*PROCEDURE create_view(p_table_name_in      IN user_tables.table_name%TYPE,
                      p_view_name_in       IN user_views.view_name%TYPE,
                      p_ebr_tool_bucket_id_in IN ebr_tool_bucket.id%TYPE,
                      p_run_date_in           IN DATE);*/

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

FUNCTION check_object_exists(p_object_type_in     IN user_objects.object_type%TYPE,
                             p_object_name_in     IN user_objects.OBJECT_NAME%TYPE)
    RETURN BOOLEAN;

---------------------------------------------------------------------------------
-- Name        : log_message (Public procedure)
-- Description : This procedure will log a message in log table
-- Notes       : none
-- Parameters  : INPUT
--              - Message  
--              - Object name
--             : OUTPUT
--              - none 
-- Example: 1. EXECUTE ebr_tool.log_message ('Hello world');
-- Returns     : none
-- Created On  : 09/04/2021
-- Created By  : Siarhei Kandrashevich
---------------------------------------------------------------------------------

PROCEDURE log_message(p_ebr_tool_bucket_id_in IN INTEGER, 
                      p_message_date_in       IN DATE,
                      p_message_source_in    IN VARCHAR2,
                      p_message_type_in       IN VARCHAR2,
                      p_log_message_in        IN VARCHAR2);

---------------------------------------------------------------------------------
-- Name        : run_renaming (Public procedure)
-- Description : This procedure will start process of renaming for list of tables  
-- Notes       : none
-- Parameters  : INPUT
--              - none 
--             : OUTPUT
--              - none 
-- Example: 1. EXECUTE ebr_tool.run_renaming('bucket 1');
-- Returns     : none
-- Created On  : 09/04/2021
-- Created By  : Siarhei Kandrashevich
---------------------------------------------------------------------------------

PROCEDURE run_renaming (p_ebr_tool_bucket_name_in IN ebr_tool_bucket.bucket_name%TYPE);

---------------------------------------------------------------------------------
-- Name        : run_rollback (Public procedure)
-- Description : This procedure will start process of dropping views and renam tables
-- Notes       : none
-- Parameters  : INPUT
--              - none 
--             : OUTPUT
--              - none 
-- Example: 1. EXECUTE ebr_tool.run_rollback('bucket 1');
-- Returns     : none
-- Created On  : 09/04/2021
-- Created By  : Siarhei Kandrashevich
---------------------------------------------------------------------------------

PROCEDURE run_rollback (p_ebr_tool_bucket_name_in IN ebr_tool_bucket.bucket_name%TYPE);

END EBR_TOOL;

