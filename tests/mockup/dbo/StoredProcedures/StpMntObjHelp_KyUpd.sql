
-- ==========================================================================================
-- Entity Name:    StpMntObjHelp_KyUpd
-- Author:         dav
-- Create date:    16/04/2018 18:16:15
-- Custom_Dbo:     NO
-- Standard_dbo:   YES
-- CustomNote:     
-- Description:    
-- History:
-- dav 16/04/2018 Creazione
-- dav 25.06.19 Aggiunta NoteHelpTec, CodFnzStato
-- sim 221205 Aggiunto IdAdmDhObject
-- dav 230215 Aggiunto @FrmName
-- ==========================================================================================
CREATE Procedure [dbo].[StpMntObjHelp_KyUpd]
(
	@IdObject nvarchar(256),
	@IdTable nvarchar(500),
	@DescHelp nvarchar(200),
	@NoteHelp nvarchar(MAX),
	@NoteHelpTec nvarchar(MAX),
	@CodFnzStato nvarchar(5),
	@IdUtente nvarchar(256),
	@Tag nvarchar(200),
	@NoteHelpLocal nvarchar(MAX),
	@IdAdmDhObject nvarchar(256),
    @FrmName nvarchar(100),
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
	SET @MsgObj='MntObjHelp'

	Declare @PrInfo  nvarchar(300)
	--Set @PrInfo  = (SELECT IdObject  FROM TbMntObjHelp WHERE (IdObject = @IdObject))
	--Set @PrInfo  = 'Riga ' + isnull(@PrInfo ,'--')
	--Set @PrInfo  = 'Doc ' + @IdObject

	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato,999) = 0
	BEGIN
		SET @Msg1= 'Confermi l''aggiornamento ?'
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'QST',@SysUserUpdate,
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

				Update TbMntObjHelp
				Set
					[IdTable] = @IdTable,
					[DescHelp] = @DescHelp,
					[NoteHelp] = @NoteHelp,
					[NoteHelpTec] = @NoteHelpTec,
					[CodFnzStato] = @CodFnzStato,
					[IdUtente] = @IdUtente,
					[NoteHelpLocal] = @NoteHelpLocal,
					[Tag]= @Tag,
                    [FrmName] = @FrmName,
					[SysUserUpdate]=@SysUserUpdate,
					[IdAdmDhObject] = @IdAdmDhObject,
					[SysDateUpdate]=Getdate()
				Where	
					[IdObject] = @IdObject
					and [SysRowVersion] = @SysRowVersion

				

				IF @@ROWCOUNT =0
				BEGIN
					SET @Msg1= 'Operazione annullata, record modificato'
					EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj,  @PrInfo ,'ALR',@SysUserUpdate,
							@KYStato,@KYRes,'', NULL,@KYMsg out
					SET @KYStato = -1
				END
				ELSE
				BEGIN
					/****************************************************************
					* Uscita
					****************************************************************/

					SET @Msg1= 'Operazione completata'
					EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'INF',@SysUserUpdate,
							@KYStato,@KYRes,'', NULL,@KYMsg out

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
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'WRN',@SysUserUpdate,
				@KYStato,@KYRes,'',null,@KYMsg out
		SET @KYStato = -4
		RETURN
	END

End

GO

