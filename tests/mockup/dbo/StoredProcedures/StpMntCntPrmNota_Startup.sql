  
-- ==========================================================================================
-- Entity Name:	StpMntCntPrmNota_Startup
-- Create date:	200217
-- AutoCreate:	YES
-- Custom:	NO
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	Manutenzione in startup
-- Histrory:
-- dav 200217 Creazione
-- ==========================================================================================


create PROCEDURE [dbo].[StpMntCntPrmNota_Startup]
(
	@SysUser nvarchar(256),
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

	SET @Msg= 'Manutenzione Contabilizzazione Fatture'
	SET @MsgObj='StpMntCntPrmNota_Startup'

	Declare @PrInfo  nvarchar(300)
	Set @PrInfo  = ''
	
	-- Gestione menu a tendina
	DECLARE @ParamCtrl nvarchar(max)
	
	DECLARE @C_FlgExport as nvarchar(max)
	
	DECLARE @FlgExport as bit
	
	SET @ParamCtrl = '<ParamCtrl>' + REPLACE(REPLACE(@KYMsg,'-|', '<'), '|-', '>') + '</ParamCtrl>'
	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato,999) = 0
	BEGIN
		-- Inserisci due menù a tendina che puntano sulle fatture
		SET @KYStato = 1
		
		SET @C_FlgExport = dbo.FncKyMsgCheckBox('FlgExport',@KYStato,'Chiudi fatture precedenti saldo iniziale con export:','False')
		
		SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato -1,@C_FlgExport)	
	

		SET @Msg1= 'Manutenzione Contabilità'
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'QST',@SysUser,
				@KYStato,@KYRes,'', '(1):Ok;0:Cancel',@KYMsg out
		
		SET @KYMsg = @KYMsg + '<ParamCtrl>' + @ParamCtrl + '</ParamCtrl>'

		RETURN
	END


	/*********************************************************
	* Stato 1 - risposta affermativa
	****************************************************************/
	IF @KYStato IS NULL OR (@KYStato = 1 and @KYRes = 1)
	BEGIN

		Set @FlgExport =dbo.FncKyMsgCtrlValue (@ParamCtrl, 'FlgExport',1)
		
		BEGIN TRY
			BEGIN TRANSACTION

				IF @FlgExport = 1
					BEGIN

						Declare @DataPrmNotaSaldi as date
						select @DataPrmNotaSaldi = min(DataPrmNota) from TbCntPrmNota inner join TbCntAnagPrmNotaCausali
						on TbCntPrmNota.IdCausalePrmNota = TbCntAnagPrmNotaCausali.IdCausalePrmNota
						where TbCntAnagPrmNotaCausali.FlgSldInz = 1

						UPDATE TbCliFatElab
						SET    FlgFatExport = 1
						FROM  TbCliFatElab INNER JOIN
						TbCliFat ON TbCliFat.IdCliFat = TbCliFatElab.IdCliFat
						WHERE (TbCliFatElab.FlgFatContabilizzata = 0) AND (TbCliFatElab.FlgFatExport = 0) AND (TbCliFat.DataCliFat <= @DataPrmNotaSaldi)

						UPDATE TbForFatElab
						SET    FlgFatExport = 1
						FROM  TbForFatElab INNER JOIN
						TbForFat ON TbForFat.IdForFat = TbForFatElab.IdForFat
						WHERE (TbForFatElab.FlgFatContabilizzata = 0) AND (TbForFatElab.FlgFatExport = 0) AND (TbForFat.DataRegistrazione <= @DataPrmNotaSaldi)

					END

				/****************************************************************
				* Uscita
				****************************************************************/
				SET @KYStato = -2
				SET @Msg1= 'Operazione completata'
				EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'INF',@SysUser,
						@KYStato,@KYRes,'', '(2):Ok',@KYMsg out
				
				SET @KYMsg = @KYMsg + '<ParamCtrl>' + @ParamCtrl + '</ParamCtrl>'

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			-- Execute error retrieval routine.
			rollback transaction
			Declare @MsgExt as nvarchar(max)
			SET @MsgExt= ERROR_MESSAGE()
			SET @Msg1= 'Errore Stp'

			EXECUTE StpUteMsg	@Msg, @Msg1,@MsgObj, @PrInfo ,'ALR',@SysUser,
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
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'WRN',@SysUser,
				@KYStato,@KYRes,'',null,@KYMsg out
		SET @KYStato = -4
		RETURN
	END

End

GO

