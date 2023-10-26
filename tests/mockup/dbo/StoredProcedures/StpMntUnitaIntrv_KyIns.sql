-- ==========================================================================================
-- Entity Name:   StpMntUnitaIntrv_KyIns
-- Author:        fab
-- Create date:   12/10/2018 16:38:34
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   
-- History:
-- vale 16.11.18 sistemato errore creazione id puntava a una tabella  sbagliata
-- fab 191220 Aggiunta IdCdlUnita
-- sim 220316 Aggiunto paremetro a FncNewIDS
-- ==========================================================================================
CREATE Procedure [dbo].[StpMntUnitaIntrv_KyIns]
(
	@IdIntrv nvarchar(20) OUTPUT,
	@BlocDoc bit,
	@IdCausaleIntrv nvarchar(20),
	@IdPiano int,
	@IdProdLotto nvarchar(20),
	@IdOdlDet int,
	@IdUnita int,
	@IdArticolo nvarchar(50),
	@DataFermo datetime,
	@DataRicIntrv datetime,
	@DataIntrv datetime,
	@DataFineIntrv datetime,
	@DurataPrevIntrv int,
	@DurataIntrv int,
	@IdUtenteProd nvarchar(256),
	@IdUtenteIntrv nvarchar(256),
	@IdManutentore int,
	@Manutentore nvarchar(200),
	@DescIntrv nvarchar(MAX),
	@NoteIntrv nvarchar(MAX),
	@CodFnzEsito nvarchar(5),
	@Costo money,
	@IdMage nvarchar(10),
	@IdMage1 nvarchar(10),
	@MagePosiz nvarchar(20),
	@MagePosiz1 nvarchar(20),
	@IdCdlUnita nvarchar(20),
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
	SET @MsgObj='MntUnitaIntrv'

	Declare @PrInfo  nvarchar(300)
	--Set @PrInfo  = (SELECT IdIntrv  FROM TbMntUnitaIntrv WHERE (IdIntrv = @IdIntrv))
	--Set @PrInfo  = 'Riga ' + isnull(@PrInfo ,'--')
	--Set @PrInfo  = 'Doc ' + @IdIntrv

	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato,999) = 0
	BEGIN
		SET @Msg1= 'Confermi l''inserimento ?'
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'QST',@SysUserCreate,
				@KYStato,@KYRes,'', '(1):Ok;0:Cancel',@KYMsg out
		SET @KYStato = 1
		RETURN
	END


	/****************************************************************
	* Stato 1 - risposta affermativa
	****************************************************************/
	IF @KYStato IS NULL OR (@KYStato = 1 and @KYRes = 1)
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION
				
				declare @PrefDoc as nvarchar(2)
				select @PrefDoc =  PrefDoc from TbMntAnagIntrvCausali where IdCausaleIntrv= @IdCausaleIntrv
					
				set @IdIntrv = dbo.FncNewIDS('TbMntUnitaIntrv',null,@PrefDoc,null,@SysUserCreate)

				Insert Into TbMntUnitaIntrv
					([IdIntrv],[BlocDoc],[IdCausaleIntrv],[IdPiano],[IdProdLotto],[IdOdlDet],[IdUnita],[IdArticolo],[DataFermo],[DataRicIntrv],[DataIntrv],[DataFineIntrv],[DurataPrevIntrv],[DurataIntrv],[IdUtenteProd],[IdUtenteIntrv],[IdManutentore],[Manutentore],[DescIntrv],[NoteIntrv],[CodFnzEsito],[Costo],[IdMage],[IdMage1],[MagePosiz],[MagePosiz1],[SysUserCreate],[SysDateCreate],[IdCdlUnita])
				Values
					(@IdIntrv,@BlocDoc,@IdCausaleIntrv,@IdPiano,@IdProdLotto,@IdOdlDet,@IdUnita,@IdArticolo,@DataFermo,@DataRicIntrv,@DataIntrv,@DataFineIntrv,@DurataPrevIntrv,@DurataIntrv,@IdUtenteProd,@IdUtenteIntrv,@IdManutentore,@Manutentore,@DescIntrv,@NoteIntrv,@CodFnzEsito,@Costo,@IdMage,@IdMage1,@MagePosiz,@MagePosiz1,@SysUserCreate,Getdate(),@IdCdlUnita)
				

				/****************************************************************
				* Uscita
				****************************************************************/

				SET @Msg1= 'Operazione completata'
				EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'INF',@SysUserCreate,
						@KYStato,@KYRes,'', NULL,@KYMsg out

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

