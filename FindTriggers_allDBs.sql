--code

-- to be fair this script was written by Brent Ozar, et al....I modified the the create index statement to suit my needs and added code to format the impact number with commas
--added fields for user impact as seen on a plan and Hits which is just seeks plus scans...for explaining large impacts
SELECT @@serverNAME AS server_instance

DECLARE @command AS VARCHAR(5000)

SELECT @command = '

USE [?]


SELECT  ''?'',
     sysobjects.name AS trigger_name 
    ,USER_NAME(sysobjects.uid) AS trigger_owner 
    ,s.name AS table_schema 
    ,OBJECT_NAME(parent_obj) AS table_name 
    ,OBJECTPROPERTY( id, ''ExecIsUpdateTrigger'') AS isupdate 
    ,OBJECTPROPERTY( id, ''ExecIsDeleteTrigger'') AS isdelete 
    ,OBJECTPROPERTY( id, ''ExecIsInsertTrigger'') AS isinsert 
    ,OBJECTPROPERTY( id, ''ExecIsAfterTrigger'') AS isafter 
    ,OBJECTPROPERTY( id, ''ExecIsInsteadOfTrigger'') AS isinsteadof 
    ,OBJECTPROPERTY(id, ''ExecIsTriggerDisabled'') AS [disabled] 
FROM sysobjects 

INNER JOIN sysusers 
    ON sysobjects.uid = sysusers.uid 

INNER JOIN sys.tables t 
    ON sysobjects.parent_obj = t.object_id 

INNER JOIN sys.schemas s 
    ON t.schema_id = s.schema_id 

WHERE sysobjects.type = ''TR'' 



'


--use [?]
 
--SELECT ''?'', OBJECT_NAME(s.[object_id]) AS [Table Name], i.name AS [Index Name], i.index_id,user_updates AS [Total Writes], 
--user_seeks + user_scans + user_lookups AS [Total Reads],
--user_updates - (user_seeks + user_scans + user_lookups) AS [Difference]
--FROM sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
--INNER JOIN sys.indexes AS i WITH (NOLOCK)
--ON s.[object_id] = i.[object_id]
--AND i.index_id = s.index_id
--WHERE OBJECTPROPERTY(s.[object_id],''IsUserTable'') = 1
--AND s.database_id = DB_ID()
--AND (user_seeks + user_scans + user_lookups) = 0
--AND i.index_id > 1 and user_updates > 25000
--ORDER BY [Difference] DESC, [Total Writes] DESC, [Total Reads] ASC OPTION (RECOMPILE);

EXEC sp_MSforeachdb @command

--/end code
















