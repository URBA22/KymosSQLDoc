
-- ==========================================================================================
-- Entity Name:    StpMntObjRlz_KyIns
-- Author:         dav
-- Create date:    17/04/2018 13:25:38
-- Custom_Dbo:     NO
-- Standard_dbo:   YES
-- CustomNote:     
-- Description:    
-- History:
-- dav 230207 Gestito IdAdmDhObject
-- ==========================================================================================
CREATE Procedure [dbo].[StpMntObjRlz_KyIns]
(
	@IdRlz int OUTPUT,
	@RifRlz nvarchar(20),
	@IdObject nvarchar(256),
	@IdObjectRlz nvarchar(256),
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
	SET @MsgObj='MntObjRlz'

	Declare @PrInfo  nvarchar(300)
	--Set @PrInfo  = (SELECT IdRlz  FROM TbMntObjRlz WHERE (IdRlz = @IdRlz))
	--Set @PrInfo  = 'Riga ' + isnull(@PrInfo ,'--')
	--Set @PrInfo  = 'Doc ' + @IdRlz

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

            -- Contorlla la chiave se relazione costruita da DBOH
            IF NOT EXISTS (SELECT IdObject FROM TbMntObjHelp WHERE IdObject = @IdObjectRlz)
            BEGIN
                SELECT @IdObjectRlz = IdObject FROM TbMntObjHelp WHERE IdAdmDhObject = @IdObjectRlz
            END

			BEGIN TRANSACTION


				Select @IdRlz = Max(IdRlz) from TbMntObjRlz

				Set @IdRlz = IsNull(@IdRlz,0) + 1

				Insert Into TbMntObjRlz
					([IdRlz],[RifRlz],[IdObject],[IdObjectRlz],[SysUserCreate],[SysDateCreate])
				Values
					(@IdRlz,@RifRlz,@IdObject,@IdObjectRlz,@SysUserCreate,Getdate())
				

				/****************************************************************
				* Uscita
				****************************************************************/

				SET @Msg1= 'Operazione completata'
				EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'INF',@SysUserCreate,
						@KYStato,@KYRes,'', NULL,@KYMsg out

				SET @KYStato = -2
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

