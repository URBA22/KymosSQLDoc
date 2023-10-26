

-- ==========================================================================================
-- Entity Name:	StpMntUnitaIntrvDist_KyIns
-- Create date:	21/03/2018 16:33:19
-- AutoCreate:	YES
-- Custom:	NO
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	This stored procedure is intended for inserting values to TbMntUnitaIntrvDist table
-- History:
-- fab 15.04.19	Aggiunto Tavola, TavolaPosiz e cambiato IdIntrv da int a nvarchar
-- ==========================================================================================
CREATE Procedure [dbo].[StpMntUnitaIntrvDist_KyIns]
(
	@IdIntrvDist int OUTPUT,
	@IdIntrv nvarchar(20),
	@IdArticolo nvarchar(50),
	@Descrizione nvarchar(MAX),
	@UnitM nvarchar(20),
	@UnitMCoeff real,
	@Qta real,
	@CostoUnit money,
	@Tavola nvarchar(15),
	@TavolaPosiz nvarchar(10),
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
	SET @MsgObj='MntUnitaIntrvDist'

	Declare @PrInfo  nvarchar(300)
	--Set @PrInfo  = (SELECT IdIntrvDist  FROM TbMntUnitaIntrvDist WHERE (IdIntrvDist = @IdIntrvDist))
	--Set @PrInfo  = 'Riga ' + isnull(@PrInfo ,'--')
	--Set @PrInfo  = 'Doc ' + @IdIntrvDist

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

				Insert Into TbMntUnitaIntrvDist
					([IdIntrv],[IdArticolo],[Descrizione],[UnitM],[UnitMCoeff],[Qta],[CostoUnit],[SysUserCreate],[SysDateCreate], [Tavola], [TavolaPosiz])
				Values
					(@IdIntrv,@IdArticolo,@Descrizione,@UnitM,@UnitMCoeff,@Qta,@CostoUnit,@SysUserCreate,Getdate(), @Tavola, @TavolaPosiz)

				Select @IdIntrvDist = SCOPE_IDENTITY() 
				

				/****************************************************************
				* Uscita
				****************************************************************/

				SET @Msg1= 'Operazione completata'
				EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'INF',@SysUserCreate,
						@KYStato,@KYRes,'', NULL,@KYMsg out

				SET @KYStato = -2
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

