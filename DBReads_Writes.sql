--USE xxx; --insert DB name here

GO



SET ANSI_WARNINGS OFF;
SET NOCOUNT ON;
GO

WITH agg AS
(
    SELECT 
        [object_id],
        last_user_seek,
        last_user_scan,
        last_user_lookup,
        last_user_update
    FROM
        sys.dm_db_index_usage_stats
    WHERE
        database_id = DB_ID()
)
SELECT
    [Schema] = OBJECT_SCHEMA_NAME([object_id]),
    [Table_Or_View] = OBJECT_NAME([object_id]),
    last_read = MAX(last_read),
    last_write = MAX(last_write)
FROM
(
    SELECT [object_id], last_user_seek, NULL FROM agg
    UNION ALL
    SELECT [object_id], last_user_scan, NULL FROM agg
    UNION ALL
    SELECT [object_id], last_user_lookup, NULL FROM agg
    UNION ALL
    SELECT [object_id], NULL, last_user_update FROM agg
) AS x ([object_id], last_read, last_write)
GROUP BY
    OBJECT_SCHEMA_NAME([object_id]),
    OBJECT_NAME([object_id])
ORDER BY 1,2;;


--end of script
