SELECT 'DATABASE STANDARDS and Best Practices Audit Report'

GO
SELECT 'This is a list of HEAP tables' AS '01'
GO

SELECT DISTINCT SCHEMA_NAME(schema_id) AS SchemaName,name AS TableName  
FROM sys.tables 
WHERE OBJECTPROPERTY(OBJECT_ID,'TableHasPrimaryKey') = 0 AND  SCHEMA_NAME(SCHEMA_ID) NOT IN ( 'cdc', 'scratch', 'conversion')
and is_ms_shipped=0 and temporal_type <> 1
ORDER BY SchemaName, TableName; 

GO
SELECT 'List Foreign Keys without indexes' AS '02'
GO
SELECT SCHEMA_NAME(FK.SCHEMA_ID) AS [SCHEMA_NAME], OBJECT_NAME(FK.PARENT_OBJECT_ID) AS TABLE_NAME, AC.NAME AS COLUMN_NAME,
CASE WHEN is_not_trusted = 0 THEN 'TRUSTED' ELSE 'NOT TRUSTED' END AS FK_TRUST, FK.NAME AS FK_NAME
--, 'FOREIGN KEY '+ FK.NAME+' HAS NO INDEX',  FK.PARENT_OBJECT_ID
--,FK.*
FROM SYS.FOREIGN_KEYS FK
       INNER JOIN SYS.FOREIGN_KEY_COLUMNS FKC
ON FK.OBJECT_ID = FKC.CONSTRAINT_OBJECT_ID  
       INNER JOIN SYS.ALL_COLUMNS AC
ON FK.PARENT_OBJECT_ID = AC.OBJECT_ID
       AND FKC.PARENT_COLUMN_ID = AC.COLUMN_ID
       LEFT OUTER JOIN SYS.INDEX_COLUMNS IC
ON IC.OBJECT_ID=FKC.PARENT_OBJECT_ID
       AND IC.COLUMN_ID=FKC.PARENT_COLUMN_ID
       AND FKC.CONSTRAINT_COLUMN_ID=IC.KEY_ORDINAL
WHERE IC.OBJECT_ID IS NULL --AND  SCHEMA_NAME(SCHEMA_ID) NOT IN ( 'History', 'Staging', 'suspense')
--if there is a FK shouldnt you want it to have an index? Otherwise just eliminate the FK and be done.
ORDER BY FK.SCHEMA_ID, FK.NAME

GO

SELECT 'Tables containing  Nchar or Nvarchar' AS '03'
GO

--SELECT TABLE_SCHEMA,TABLE_NAME, COLUMN_NAME, DATA_TYPE
--FROM INFORMATION_SCHEMA.COLUMNS
--WHERE (DATA_TYPE = 'NCHAR' OR  DATA_TYPE = 'NVARCHAR') AND TABLE_SCHEMA <>'cdc'

SELECT c.TABLE_SCHEMA,TABLE_NAME, c.COLUMN_NAME, c.DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS c
 inner join sys.tables t on  c.TABLE_NAME =OBJECT_NAME(t.object_id) and c.TABLE_SCHEMA = SCHEMA_NAME(t.schema_id)
WHERE (DATA_TYPE = 'NCHAR' OR  DATA_TYPE = 'NVARCHAR') AND TABLE_SCHEMA not in ('cdc','dba')
and t.is_ms_shipped = 0

GO
SELECT 'Over complicated or long stored procedures' AS '04'
GO

--SELECT DISTINCT  
--SCHEMA_NAME() AS SCHEMA_Name, name, definition
--       --o.name AS Object_Name,
--      -- o.type_desc
--  FROM sys.sql_modules m 
--       INNER JOIN 
--       sys.objects o 
--         ON m.object_id = o.object_id
-- WHERE (m.definition Like '%SELECT CASE%' OR  m.definition Like '%THEN%') AND m.definition NOT like '%MERGE%'
-- UNION
 SELECT DISTINCT  
SCHEMA_NAME(schema_id) AS SCHEMA_Name, name, definition
       --o.name AS Object_Name,
      -- o.type_desc
  FROM sys.sql_modules m 
       INNER JOIN 
       sys.objects o 
         ON m.object_id = o.object_id
 WHERE (len(definition) -len(replace(definition, char(0x0d) + char(0x0a), ''))) /2  > 250 AND (name NOT LIKE '%batch%' and name NOT LIKE '%cdc%')
 and
SCHEMA_NAME( o.schema_id) not in ('conversion','dba')
 UNION 
 SELECT DISTINCT  
SCHEMA_NAME(schema_id) AS SCHEMA_Name, name, definition
       --o.name AS Object_Name,
      -- o.type_desc
  FROM sys.sql_modules m 
       INNER JOIN 
       sys.objects o 
         ON m.object_id = o.object_id
  WHERE (len(definition) -len(replace(definition, 'ELSE','')))/2   > 2 AND (name NOT LIKE '%batch%' and name NOT LIKE '%cdc%')
 and
SCHEMA_NAME( o.schema_id) not in ('conversion','dba')


 GO
SELECT 'Procedures with Dynamic SQL' AS '05'
GO

SELECT DISTINCT  
SCHEMA_NAME(schema_id) AS SCHEMA_Name, name, definition
       --o.name AS Object_Name,
      -- o.type_desc
  FROM sys.sql_modules m 
       INNER JOIN 
       sys.objects o 
         ON m.object_id = o.object_id
 WHERE m.definition Like '% EXEC @%'  AND name NOT LIKE '%diagram%'
 --added the @ as a way to narrow the false positives
 SELECT 'Procedures without "Set NOCOUNT ON" ' AS '05A'
GO

SELECT DISTINCT  
SCHEMA_NAME(schema_id) AS SCHEMA_Name, name, definition
       --o.name AS Object_Name,
      -- o.type_desc
  FROM sys.sql_modules m 
       INNER JOIN 
       sys.objects o 
         ON m.object_id = o.object_id
 WHERE m.definition NOT LIKE '%Set nocount ON%' AND name NOT LIKE '%diagram%' AND type NOT IN ('TF', 'FN') and SCHEMA_NAME(schema_id) not in ('cdc','conversion','dba') 
  and o.is_ms_shipped = 0

GO
SELECT 'Procedures with "Select *" ' AS '05B'
GO

SELECT DISTINCT  
SCHEMA_NAME(schema_id) AS SCHEMA_Name, name, definition
       --o.name AS Object_Name,
      -- o.type_desc
  FROM sys.sql_modules m 
       INNER JOIN 
       sys.objects o 
         ON m.object_id = o.object_id
 WHERE m.definition LIKE '%Select *%' AND name NOT LIKE '%diagram%' AND SCHEMA_NAME(schema_id) NOT IN ('CDC', 'dba')



GO
SELECT 'PRINT TABLES Missing AddUser column' AS '06'
GO


SELECT SCHEMA_NAME(SCHEMA_ID) schemaname , name FROM sys.tables WHERE name IN (
SELECT name FROM sys.tables
except
Select table_name From INFORMATION_SCHEMA.COLUMNS WHERE column_name = 'AddUser' OR SCHEMA_NAME(SCHEMA_ID) IN ( 'cdc', 'scratch','dba')
OR TABLE_NAME LIKE 'sys%' OR TABLE_NAME LIKE 'MSPeer%')
ORDER BY schemaname, name
GO


GO
SELECT 'PRINT TABLES Missing ModUser column' AS '07'
GO


SELECT SCHEMA_NAME(SCHEMA_ID) schemaname , name FROM sys.tables WHERE name IN (
SELECT name FROM sys.tables
except
Select table_name From INFORMATION_SCHEMA.COLUMNS WHERE column_name = 'ModUser' OR SCHEMA_NAME(SCHEMA_ID) IN ( 'cdc', 'scratch','dba')
OR TABLE_NAME LIKE 'sys%' OR TABLE_NAME LIKE 'MSPeer%')
ORDER BY schemaname, name
GO


GO
SELECT 'PRINT TABLES Missing AddDate column' AS '08'
GO


SELECT SCHEMA_NAME(SCHEMA_ID) schemaname , name FROM sys.tables WHERE name IN (
SELECT name FROM sys.tables
except
Select table_name From INFORMATION_SCHEMA.COLUMNS WHERE column_name like 'AddDate%' OR SCHEMA_NAME(SCHEMA_ID) IN ( 'cdc', 'scratch','dba')
OR TABLE_NAME LIKE 'sys%' OR TABLE_NAME LIKE 'MSPeer%')

--and o.is_ms_shipped = 0)
ORDER BY schemaname, name
GO


GO
SELECT 'PRINT TABLES Missing ModDate column' AS '09'
GO


SELECT SCHEMA_NAME(SCHEMA_ID) schemaname , name FROM sys.tables WHERE name IN (
SELECT name FROM sys.tables
except
Select table_name From INFORMATION_SCHEMA.COLUMNS WHERE column_name like 'ModDate%' OR SCHEMA_NAME(SCHEMA_ID) IN ( 'cdc', 'scratch','dba')
OR TABLE_NAME LIKE 'sys%' OR TABLE_NAME LIKE 'MSPeer%')
ORDER BY schemaname, name
GO


SELECT 'Constraints that are system named' AS '10'
GO
SELECT s.name AS Schema_name , o.name AS Table_name, i.name AS Constraint_name
FROM sys.indexes i
INNER JOIN sys.objects o ON i.object_id = o.object_id
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
 WHERE  i.NAME LIKE '%____%' ESCAPE '_' AND s.name NOT LIKE 'cdc' AND o.name NOT LIKE 'MSPeer%' AND o.name NOT LIKE 'sys%'

union
SELECT s.name, o.name, c.name
FROM sys.check_constraints c
INNER JOIN sys.objects o ON c.parent_object_id = o.object_id
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
 WHERE  c.NAME LIKE '%____%' ESCAPE '_' AND s.name NOT LIKE 'cdc' AND o.name NOT LIKE 'MSPeer%' AND o.name NOT LIKE 'sys%'

union
SELECT s.name  , o.name , d.name
FROM sys.default_constraints d
INNER JOIN sys.objects o ON d.parent_object_id = o.object_id
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
 WHERE  d.NAME LIKE '%____%' ESCAPE '_' AND s.name NOT LIKE 'cdc' AND o.name NOT LIKE 'MSPeer%' AND o.name NOT LIKE 'sys%'


union
 SELECT s.name  , o.name , f.name
FROM sys.foreign_keys f
INNER JOIN sys.objects o ON f.parent_object_id = o.object_id
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
 WHERE f.NAME LIKE '%____%' ESCAPE '_' AND s.name NOT LIKE 'cdc' AND o.name NOT LIKE 'MSPeer%' AND o.name NOT LIKE 'sys%'


GO
SELECT 'This report was run against:'AS '11'
GO
SELECT @@serverNAME AS server_instance
GO
SELECT @@VERSION AS 'SQL Server Version'
GO

SELECT 'DONE' AS '99'
GO


