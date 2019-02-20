SELECT Distinct
   @@SERVERNAME ServerName,
       logical_volume_name MountPoint, 
       file_system_type FileSystemType, 
       total_bytes/1024/1024/1024 MountPointSizeInGB, 
       available_bytes/1024/1024/1024 FreeSpaceOnMountPointSizeInGB 
FROM sys.master_files AS mf cross apply sys.dm_os_volume_stats (mf.database_id, mf.file_id)
--WHERE available_bytes < (.1 * total_bytes) --and logical_volume_name not like '%Log%'
order by MountPoint
