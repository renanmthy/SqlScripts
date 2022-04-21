IF EXISTS(SELECT 1 FROM sys.columns WHERE Name = 'ColumnName' AND Object_ID = Object_ID('TableName'))
BEGIN
	DECLARE @sql NVARCHAR(MAX);
	SET @sql = 
	'YOUR_SQL_HERE'
	EXECUTE(@sql)
END