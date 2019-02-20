
SELECT 'REVOKE EXECUTE ON ' + o.[name] + ' TO [public] AS [dbo]' as exe_script,
 o.[name] AS [SPName]

 ,u.[name] AS [Role]

FROM [master]..[sysobjects] o

INNER JOIN [master]..[sysprotects] p

ON o.[id] = p.[id]

INNER JOIN [master]..[sysusers] u

ON P.Uid = U.UID

AND p.[uid] = 0

AND o.[xtype] IN ('X','P')