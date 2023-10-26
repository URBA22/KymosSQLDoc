

-- ==========================================================================================
-- Entity Name:   StpYReparti_Ricodifica
-- Author:        Dav
-- Create date:   07.02.17
-- Custom_Dbo:	  NO
-- Standard_dbo:  NO
-- CustomNote:    
-- Description:   Ricodifica il reparto in tutte le tabelle
-- History:
-- anna 10.07.18 creazione da StpArticoli_Ricodifica
-- dav 200321 Descrizione
-- ==========================================================================================

CREATE Procedure [dbo].[StpYReparti_Ricodifica]
(
	@IdReparto nvarchar(50) OUTPUT,
	@SysUserCreate nvarchar(256),
	@KYStato int = NULL output,
	@KYMsg nvarchar(max) = NULL output,
	@KYRes int = NULL
)
As
Begin
	/*
	return -1: Normal; return -2: Refresh data; return -3: Chiude la maschera; -4: Non fa nulla	
	Tipo Messaggio: INF Informativo, ALR Allert, WRN Warning, QST Question	
	*/
	Declare @Msg nvarchar(300)
	Declare @Msg1 nvarchar(300)
	Declare @MsgObj nvarchar(300)

	Declare @IdRepartoNew nvarchar(50)

	SET @Msg= 'Ricodifica'
	SET @MsgObj='StpXReparto_Ricodifica'

	Declare @PrInfo  nvarchar(300)
	Set @PrInfo  = @IdReparto
	
	-- Gestione menu a tendina
	DECLARE @ParamCtrl nvarchar(max)
	DECLARE @ControlReparto as nvarchar(max)

	SET @ParamCtrl = '<ParamCtrl>' + REPLACE(REPLACE(@KYMsg,'-|', '<'), '|-', '>') + '</ParamCtrl>'
	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato,999) = 0 
	BEGIN
		SET @KYStato = 1

		SET @ControlReparto  = dbo.FncKyMsgTextBox('IdReparto',@KYStato,'IdReparto:', @IdRepartoNew,'string')

		SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato - 1,@ControlReparto)

		SET @Msg1= 'Confermi la ricodifica del reparto ?'
		SET @Msg1= dbo.FncStr( @Msg1, 'Attenzione: il reparto verrà modificato in tutti i documenti!')
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'WRN',@SysUserCreate,
				@KYStato,@KYRes,'', '(1):Ricodifica;0:Cancel',@KYMsg out
		
		SET @KYMsg = @KYMsg + '<ParamCtrl>' + @ParamCtrl + '</ParamCtrl>'

		RETURN
	END


	/****************************************************************
	* Stato 1 - risposta affermativa
	****************************************************************/
	IF @KYStato IS NULL OR (@KYStato = 1 and @KYRes = 1) 
	BEGIN
		
		Set @IdRepartoNew = dbo.FncKyMsgCtrlValue(@ParamCtrl, 'IdReparto',1)

		
		/****************************************************************
		* Controllo esistenza
		****************************************************************/

		If Exists (select IdReparto from TbProdReparti where IdReparto= @IdRepartoNew)
		BEGIN	
			SET @KYStato = 0
			
			SET @Msg1= 'Operazione annullata, codice esistente'
			EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'WRN',@SysUserCreate,
					@KYStato,@KYRes,'','(1):Ok',@KYMsg out
			RETURN
		END

		If  IsNull(@IdRepartoNew,'')=''
		BEGIN	
			SET @KYStato = 0
			
			SET @Msg1= 'Operazione annullata, definire il codice articolo'
			EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'WRN',@SysUserCreate,
					@KYStato,@KYRes,'','(1):Ok',@KYMsg out
			RETURN
		END
	
		/****************************************************************
		* Ricodifica
		****************************************************************/
		
		BEGIN TRY
		
			
			BEGIN TRANSACTION

				-- aggiorna per descrizione
				Set @PrInfo = @IdReparto + ' >> ' + @IdRepartoNew
			
				/****************************************
				 * Rimuove vicoli
				 ****************************************/

				ALTER TABLE TbProdReparti NOCHECK CONSTRAINT FK_TbProdReparti_TbProdReparti
				ALTER TABLE TbArtAnagCatgrMacro NOCHECK CONSTRAINT FK_TbArtAnagCatgrMacro_TbProdReparti
				ALTER TABLE TbAttAnagTipo NOCHECK CONSTRAINT FK_TbAttAnagTipo_TbProdReparti
				ALTER TABLE TbDispositivi NOCHECK CONSTRAINT FK_TbDispositivi_TbProdReparti
				ALTER TABLE TbForOrd NOCHECK CONSTRAINT FK_TbForOrd_TbProdReparti
				ALTER TABLE TbOdl NOCHECK CONSTRAINT FK_TbOdl_TbProdReparti
				ALTER TABLE TbProdCdl NOCHECK CONSTRAINT FK_TbProdCdl_TbProdReparti
				ALTER TABLE TbProdRepartiResp NOCHECK CONSTRAINT FK_TbProdRepartiResp_TbProdReparti
				ALTER TABLE TbQaNc NOCHECK CONSTRAINT FK_TbQaNc_TbProdReparti
				ALTER TABLE TbRlvPresenze NOCHECK CONSTRAINT FK_TbRlvPresenze_TbProdReparti
				ALTER TABLE TbUtenti NOCHECK CONSTRAINT FK_TbUtenti_TbProdReparti

				/****************************************
				 * Aggiorna
				 ****************************************/

				--Delete From TbMageElab Where IdArticolo = @IdArticolo

				UPDATE TbProdReparti SET IdReparto = @IdRepartoNew WHERE IdReparto = @IdReparto
				UPDATE TbArtAnagCatgrMacro SET IdReparto = @IdRepartoNew WHERE IdReparto = @IdReparto
				UPDATE TbAttAnagTipo SET IdReparto = @IdRepartoNew WHERE IdReparto = @IdReparto
				UPDATE TbDispositivi SET IdReparto = @IdRepartoNew WHERE IdReparto = @IdReparto
				UPDATE TbForOrd SET IdReparto = @IdRepartoNew WHERE IdReparto = @IdReparto
				UPDATE TbOdl SET IdReparto = @IdRepartoNew WHERE IdReparto = @IdReparto
				UPDATE TbProdCdl SET IdReparto = @IdRepartoNew WHERE IdReparto = @IdReparto
				UPDATE TbProdRepartiResp SET IdReparto = @IdRepartoNew WHERE IdReparto = @IdReparto
				UPDATE TbQaNc SET IdReparto = @IdRepartoNew WHERE IdReparto = @IdReparto
				UPDATE TbRlvPresenze SET IdReparto = @IdRepartoNew WHERE IdReparto = @IdReparto
				UPDATE TbUtenti SET IdReparto = @IdRepartoNew WHERE IdReparto = @IdReparto
				

				/****************************************
				 * Ripristina vicoli
				 ****************************************/

				ALTER TABLE TbProdReparti CHECK CONSTRAINT FK_TbProdReparti_TbProdReparti				
				ALTER TABLE TbArtAnagCatgrMacro CHECK CONSTRAINT FK_TbArtAnagCatgrMacro_TbProdReparti
				ALTER TABLE TbAttAnagTipo CHECK CONSTRAINT FK_TbAttAnagTipo_TbProdReparti
				ALTER TABLE TbDispositivi CHECK CONSTRAINT FK_TbArtCicliFasiDist_TbArticoli
				ALTER TABLE TbForOrd CHECK CONSTRAINT FK_TbForOrd_TbProdReparti
				ALTER TABLE TbOdl CHECK CONSTRAINT FK_TbOdl_TbProdReparti
				ALTER TABLE TbProdCdl CHECK CONSTRAINT FK_TbProdCdl_TbProdReparti
				ALTER TABLE TbProdRepartiResp CHECK CONSTRAINT FK_TbProdRepartiResp_TbProdReparti
				ALTER TABLE TbQaNc CHECK CONSTRAINT FK_TbQaNc_TbProdReparti
				ALTER TABLE TbRlvPresenze CHECK CONSTRAINT FK_TbRlvPresenze_TbProdReparti
				ALTER TABLE TbUtenti CHECK CONSTRAINT FK_TbUtenti_TbProdReparti


				If dbo.FncOggettoPrs('TB','TbxReparti')=1
					BEGIN
						UPDATE TbxReparti SET IdReparto = @IdRepartoNew WHERE IdReparto = @IdReparto 
					END

				/****************************************************************
				* Uscita
				****************************************************************/
				SET @IdReparto=@IdRepartoNew
				
				SET @Msg1= 'Operazione completata'
				EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'INF',@SysUserCreate,
						@KYStato,-1,'', NULL,@KYMsg out

				SET @KYStato = -1
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			-- Execute error retrieval routine.
			rollback transaction
			Declare @MsgExt as nvarchar(max)
			SET @MsgExt= ERROR_MESSAGE()
			SET @Msg1= 'Errore Stp'
			
			EXECUTE StpUteMsg	@Msg, @Msg1,@MsgObj, @PrInfo ,'ALR',@SysUserCreate,
					@KYStato,@KYRes,@MsgExt,null,@KYMsg out
			SET @KYStato = -4
		END CATCH

		RETURN
	END

	/****************************************************************
	* Stato 1 - risposta negativa
	****************************************************************/
	IF ISNULL(@KYStato,999) = 1 and @KYRes = 0
	BEGIN

		/****************************************************************
		* Uscita
		****************************************************************/

		SET @Msg1= 'Operazione annullata'
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'WRN',@SysUserCreate,
				@KYStato,@KYRes,'',null,@KYMsg out
		SET @KYStato = -4
		RETURN
	END

	
	
	
End

GO

