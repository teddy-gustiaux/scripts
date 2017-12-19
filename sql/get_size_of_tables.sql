SELECT table_name AS "Table Name",
ROUND(((data_length + index_length) / 1024 / 1024), 2) AS "Size in (MB)"
FROM information_schema.TABLES
WHERE table_schema = "ENTER_YOUR_DATABASE_NAME_HERE"
ORDER BY (data_length + index_length) DESC;