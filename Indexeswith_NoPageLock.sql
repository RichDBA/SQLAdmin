DECLARE @command VARCHAR(500);
BEGIN

SELECT @command = 'IF ''?'' NOT IN(''master'', ''model'', ''msdb'', ''tempdb'') BEGIN USE ? SELECT DB_NAME() ,* FROM sys.indexes WHERE ALLOW_PAGE_LOCKS = 0 AND name NOT in (''queue_secondary_index'',''queue_primary_index'') END' ;

EXEC sp_MSforeachdb @command
END
