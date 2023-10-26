

        
-- ==========================================================================================
-- Entity Name:   StpMntObjDbVrs_KyUpd
-- Author:        dav
-- Create date:   220514
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   
-- History:
-- dav 220514 Creazione
-- =============================================
CREATE PROCEDURE [dbo].[StpMntObjDbVrs_KyUpd]
(
	@IdObjVrs int,
	@IdObj NVARCHAR(200),
	@SchemaName NVARCHAR(256),
	@ObjName NVARCHAR(256),
	@ObjType NVARCHAR(256),
	@IdVrs NVARCHAR(20),
	@DescVrs NVARCHAR(200),
	@ObjDefinition NVARCHAR(MAX),
	@SysRowVersion TIMESTAMP,
	@ObjStandard NVARCHAR(10),
	@FlgTest BIT,
	@IdUtenteTest NVARCHAR(256),
	@DescTest NVARCHAR(MAX),
	@EsitoTest NVARCHAR(MAX),
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

	DECLARE @Msg NVARCHAR(300)
	DECLARE @Msg1 NVARCHAR(300)
	DECLARE @MsgObj NVARCHAR(300)

	SET @Msg = 'Aggiornamento'
	SET @MsgObj = 'MntObjDbVrs'

	DECLARE @PrInfo NVARCHAR(300)
	-- SET @PrInfo = (SELECT IdObj FROM TbMntObjDbVrs WHERE (IdObj = @IdObj))
	-- SET @PrInfo = 'Riga ' + isnull(@PrInfo ,'--')
	-- SET @PrInfo = 'Doc ' + @IdObj

	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato,999) = 0
	BEGIN
		SET @Msg1 = 'Confermi l''aggiornamento ?'
		EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo ,'QST', @SysUserUpdate,
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
			BEGIN TRANSACTION

				UPDATE TbMntObjDbVrs
				SET
					--[SchemaName] = @SchemaName,
					--[ObjName] = @ObjName,
					--[ObjType] = @ObjType,
					--[DescVrs] = @DescVrs,
					--[ObjDefinition] = @ObjDefinition,
					--[ObjStandard] = @ObjStandard,
					[FlgTest] = @FlgTest,
					[IdUtenteTest] = @IdUtenteTest,
					[DescTest] = @DescTest,
					[EsitoTest] = @EsitoTest,
					[SysUserUpdate] = @SysUserUpdate,
					[SysDateUpdate] = GETDATE()
				WHERE	
					[IdObjVrs] = @IdObjVrs
					AND [SysRowVersion] = @SysRowVersion

				

				IF @@ROWCOUNT =0
				BEGIN
					SET @Msg1 = 'Operazione annullata, record non modificato'
					EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUserUpdate,
						@KYStato, @KyRes, '', NULL, @KYMsg OUT
					SET @KYStato = -1
				END
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
			DECLARE @MsgExt NVARCHAR(MAX)
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
	IF ISNULL(@KYStato,999) = 1 AND @KYRes = 0
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
END

GO

