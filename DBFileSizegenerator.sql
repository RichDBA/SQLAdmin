SELECT DB_NAME(database_id) AS DatabaseName, 
--CAST([Name] AS varchar(20)) AS NameofFile,
--CAST(physical_name AS varchar(100)) AS PhysicalFile,
--type_desc AS FileType,
SUM(((size * 8)/1024)) AS TotalFileSize--,
--MaxFileSize = CASE WHEN max_size = -1 OR max_size = 268435456 THEN 'UNLIMITED'
--WHEN max_size = 0 THEN 'NO_GROWTH' 
--WHEN max_size <> -1 OR max_size <> 0 THEN CAST(((max_size * 8) / 1024) AS varchar(15))
--ELSE 'Unknown'
--END,
--SpaceRemainingMB = CASE WHEN max_size = -1 OR max_size = 268435456 THEN 'UNLIMITED'
--WHEN max_size <> -1 OR max_size = 268435456 THEN CAST((((max_size - size) * 8) / 1024) AS varchar(10))
--ELSE 'Unknown'
--END,
--Growth = CASE WHEN growth = 0 THEN 'FIXED_SIZE'
--WHEN growth > 0 THEN ((growth * 8)/1024)
--ELSE 'Unknown'
--END,
--GrowthType = CASE WHEN is_percent_growth = 1 THEN 'PERCENTAGE'
--WHEN is_percent_growth = 0 THEN 'MBs'
--ELSE 'Unknown'
--END
FROM master.sys.master_files
WHERE state = 0
AND type_desc IN ('rows') AND DB_NAME(database_id) NOT IN ('master','model','msdb','tempdb') --DB_ID() >4
GROUP BY DB_NAME(database_id)

ORDER BY TotalFileSize desc--DATABASEName --database_id, file_id