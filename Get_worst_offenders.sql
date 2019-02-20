--Get Worst Offenders
select top 100
	DB_NAME(txt.dbid) as DBName,
	cp.cacheobjtype, 
	cp.objtype,
	OBJECT_NAME(txt.objectid, txt.dbid) as SPName,
	SUBSTRING (txt.text,(r.statement_start_offset / 2) + 1,((CASE r.statement_end_offset WHEN -1 THEN DATALENGTH(txt.text) ELSE r.statement_end_offset END - r.statement_start_offset) / 2) + 1) as QueryText,
	pln.query_plan as ExecutionPlan,
	r.total_worker_time / r.execution_count as AverageWorkerTime,
	r.total_elapsed_time / r.execution_count as AverageDuration,
	r.total_logical_reads / r.execution_count as AverageLogicalReads,
	r.total_physical_reads / r.execution_count as AveragePhysicalReads,
	r.total_logical_writes / r.execution_count as AverageLogicalWrites,
	r.execution_count as ExecutionCount,
	r.total_worker_time as TotalWorkerTime,
	r.total_elapsed_time as TotalDuration,
	r.total_logical_reads as TotalLogicalReads,
	r.total_physical_reads as TotalPhysicalReads,
	r.total_logical_writes as TotalLogicalWrites,
	r.sql_handle as sql_handle,
	r.plan_handle as plan_handle
from sys.dm_exec_query_stats r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) as txt
CROSS APPLY sys.dm_exec_query_plan(r.plan_handle) as pln
INNER JOIN sys.dm_exec_cached_plans cp ON cp.plan_handle = r.plan_handle

--Only if it is a compiled object or it will be NULL
WHERE DB_NAME(txt.dbid) = 'OTIS' --Only if it is a compiled object (Proc or Trigger) or it will be NULL
--WHERE objtype = 'Prepared' --Use to find cetain Object Types (AdHoc, Prepared, Proc, etc)


--ORDER BY ExecutionCount			desc		--Frequency
--ORDER BY TotalWorkerTime			desc		--CPU
--ORDER BY TotalDuration			desc		--TotalDuration
--ORDER BY TotalLogicalReads		desc		--Reads
--ORDER BY TotalLogicalWrites		desc		--Writes
--ORDER BY TotalPhysicalReads		desc		--PhysicalReads
--ORDER BY AverageWorkerTime		desc		--AverageCPU
ORDER BY AverageDuration			desc		--AverageDuration
--ORDER BY AverageLogicalReads		desc		--AverageReads
--ORDER BY AverageLogicalWrites		desc		--AverageWrites
--ORDER BY AveragePhysicalReads		desc		--AveragePhysicalReads
