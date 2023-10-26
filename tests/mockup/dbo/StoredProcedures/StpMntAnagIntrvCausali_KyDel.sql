-- =============================================
-- Entity name: StpMntAnagIntrvCausali_KyDel
-- Author:		auto
-- Create date: 221201
-- AutoCreate: YES
-- Custom: NO
-- Generator: 221201
-- CustomNote: Write custom note here
-- Description: This stored procedure is intended for deleting a specific row from  TbMntAnagIntrvCausali table
-- History:
-- fra 221201 Creazione
-- =============================================
CREATE PROCEDURE [dbo].[StpMntAnagIntrvCausali_KyDel]
(
	@IdCausaleIntrv NVARCHAR(20),
	@SysRowVersion TIMESTAMP,
	@SysUserUpdate NVARCHAR(256),
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

	SET @Msg = 'Eliminazione'
	SET @MsgObj ='MntAnagIntrvCausali'

	DECLARE @PrInfo NVARCHAR(300)
	-- SET @PrInfo = (SELECT IdCausaleIntrv FROM TbMntAnagIntrvCausali WHERE (IdCausaleIntrv = @IdCausaleIntrv))
	-- SET @PrInfo = 'Riga ' + isnull(@PrInfo ,'--')
	-- SET @PrInfo = 'Doc ' + @IdCausaleIntrv

	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato,999) = 0
	BEGIN
		SET @Msg1 = 'Confermi l''eliminazione ?'
		EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'QST', @SysUserUpdate,
			@KYStato, @KyRes, '', '(1):Ok;0:Cancel', @KYMsg OUT
		SET @KYStato = 1
		RETURN
	END


	/****************************************************************
	* Stato 1 - risposta affermativa
	****************************************************************/
	IF @KYStato IS NULL OR (@KYStato = 1 AND @KYRes = 1)
	BEGIN
		/****************************************************************
		* Controlla se esistono righe collegate nele tabelle dipendenti
		****************************************************************/
		/*
		IF EXISTS(SELECT IdCausaleIntrv FROM #TableName WHERE (IdCausaleIntrv = @IdCausaleIntrv))
		BEGIN
			SET @Msg1 = 'Operazione annullata, ci sono record correlati'
				EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUserUpdate,
					@KYStato, @KyRes, 'Righe Documento', NULL, @KYMsg OUT
				SET @KYStato = -2
		RETURN
		END
		*/

		-- Elimina

		BEGIN TRY
			BEGIN TRANSACTION

				DELETE  TbMntAnagIntrvCausali
				WHERE
					[IdCausaleIntrv] = @IdCausaleIntrv
					AND [SysRowVersion] = @SysRowVersion
				

				IF @@ROWCOUNT = 0
				BEGIN
					SET @Msg1 = 'Operazione annullata, record non modificato'
					EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUserUpdate,
						@KYStato, @KyRes, '', NULL, @KYMsg OUT
					SET @KYStato = -2
				END
				ELSE
				BEGIN
					/****************************************************************
					* Uscita
					****************************************************************/

					EXECUTE StpGen_DelDoc 'TbMntAnagIntrvCausali', @IdCausaleIntrv
					SET @Msg1 = 'Operazione completata'
					EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'INF', @SysUserUpdate,
							@KYStato, @KyRes, '', NULL, @KYMsg OUT

					SET @KYStato = -3
				END
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			-- Execute error retrieval routine.
			ROLLBACK TRANSACTION
			DECLARE @MsgExt NVARCHAR(MAX)
			SET @MsgExt = ERROR_MESSAGE()
			SET @Msg1 = 'Errore Stp'

			EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUserUpdate,
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
		EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'WRN', @SysUserUpdate,
			@KYStato, @KyRes, '', NULL, @KYMsg OUT
		SET @KYStato = -1
		RETURN
	END
END

GO

