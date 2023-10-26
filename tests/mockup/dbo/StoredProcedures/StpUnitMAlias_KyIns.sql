-- =============================================
-- Entity name: StpUnitMAlias_KyIns
-- Author:		Auto
-- Create date: 03-12-22
-- AutoCreate: YES
-- Custom_Dbo: NO
-- Generator: 03-12-22
-- CustomNote:  Write custom note here
-- Description: This stored procedure is intended for inserting values to TbUnitMAlias table
-- History:
-- dav 221203 Creazione
-- =============================================
CREATE PROCEDURE [dbo].[StpUnitMAlias_KyIns]
(
	@IdUnitMAlias INT OUTPUT,
	@UnitM NVARCHAR(20),
	@UnitMAlias NVARCHAR(20),
	@SysUserCreate NVARCHAR(256),
	@KYStato INT = NULL OUTPUT,
	@KYMsg NVARCHAR(MAX) = NULL OUTPUT,
	@KYRes INT = NULL
)
AS
BEGIN
	/*
	return -1: Normal; return -2: Refresh data; return -3: Chiude la maschera; -4: Non fa nulla	
	Tipo Messaggio: INF Informativo, ALR Allert, WRN Warning, QST Question	
	*/

	DECLARE @Msg NVARCHAR(300)
	DECLARE @Msg1 NVARCHAR(300)
	DECLARE @MsgObj NVARCHAR(300)

	SET @Msg = 'Inserimento'
	SET @MsgObj = 'UnitMAlias'

	DECLARE @PrInfo NVARCHAR(300)
	-- SET @PrInfo = (SELECT #DBO_PK FROM #TableName WHERE (#DBO_PK = @#DBO_PK))
	-- SET @PrInfo = 'Riga ' + ISNULL(@PrInfo ,'--')
	-- SET @PrInfo = 'Doc ' + @#DBO_PK

	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato,999) = 0
	BEGIN
		SET @Msg1= 'Confermi l''inserimento ?'
		EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'QST', @SysUserCreate,
			@KYStato, @KyRes,'', '(1):Ok;0:Cancel', @KYMsg OUT
		SET @KYStato = 1
		RETURN
	END


	/****************************************************************
	* Stato 1 - risposta affermativa
	****************************************************************/
	IF @KYStato IS NULL OR (@KYStato = 1 AND @KYRes = 1)
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION


				INSERT INTO TbUnitMAlias
					([UnitM],[UnitMAlias],[SysUserCreate],[SysDateCreate])
				VALUES
					(@UnitM,@UnitMAlias,@SysUserCreate,GETDATE())

				SELECT @IdUnitMAlias = SCOPE_IDENTITY() 
				

				/****************************************************************
				* Uscita
				****************************************************************/

				SET @Msg1 = 'Operazione completata'
				EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'INF', @SysUserCreate,
						@KYStato, @KyRes,'', NULL, @KYMsg OUT

				SET @KYStato = -2
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			-- Execute error retrieval routine.
			ROLLBACK TRANSACTION
			DECLARE @MsgExt NVARCHAR(MAX)
			SET @MsgExt = ERROR_MESSAGE()
			SET @Msg1 = 'Errore Stp'

			EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUserCreate,
					@KYStato, @KyRes, @MsgExt, NULL, @KYMsg OUT
			SET @KYStato = -4
		END CATCH

		RETURN
	END

	/****************************************************************
	* Stato 1 - risposta negativa
	****************************************************************/
	IF ISNULL(@KYStato,999) = 1 AND @KYRes = 0
	BEGIN

		/****************************************************************
		* Uscita
		****************************************************************/

		SET @Msg1 = 'Operazione annullata'
		EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'WRN', @SysUserCreate,
			@KYStato, @KyRes, '', NULL, @KYMsg OUT
		SET @KYStato = -4
		RETURN
	END
	END

GO

