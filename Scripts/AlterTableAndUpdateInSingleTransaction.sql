BEGIN TRY
	BEGIN TRANSACTION
		ALTER TABLE "sales"."Proposals"
		ADD BillingCustomerPersonId  int  NULL

		ALTER TABLE "sales"."Proposals"
		ADD CONSTRAINT "FK_Persons_Proposals_BillingCustomerPersonId" FOREIGN KEY ("BillingCustomerPersonId") REFERENCES "dbo"."Persons"("Id")

		EXEC('update "sales"."Proposals" set BillingCustomerPersonId = CustomerPersonId
		where ProposalStatusId = ''00000005-0005-11E3-AA6E-0800200C9A66''')
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
		 
	RAISERROR ('Error found in line %i: %s', @ErrorSeverity, @ErrorState, @ErrorLine, @ErrorMessage) WITH SETERROR
END CATCH