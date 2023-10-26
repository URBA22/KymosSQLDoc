-- ==========================================================================================
-- Entity Name:	StpWelcomeConfig_KyUpd
-- Create date:	211103
-- AutoCreate:	YES
-- Custom:	NO
-- Custom_Dbo:	NO
-- Standard_dbo:	YES
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	This stored procedure is intended for updating WelcomeConfig related tables
-- History:
-- sim 211103 Creazione
-- sim 211108 # IN ATTESA DI MICHELE #
-- ==========================================================================================
CREATE PROCEDURE [dbo].[StpWelcomeConfig_KyUpd](
	-- @Logo VARBINARY(MAX),
	@NoteWelcome NVARCHAR(MAX),
	@NoteGDPR NVARCHAR(MAX),
	@SysRowVersion TIMESTAMP,
	@SysUserUpdate NVARCHAR(256),
	@KYStato INT = NULL OUTPUT,
	@KYMsg NVARCHAR(MAX) = NULL OUTPUT,
	@KYRes INT = NULL
)
AS
BEGIN
	/*
	return -1: Normal; return -2: Refresh data; return -3: Chiude la maschera; -4: Non fa nulla
	Tipo Messaggio: INF Informativo, ALR Allert, WRN Warning, QST Question
	*/
	
	
	
	-- IMBROGLIO IN ATTESA DI MICHELE
	-- TODO: CANCELLARE QUESTA RIGA
	SET @SysUserUpdate = ISNULL(@SysUserUpdate, 'galileo@galilei.com')
	


	DECLARE @Msg NVARCHAR(300)
	DECLARE @Msg1 NVARCHAR(300)
	DECLARE @MsgObj NVARCHAR(300)

	DECLARE @IdCliente INT

	DECLARE @RowCountCliente INT = 0
	-- DECLARE @RowCountDoc INT = 0

	SET @Msg = 'Aggiornamento'
	SET @MsgObj = 'WelcomeConfig'

	DECLARE @PrInfo NVARCHAR(300)
	--SET @PrInfo  = (SELECT IdVstr  FROM TbVstr WHERE (IdVstr = @IdVstr))
	--SET @PrInfo  = 'Riga ' + isnull(@PrInfo ,'--')
	--SET @PrInfo  = 'Doc ' + @IdVstr

	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato, 999) = 0
		BEGIN
			SET @Msg1 = 'Confermi l''aggiornamento ?'
			EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'QST', @SysUserUpdate,
			        @KYStato, @KyRes, '', '(1):Ok;0:Cancel', @KYMsg OUT
			SET @KYStato = 1
			RETURN
		END

	/****************************************************************
	* Stato 1 - risposta affermativa
	****************************************************************/
	IF @KYStato IS NULL OR (@KYStato = 1 AND @KYRes = 1)
		BEGIN
			BEGIN TRY
				IF (ISNULL(@SysUserUpdate, '') <> '' AND ISNULL(@IdCliente, 0) = 0)
					BEGIN
						SELECT @IdCliente = VstContatti.IdCliente
						FROM
							dbo.AspNetUsers     AspNetUsers
								INNER JOIN
								dbo.VstContatti VstContatti
									ON AspNetUsers.UserName = VstContatti.EMail
						WHERE AspNetUsers.UserName = @SysUserUpdate
					END

				IF ISNULL(@IdCliente, 0) = 0
					BEGIN
						SET @Msg1 = 'Operazione annullata, cliente del contatto non definito'
						EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUserUpdate,
						        @KYStato, @KyRes, '', NULL, @KYMsg OUT
						SET @KYStato = -1
					    RETURN 
					END

				BEGIN TRANSACTION
					UPDATE TbClienti
					SET [NoteWelcome]   = @NoteWelcome,
					    [NoteGDPR]      = @NoteGDPR,
					    [SysUserUpdate] = @SysUserUpdate,
					    [SysDateUpdate] = GETDATE()
					WHERE [IdCliente] = @IdCliente
					  AND [SysRowVersion] = @SysRowVersion

					SET @RowCountCliente = @@ROWCOUNT

					IF @RowCountCliente = 0
						BEGIN
							SET @Msg1 = 'Operazione annullata, record modificato'
							EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUserUpdate,
							        @KYStato, @KyRes, '', NULL, @KYMsg OUT
							SET @KYStato = -1
						END
				    /*ELSE IF @RowCountDoc = 0
						BEGIN
							SET @Msg1 = 'Operazione annullata, impossibile inserire il logo'
							EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUserUpdate,
							        @KYStato, @KyRes, '', NULL, @KYMsg OUT
							SET @KYStato = -1
						END*/
					ELSE
						BEGIN
							/****************************************************************
							* Uscita
							****************************************************************/

							SET @Msg1 = 'Operazione completata'
							EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'INF', @SysUserUpdate,
							        @KYStato, @KyRes, '', NULL, @KYMsg OUT

							SET @KYStato = -1
						END
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				-- Execute error retrieval routine.
				ROLLBACK TRANSACTION
				DECLARE @MsgExt AS NVARCHAR(MAX)
				SET @MsgExt = ERROR_MESSAGE()
				SET @Msg1 = 'Errore Stp'

				EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUserUpdate,
				        @KYStato, @KyRes, @MsgExt, NULL, @KYMsg OUT
				SET @KYStato = -4
			END CATCH

			RETURN
		END

	/****************************************************************
	* Stato 1 - risposta negativa
	****************************************************************/
	IF ISNULL(@KYStato, 999) = 1 AND @KYRes = 0
		BEGIN

			/****************************************************************
			* Uscita
			****************************************************************/

			SET @Msg1 = 'Operazione annullata'
			EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'WRN', @SysUserUpdate,
			        @KYStato, @KyRes, '', NULL, @KYMsg OUT
			SET @KYStato = -4
			RETURN
		END

End

GO

