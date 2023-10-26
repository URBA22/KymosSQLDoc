-- ==========================================================================================
-- Entity Name:   StpWelcomeConfig_LogoUpload
-- Author:        sim
-- Create date:   211105
-- Custom_Dbo:    NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   Esegue l'upload del logo aziendale
-- History:       
-- sim 211105 Creazione
-- ==========================================================================================
Create Procedure dbo.StpWelcomeConfig_LogoUpload(
	@SysUser NVARCHAR(256),
	@KYStato int = NULL output,
	@KYMsg NVARCHAR(MAX) = NULL output,
	@KYRes int = NULL
)
AS
BEGIN

	-- Return -1: Normal; return -2: Refresh data; return -3: Chiude la maschera; -4: Non fa nulla
	-- Tipo Messaggio: INF Informativo, ALR Allert, WRN Warning, QST Question

	SET NOCOUNT ON

	-------------------------------------
	-- Parametri generali
	-------------------------------------
	DECLARE @Msg NVARCHAR(300)
	DECLARE @Msg1 NVARCHAR(300)
	DECLARE @MsgObj NVARCHAR(300)
	DECLARE @MsgInfo NVARCHAR(300)
	DECLARE @PrInfo NVARCHAR(300)
	DECLARE @MsgExt NVARCHAR(MAX)

	SET @Msg = 'Upload Logo.'
	SET @MsgObj = 'StpWelcomeConfig_LogoUpload'

	DECLARE @RowCount INT

	-------------------------------------
	-- Parametri per struttura XML
	-------------------------------------
	DECLARE @ParamCtrl NVARCHAR(MAX)
	DECLARE @C_Logo NVARCHAR(MAX)
	DECLARE @C_IdDoc NVARCHAR(MAX)

	-------------------------------------
	-- Variabili ausiliarie
	-------------------------------------
	DECLARE @Logo NVARCHAR(50)
	DECLARE @IdCliente INT
	DECLARE @IdDoc NVARCHAR(50)
	DECLARE @TipoDoc NVARCHAR(300) = 'ImportLogoAziendale'

	SET @ParamCtrl = '<ParamCtrl>' + REPLACE(REPLACE(@KYMsg, '-|', '<'), '|-', '>') + '</ParamCtrl>'

	/****************************************************************
	 * Stato 0 - Domanda Iniziale
	 ****************************************************************/
	IF @KYStato = 0
		BEGIN
			SET @KYStato = 1

			SET @IdDoc = CONVERT(NVARCHAR(50), NEWID())

			-- Recupera parametri per autoupdate
			SET @Logo = dbo.FncKyMsgCtrlValue(@ParamCtrl, 'Logo', 1)
			SET @IdDoc = dbo.FncKyMsgCtrlValue(@ParamCtrl, 'IdDoc', 1)

			-- Parametri di richiesta
			SET @C_Logo = dbo.FncKyMsgDocUpload('Logo', @KYStato, 'Logo:', @TipoDoc, @IdDoc)
			SET @C_IdDoc = dbo.FncKyMsgVariable('IdDoc', @KYStato, @IdDoc)

			-- Crea XML
			SET @ParamCtrl = dbo.FncKyMsgAddControl(@ParamCtrl, @KYStato - 1, @C_Logo)
			SET @ParamCtrl = dbo.FncKyMsgAddControl(@ParamCtrl, @KYStato, @C_IdDoc)

			SET @Msg1 = 'Confermi l''operazione?'
			EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'QST', @SysUser,
			        @KYStato, @KYRes, '', '(1):Ok;0:Cancel', @KYMsg out

			SET @KYMsg = @KYMsg + '<ParamCtrl>' + @ParamCtrl + '</ParamCtrl>'

			RETURN
		END

	/****************************************************************
	* Stato 1 - risposta affermativa
	****************************************************************/
	IF @KYStato IS NULL OR (@KYStato = 1 AND @KYRes = 1)
		BEGIN
			-------------------------------------
			-- Esegue il comando
			-------------------------------------
			BEGIN TRY
				SET @IdDoc = dbo.FncKyMsgCtrlValue(@ParamCtrl, 'IdDoc', 1)

				IF (ISNULL(@SysUser, '') <> '')
					BEGIN
						SELECT @IdCliente = VstContatti.IdCliente
						FROM
							dbo.AspNetUsers     AspNetUsers
								INNER JOIN
								dbo.VstContatti VstContatti
									ON AspNetUsers.UserName = VstContatti.EMail
						WHERE AspNetUsers.UserName = @SysUser
					END

				BEGIN TRANSACTION
					IF ISNULL(@IdCliente, 0) = 0
						BEGIN
							SET @Msg1 = 'Operazione annullata, cliente del contatto non definito'
							EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUser,
							        @KYStato, @KyRes, '', NULL, @KYMsg OUT
							SET @KYStato = -1

							-- Delete pending documents
							DELETE TbDocumenti
							WHERE IdDoc = @IdDoc
							  AND TipoDoc = @TipoDoc

							COMMIT TRANSACTION

							RETURN
						END


					UPDATE TbDocumenti
					SET TipoDoc    = 'TbClienti',
					    IdDoc      = @IdCliente,
					    CodFnzTipo = 'LOGO'
					WHERE IdDoc = @IdDoc
					  AND TipoDoc = @TipoDoc

					-------------------------------------
					-- Controllo esito negativo
					-------------------------------------
					SET @RowCount = @@ROWCOUNT
					IF @RowCount = 0
						BEGIN
							SET @Msg1 = 'Nessun record modificato'
							EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'WRN', @SysUser,
							        @KYStato, @KYRes, '', NULL, @KYMsg OUT
							SET @KYStato = -1
						END
					ELSE
						-------------------------------------
						-- Uscita
						-------------------------------------
						BEGIN

							SET @Msg1 = 'Operazione Completata, modificati ' + convert(NVARCHAR(20), @RowCount) +
							            ' record.'
							EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'INF', @SysUser,
							        @KYStato, @KYRes, '', NULL, @KYMsg OUT
							SET @KYStato = -2
						END
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				-------------------------------------
				-- Gestione CATCH
				-------------------------------------

				ROLLBACK TRANSACTION
				SET @MsgExt = ERROR_MESSAGE()
				SET @Msg1 = 'Errore Stp'

				EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUser,
				        @KYStato, @KYRes, @MsgExt, null, @KYMsg OUT
				SET @KYStato = -4
			END CATCH

			RETURN
		END

/****************************************************************
 * Stato 1 - risposta negativa
 ****************************************************************/
	IF @KYStato = 1 AND @KYRes = 0
		BEGIN

			SET @Msg1 = 'Operazione annullata'
			EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'WRN', @SysUser,
			        @KYStato, @KYRes, '', null, @KYMsg OUT
			SET @KYStato = -4
			RETURN
		END
END

GO

