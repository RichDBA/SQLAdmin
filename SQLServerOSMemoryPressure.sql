
-- Good basic information about OS memory amounts and state
-- You want to see "Available physical memory is high"
-- This indicates that you are not under external memory pressure
-- https://msdn.microsoft.com/en-us/library/bb510493.aspx

SELECT total_physical_memory_kb/1024        AS TotalPhysical_OS_RAM_MB
      ,available_physical_memory_kb/1024    AS Physical_OS_RAM_Available_MB
      ,total_page_file_kb/1024              AS TotalPhysicalRAMPlusPageFile_MB
      ,available_page_file_kb/1024          AS PageFile_Available_MB
      ,system_memory_state_desc
FROM sys.dm_os_sys_memory WITH (NOLOCK)
OPTION (RECOMPILE);

