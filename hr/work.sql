select editions_enabled from dba_users where username = 'EBR_HR';

alter user test_codea enable editions force;




marks:
-- Each function for index schould be NONEDITIONABLE before altering user
