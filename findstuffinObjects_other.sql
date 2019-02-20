SELECT SCHEMA_NAME() AS SCHEMA_Name, name, definition
       --o.name AS Object_Name,
      -- o.type_desc
  FROM sys.sql_modules m 
       INNER JOIN 
       sys.objects o 
         ON m.object_id = o.object_id
  WHERE m.definition LIKE '%usp_OSHPPersonalDetails%'
