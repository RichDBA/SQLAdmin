SELECT
  OBJECT_NAME(parent_object_id) AS ObjectName,
  *
FROM   sys.objects
WHERE  type IN( 'UQ' ) --('UQ','PK') to include PK's which are also unique