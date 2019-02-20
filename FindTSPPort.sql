-- returns TCP/IP SQL Server Port
-- you must connect remotely using TCP/IP
SELECT local_tcp_port
FROM   sys.dm_exec_connections
WHERE  session_id = @@SPID
GO
