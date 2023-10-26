
-- ==========================================================================================
-- Entity Name:    StpMntObjHelp_KyIns
-- Author:         dav
-- Create date:    16/04/2018 18:16:15
-- Custom_Dbo:     NO
-- Standard_dbo:   YES
-- CustomNote:     
-- Description:    
-- History:
-- dav 16/04/2018 Creazione
-- dav 19.08.19 Correzione generazione Help da procedure
-- dav 221115 Gestione IdAdmDhObject
-- fab 230118 Gestito IdObject se viene passato IdAdmDhObject
-- ==========================================================================================
CREATE Procedure [dbo].[StpMntObjHelp_KyIns]
(
	@IdObject nvarchar(256) OUTPUT,
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
	SET @MsgObj='StpMntObjHelp_KyIns'

	Declare @PrInfo  nvarchar(300)
	--Set @PrInfo  = (SELECT IdObject  FROM TbMntObjHelp WHERE (IdObject = @IdObject))
	--Set @PrInfo  = 'Riga ' + isnull(@PrInfo ,'--')
	--Set @PrInfo  = 'Doc ' + @IdObject

	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato,999) = 0
	BEGIN
		SET @Msg1= 'Confermi l''inserimento ?'
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'QST',@SysUserCreate,
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
				
				IF (EXISTS(SELECT IdObject FROM TbMntObjHelp WHERE IdAdmDhObject = @IdObject))
				BEGIN
					SELECT @IdObject = IdObject FROM TbMntObjHelp WHERE IdAdmDhObject = @IdObject
				END

				IF NOT(EXISTS(SELECT IdObject FROM TbMntObjHelp WHERE IdObject = @IdObject))
                    AND NOT(EXISTS(SELECT IdObject FROM TbMntObjHelp WHERE IdAdmDhObject = @IdObject))

				BEGIN
					Declare @DescHelp as nvarchar(50)
					Declare @IdTable as nvarchar(50)
					if @IdObject is null
						begin
							SELECT @IdObject = max (IdObject) FROM TbMntObjHelp where left(IdObject,10) = 'PROCEDURE#'
							SET @IdObject = SUBSTRING(@IdObject,11,99)
							SET @IdObject = ISNULL(@IdObject,0)
							IF ISNUMERIC (@IdObject ) = 1
								BEGIN
									SET @IdObject = @IdObject + 1
									SET @IdObject = 'PROCEDURE#' + RIGHT('0000' + @IdObject,4)
									SET @DescHelp = @IdObject
									SET @IdTable = 'DBO'
								END
						end
					Insert Into TbMntObjHelp
						([IdObject],[IdAdmDhObject],[SysUserCreate],[SysDateCreate], DescHelp, IdTable)
					Values
						(@IdObject,@IdObject,@SysUserCreate,Getdate(), @DescHelp, @IdTable)
				
					SET @Msg1= 'Operazione completata'
					EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'INF',@SysUserCreate,
							@KYStato,@KYRes,'', NULL,@KYMsg out

					SET @KYStato = -2
				END

				/****************************************************************
				* Uscita
				****************************************************************/
				SET @Msg1= ''
				SET @KyMsg = Null

				SET @KYStato = -1
				
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			-- Execute error retrieval routine.
			rollback transaction
			Declare @MsgExt as nvarchar(max)
			SET @MsgExt= ERROR_MESSAGE()
			SET @Msg1= 'Errore Stp'

			EXECUTE StpUteMsg	@Msg, @Msg1,@MsgObj, @PrInfo ,'ALR',@SysUserCreate,
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
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'WRN',@SysUserCreate,
				@KYStato,@KYRes,'',null,@KYMsg out
		SET @KYStato = -4
		RETURN
	END

End

GO

