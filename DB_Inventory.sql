
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




