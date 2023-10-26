
-- ==========================================================================================
-- Entity Name:   StpTrspListini_Clona
-- Author:     Vale   
-- Create date:   03.05.20
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   
-- History:
-- vale 220223 Correzione Bug su clonazione delle tratte dettaglio
-- ==========================================================================================
      


CREATE Procedure [dbo].[StpTrspListini_Clona]
(
	@IdListino nvarchar(20) OUTPUT,
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
	SET @MsgObj='Listino Trasporto Clona'
	
	Declare @PrInfo  nvarchar(300)
	Set @PrInfo  = ''

	-- Gestione menu a tendina
	DECLARE @ParamCtrl nvarchar(max)
	DECLARE @C_IdListino as nvarchar(max)
	DECLARE @C_IdListinoNew as nvarchar(max)
	

	--DECLARE @IdListino as nvarchar(20)
	Declare @IdListinoNew as nvarchar(20)
	

	SET @ParamCtrl = '<ParamCtrl>' + REPLACE(REPLACE(@KYMsg,'-|', '<'), '|-', '>') + '</ParamCtrl>'
	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato,999) = 0 
	BEGIN
		SET @KYStato = 1

		
		
		SET @C_IdListino  = dbo.FncKyMsgTextBox('IdListino',@KYStato,'Listino di partenza:', @IdListino,'string')
		SET @C_IdListinoNew  = dbo.FncKyMsgTextBox('IdListinoNew',@KYStato,'Listino nuovo:', @IdListinoNew,'string')

		SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato - 1,@C_IdListino)
		SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato,@C_IdListinoNew)
		


		SET @Msg1= 'Confermi la clonazione ?'
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

		Set @IdListino = dbo.FncKyMsgCtrlValue(@ParamCtrl, 'IdListino',1)
		Set @IdListinoNew = dbo.FncKyMsgCtrlValue(@ParamCtrl, 'IdListinoNew',1)
	
		/****************************************************************
		* Controllo esistenza
		****************************************************************/

		If Exists (select IdListino from TbTrspListini where IdListino= @IdListinoNew)
		BEGIN	
			SET @KYStato = 0
			
			SET @Msg1= 'Operazione annullata, listino esistente'
			EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'WRN',@SysUserCreate,
					@KYStato,@KYRes,'','(1):Ok',@KYMsg out
			RETURN
		END


		/****************************************************************
		* Insert
		****************************************************************/
		
		BEGIN TRY
		
			
			BEGIN TRANSACTION

			
			
					INSERT INTO TbTrspListini
					(DescListino, NotePopUp, NoteListino, CodFnzTipo, UnitM, TipoListino, IdListino, SysUserCreate, SysDateCreate)
					SELECT DescListino, NotePopUp, NoteListino, CodFnzTipo, UnitM, TipoListino, @IdListinoNew AS Expr1, @SysUserCreate AS Expr2, GETDATE() AS Expr3
					FROM   TbTrspListini AS TbTrspListini_1
					WHERE  (IdListino = @IdListino)

					INSERT INTO TbTrspListiniTratte
					(IdProvGrp1, IdProvGrp2, ImpMin, QtaRif, ImportoRif, KgMin, IdListino, SysUserCreate, SysDateCreate, IdListinoTrattaOld)
					SELECT IdProvGrp1, IdProvGrp2, ImpMin, QtaRif, ImportoRif, KgMin, @IdListinoNew AS Expr1, @SysUserCreate AS Expr2, GETDATE() AS Expr3, IdListinoTratta
					FROM   TbTrspListiniTratte AS TbTrspListiniTratte_1
					WHERE  (IdListino = @IdListino)

				

					INSERT INTO TbTrspListiniTratteDet
					(IdListinoTratta, PesoMax, Costo, HMax, Percentuale, SysUserCreate, SysDateCreate)
					SELECT TbTrspListiniTratte_1.IdListinoTratta, TbTrspListiniTratteDet_1.PesoMax, TbTrspListiniTratteDet_1.Costo, TbTrspListiniTratteDet_1.HMax, TbTrspListiniTratteDet_1.Percentuale, @SysUserCreate  AS Expr1, GETDATE() AS Expr2
					FROM   TbTrspListiniTratte INNER JOIN
					TbTrspListiniTratteDet AS TbTrspListiniTratteDet_1 ON TbTrspListiniTratte.IdListinoTratta = TbTrspListiniTratteDet_1.IdListinoTratta INNER JOIN
					TbTrspListiniTratte AS TbTrspListiniTratte_1 ON TbTrspListiniTratte.IdListinoTratta = TbTrspListiniTratte_1.IdListinoTrattaOld
					WHERE  (TbTrspListiniTratte.IdListino = @IdListino)

					SET @IdListino =@IdListinoNew 
				
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

