

-- ==========================================================================================
-- Entity Name:	StpWebPagine_KyIns
-- Author:	Dav
-- Create date:	08/03/2013 23:41:07
-- AutoCreate:	YES
-- Custom:	NO
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	This stored procedure is intended for inserting values to TbWebPagine table
-- ==========================================================================================
CREATE Procedure [dbo].[StpWebPagine_KyIns]
(
	@IdPagina int OUTPUT,
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
	
	SET @Msg= 'Inserimento'
	SET @MsgObj='WebPagine'
	
	Declare @PrInfo  nvarchar(300)
	Set @PrInfo  = ''
	
	Declare @IdAmbito as nvarchar(20)
	
	-- Gestione menu a tendina
	DECLARE @ParamCtrl nvarchar(max)
	DECLARE @Control as nvarchar(max)
	SET @ParamCtrl = '<ParamCtrl>' + REPLACE(REPLACE(@KYMsg,'-|', '<'), '|-', '>') + '</ParamCtrl>'
	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato,999) = 0
	BEGIN
		SET @KYStato = 1
		set @IdAmbito = (Select min(IdAmbito) from TbWebAmbiti)
		
		SET @Control = dbo.FncKyMsgComboBox('IdAmbito',@KYStato,'Ambito:', @IdAmbito, 'IdAmbito', 'Descrizione', 'IdAmbito;Descrizione', 'DboDomainContext', 'GetTbWebAmbitis','False')
		
		SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato - 1,@Control)

	
		SET @Msg1= 'Confermi l''inserimento ?'
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'QST',@SysUserCreate,
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
			
				declare @IdLingua as nvarchar(5)
				
				set @IdAmbito= dbo.FncKyMsgCtrlValue(@ParamCtrl, 'IdAmbito',1)
				set @IdLingua= (SELECT  IdLingua FROM  TbWebAmbiti WHERE (IdAmbito = @IdAmbito))

				Insert Into TbWebPagine
					(IdLingua,IdAmbito,[SysUserCreate],[SysDateCreate])
				Values
					(@IdLingua,@IdAmbito,@SysUserCreate,Getdate())

				Select @IdPagina = SCOPE_IDENTITY() 
				

				/****************************************************************
				* Uscita
				****************************************************************/

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

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'Dav', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPagine_KyIns';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'NO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPagine_KyIns';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'01.00.00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPagine_KyIns';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'Web pagine', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPagine_KyIns';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '03/12/2013 18:02:32', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPagine_KyIns';


GO

