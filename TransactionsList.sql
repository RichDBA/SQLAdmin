SELECT 
trans.session_id as [Session ID], 
trans.transaction_id as [Transaction ID], 
tas.name as [Transaction Name], 
tds.database_id as [Database ID] 
FROM sys.dm_tran_active_transactions tas 
INNER JOIN sys.dm_tran_database_transactions tds 
ON (tas.transaction_id = tds.transaction_id ) 
INNER JOIN sys.dm_tran_session_transactions trans 
ON (trans.transaction_id=tas.transaction_id) 
WHERE trans.is_user_transaction = 1 -- user 
AND tas.transaction_state = 2 -- active 
AND tds.database_transaction_begin_time IS NOT NULL