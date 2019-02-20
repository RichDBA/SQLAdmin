

SELECT TABLE_SCHEMA,  
TABLE_NAME,  
COLUMN_NAME,  
--COLUMN_DEFAULT,  
--IS_NULLABLE,  
DATA_TYPE,  
CHARACTER_MAXIMUM_LENGTH, 
CASE  
WHEN  Column_name LIKE'%Address%' THEN 'CPI' 
WHEN Column_name LIKE 'Cert%' THEN 'CPI' 
WHEN Column_name LIKE '%email%' THEN 'CPI' 
WHEN Column_name LIKE '%Phone%' THEN 'CPI' 
WHEN Column_name LIKE '%License%' THEN 'CPI' 
WHEN Column_name LIKE 'DL%' THEN 'CPI' 
WHEN Column_name LIKE 'State%Id' THEN 'CPI' 
WHEN Column_name LIKE '%Account%' THEN 'CPI' 
WHEN Column_name LIKE '%Acct%' THEN 'CPI' 
WHEN Column_name LIKE '%No' THEN 'CPI' 
WHEN Column_name LIKE '%Num' THEN 'CPI' 
WHEN Column_name LIKE 'Bank%' THEN 'CPI' 
WHEN Column_name LIKE 'Credit%' THEN 'CPI' 
WHEN Column_name LIKE 'Med%' THEN 'CPI' 
WHEN Column_name LIKE '%Maiden%' THEN 'CPI' 
WHEN Column_name LIKE 'First%Name' THEN 'CPI' 
WHEN Column_name LIKE 'Last%Name' THEN 'CPI' 
WHEN Column_name LIKE 'Middle%Name' THEN 'CPI' 
WHEN Column_name LIKE 'Name' THEN 'CPI' 
WHEN Column_name LIKE 'SSN%' THEN 'CPI' 
WHEN Column_name LIKE 'Tax%' THEN 'CPI' 
WHEN Column_name LIKE 'DOB%' THEN 'CPI' 
WHEN Column_name LIKE 'Social%' THEN 'CPI' 
--WHEN Column_name LIKE 'Cert%' THEN 'CPI' 
--WHEN Column_name LIKE 'Cert%' THEN 'CPI'  

ELSE 'NO' 
END  
AS CPI_DATA 
FROM  INFORMATION_SCHEMA.COLUMNS 
WHERE (TABLE_CATALOG = 'RECON') 
ORDER BY TABLE_NAME