IF (
	NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = 'CustomerPersonId' AND Object_ID = Object_ID('finance.Entries')) 
	AND NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = 'CustomerPersonId' AND Object_ID = Object_ID('finance.RecurringEntries'))
	)
BEGIN
	DECLARE @sql NVARCHAR(MAX);
	SET @sql = 
	'BEGIN TRY
	 BEGIN TRANSACTION
		ALTER TABLE finance.Entries
		ADD CustomerPersonId  int  NULL

		ALTER TABLE finance.RecurringEntries
		ADD CustomerPersonId  int  NULL

		CREATE NONCLUSTERED INDEX IDX_Entries_CustomerOrSupplierId ON finance.Entries
		( 
			CustomerOrSupplierId  ASC
		)

		CREATE NONCLUSTERED INDEX IDX_Entries_CustomerPersonId ON finance.Entries
		( 
			CustomerPersonId      ASC
		)

		CREATE NONCLUSTERED INDEX IDX_RecurringEntries_CustomerOrSupplierId ON finance.RecurringEntries
		( 
			CustomerOrSupplierId  ASC
		)

		CREATE NONCLUSTERED INDEX IDX_RecurringEntries_CustomerPersonId ON finance.RecurringEntries
		( 
			CustomerPersonId      ASC
		)

		ALTER TABLE finance.Entries
			ADD CONSTRAINT FK_Persons_Entries_CustomerPersonId FOREIGN KEY (CustomerPersonId) REFERENCES dbo.Persons(Id)

		ALTER TABLE finance.RecurringEntries
			ADD CONSTRAINT FK_Persons_RecurringEntries_CustomerPersonId FOREIGN KEY (CustomerPersonId) REFERENCES dbo.Persons(Id)
	-- Commands End
	COMMIT TRAN -- Transaction Success!
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRAN --RollBack in case of Error

	-- Raise ERROR with RAISEERROR() Statement including the details of the exception
	DECLARE @ErrorLine INT;
	DECLARE @ErrorMessage NVARCHAR(4000);
	DECLARE @ErrorSeverity INT;
	DECLARE @ErrorState INT;

	SELECT
		@ErrorLine = ERROR_LINE(),
		@ErrorMessage = ERROR_MESSAGE(),
		@ErrorSeverity = ERROR_SEVERITY(),
		@ErrorState = ERROR_STATE();
		 
	RAISERROR (''Error found in line %i: %s'', @ErrorSeverity, @ErrorState, @ErrorLine, @ErrorMessage) WITH SETERROR
END CATCH'
	EXECUTE(@sql)
END