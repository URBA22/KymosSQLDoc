

-- ==========================================================================================
-- Entity Name:   StpMntUnitaIntrv_KyUpd
-- Author:        fab
-- Create date:   12/10/2018 16:38:34
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   
-- History:
-- vale 11.02.19 Aggiornamento Manutentore
-- fab 191220 Aggiunta IdCdlUnita
-- fab 221020 Gestito azzeramento del contatore e dell'ultimo intervento nel momento in cui l'opratore chiude la manuntenzione
-- ==========================================================================================
CREATE Procedure [dbo].[StpMntUnitaIntrv_KyUpd]
(
	@IdIntrv nvarchar(20),
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
	@SysRowVersion timestamp,
	@SysUserUpdate nvarchar(256),
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

	SET @Msg= 'Aggiornamento'
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
		SET @Msg1= 'Confermi l''aggiornamento ?'
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'QST',@SysUserUpdate,
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
			DECLARE @DataFineIntrvPrev datetime

			SELECT @DataFineIntrvPrev = DataFineIntrv FROM TbMntUnitaIntrv
			WHERE IdIntrv = @IdIntrv
			
			IF (@DataFineIntrvPrev <> @DataFineIntrv OR @DataFineIntrvPrev IS NULL) 
			   AND NOT(@DataFineIntrv IS NULL)
			BEGIN
				
				-- Aggiorno il contantore
				UPDATE TbMntUnitaIntrvPianiElab
				SET DeltaPeriodicita = NULL, DataIntrvUltimo = @DataFineIntrv, DataIntrvProssimo = NULL
				FROM TbMntUnitaIntrvPianiElab INNER JOIN TbMntUnitaIntrvPiani  ON TbMntUnitaIntrvPiani.IdPiano = TbMntUnitaIntrvPianiElab.IdPiano
				WHERE IdUnita = @IdUnita
			END
			--Declare @Manutentore as nvarchar (max)
			IF @Manutentore is null 
			BEGIN
				SELECT  @Manutentore=Manutentore from TbMntManutentori where IdManutentore =@IdManutentore 
			END

				Update TbMntUnitaIntrv
				Set
					[BlocDoc] = @BlocDoc,
					[IdCausaleIntrv] = @IdCausaleIntrv,
					[IdPiano] = @IdPiano,
					[IdProdLotto] = @IdProdLotto,
					[IdOdlDet] = @IdOdlDet,
					[IdUnita] = @IdUnita,
					[IdArticolo] = @IdArticolo,
					[DataFermo] = @DataFermo,
					[DataRicIntrv] = @DataRicIntrv,
					[DataIntrv] = @DataIntrv,
					[DataFineIntrv] = @DataFineIntrv,
					[DurataPrevIntrv] = @DurataPrevIntrv,
					[DurataIntrv] = @DurataIntrv,
					[IdUtenteProd] = @IdUtenteProd,
					[IdUtenteIntrv] = @IdUtenteIntrv,
					[IdManutentore] = @IdManutentore,
					[Manutentore] = @Manutentore,
					[DescIntrv] = @DescIntrv,
					[NoteIntrv] = @NoteIntrv,
					[CodFnzEsito] = @CodFnzEsito,
					[Costo] = @Costo,
					[IdMage] = @IdMage,
					[IdMage1] = @IdMage1,
					[MagePosiz] = @MagePosiz,
					[MagePosiz1] = @MagePosiz1,
					[IdCdlunita] = @IdCdlUnita,
					[SysUserUpdate]=@SysUserUpdate,
					[SysDateUpdate]=Getdate()
				Where	
					[IdIntrv] = @IdIntrv
					and [SysRowVersion] = @SysRowVersion

				

				IF @@ROWCOUNT =0
				BEGIN
					SET @Msg1= 'Operazione annullata, record modificato'
					EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj,  @PrInfo ,'ALR',@SysUserUpdate,
							@KYStato,@KYRes,'', NULL,@KYMsg out
					SET @KYStato = -1
				END
				ELSE
				BEGIN
					/****************************************************************
					* Uscita
					****************************************************************/

					SET @Msg1= 'Operazione completata'
					EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'INF',@SysUserUpdate,
							@KYStato,@KYRes,'', NULL,@KYMsg out

					SET @KYStato = -1
				END

				COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			-- Execute error retrieval routine.
			rollback transaction
			Declare @MsgExt as nvarchar(max)
			SET @MsgExt= ERROR_MESSAGE()
			SET @Msg1= 'Errore Stp'

			EXECUTE StpUteMsg	@Msg, @Msg1,@MsgObj, @PrInfo ,'ALR',@SysUserUpdate,
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
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'WRN',@SysUserUpdate,
				@KYStato,@KYRes,'',null,@KYMsg out
		SET @KYStato = -4
		RETURN
	END

End

GO

