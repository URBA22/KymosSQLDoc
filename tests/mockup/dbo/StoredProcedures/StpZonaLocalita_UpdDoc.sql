
-- ==========================================================================================
-- Entity Name:   StpZonaLocalita_UpdDoc
-- Author:        FRA
-- Create date:   23/03/23
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote: Write custom note here
-- Description: Modifica la località del Cliente da Lista di inserimento
-- History
-- FRA 230320 Creazione
-- fab 230328 Aggiunto IdCliSede
-- dav 230418 Tolto IdCliSede
-- fab 230605 Gestione Contatto
-- ==========================================================================================
CREATE PROCEDURE [dbo].[StpZonaLocalita_UpdDoc] (
	@IdZonaLocalita INT,
    @TipoDoc nvarchar(50),
	@IdDoc INT OUTPUT,
	@SysUserCreate NVARCHAR(256),
	@KYStato INT = NULL OUTPUT,
	@KYMsg NVARCHAR(max) = NULL OUTPUT,
	@KYRes INT = NULL,
	@KYSel NVARCHAR(MAX) = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	IF ISNULL(@KYSel, '') <> ''
	BEGIN
		EXEC dbo.StpAdmDynamicSel 'StpZonaLocalita_UpdDoc',
			@SysUserCreate,
			@KYSel

		SET @KYStato = - 2

		RETURN
	END

	DECLARE @Msg NVARCHAR(300)
	DECLARE @Msg1 NVARCHAR(300)
	DECLARE @MsgObj NVARCHAR(300)

	SET @Msg = 'Inserimento Località'
	SET @MsgObj = 'StpZonaLocalita_UpdDoc'

	DECLARE @PrInfo NVARCHAR(300)

	SET @PrInfo = @IdZonaLocalita
	SET @PrInfo = 'Doc ' + isnull(@PrInfo, '--')

	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato, 999) = 0
	BEGIN
		DECLARE @Note AS NVARCHAR(max)
		DECLARE @tipomsg AS NVARCHAR(3)
		DECLARE @param AS NVARCHAR(max)
		DECLARE @RagSoc AS NVARCHAR(300)

        IF (@TipoDoc = 'TbCliDest' AND @IdDoc < 0)
        BEGIN
            SET @TipoDoc = 'TbClienti'
            SET @IdDoc = -1 * @IdDoc
        END
        
        IF @TipoDoc = 'TbClienti'
        BEGIN
            SELECT @RagSoc = RagSoc
            FROM VstClienti
            WHERE IdCliente = @IdDoc
        END
        
        IF @TipoDoc = 'TbCliDest'
        BEGIN
            SELECT @RagSoc = DescDest
            FROM VstCliDest
            WHERE IdCliDest = @IdDoc
        END

        IF @TipoDoc = 'TbContatti'
        BEGIN
            SELECT @RagSoc = CognomeNome
            FROM VstContatti
            WHERE IdContatto = @IdDoc
        END
        
        IF @TipoDoc = 'TbFornitori'
        BEGIN
            SELECT @RagSoc = RagSoc
            FROM VstFornitori
            WHERE IdFornitore = @IdDoc
        END
        
		SET @tipomsg = 'QST'
		SET @param = @RagSoc
		SET @Msg1 = 'Confermi modifica della località?'

		DECLARE @StrCmd AS NVARCHAR(300)

		SET @StrCmd = '(1):Ok;0:Cancel'

		EXECUTE [dbo].[StpUteMsg] @Msg = @Msg,
			@Msg1 = @Msg1,
			@MsgObj = @MsgObj,
			@Param = @Param,
			@CodFnzTipoMsg = @Tipomsg,
			@SysUser = @SysUserCreate,
			@KYStato = @KYStato,
			@KYRes = @KYRes,
			@KyParam = @StrCmd,
			@KyMsg = @KyMsg OUTPUT

		SET @KYStato = 1

		RETURN
	END

	/****************************************************************
	* Stato 1 - risposta affermativa
	****************************************************************/
	IF @KYStato IS NULL
		OR (
			@KYStato = 1
			AND (
				@KYRes = 1
				OR @KYRes = 2
				)
			)
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION

			DECLARE @IdZona NVARCHAR(20)
			DECLARE @IdProvincia NVARCHAR(20)
			DECLARE @Citta NVARCHAR(300)
			DECLARE @Localita [nvarchar] (300)
			DECLARE @Cap NVARCHAR(20)
			DECLARE @IdPaese NVARCHAR(20)

			SELECT @Localita = Localita,
				@IdProvincia = IdProvincia,
				@Citta = Citta,
				@Cap = Cap,
				@IdZona = IdZona,
                @IdPaese = IdPaese
			FROM TbZoneLocalita
			WHERE IdZonaLocalita = @IdZonaLocalita

            IF (@TipoDoc = 'TbCliDest' AND @IdDoc < 0)
            BEGIN
                SET @TipoDoc = 'TbClienti'
                SET @IdDoc = -1 * @IdDoc
            END

            IF @TipoDoc = 'TbClienti' 
            BEGIN
                UPDATE TbClienti
                SET IdZonaLocalita = @IdZonaLocalita,
                    Localita = @Localita,
                    IdZona = @IdZona,
                    Cap = @Cap,
                    Citta = @Citta,
                    Provincia = @IdProvincia,
                    IdPaese = @IdPaese
                WHERE IdCliente = @IdDoc
            END

            IF @TipoDoc = 'TbCliDest'
            BEGIN
                UPDATE TbCliDest
                SET IdZona = @IdZona,
                    Cap = @Cap,
                    Citta = @Citta,
                    Provincia = @IdProvincia,
                    IdPaese = @IdPaese
                WHERE IdCliDest = @IdDoc
            END

            IF @TipoDoc = 'TbContatti'
            BEGIN
                UPDATE TbContatti
                SET IdZona = @IdZona,
                    Cap = @Cap,
                    Citta = @Citta,
                    Provincia = @IdProvincia,
                    IdPaese = @IdPaese
                WHERE IdContatto = @IdDoc
            END

            IF @TipoDoc = 'TbFornitori'
            BEGIN
                UPDATE TbFornitori
                SET 
                    -- IdZonaLocalita = @IdZonaLocalita,
                    -- Localita = @Localita,
                    IdZona = @IdZona,
                    Cap = @Cap,
                    Citta = @Citta,
                    Provincia = @IdProvincia,
                    IdPaese = @IdPaese
                WHERE IdFornitore = @IdDoc
            END


			SET @Msg1 = 'Operazione completata'

			EXECUTE [dbo].[StpUteMsg] @Msg = @Msg,
				@Msg1 = @Msg1,
				@MsgObj = @MsgObj,
				@Param = @Param,
				@CodFnzTipoMsg = 'INF',
				@SysUser = @SysUserCreate,
				@KYStato = @KYStato,
                @KYRes = @KYRes,
				@KyMsg = @KyMsg OUTPUT

			SET @KYStato = -3

			COMMIT TRANSACTION
		END TRY

		BEGIN CATCH
			-- Execute error retrieval routine.
			ROLLBACK TRANSACTION

			DECLARE @MsgExt AS NVARCHAR(max)

			SET @Msg1 = 'Errore Stp'
			SET @MsgExt = ERROR_MESSAGE()

            EXECUTE  [dbo].[StpUteMsg] 
                @Msg = @Msg
                ,@Msg1 = @Msg1
                ,@MsgObj = @MsgObj
                ,@Param = @Param
                ,@CodFnzTipoMsg = 'ALR'
                ,@SysUser = @SysUserCreate
                ,@KYStato = @KYStato
                ,@KYRes = @KYRes
                ,@KYInfoEst = @MsgExt
                ,@KyMsg = @KyMsg OUTPUT

			SET @KYStato = -4
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

        EXECUTE  [dbo].[StpUteMsg] 
            @Msg = @Msg
            ,@Msg1 = @Msg1
            ,@MsgObj = @MsgObj
            ,@Param = @Param
            ,@CodFnzTipoMsg = 'WRN'
            ,@SysUser = @SysUserCreate
            ,@KYStato = @KYStato
            ,@KYRes = @KYRes
            ,@KyMsg = @KyMsg OUTPUT

		SET @KYStato = -4

		RETURN
	END
END

GO

