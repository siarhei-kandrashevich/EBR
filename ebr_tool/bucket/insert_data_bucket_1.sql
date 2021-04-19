SET TERMOUT ON
SET ECHO ON

REM DEFINE  bucket_name = &&1 
DEFINE  bucket_name = 'Bucket 1'

DEFINE;

DECLARE
    
    c_prog_name           VARCHAR2(100) := 'insert_data_bucket_1';
    c_sysdate             DATE := SYSDATE;
    c_bucket_name         ebr_tool_bucket.bucket_name%TYPE := '&&bucket_name';
    c_ebr_tool_bucket_id  ebr_tool_bucket.id%TYPE;
    
    TYPE t_data_rec IS RECORD (
        table_name      ebr_tool_table.table_name%TYPE,
        new_table_name  ebr_tool_table.new_table_name%TYPE,
        view_name       ebr_tool_table.view_name%TYPE,
        status          ebr_tool_table.status%TYPE,
        description     ebr_tool_table.description%TYPE        
    );

    TYPE t_tbl IS TABLE OF t_data_rec;
    l_table t_tbl := 
        t_tbl(t_data_rec('PCMS_ISSUANCEENTRY_UPDATE', 'PCMS_ISSUANCEENTRY_UPDATE_EBR','PCMS_ISSUANCEENTRY_UPDATE','Proposed','The table is ready to rename'),
                t_data_rec('CMS_STOCK_REPORT', 'CMS_STOCK_REPORT_EBR','CMS_STOCK_REPORT','Proposed','The table is ready to rename'),
                t_data_rec('CMS_UPLOAD_CTRL', 'CMS_UPLOAD_CTRL_EBR','CMS_UPLOAD_CTRL','Proposed','The table is ready to rename'),
                t_data_rec('CMS_UPLOAD_SUMMARY', 'CMS_UPLOAD_SUMMARY_EBR','CMS_UPLOAD_SUMMARY','Proposed','The table is ready to rename'),
                t_data_rec('CMS_BULK_ACTIVITY_REPORT', 'CMS_BULK_ACTIVITY_REPORT_EBR','CMS_BULK_ACTIVITY_REPORT','Proposed','The table is ready to rename'),
                t_data_rec('CMS_BRANCH_TRANSFER', 'CMS_BRANCH_TRANSFER_EBR','CMS_BRANCH_TRANSFER','Proposed','The table is ready to rename'));
                               
BEGIN
    
	DELETE FROM ebr_tool_bucket
    WHERE UPPER(bucket_name) = UPPER(c_bucket_name);
    
	INSERT INTO ebr_tool_bucket (bucket_name,status,description) 
    VALUES (c_bucket_name,'Proposed','Initial bucket contain only 6 tables.');
		
	SELECT id
    INTO c_ebr_tool_bucket_id
    FROM ebr_tool_bucket
    WHERE UPPER(bucket_name) = UPPER(c_bucket_name);
    
    DELETE FROM ebr_tool_table
    WHERE ebr_tool_bucket_id = c_ebr_tool_bucket_id;
    
    FOR i IN l_table.FIRST .. l_table.LAST
    LOOP
        BEGIN
            INSERT INTO ebr_tool_table (
                table_name,
                ebr_tool_bucket_id,
                new_table_name,
                view_name,
                status,
                description
            )
            VALUES (
                l_table(i).table_name,
                c_ebr_tool_bucket_id,
                l_table(i).new_table_name,
                l_table(i).view_name,
                l_table(i).status,
                l_table(i).description
            );
        END;
    END LOOP;
    
    COMMIT;
END;

/