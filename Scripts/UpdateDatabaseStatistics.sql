------------------------------------------------------
-- If you're using AWS RDS, follow this steps
------------------------------------------------------
-- 1. Create a procedure to dbo schema
create procedure dbo.sp_updstats
	with execute as 'dbo'
as
	exec sp_updatestats
go

-- 2. Grant [admin] access to run procedure (Change [admin] to whatever user you have the credentials)
grant execute on dbo.sp_updstats to [admin]
go

-- 3. Execute the procedure
exec dbo.sp_updstats

------------------------------------------------------
-- If you're not using AWS RDS, follow this steps
------------------------------------------------------
-- 1. Execute the procedure
exec sp_updatestats