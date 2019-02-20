--code

-- to be fair this script was written by Brent Ozar, et al....I modified the the create index statement to suit my needs and added code to format the impact number with commas
--added fields for user impact as seen on a plan and Hits which is just seeks plus scans...for explaining large impacts

 

 


SELECT sys.objects.NAME AS [Table Name]
, CONVERT(VARCHAR,CAST((avg_total_user_cost * avg_user_impact) * (user_seeks + user_scans)AS MONEY),1) AS Impact, avg_user_impact AS Impact_match, user_seeks + user_scans AS Hits
, 'CREATE NONCLUSTERED INDEX ix_IndexName ON ' + sys.objects.name COLLATE DATABASE_DEFAULT + ' ( ' + IsNull(mid.equality_columns, '') + CASE WHEN mid.inequality_columns IS NULL 
THEN '' 
ELSE CASE WHEN mid.equality_columns IS NULL 
THEN '' 
ELSE ',' END + mid.inequality_columns END + ' ) ' + CASE WHEN mid.included_columns IS NULL 
THEN '' 
ELSE 'INCLUDE (' + mid.included_columns + ')' END + 'WITH (PAD_INDEX = OFF, FILLFACTOR= 80, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, 
IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY];' AS CreateIndexStatement
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
ORDER BY (avg_total_user_cost * avg_user_impact) * (user_seeks + user_scans) DESC)) 
AND OBJECTPROPERTY(sys.objects.OBJECT_ID, 'isusertable')=1 
ORDER BY 2 DESC , 3 DESC


 

--/end code