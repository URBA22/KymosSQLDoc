

-- ==========================================================================================
-- Entity Name:	StpMntDurataElab
-- Author:	Dav
-- Create date:	27.09.17
-- AutoCreate:	NO
-- Custom:		NO
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	Calcola la durata di una elaborazione
--				Con INIT resetta il cronometro
-- History: 
-- ====================================================

CREATE PROCEDURE [dbo].[StpMntDurataElab]
	( 
		@Str as nvarchar(50)
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @DataOra datetime
	DECLARE @Context VARBINARY(128)
	DECLARE @DurataSec as real

	If @Str = 'INIT'
		BEGIN
			Print 'Inizio Elaborazione'
		END
	ELSE
		BEGIN
			SELECT @DataOra = convert(datetime, substring( CONTEXT_INFO(),1,20));

			Set @DurataSec = Round(datediff (ms,@DataOra, Getdate()) / 1000.,3)

			--Print  convert (nvarchar(20), @DataOra, 121)

			Print @Str + ' durata: ' +  convert (nvarchar(20),@DurataSec)
		END

	set @DataOra = getdate()
	set @context =  Convert(binary(20),@DataOra)

	SET CONTEXT_INFO @context

END

GO

