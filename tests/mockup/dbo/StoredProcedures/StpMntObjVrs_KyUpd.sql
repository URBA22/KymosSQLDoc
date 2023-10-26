
-- ==========================================================================================
-- Entity Name:	StpMntObjVrs_KyUpd
-- Create date:	16/04/2018 17:46:48
-- AutoCreate:	YES
-- Custom:	NO
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	This stored procedure is intended for updating TbMntObjVrs table
-- History:
-- fab 200428 Aggiunto CodFnzAmbito
-- dav 230728 Aggiunto IdUtente, DataVrs
-- dav 230821 Aggiunta gestione FlgBug,
-- ==========================================================================================
CREATE PROCEDURE [dbo].[StpMntObjVrs_KyUpd] (
	@IdObjVrs INT,
	@IdVrs NVARCHAR(20),
	@IdObject NVARCHAR(500),
	@DescVrs NVARCHAR(200),
	@NoteVrs NVARCHAR(MAX),
	@CodFnzAmbito NVARCHAR(5),
	@IdUtente NVARCHAR(256),
	@DataVrs DATE,
    @FlgBug bit,
    @FlgRilascio bit,
    @DataRilascio date,
	@SysRowVersion TIMESTAMP,
	@SysUserUpdate NVARCHAR(256),
	@KYStato INT = NULL OUTPUT,
	@KYMsg NVARCHAR(max) = NULL OUTPUT,
	@KYRes INT = NULL
	)
AS
BEGIN
	/*
	return -1: Normal; return -2: Refresh data; return -3: Chiude la maschera; -4: Non fa nulla	
	Tipo Messaggio: INF Informativo, ALR Allert, WRN Warning, QST Question	
	*/
	DECLARE @Msg NVARCHAR(300)
	DECLARE @Msg1 NVARCHAR(300)
	DECLARE @MsgObj NVARCHAR(300)

	SET @Msg = 'Aggiornamento'
	SET @MsgObj = 'StpMntObjVrs_KyUpd'

    IF @FlgRilascio = 1 AND @DataRilascio IS NULL
    BEGIN
        SET @DataRilascio = GETDATE()
        SET @IdVrs = CONVERT (nvarchar(10), @DataRilascio, 12)
    END

	DECLARE @PrInfo NVARCHAR(300)

	--Set @PrInfo  = (SELECT IdObjVrs  FROM TbMntObjVrs WHERE (IdObjVrs = @IdObjVrs))
	--Set @PrInfo  = 'Riga ' + isnull(@PrInfo ,'--')
	--Set @PrInfo  = 'Doc ' + @IdObjVrs
	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato, 999) = 0
	BEGIN
		SET @Msg1 = 'Confermi l''aggiornamento ?'

		EXECUTE StpUteMsg @Msg,
			@Msg1,
			@MsgObj,
			@PrInfo,
			'QST',
			@SysUserUpdate,
			@KYStato,
			@KYRes,
			'',
			'(1):Ok;0:Cancel',
			@KYMsg OUT

		SET @KYStato = 1

		RETURN
	END

	/****************************************************************
	* Stato 1 - risposta affermativa
	****************************************************************/
	IF @KYStato IS NULL
		OR (
			@KYStato = 1
			AND @KYRes = 1
			)
	BEGIN

        /****************************************************************
		* Controlla correttezza IDVRS
		****************************************************************/
		
		If NOT(ISDATE (@IdVrs) = 1  OR @IdVrs = '300000')
		BEGIN
			SET @Msg1= 'Operazione annullata, il codice versione non è una data formattata'
				EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'ALR',@SysUserUpdate,
					@KYStato,@KYRes,'Versioni', Null,@KYMsg out
				SET @KYStato = -2
		RETURN
		END
		

		BEGIN TRY
			BEGIN TRANSACTION

			UPDATE TbMntObjVrs
			SET [IdVrs] = @IdVrs,
				[IdObject] = @IdObject,
				[DescVrs] = @DescVrs,
				[NoteVrs] = @NoteVrs,
				[CodFnzAmbito] = @CodFnzAmbito,
				[IdUtente] = @IdUtente,
				[DataVrs] = @DataVrs,
                [FlgBug] = @FlgBug,
                [DataRilascio] = @DataRilascio,
				[SysUserUpdate] = @SysUserUpdate,
				[SysDateUpdate] = Getdate()
			WHERE [IdObjVrs] = @IdObjVrs
				AND [SysRowVersion] = @SysRowVersion

			IF @@ROWCOUNT = 0
			BEGIN
				SET @Msg1 = 'Operazione annullata, record modificato'

				EXECUTE StpUteMsg @Msg,
					@Msg1,
					@MsgObj,
					@PrInfo,
					'ALR',
					@SysUserUpdate,
					@KYStato,
					@KYRes,
					'',
					NULL,
					@KYMsg OUT

				SET @KYStato = - 1
			END
			ELSE
			BEGIN
				/****************************************************************
					* Uscita
					****************************************************************/
				SET @Msg1 = 'Operazione completata'

				EXECUTE StpUteMsg @Msg,
					@Msg1,
					@MsgObj,
					@PrInfo,
					'INF',
					@SysUserUpdate,
					@KYStato,
					@KYRes,
					'',
					NULL,
					@KYMsg OUT

				SET @KYStato = - 1
			END

			COMMIT TRANSACTION
		END TRY

		BEGIN CATCH
			-- Execute error retrieval routine.
			ROLLBACK TRANSACTION

			DECLARE @MsgExt AS NVARCHAR(max)

			SET @MsgExt = ERROR_MESSAGE()
			SET @Msg1 = 'Errore Stp'

			EXECUTE StpUteMsg @Msg,
				@Msg1,
				@MsgObj,
				@PrInfo,
				'ALR',
				@SysUserUpdate,
				@KYStato,
				@KYRes,
				@MsgExt,
				NULL,
				@KYMsg OUT

			SET @KYStato = - 4
		END CATCH

		RETURN
	END

	/****************************************************************
	* Stato 1 - risposta negativa
	****************************************************************/
	IF ISNULL(@KYStato, 999) = 1
		AND @KYRes = 0
	BEGIN
		/****************************************************************
		* Uscita
		****************************************************************/
		SET @Msg1 = 'Operazione annullata'

		EXECUTE StpUteMsg @Msg,
			@Msg1,
			@MsgObj,
			@PrInfo,
			'WRN',
			@SysUserUpdate,
			@KYStato,
			@KYRes,
			'',
			NULL,
			@KYMsg OUT

		SET @KYStato = - 4

		RETURN
	END
END

GO

