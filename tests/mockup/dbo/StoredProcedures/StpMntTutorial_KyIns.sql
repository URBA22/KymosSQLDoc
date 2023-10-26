
-- ==========================================================================================
-- Entity Name:	StpMntTutorial_KyIns
-- Create date:	23/01/2020 12:09:21
-- AutoCreate:	YES
-- Custom:	NO
-- Custom_Dbo:	NO
-- Standard_dbo:	YES
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	This stored procedure is intended for inserting values to TbMntTutorial table
-- History:
-- fab 200428 Aggiunti DataRilascio, NoteTutorial, CodFnzStato e CodFnzAmbito
-- ==========================================================================================
CREATE Procedure [dbo].[StpMntTutorial_KyIns]
(
	@IdTutorial nvarchar(20) OUTPUT,
	@DescTutorial nvarchar(200),
	@UrlTutorial nvarchar(256),
	@DataRilascio date,
	@NoteTutorial nvarchar(max),
	@CodFnzStato nvarchar(5),
	@CodFnzAmbito nvarchar(5),
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
	SET @MsgObj='MntTutorial'

	Declare @PrInfo  nvarchar(300)
	--Set @PrInfo  = (SELECT IdTutorial  FROM TbMntTutorial WHERE (IdTutorial = @IdTutorial))
	--Set @PrInfo  = 'Riga ' + isnull(@PrInfo ,'--')
	--Set @PrInfo  = 'Doc ' + @IdTutorial

	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato,999) = 0
	BEGIN
		SET @Msg1= 'Confermi l''inserimento ?'
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'QST',@SysUserCreate,
				@KYStato,@KyRes,'', '(1):Ok;0:Cancel',@KYMsg out
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

				Insert Into TbMntTutorial
					([IdTutorial],[DescTutorial],[UrlTutorial],[SysUserCreate],[SysDateCreate], [DataRilascio], [NoteTutorial], [CodFnzStato], [CodFnzAmbito])
				Values
					(@IdTutorial,@DescTutorial,@UrlTutorial,@SysUserCreate,Getdate(), @DataRilascio, @NoteTutorial, @CodFnzStato, @CodFnzAmbito)
				

				/****************************************************************
				* Uscita
				****************************************************************/

				SET @Msg1= 'Operazione completata'
				EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'INF',@SysUserCreate,
						@KYStato,@KyRes,'', NULL,@KYMsg out

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
					@KYStato,@KyRes,@MsgExt,null,@KYMsg out
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
				@KYStato,@KyRes,'',null,@KYMsg out
		SET @KYStato = -4
		RETURN
	END

End

GO

