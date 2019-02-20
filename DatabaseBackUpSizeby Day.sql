DECLARE @db_name VARCHAR(20)= 'SDA',
        @year INTEGER = 2015

SELECT [database_name] AS "Database",
       DATEPART(day,[backup_start_date]) AS "Day",
          AVG([backup_size]/1024/1024) AS "Backup Size MB",
          AVG([compressed_backup_size]/1024/1024) AS "Compressed Backup Size MB",
          AVG([backup_size]/[compressed_backup_size]) AS "Compression Ratio"
FROM msdb.dbo.backupset
WHERE [database_name] = @db_name AND [type] = 'D'
  AND DATEPART(month,backup_start_date) = '07' AND DATEPART(Year,backup_start_date) = '2015'
  GROUP BY [database_name], DATEPART(dd,[backup_start_date])
ORDER BY [database_name], DATEPART(dd,[backup_start_date]);
