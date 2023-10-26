
-- ==========================================================================================
-- Entity Name:   StpUteMsg_Ins
-- Author:        Dav
-- Create date:   27/12/2012 18:50:40
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   Inserisce un messaggio utente  
--				  Esempio
--				  Execute StpUteMsg_Ins  'Ricodifica Offerta Cliente','Codice esistente',@IdDocNew,'ALR',@SysUserUpdate
-- History:
-- dav 17.08.16 Aggiunta spid, iddoc e idrow
-- dav 12.08.16 Disattivazione traduzioni (traduce anche i parametri in molte chiamate)
-- dav 15.06.19 Aggiunta gestione Log
-- dav 201205 Aggiunto esempio
-- dav 210329 Gestione UteMsgWrnDisable
-- dav 230105 @SysUserUpdate -> @SysUser
-- ==========================================================================================
CREATE PROCEDURE [dbo].[StpUteMsg_Ins] (
	@Msg AS NVARCHAR(300), -- Titolo messaggio
	@Msg1 AS NVARCHAR(300), -- Messaggio 
	@Param AS NVARCHAR(300), -- Parametro (non tradotto)
	@CodFnzTipoMsg AS NVARCHAR(5), -- Tipo di mesaggio a lato
	@SysUser AS NVARCHAR(256), -- Utente che richiede la funzione
	@MsgObj AS NVARCHAR(300) = NULL, -- Parametro esteso -- Oggetto di riferimento (sezione in cui scatta il messaggio, esempio CLIORD)	
	@KYInfoEst AS NVARCHAR(max) = NULL, -- Parametro esteso -- Informazioni estese
	@TipoDoc AS NVARCHAR(256) = NULL, -- Parametro esteso -- Tabella coinvolta
	@IdDoc AS NVARCHAR(50) = NULL, -- Parametro esteso -- Documento
	@IdDocDet AS NVARCHAR(100) = NULL, -- Parametro esteso -- Riga (chiave)
	@MsgLog AS NVARCHAR(max) = NULL -- Parametro esteso -- Informazioni di log
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--@CodFnzTipoMsg puo valere
	-- ALR allarme
	-- INF information
	-- WRN warning
	-- LOG non visualizzato
	--EXECUTE  StpLngTrad @Msg OUT, 'MSG',@SysUser, NULL
	--EXECUTE  StpLngTrad @Msg1 OUT,  'MSG',@SysUser, NULL
	DECLARE @DataMsgAcq AS DATETIME

	IF (@CodFnzTipoMsg = 'LOG')
	BEGIN
		SET @DataMsgAcq = GETDATE()
	END

	IF ISNULL(dbo.FncKeyValue('UteMsgWrnDisable', @SysUser), 'OFF') = 'ON'
		AND @CodFnzTipoMsg = 'WRN'
	BEGIN
		SET @DataMsgAcq = GETDATE()
	END

	SET @Msg = @Msg + ' ' + IsNull(@Param, '')

	INSERT INTO TbUteMsg (
		IdUtente,
		Messaggio,
		Messaggio1,
		DataMsg,
		SysDateCreate,
		SysUserCreate,
		CodFnzTipoMsg,
		MsgObj,
		SPID,
		IdDoc,
		IdDocDet,
		MsgParam,
		MsgInfoEstese,
		MsgLog,
		TipoDoc,
		DataMsgAcq
		)
	VALUES (
		@SysUser,
		@Msg,
		@Msg1,
		GETDATE(),
		GETDATE(),
		@SysUser,
		@CodFnzTipoMsg,
		@MsgObj,
		@@SPID,
		@IdDoc,
		@IdDocDet,
		@Param,
		@KYInfoEst,
		@MsgLog,
		@TipoDoc,
		@DataMsgAcq
		)
END

GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpUteMsg_Ins';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpUteMsg_Ins';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpUteMsg_Ins';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '12/24/2012 23:10:31', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpUteMsg_Ins';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpUteMsg_Ins';


GO

