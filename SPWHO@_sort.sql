

--KILL 1124 WITH STATUSONLY


Declare @sp_who2 table
(SPID INT,
Status VARCHAR(1000) NULL,  
Login SYSNAME NULL,  
HostName SYSNAME NULL,   
BlkBy SYSNAME NULL,  
DBName SYSNAME NULL, 
Command VARCHAR(1000) NULL,  
CPUTime INT NULL,  
DiskIO INT NULL,  
LastBatch VARCHAR(1000) NULL,  
ProgramName VARCHAR(1000) NULL,  
SPID2 INT,
RequestID INT) 

insert into @sp_who2
exec sp_who2
select * from @sp_who2 
--WHERE BlkBy <> '  .'
--WHERE ProgramName = '2007 Microsoft Office system                  '
--WHERE spid = 150
ORDER BY SPID