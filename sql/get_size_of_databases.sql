SELECT table_schema AS "Database Name",
ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS "Size in (MB)"
FROM information_schema.TABLES
GROUP BY table_schema;