--code

-- to be fair this script was written by Brent Ozar, et al....I modified the the create index statement to suit my needs and added code to format the impact number with commas
--added fields for user impact as seen on a plan and Hits which is just seeks plus scans...for explaining large impacts
SELECT @@serverNAME AS server_instance

DECLARE @command AS VARCHAR(5000)

SELECT @command = '


use [?]
 


SELECT ''?'' ,statement AS Full_Table_Name, sys.objects.NAME AS [Table Name], avg_total_user_cost, avg_user_impact,
user_seeks + user_scans AS Hits
, (avg_total_user_cost * avg_user_impact) * (user_seeks + user_scans) AS Total_Impact 
, mid.equality_columns
, mid.inequality_columns
, mid.included_columns 

FROM sys.dm_db_missing_index_group_stats AS migs 
INNER JOIN sys.dm_db_missing_index_groups AS mig ON migs.group_handle = mig.index_group_handle 
INNER JOIN sys.dm_db_missing_index_details AS mid ON mig.index_handle = mid.index_handle AND mid.database_id = DB_ID() 
INNER JOIN sys.objects WITH (nolock) ON mid.OBJECT_ID = sys.objects.OBJECT_ID 
WHERE (migs.group_handle IN 
( 
SELECT TOP (500) group_handle 
FROM sys.dm_db_missing_index_group_stats WITH (nolock) 
WHERE (avg_total_user_cost * avg_user_impact) * (user_seeks + user_scans) > 1000000

ORDER BY (avg_total_user_cost * avg_user_impact) * (user_seeks + user_scans) DESC)) 
AND OBJECTPROPERTY(sys.objects.OBJECT_ID, ''isusertable'')=1 
ORDER BY 6 DESC , 5 DESC
'
EXEC sp_MSforeachdb @command

--/end code