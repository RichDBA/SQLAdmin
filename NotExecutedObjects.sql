/*
Grab User objects that have not been executed since last cache flush
*/
WITH    object_cte        --Capture all objects that are not Dynamic views, system procs, sys objects or related to cdc
          AS ( SELECT   OBJECT_NAME(object_id) AS NAME ,
                        object_id AS 'ObjectID'
               FROM     sys.all_sql_modules
               WHERE    OBJECT_NAME(object_id) NOT LIKE 'sp_%'
                        AND OBJECT_NAME(object_id) NOT LIKE 'dm_%'
                        AND definition NOT LIKE '%sys.%'
                        AND definition NOT LIKE '%_cdc_%'
						AND definition not like '%syncob%'
             )
    SELECT  TAB1.name, TAB1.ObjectID, TAB2.Time AS 'LastTimeExecuted' 
    FROM    object_cte TAB1
            LEFT JOIN ( SELECT  I2.objectid AS [OBJECTID],                           --ObjectID 
                                I1.last_execution_time AS [Time],                    --Last Time Executed
                                I2.text AS [Query],                                         --Text of Executed Query
                                DB_NAME(I2.[dbid]) AS [Database],               --Database 
                                OBJECT_NAME(I2.[objectid]) AS [TableName]  --Table Referenced by Query
                        FROM    sys.dm_exec_query_stats AS I1
                                CROSS APPLY sys.dm_exec_sql_text(I1.sql_handle)    --Get Object ID From execution handle
                                AS I2
                        WHERE   OBJECT_NAME(I2.[objectid]) NOT LIKE 'sp_'
                      ) AS TAB2 ON TAB1.ObjectID = TAB2.OBJECTID
  -- where name like 'prc%'
   
   WHERE   TAB2.OBJECTID IS NULL and Tab1.ObjectID not in (select object_id from sys.dm_exec_procedure_stats)
--where database_id = 7)
;
