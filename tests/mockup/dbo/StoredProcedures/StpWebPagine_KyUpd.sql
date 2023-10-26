

-- ==========================================================================================
-- Entity Name:	StpWebPagine_KyUpd
-- Author:	Dav
-- Create date:	11/03/2013 23:51:27
-- AutoCreate:	YES
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	This stored procedure is intended for updating TbWebPagine table
-- History:
-- fab 201130 Aggiunto IdDoc
-- ==========================================================================================
CREATE Procedure [dbo].[StpWebPagine_KyUpd]
(
	@IdPagina int,
	@IdPaginaPadre int,
	@Ordinamento int,
	@FlgMenu bit,
	@FlgMenuSecondario bit,
	@DescMenu nvarchar(200),
	@IdAmbito nvarchar(20),
	@Descrizione nvarchar(200),
	@Data datetime,
	@Titolo nvarchar(500),
	@Sottotitolo nvarchar(500),
	@ContenutoHtml nvarchar(MAX),
	@ContenutoHtml1 nvarchar(MAX),
	@CodFnzTipo nvarchar(5),
	@CodFnzStato nvarchar(5),
	@IdTemplate nvarchar(256),
	@DataValiditaDa date,
	@DataValiditaA date,
	@Autore nvarchar(256),
	@IdUtente nvarchar(256),
	@IdLingua nvarchar(5),
	@IdPaginaLngOrigine int,
	@Versione int,
	@DataVersione datetime,
	@DescVersione nvarchar(MAX),
	@Disabilita bit,
	@UrlEsterno nvarchar(256),
	@MetaDescription nvarchar(MAX),
	@MetaTitolo nvarchar(500),
	@MetaKeyWords nvarchar(MAX),
	@BlocDoc bit,
	@UrlEsternoTarget bit,
	@IdDoc nvarchar(50),
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
	SET @MsgObj='WebPagine'

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

				Update TbWebPagine
				Set
					[IdPaginaPadre] = @IdPaginaPadre,
					[Ordinamento] = @Ordinamento,
					[FlgMenu] = @FlgMenu,
					[FlgMenuSecondario] = @FlgMenuSecondario,
					[DescMenu] = @DescMenu,
					[IdAmbito] = @IdAmbito,
					[Descrizione] = @Descrizione,
					[Data] = @Data,
					[Titolo] = @Titolo,
					[Sottotitolo] = @Sottotitolo,
					[ContenutoHtml] = @ContenutoHtml,
					[ContenutoHtml1] = @ContenutoHtml1,
					[CodFnzTipo] = @CodFnzTipo,
					[CodFnzStato] = @CodFnzStato,
					[IdTemplate] = @IdTemplate,
					[DataValiditaDa] = @DataValiditaDa,
					[DataValiditaA] = @DataValiditaA,
					[Autore] = @Autore,
					[IdUtente] = @IdUtente,
					[IdLingua] = @IdLingua,
					[IdPaginaLngOrigine] = @IdPaginaLngOrigine,
					[Versione] = @Versione,
					[DataVersione] = @DataVersione,
					[DescVersione] = @DescVersione,
					[Disabilita] = @Disabilita,
					[UrlEsterno] = @UrlEsterno,
					[MetaDescription] = @MetaDescription,
					[MetaTitolo] = @MetaTitolo,
					[MetaKeyWords] = @MetaKeyWords,
					[BlocDoc] = @BlocDoc,
					[UrlEsternoTarget]=@UrlEsternoTarget,
					[IdDoc] = @IdDoc,
					[SysUserUpdate]=@SysUserUpdate,
					[SysDateUpdate]=Getdate()
				Where	
					[IdPagina] = @IdPagina
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

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '03/12/2013 18:02:21', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPagine_KyUpd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'Dav', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPagine_KyUpd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'01.00.00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPagine_KyUpd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'Web pagine', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPagine_KyUpd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'NO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpWebPagine_KyUpd';


GO

