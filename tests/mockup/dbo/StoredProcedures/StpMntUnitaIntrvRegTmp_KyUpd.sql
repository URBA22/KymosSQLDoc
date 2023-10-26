
-- ==========================================================================================
-- Entity Name:	StpMntUnitaIntrvRegTmp_KyUpd
-- Create date:	18/01/2019 18:23:20
-- AutoCreate:	YES
-- Custom:	NO
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	This stored procedure is intended for updating TbMntUnitaIntrvRegTmp table
--
-- ==========================================================================================
CREATE Procedure StpMntUnitaIntrvRegTmp_KyUpd
(
	@IdIntrvRegTmp int,
	@IdIntrv nvarchar(20),
	@IdUtente nvarchar(256),
	@DataReg date,
	@DataInizio datetime,
	@DataFine datetime,
	@Durata real,
	@IdTipoAtvt nvarchar(20),
	@NoteRegTmp nvarchar(MAX),
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
	SET @MsgObj='MntUnitaIntrvRegTmp'

	Declare @PrInfo  nvarchar(300)
	--Set @PrInfo  = (SELECT IdIntrvRegTmp  FROM TbMntUnitaIntrvRegTmp WHERE (IdIntrvRegTmp = @IdIntrvRegTmp))
	--Set @PrInfo  = 'Riga ' + isnull(@PrInfo ,'--')
	--Set @PrInfo  = 'Doc ' + @IdIntrvRegTmp

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

				Update TbMntUnitaIntrvRegTmp
				Set
					[IdIntrv] = @IdIntrv,
					[IdUtente] = @IdUtente,
					[DataReg] = @DataReg,
					[DataInizio] = @DataInizio,
					[DataFine] = @DataFine,
					[Durata] = @Durata,
					[IdTipoAtvt] = @IdTipoAtvt,
					[NoteRegTmp] = @NoteRegTmp,
					[SysUserUpdate]=@SysUserUpdate,
					[SysDateUpdate]=Getdate()
				Where	
					[IdIntrvRegTmp] = @IdIntrvRegTmp
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

