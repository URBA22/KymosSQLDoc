-- ==========================================================================================
-- Entity Name:   StpCntCespiti_Impt
-- Author:        lisa
-- Create date:   210409
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   Importa i cespiti
-- History:
-- ==========================================================================================
CREATE PROCEDURE [dbo].[StpXImport_Doc] 
(
	@IdAttivita int,
	@SysUser NVARCHAR(256),
	@KYStato int = NULL output,
	@KYMsg NVARCHAR(max) = NULL output,
	@KYRes int = NULL
)
AS
BEGIN


	/*
	return -1: Normal; return -2: Refresh data; return -3: Chiude la maschera; -4: Non fa nulla	
	Tipo Messaggio: INF Informativo, ALR Allert, WRN Warning, QST Question	
	*/
	
	Declare @Msg NVARCHAR(300)
	Declare @Msg1 NVARCHAR(300)
	Declare @MsgObj NVARCHAR(300)
	Declare @TipoMsg as NVARCHAR(5)

	/*
	Inizializzo variabili d'ambiente
	--abilito OLE Automation
	--abilito OLE Automation

	Exec sp_configure 'show advanced options', 1
	RECONFIGURE
	Exec sp_configure 'Ole Automation Procedures', 1
	RECONFIGURE

	--mi assicuro che non ci siano problemi con la lettura del file xlsx
	Exec sp_configure 'show advanced options', 1
	RECONFIGURE

	Exec sp_configure 'Ad Hoc Distributed Queries', 1
	RECONFIGURE

	EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0' , N'AllowInProcess' , 1
	EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0' , N'DynamicParameters' , 1
	*/

	Declare @NumRow as int

	SET @Msg= 'Inserimento'
	SET @MsgObj='StpXImport_Doc'
	
	Declare @PrInfo  NVARCHAR(300)
	Set @PrInfo  = ''
	Set @PrInfo  = 'Doc ' + isnull(@PrInfo ,'--')
	
	DECLARE @ParamCtrl NVARCHAR(max)
	DECLARE @Control as NVARCHAR(max)
	
	SET @ParamCtrl = '<ParamCtrl>' + REPLACE(REPLACE(@KYMsg,'-|', '<'), '|-', '>') + '</ParamCtrl>'
	
	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato,999) = 0
	BEGIN
		SET @Msg1 = 'Caricamento documento'
		--SET @Msg1 = dbo.FncStr( @Msg1, 'Campi:')
		--SET @Msg1 = dbo.FncStr( @Msg1, '  TipoMov (C/F) | IdCespite (Cod. Dbo) | DescCespite (Descrizione) | FlgUsato (Usato) | IdCespiteCatgr | IdCespiteCatgrTec  | IdCespiteUbicazione | IdDoc (Nr Fattura) | DataDoc (Data Fattura) | RagSoc (Rag. Soc.) |ImportoDoc (Costo Storico) | DataAttivazione |  PercVarFisc | PercAlqAmrtCiv1 | PercAlqAmrtCiv  | PercAlqAmrtFisc | PercAlqAmrtFisc1 |  NoteCespite ')
		--SET @Msg1 = dbo.FncStr( @Msg1, 'Nome Foglio:')
		--SET @Msg1 = dbo.FncStr( @Msg1, '  Cespiti')

		SET @KYStato = 1

		SET @Control = dbo.FncKyMsgDocUpload('Documento',@KYStato,'Documento:', 'TbXAttivita', 'InsDocumento')
		
		SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato - 1,@Control)
		
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'QST',@SysUser,
				@KYStato,@KYRes,'', '(1):Ok;0:Cancel',@KYMsg out

		SET @KYMsg = @KYMsg + '<ParamCtrl>' + @ParamCtrl + '</ParamCtrl>'
		RETURN
	END
	
	/****************************************************************
	* Stato 1 - risposta affermativa
	****************************************************************/
	IF @KYStato IS NULL OR (@KYStato = 1 and @KYRes = 1)
	BEGIN

		

		BEGIN TRY
			
			BEGIN TRANSACTION

			--creo file excel temporaneo su disco
			
			UPDATE TbDocumenti
			SET IdDoc =@IdAttivita, TipoDoc = 'TbAttivita'
			WHERE TipoDoc = 'TbXAttivita' AND IdDoc = 'InsDocumento'

			/****************************************************************
			* Uscita
			****************************************************************/

			SET @Msg1= 'Operazione completata, importati: ' + convert(NVARCHAR(20), @NumRow)
			EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'INF',@SysUser,
					@KYStato,-1,'', NULL,@KYMsg out
						
			SET @KYStato = -2
				--END

			COMMIT TRANSACTION
		END TRY

		BEGIN CATCH

			rollback transaction
			-- Execute error retrieval routine.
			Declare @MsgExt as NVARCHAR(max)
			SET @Msg1= 'Errore Stp' 
			--SET @MsgExt= (SELECT * FROM #temp_cespiti FOR XML PATH)
			--rollback transaction
			SET @MsgExt= ERROR_MESSAGE ( ) 

			EXECUTE StpUteMsg	@Msg, @Msg1,@MsgObj, @PrInfo ,'ALR',@SysUser,
					@KYStato,@KYRes,@MsgExt,null,@KYMsg out
			SET @KYStato = -4
		END CATCH

		--IF(EXISTS(select * from sys.servers where name = N'XLSX_NewSheet'))
		--	BEGIN
		--		EXEC sp_dropserver 'XLSX_NewSheet'
		--	END

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

END

GO

