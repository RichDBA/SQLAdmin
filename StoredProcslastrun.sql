--SELECT [dbid] 
--                FROM master.dbo.sysdatabases 
--                WHERE name = 'ATPS'


select OBJECT_NAME(object_id) AS NAME ,* from sys.dm_exec_procedure_stats
where database_id = 7 --and object_id = 1628584890
order by OBJECT_NAME(object_id) asc
 
 --inner join 
 
 --select * from sys.all_sql_modules



--where execution_count = 0