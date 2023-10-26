
-- ==========================================================================================
-- Entity Name:	StpMntObjVrs_KyIns
-- Create date:	16/04/2018 17:46:48
-- AutoCreate:	YES
-- Custom:	NO
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	This stored procedure is intended for inserting values to TbMntObjVrs table
-- History:
-- fab 200428 Aggiunto CodFnzAmbito,
-- dav 230728 Aggiunto IdUtente, DataVrs
-- FRA 230728 Aggiunta gestione DataVrs in inserimento se nulla
-- dav 230821 Aggiunta gestione FlgBug
-- ==========================================================================================
CREATE PROCEDURE [dbo].[StpMntObjVrs_KyIns] (
	@IdObjVrs INT OUTPUT,
	@IdVrs NVARCHAR(20),
	@IdObject NVARCHAR(500),
	@DescVrs NVARCHAR(200) = NULL,
	@NoteVrs NVARCHAR(MAX) = NULL,
	@CodFnzAmbito NVARCHAR(5) = NULL,
	@IdUtente NVARCHAR(256) = NULL,
	@DataVrs DATE = NULL,
    @FlgBug bit = 0,
    @FlgRilascio bit = 0,
    @DataRilascio date = NULL,
	@SysUserCreate NVARCHAR(256),
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

	SET @Msg = 'Inserimento'
	SET @MsgObj = 'StpMntObjVrs_KyIns'

    SET @FlgBug = ISNULL(@FlgBug,0)
    SET @FlgRilascio = ISNULL(@FlgRilascio,0)

    IF @FlgRilascio = 1
    BEGIN
        SET @DataRilascio = GETDATE()
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
		SET @Msg1 = 'Confermi l''inserimento ?'

		EXECUTE StpUteMsg @Msg,
			@Msg1,
			@MsgObj,
			@PrInfo,
			'QST',
			@SysUserCreate,
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
		BEGIN TRY
			BEGIN TRANSACTION

			SELECT @IdObjVrs = MAX(IdObjVrs)
			FROM TbMntObjVrs

			SET @IdObjVrs = ISNULL(@IdObjVrs, 0) + 1

            IF ISNULL(@DataVrs, '') = ''
            BEGIN
                SET @DataVrs = GETDATE()
            END

			INSERT INTO TbMntObjVrs (
				[IdObjVrs],
				[IdVrs],
				[IdObject],
				[DescVrs],
				[NoteVrs],
				[SysUserCreate],
				[SysDateCreate],
				[CodFnzAmbito],
                [IdUtente],
                [DataVrs], 
                [FlgBug],
                [DataRilascio]
				)
			VALUES (
				@IdObjVrs,
				@IdVrs,
				@IdObject,
				@DescVrs,
				@NoteVrs,
				@SysUserCreate,
				Getdate(),
				@CodFnzAmbito,
                @IdUtente,
                @DataVrs, 
                @FlgBug,
                @DataRilascio
				)

			--Select @IdObjVrs = SCOPE_IDENTITY() 
			/****************************************************************
				* Uscita
				****************************************************************/
			SET @Msg1 = 'Operazione completata'

			EXECUTE StpUteMsg @Msg,
				@Msg1,
				@MsgObj,
				@PrInfo,
				'INF',
				@SysUserCreate,
				@KYStato,
				@KYRes,
				'',
				NULL,
				@KYMsg OUT

			SET @KYStato = - 2

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
				@SysUserCreate,
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
			@SysUserCreate,
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

