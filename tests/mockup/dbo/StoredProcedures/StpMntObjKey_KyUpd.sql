

-- ==========================================================================================
-- Entity Name:	StpMntObjKey_KyUpd
-- Create date:	17/07/2019 11:38:12
-- AutoCreate:	YES
-- Custom:	NO
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	This stored procedure is intended for updating TbMntObjKey table
-- History:
-- fab 23.07.19	Aggiunto Value e UPDATE TbSettingKey
-- ==========================================================================================
CREATE Procedure [dbo].[StpMntObjKey_KyUpd]
(
	@IdObjKey int,
	@IdKey nvarchar(200),
	@IdObject nvarchar(256),
	@Value nvarchar(max),
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
	SET @MsgObj='MntObjKey'

	Declare @PrInfo  nvarchar(300)
	--Set @PrInfo  = (SELECT IdObjKey  FROM TbMntObjKey WHERE (IdObjKey = @IdObjKey))
	--Set @PrInfo  = 'Riga ' + isnull(@PrInfo ,'--')
	--Set @PrInfo  = 'Doc ' + @IdObjKey

	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato,999) = 0
	BEGIN
		SET @Msg1= 'Confermi l''aggiornamento ?'
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'QST',@SysUserUpdate,
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

				Update TbMntObjKey
				Set
					[IdKey] = @IdKey,
					[IdObject] = @IdObject,
					[SysUserUpdate]=@SysUserUpdate,
					[SysDateUpdate]=Getdate()
				Where	
					[IdObjKey] = @IdObjKey
					and [SysRowVersion] = @SysRowVersion

				IF @@ROWCOUNT =0
				BEGIN
					SET @Msg1= 'Operazione annullata, record modificato'
					EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj,  @PrInfo ,'ALR',@SysUserUpdate,
							@KYStato,@KyRes,'', NULL,@KYMsg out
					SET @KYStato = -1
				END
				ELSE
				BEGIN
					/****************************************************************
					* Uscita
					****************************************************************/
					
					UPDATE TbSettingKey
					SET Value = @Value
					WHERE IdKey = @IdKey

					SET @Msg1= 'Operazione completata'
					EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'INF',@SysUserUpdate,
							@KYStato,@KyRes,'', NULL,@KYMsg out

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
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'WRN',@SysUserUpdate,
				@KYStato,@KyRes,'',null,@KYMsg out
		SET @KYStato = -4
		RETURN
	END

End

GO

