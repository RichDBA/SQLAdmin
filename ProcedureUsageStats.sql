SELECT d.object_id, d.database_id, OBJECT_NAME(object_id, database_id) 'proc name',   
    d.cached_time, d.last_execution_time, d.total_elapsed_time,  
    d.total_elapsed_time/d.execution_count AS [avg_elapsed_time],  
    d.last_elapsed_time, d.execution_count  
FROM sys.dm_exec_procedure_stats AS d  

WHERE database_id = 7 --put dbid here 


--ORDER BY [total_worker_time] DESC;  
order by [proc name] asc
--order by object_id
--SELECT database_id, DB_NAME (database_id) from sys.dm_exec_procedure_stats

select distinct * from sys.objects
where type ='P' and object_id not in (SELECT object_id FROM sys.dm_exec_procedure_stats WHERE database_id = 7) and schema_id <> 38
order by name
--order by object_id