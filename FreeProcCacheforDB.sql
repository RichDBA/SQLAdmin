DECLARE @intDBID INT;
SET @intDBID = (SELECT [dbid] 
                FROM master.dbo.sysdatabases 
                WHERE name = 'Tax');

-- Flush the procedure cache for one database only
DBCC FLUSHPROCINDB (@intDBID);
--SELECT @intDBID
