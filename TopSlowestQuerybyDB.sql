
SELECT TOP 100
	st.text,
	qp.query_plan,
	 qs.total_worker_time/qs.execution_count AS average_time,
	qs.*
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.plan_handle) st
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
WHERE DB_NAME(st.dbid) = 'PISGS' AND qs.execution_count > 1000 AND qs.total_worker_time <> 0 
ORDER BY total_worker_time/qs.execution_count DESC 



