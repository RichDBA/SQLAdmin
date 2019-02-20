DECLARE @PERF_COUNTER_BULK_COUNT INT 
SELECT @PERF_COUNTER_BULK_COUNT = 272696576 

--Holds initial state 
DECLARE @baseline TABLE 
   ( 
      object_name NVARCHAR(256) , 
      counter_name NVARCHAR(256) , 
      instance_name NVARCHAR(256) , 
      cntr_value BIGINT , 
      cntr_type INT , 
      time DATETIME DEFAULT ( GETDATE() ) 
   ) 
   
DECLARE @current TABLE 
   ( 
      object_name NVARCHAR(256) , 
      counter_name NVARCHAR(256) , 
      instance_name NVARCHAR(256) , 
      cntr_value BIGINT , 
      cntr_type INT , 
      time DATETIME DEFAULT ( GETDATE() ) 
   ) 

--capture the initial state of bulk counters 
INSERT INTO @baseline 
   ( object_name , 
     counter_name , 
     instance_name , 
     cntr_value , 
     cntr_type 
   ) 
   SELECT object_name , 
          counter_name , 
          instance_name , 
          cntr_value , 
          cntr_type 
   FROM sys.dm_os_performance_counters AS dopc 
   WHERE cntr_type = @PERF_COUNTER_BULK_COUNT 

WAITFOR DELAY '00:00:10' --the code will work regardless of delay chosen

--get the followon state of the counters 
INSERT INTO @current 
   ( object_name , 
     counter_name , 
     instance_name , 
     cntr_value , 
     cntr_type 
   ) 
   SELECT object_name , 
          counter_name , 
          instance_name , 
          cntr_value , 
          cntr_type 
   FROM sys.dm_os_performance_counters AS dopc 
   WHERE cntr_type = @PERF_COUNTER_BULK_COUNT 

SELECT dopc.object_name , 
       dopc.instance_name , 
       dopc.counter_name , 
       --ms to second conversion factor 
       1000 * 
       --current value less the previous value 
   ( ( dopc.cntr_value - prev_dopc.cntr_value ) 
       --divided by the number of milliseconds that pass 
       --casted as float to get fractional results. Float 
       --lets really big or really small numbers to work 
       / CAST(DATEDIFF(ms, prev_dopc.time, dopc.time) AS FLOAT) ) 
                                                 AS cntr_value 
       --simply join on the names of the counters 
FROM @current AS dopc 
     JOIN @baseline AS prev_dopc ON prev_dopc. object_name = 
dopc. object_name 
                       AND prev_dopc.instance_name = dopc.instance_name
                       AND prev_dopc.counter_name = dopc.counter_name 
WHERE dopc.cntr_type = @PERF_COUNTER_BULK_COUNT 
AND dopc.counter_name in ('Lazy writes/sec','Page reads/sec','Readahead pages/sec' ,'Free list stalls/sec','Transactions/sec','Logins/sec','Logouts/sec','Lock Requests/sec', 'Errors/sec', 'Batch Requests/sec'     )


--removed below so I could filter on counters and get what I want only
--      AND 1000 * ( ( dopc.cntr_value - prev_dopc.cntr_value ) 
--                   /  CAST( DATEDIFF(ms, prev_dopc. time, dopc. time)  AS FLOAT) ) 
 --/* default to only showing non-zero values */ <> 0 
ORDER BY dopc. object_name , 
         dopc.instance_name , 
         dopc.counter_name

SELECT object_name, instance_name, counter_name, cntr_value FROM sys.dm_os_performance_counters
WHERE counter_name = 'Page life expectancy' or counter_name = 'Free Memory (KB)' OR counter_name = 'Free Pages'

DECLARE @num AS INT
DECLARE @den AS INT		

Set @num = (SELECT cntr_value FROM sys.dm_os_performance_counters
WHERE instance_name = 'Database'AND counter_name = 'Average Wait Time (MS)')

Set @den = (SELECT cntr_value FROM sys.dm_os_performance_counters
WHERE instance_name = 'Database' AND  counter_name = 'Average Wait Time base')

SELECT @num/@den AS AverageWaitTimeMS