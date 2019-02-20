DBCC OPENTRAN
--Code begin

SELECT DISTINCT 'KILL ''' + CONVERT(VARCHAR(50),request_owner_guid) + ''';'
FROM   sys.dm_tran_locks
WHERE  request_session_id =-2
AND   resource_database_id = DB_ID('Your_Database_name_here');

--Code end
