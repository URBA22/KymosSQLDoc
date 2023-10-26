-- ==========================================================================================
-- Entity Name:    StpMntUnita_KyDel
-- Author:         dav
-- Create date:    21/03/2018 16:55:39
-- Custom_Dbo:     NO
-- Standard_dbo:   YES
-- CustomNote:     
-- Description:    @Descrizione
-- History:
-- sim 211018 Aggiunto eliminazione record collegati tabella TbMntUnitaDpi e controllo su record collegati
-- vale 23025 Messo messaggio che avverte che se esiste ancora unità macchina verrà ricreata nelle manutenzioni
-- dav 230228 Se presente in produzioen blocca eliminazione
-- ==========================================================================================
CREATE PROCEDURE [dbo].[StpMntUnita_KyDel](
	@IdUnita INT,
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
	SET @MsgObj = 'MntUnita'

	DECLARE @PrInfo NVARCHAR(300)
	--Set @PrInfo  = (SELECT IdUnita  FROM TbMntUnita WHERE (IdUnita = @IdUnita))
	--Set @PrInfo  = 'Riga ' + isnull(@PrInfo ,'--')
	--Set @PrInfo  = 'Doc ' + @IdUnita

    DECLARE @IdCdlUnita NVARCHAR(20)
    SELECT @IdCdlUnita =IdCdlUnita From TbMntUnita WHERE IdUnita=@IdUnita
	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato, 999) = 0
		BEGIN

            SET @Msg1 = 'Confermi l''eliminazione?'

			EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'QST', @SysUserUpdate,
			        @KYStato, @KYRes, '', '(1):Ok;0:Cancel', @KYMsg OUT
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
			IF EXISTS(SELECT IdIntrv FROM TbMntUnitaIntrv WHERE (IdUnita = @IdUnita))
				BEGIN
					SET @Msg1 = 'Operazione annullata, ci sono record correlati'
					EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUserUpdate,
					        @KYStato, @KYRes, 'Interventi', Null, @KYMsg OUT
					SET @KYStato = -2
					RETURN
				END

			IF EXISTS(SELECT IdPiano FROM TbMntUnitaIntrvPiani WHERE (IdUnita = @IdUnita))
				BEGIN
					SET @Msg1 = 'Operazione annullata, ci sono record correlati'
					EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUserUpdate,
					        @KYStato, @KYRes, 'Piani', Null, @KYMsg OUT
					SET @KYStato = -2
					RETURN
				END

            IF EXISTS (Select IdCdlUnita from TbProdCdlUnita where IdCdlUnita=@IdCdlUnita)
				BEGIN
					SET @Msg1 = 'Operazione annullata, l''unità è presente nell''anagrafica di Produzione'
					EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUserUpdate,
					        @KYStato, @KYRes, 'Unità', Null, @KYMsg OUT
					SET @KYStato = -2
					RETURN
				END

			BEGIN TRY
				BEGIN TRANSACTION

					-- Elimina 'collegamento' a DPI
					DELETE TbMntUnitaDpi
					WHERE IdUnita = @IdUnita

					DELETE TbMntUnita
					WHERE [IdUnita] = @IdUnita
					  AND [SysRowVersion] = @SysRowVersion


					IF @@ROWCOUNT = 0
						BEGIN
							SET @Msg1 = 'Operazione annullata, record modificato'
							EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUserUpdate,
							        @KYStato, @KYRes, '', NULL, @KYMsg OUT
							SET @KYStato = -2
						END
					ELSE
						BEGIN

							EXECUTE StpGen_DelDoc 'TbMntUnita', @IdUnita

							SET @Msg1 = 'Operazione completata'
							EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'INF', @SysUserUpdate,
							        @KYStato, @KYRes, '', NULL, @KYMsg OUT
							SET @KYStato = -3
						END
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				-- Execute error retrieval routine.
				ROLLBACK TRANSACTION
				DECLARE @MsgExt as NVARCHAR(MAX)
				SET @MsgExt = ERROR_MESSAGE()
				SET @Msg1 = 'Errore Stp'

				EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUserUpdate,
				        @KYStato, @KYRes, @MsgExt, NULL, @KYMsg OUT
				SET @KYStato = -4
			END CATCH

			RETURN
		END

	/****************************************************************
	* Stato 1 - risposta negativa
	****************************************************************/
	IF ISNULL(@KYStato, 999) = 1 AND @KYRes = 0
		BEGIN

			/****************************************************************
			* Uscita
			****************************************************************/

			SET @Msg1 = 'Operazione annullata'
			EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'WRN', @SysUserUpdate,
			        @KYStato, @KYRes, '', NULL, @KYMsg OUT
			SET @KYStato = -1
			RETURN
		END

END

GO

