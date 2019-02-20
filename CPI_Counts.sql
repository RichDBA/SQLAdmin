
SELECT @@serverNAME AS server_instance
Select ServerProperty('ComputerNamePhysicalNetBIOS') AS physical_node
SELECT @@VERSION AS 'SQL Server Version'

SELECT 'IsClustered', SERVERPROPERTY('IsClustered')
 SELECT * FROM fn_virtualservernodes() AS nodes

SELECT COUNT(*) AS NumberofDatabases
FROM master..sysdatabases
WHERE dbid >4

SELECT name AS DB_Name
FROM master..sysdatabases
WHERE dbid >4
ORDER BY name


DECLARE @command VARCHAR(2000)


SELECT @command = 
'USE ?
SELECT table_catalog, 
COUNT(*)  AS CPI_Columns
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE (COLUMN_NAME LIKE''%Address%'' OR 
COLUMN_NAME LIKE ''Cert%'' OR
COLUMN_NAME LIKE ''%email%'' OR
COLUMN_NAME LIKE ''%Phone%'' OR
COLUMN_NAME LIKE ''%License%'' OR
COLUMN_NAME LIKE ''DL%'' OR
COLUMN_NAME LIKE ''State%Id'' OR
COLUMN_NAME LIKE ''%Account%'' OR
COLUMN_NAME LIKE ''%Acct%'' OR
COLUMN_NAME LIKE ''%No'' OR
COLUMN_NAME LIKE ''%Num'' OR
COLUMN_NAME LIKE ''Bank%'' OR
COLUMN_NAME LIKE ''Credit%'' OR
COLUMN_NAME LIKE ''Med%'' OR
COLUMN_NAME LIKE ''%Maiden%''OR
COLUMN_NAME LIKE ''First%Name'' OR
COLUMN_NAME LIKE ''Last%Name'' OR
COLUMN_NAME LIKE ''Middle%Name''  OR
COLUMN_NAME LIKE ''Name'' OR
COLUMN_NAME LIKE ''SSN%'' OR
COLUMN_NAME LIKE ''Tax%'' OR
COLUMN_NAME LIKE ''DOB%'' OR
COLUMN_NAME LIKE ''Social%'')
and (TABLE_CATALOG <> ''master'' and TABLE_CATALOG <> ''tempdb'' and TABLE_CATALOG <> ''msdb'' and TABLE_CATALOG <> ''model'')
GROUP BY TABLE_CATALOG'

EXECUTE master.sys.sp_MSforeachdb @command