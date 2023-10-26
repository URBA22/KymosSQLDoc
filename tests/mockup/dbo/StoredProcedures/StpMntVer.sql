
-- ==========================================================================================
-- Entity Name:	StpMntVer
-- Author:	Dav
-- Create date:	18.02.16
-- AutoCreate:	NO
-- Custom:	NO
-- Generator:	01.00.00
-- CustomNote:	Write custom note here
-- Description:	Versione del db
-- ==========================================================================================

CREATE Procedure [dbo].[StpMntVer]
(
	@SysUser nvarchar(256),
	@KYStato int = NULL output,
	@KYMsg nvarchar(max) = NULL output,
	@KYRes int = NULL
)

AS
BEGIN

	/*
	return -1: Normal; return -2: Refresh data; return -3: Chiude la maschera;	
	Tipo Messaggio: INF Informativo, ALR Allert, WRN Warning, QST Question	
	*/


	Declare @Ver as nvarchar (50)
	Declare @DecsVerVer as nvarchar (Max)

	Set @Ver  = '16.02.21.0'
	Set @DecsVerVer = 'Controllo sequenza nei documenti'
	
	/*
		16.02.21.0 Controllo sequenza nei documenti
		16.02.19.1 Correzzione generazione ord e off for da rda unitmvlt
		16.02.19.0 Gesione dichiarazione di intento, correzione calcolo bollo
		16.02.18.0 Gesione dichiarazione di intento
		16.02.17.0 Gesione dichiarazione di intento
	*/
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @Msg nvarchar(300)
	Declare @Msg1 nvarchar(300)
	Declare @MsgObj nvarchar(300)
	Declare @MsgExt nvarchar(300)


	SET @Msg= 'Versione DB'
	SET @MsgObj='Versione'

	Declare @Version as nvarchar(20)

	Declare @PrInfo  nvarchar(300)
	Set @PrInfo  = ''
	
	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato,999) = 0
	BEGIN
		SET @KYStato = 1
		
		SET @Msg1= 'Versione db:' + @Ver
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'QST',@SysUser,
				@KYStato,@KYRes,'', '(1):OK;0:Cancel',@KYMsg out
		
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
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'WRN',@SysUser,
				@KYStato,@KYRes,'',null,@KYMsg out
		SET @KYStato = -4
		RETURN
	END
	
END

GO

