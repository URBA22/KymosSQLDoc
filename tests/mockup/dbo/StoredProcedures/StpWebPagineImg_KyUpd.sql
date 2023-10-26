

-- ==========================================================================================
-- Entity Name:	StpWebPagineImg_KyUpd
-- Author:	Dav
-- Create date:	12/03/2013 00:06:00
-- AutoCreate:	YES
-- Custom:	NO
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	This stored procedure is intended for updating TbWebPagineImg table
-- ==========================================================================================
CREATE Procedure [dbo].[StpWebPagineImg_KyUpd]
(
	@IdPaginaImg int,
	@IdPagina int,
	@IdPaginaImgPadre int,
	@Didascalia nvarchar(300),
	@CodFnzTipo nvarchar(5),
	@NrImg int,
	@Ordinamento int,
	@Disabilita bit,
	@IdImg int,
	@IdImgAlt int,
	@DataValiditaDa date,
	@DataValiditaA date,
	@Titolo nvarchar(500),
	@Sottotitolo nvarchar(500),
	@Descrizione nvarchar(MAX),
	@UrlEsterno nvarchar(256),
	@UrlEsternoTarget bit,
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
	SET @MsgObj='WebPagineImg'
	
	Declare @PrInfo  nvarchar(300)
	Set @PrInfo  = @IdPagina
	Set @PrInfo  = 'Doc ' + isnull(@PrInfo ,'--')

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

				Update TbWebPagineImg
				Set
					[IdPagina] = @IdPagina,
					[IdPaginaImgPadre] = @IdPaginaImgPadre,
					[Didascalia] = @Didascalia,
					[CodFnzTipo] = @CodFnzTipo,
					[NrImg] = @NrImg,
					[Ordinamento] = @Ordinamento,
					[Disabilita] = @Disabilita,
					[IdImg] = @IdImg,
					IdImgAlt=@IdImgAlt,
					[DataValiditaDa] = @DataValiditaDa,
					[DataValiditaA] = @DataValiditaA,
					[Titolo] = @Titolo,
					[Sottotitolo] = @Sottotitolo,
					[Descrizione] = @Descrizione,
					[UrlEsterno] = @UrlEsterno,
					UrlEsternoTarget=@UrlEsternoTarget,
					[SysUserUpdate]=@SysUserUpdate,
					[SysDateUpdate]=Getdate()
				Where	
					[IdPaginaImg] = @IdPaginaImg
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

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'NO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPagineImg_KyUpd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'01.00.00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPagineImg_KyUpd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '03/12/2013 18:02:21', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPagineImg_KyUpd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'Web immagini', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPagineImg_KyUpd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'Dav', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPagineImg_KyUpd';


GO

