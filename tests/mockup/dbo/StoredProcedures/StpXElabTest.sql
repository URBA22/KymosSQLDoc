-- ==========================================================================================
-- Entity Name:		StpXElabTest
-- Author:			Mik
-- Create date:		04/02/23
-- AutoCreate:		NO
-- Custom:			NO
-- CustomNote:		Write custom note here
-- Description:		STP che serve solo come test per la cattura dei PRINT da parte di DboH
-- ==========================================================================================

CREATE Procedure [dbo].[StpXElabTest] 
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @maxIterations INT = 4
	DECLARE @i INT = 0
	DECLARE @tmpStr as nvarchar(4000)

	begin try
	begin transaction
	WHILE(@i<4)
	BEGIN
		SET @i = @i + 1
		SET @tmpStr = 'MSG' + cast(@i as nvarchar(20))
		--SET @tmpStr = 'MSG' + cast(@i as nvarchar(20)) + ' | ' + CONVERT(datetime,GETDATE(),121)
		--PRINT @tmpStr
		--WAITFOR DELAY '00:00:01'

		--RAISERROR(@tmpStr, 1, 1) WITH NOWAIT
		--WAITFOR DELAY '00:00:01'

		EXECUTE StpAdmDhMsg @tmpStr, 1, 1
		WAITFOR DELAY '00:00:02'
	END
	commit transaction
	end try
	begin catch
		rollback transaction
		declare @errMsg as nvarchar(4000)
		set @errMsg = ERROR_MESSAGE()
		EXECUTE StpAdmDhMsg @errMsg, 9, 1
	end catch
 --   RAISERROR('MSGTHEENDHASNOEND1', 1, 1) WITH NOWAIT
	--RAISERROR('MSGTHEENDHASNOEND2', 1, 1) WITH NOWAIT
	--RAISERROR('MSGTHEENDHASNOEND3', 1, 1) WITH NOWAIT
	--RAISERROR('MSGTHEENDHASNOEND4', 1, 1) WITH NOWAIT

END

GO

