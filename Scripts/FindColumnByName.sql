SELECT      COLUMN_NAME AS 'ColumnName'
            ,TABLE_NAME AS  'TableName'
FROM        INFORMATION_SCHEMA.COLUMNS
WHERE       COLUMN_NAME LIKE '% COLUMN_NAME_HERE %'
ORDER BY    TableName
            ,ColumnName;