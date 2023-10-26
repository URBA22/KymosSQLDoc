-- ==========================================================================================
-- Entity Name:	StpMntAnagUnitaTipo_KyDel
-- Create date:	19/08/2021 11:56:24
-- AutoCreate:	YES
-- Custom:	NO
-- Custom_Dbo:	NO
-- Standard_dbo:	YES
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	This stored procedure is intended for deleting a specific row from TbMntAnagUnitaTipo table
-- History:
-- sim 210819 Creazione
-- ==========================================================================================
Create Procedure StpMntAnagUnitaTipo_KyDel(
	@IdUnitaTipo nvarchar(20),
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

	SET @Msg = 'Eliminazione'
	SET @MsgObj = 'MntAnagUnitaTipo'

	Declare @PrInfo nvarchar(300)
	--Set @PrInfo  = (SELECT IdUnitaTipo  FROM TbMntAnagUnitaTipo WHERE (IdUnitaTipo = @IdUnitaTipo))
	--Set @PrInfo  = 'Riga ' + isnull(@PrInfo ,'--')
	--Set @PrInfo  = 'Doc ' + @IdUnitaTipo

	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato, 999) = 0
		BEGIN
			SET @Msg1 = 'Confermi l''eliminazione ?'
			EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'QST', @SysUserUpdate,
			        @KYStato, @KyRes, '', '(1):Ok;0:Cancel', @KYMsg out
			SET @KYStato = 1
			RETURN
		END


	/****************************************************************
	* Stato 1 - risposta affermativa
	****************************************************************/
	IF @KYStato IS NULL OR (@KYStato = 1 and @KYRes = 1)
		BEGIN
			/****************************************************************
			* Controlla se esistono righe collegate nele tabelle dipendenti
			****************************************************************/
			/*
			If Exists(SELECT IdUnitaTipo  FROM TbMntAnagUnitaTipo WHERE (IdUnitaTipo = @IdUnitaTipo))
			BEGIN
				SET @Msg1= 'Operazione annullata, ci sono record correlati'
					EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'ALR',@SysUserUpdate,
						@KYStato,@KyRes,'Righe Documento', Null,@KYMsg out
					SET @KYStato = -2
			RETURN
			END
			*/

			-- Elimina

			BEGIN TRY
				BEGIN TRANSACTION
					Delete TbMntAnagUnitaTipo
					Where [IdUnitaTipo] = @IdUnitaTipo
					  and [SysRowVersion] = @SysRowVersion


					IF @@ROWCOUNT = 0
						BEGIN
							SET @Msg1 = 'Operazione annullata, record modificato'
							EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUserUpdate,
							        @KYStato, @KyRes, '', NULL, @KYMsg out
							SET @KYStato = -2
						END
					ELSE
						BEGIN

							EXECUTE StpGen_DelDoc 'TbMntAnagUnitaTipo', @IdUnitaTipo

							SET @Msg1 = 'Operazione completata'
							EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'INF', @SysUserUpdate,
							        @KYStato, @KyRes, '', NULL, @KYMsg out
							SET @KYStato = -3
						END
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				-- Execute error retrieval routine.
				rollback transaction
				Declare @MsgExt as nvarchar(max)
				SET @MsgExt = ERROR_MESSAGE()
				SET @Msg1 = 'Errore Stp'

				EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'ALR', @SysUserUpdate,
				        @KYStato, @KyRes, @MsgExt, null, @KYMsg out
				SET @KYStato = -4
			END CATCH

			RETURN
		END

	/****************************************************************
	* Stato 1 - risposta negativa
	****************************************************************/
	IF ISNULL(@KYStato, 999) = 1 and @KYRes = 0
		BEGIN

			/****************************************************************
			* Uscita
			****************************************************************/

			SET @Msg1 = 'Operazione annullata'
			EXECUTE StpUteMsg @Msg, @Msg1, @MsgObj, @PrInfo, 'WRN', @SysUserUpdate,
			        @KYStato, @KyRes, '', null, @KYMsg out
			SET @KYStato = -1
			RETURN
		END

End

GO

