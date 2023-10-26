-- ==========================================================================================
-- Entity Name:   StpXArticoli_ImptEl
-- Author:        simone
-- Create date:   230127
-- Custom_Dbo:    NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   Importa distinta impianti elettrici, crea in automatico listino e ordine fornitore.
-- History:       
-- simone 230127 Creazione
-- ==========================================================================================

create Procedure [dbo].[StpXArticoli_ImptEl]
(
	@SysUser nvarchar(256),
	@KYStato int = NULL output,
	@KYMsg nvarchar(max) = NULL output,
	@KYRes int = NULL
)

AS
BEGIN

-- Return -1: Normal; return -2: Refresh data; return -3: Chiude la maschera; -4: Non fa nulla
-- Tipo Messaggio: INF Informativo, ALR Allert, WRN Warning, QST Question

SET NOCOUNT ON

-------------------------------------
-- Parametri generali
-------------------------------------
Declare @Msg nvarchar(300)
Declare @Msg1 nvarchar(300)
Declare @MsgObj nvarchar(300)
Declare @MsgInfo nvarchar(300)
Declare @PrInfo  nvarchar(300)
Declare @MsgExt nvarchar(max)

SET @Msg= 'Importazione impianti elettrici'
SET @MsgObj='StpXArticoli_ImptEl'

-- Parametro di log

/****************************************************************
 * Stato 0 - Domanda Iniziale
 ****************************************************************/

IF @KYStato = 0
BEGIN
	SET @KYStato = 1

	SET @Msg1= 'Confermi l''operazione?'
	EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'QST',@SysUser,
			@KYStato,@KYRes,'', '(1):Ok;0:Cancel',@KYMsg out
	RETURN
END

/****************************************************************
* Stato 1 - risposta affermativa
****************************************************************/
--Testa @KYStato IS NULL per lancio diretto della STP
IF @KYStato IS NULL OR (@KYStato = 1 and @KYRes = 1)
BEGIN

	/****************************************************************
	* Controllo da attivare se richiesto
	****************************************************************/
	/*
	If Exists(SELECT 1 FROM Tb WHERE (Id = @Id))
	BEGIN
		SET @Msg1= 'Operazione annullata, ci sono record correlati'
			EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'WRN',@SysUser,
				@KYStato,@KYRes,'Righe Documento', Null,@KYMsg out
			SET @KYStato = -2
	RETURN
	END
	*/

	-------------------------------------
	-- Esegue il comando
	-------------------------------------
	BEGIN TRY
		BEGIN TRANSACTION

			--#######################
			--##INSERISCI IL CODICE##
			--#######################

			-------------------------------------
			-- Controllo esito negativo
			-------------------------------------
			Declare @RowCount as INT
			SET @RowCount = @@ROWCOUNT
			IF @RowCount = 0
			BEGIN
				SET @Msg1= 'Nessun record modificato'
				EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'WRN',@SysUser,
						@KYStato,@KYRes,'', NULL,@KYMsg OUT
				SET @KYStato = -1
			END
			ELSE

			-------------------------------------
			-- Uscita
			-------------------------------------
			BEGIN

				SET @Msg1= 'Operazione Completata, modificati ' + convert(nvarchar(20),@RowCount) + ' record.'
				EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'INF',@SysUser,
						@KYStato,@KYRes,'', NULL,@KYMsg OUT
				SET @KYStato = -2 --## SE SI VUOLE APRIRE UNA NUOVA MASCHERA AL TERMINE DELLA PROCEDURA ALLORA BISOGNA METTERE SET @KYStato = -1 
			END
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		-------------------------------------
		-- Gestione CATCH
		-------------------------------------

		ROLLBACK TRANSACTION
		SET @MsgExt= ERROR_MESSAGE()
		SET @Msg1= 'Errore Stp'

				EXECUTE StpUteMsg	@Msg, @Msg1,@MsgObj, @PrInfo ,'ALR',@SysUser,
						@KYStato,@KYRes,@MsgExt,null,@KYMsg OUT
				SET @KYStato = -4
	END CATCH

	RETURN
END

/****************************************************************
 * Stato 1 - risposta negativa
 ****************************************************************/
IF @KYStato = 1 and @KYRes = 0
BEGIN

	SET @Msg1= 'Operazione annullata'
	EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'WRN',@SysUser,
			@KYStato,@KYRes,'',null,@KYMsg OUT
	SET @KYStato = -4
	RETURN
END
END


/***************************************
 ParamCtrl
 ***************************************
<ParamCtrl><ParamCtrlKy Type="" Passo="1" Value="StpXArticoli_ImptEl" Name="StpName"/><ParamCtrlKy Type="" Passo="1" Value="Importazione impianti elettrici" Name="StpCmdTitolo"/><ParamCtrlKy Type="" Passo="1" Value="Importa distinta impianti elettrici, crea in automatico listino e ordine fornitore." Name="StpCmdDesc"/><ParamCtrlKy Type="" Passo="1" Value="" Name="StpParamKey"/><ParamCtrlKy Type="" Passo="1" Value="" Name="StpParamKeyType"/><ParamCtrlKy Type="" Passo="1" Value="Confermi l&#039;operazione?" Name="StpMsgConferma"/><ParamCtrlKy Type="" Passo="1" Value="Operazione Completata" Name="StpMsgOk"/><ParamCtrlKy Type="" Passo="1" Value="Operazione Annullata" Name="StpMsgCancel"/><ParamCtrlKy Type="" Passo="1" Value="8599492E80C543A5800BB92AC5CBABBC" Name="KYCmdName"/></ParamCtrl>
***************************************/

GO

