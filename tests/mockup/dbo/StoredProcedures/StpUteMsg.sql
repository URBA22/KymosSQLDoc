-- ==========================================================================================
-- Entity Name:   StpUteMsg
-- @author:        Dav
-- Create date:   11/08/12
-- @custom:	  NO
-- @standard:  YES
-- CustomNote: Write custom note here
-- @summary:	Inserisce messaggi utente asincroni
-- @CodFnzTipoMsg puo valere
--		ALR allarme
--		INF information
--		WRN warning
--		LOG non visualizzato
-- History:
-- @version dav 141123 se <>INF mostra indipdendentemente dallo stato
-- @version dav 160217 @ERROR_MESSAGE() in dummy per evitare troncamenti a 4000 
-- @version dav 160817 Aggiunta spid, iddoc e idrow
-- @version dav 160812 Disattivazione traduzioni (traduce anche i parametri in molte chiamate)
-- @version dav 180522 abilitaizone messaggi di WRN
-- @version dav 210329 Gestione UteMsgWrnDisable
-- @version dav 211202 Aggiunto @ExecutionTime
-- @version dav 220226 Gestione isnull(@Stato,0) <> - 3 per comandi lunghi
-- @version dav 221112 @KYInfoEst as nvarchar(max) = NULL
-- @version marco 221227 Rinomina @SysUserUpdate -> @SysUser , @Stato -> KyStato
-- ==========================================================================================
CREATE Procedure [dbo].[StpUteMsg] 
	(
		@Msg as nvarchar(300),					-- Titolo messaggio
		@Msg1 as nvarchar(300),					-- Messaggio 
		@MsgObj as nvarchar(300),				-- Oggetto di riferimento (sezione in cui scatta il messaggio, esempio CLIORD)	
												-- Non visualzizzato ma memorizzato
		@Param  as nvarchar(300),				-- Parametro del messaggio ( esempio codice articolo, non tradotto)
		@CodFnzTipoMsg as nvarchar(5),			-- Tipo di mesaggio (QST , INF, WRN, ALR)
		@SysUser as nvarchar(256),		        -- Utente che richiede la funzione
		@KYStato as int,							-- Stato di entarta
		@KYRes as int,							-- Risposta al messaggio precedente
		@KYInfoEst as nvarchar(max) = NULL,		-- Informazioni estese
		@KyParam as nvarchar(max)=NULL,			-- Parametri per il messaggio di uscita
		@KyMsg as nvarchar(max) Output,			-- Messaggio di uscita composto
		
		@TipoDoc as nvarchar(256) = NULL,		-- Tabella coinvolta
		@IdDoc as nvarchar(50) = NULL,			-- Documento
		@IdDocDet as nvarchar(100)= NULL,		-- Riga
		@MsgLog as nvarchar(max) = Null,		-- Informazioni di log
		@ExecutionTime int = null				-- Tempo di esecuzione in ms
		
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @KYIcon as nvarchar(10) -- Icona (W Warning;S Ok;E Error;Q Question) 
	
	If @CodFnzTipoMsg='QST'  SET @KYIcon='Q' --Question
	If @CodFnzTipoMsg='INF'  SET @KYIcon='S' --Conferma
	If @CodFnzTipoMsg='WRN'  SET @KYIcon='W' --Warning
	If @CodFnzTipoMsg='ALR'  SET @KYIcon='E' --Alert
	
	-- Normalizza messaggio laterale
	If @CodFnzTipoMsg = 'QST'  Set @CodFnzTipoMsg = 'INF'
	
	set @KYInfoEst= isnull(@KYInfoEst,'')
	
	
	-- Se c'è un errore non passato in ingresso
	-- Carica dummy perchè ERROR_MESSAGE è varchar(4000)
	-- e nell'IF tronca @KYInfoEst

	Declare @Dummy as nvarchar(max)
	Set @Dummy = ERROR_MESSAGE()

	if @KYInfoEst<>isnull( @Dummy,@KYInfoEst) 
		BEGIN
			Set @Msg1='Errore Stp'
			If @KYInfoEst <> '' Set @KYInfoEst= @KYInfoEst + char(13) + char(10) 
			Set @KYInfoEst= @KYInfoEst + isnull( @Dummy,'')
		END
	
	--EXECUTE  StpLngTrad @Msg OUT, 'MSG',@SysUser, NULL
	--EXECUTE  StpLngTrad @Msg1 OUT,  'MSG',@SysUser, NULL
	
	
	declare @DataMsgAcq as datetime
	
	-- dav 220226 se stato = -5 e INF allora deve mostare il messaggio (uscita procedura lunga)
	If (@CodFnzTipoMsg = 'INF' and isnull(@KYStato,0) <> - 5)
		BEGIN
			SET @CodFnzTipoMsg = 'LOG'
			SET @DataMsgAcq= GETDATE()
		END
	
	-- dav 22.05.18 se wrn e stato non è nullo allora è un messaggio a fascia e non visualizza popup
	-- Se stato = -3 allora è in chiusura della maschera e mostra il popup (per messaggi stp di controllo)
	-- dav 220226 se stato = -5 e WRN allora deve mostare il messaggio (uscita procedura lunga)
	If  (@CodFnzTipoMsg = 'WRN' and @KYStato is not null	and @KYStato <> - 3  and @KYStato <> - 5)
		BEGIN
			SET @CodFnzTipoMsg = 'LOG'
			SET @DataMsgAcq= GETDATE()
		END

	If ISNULL(dbo.FncKeyValue('UteMsgWrnDisable', @SysUser ),'OFF')= 'ON' AND @CodFnzTipoMsg = 'WRN'
		BEGIN
			SET @DataMsgAcq= GETDATE()
		END
	
	-- Se operazione completata non mostra messaggio (apre la maschera)
	if @KYRes = -1 
		SET @KyMsg = Null
	else
		SET @KyMsg = dbo.FncKYMsg(@Msg1,@Param,@KYInfoEst,@KYIcon, @KyParam)
		
		
	INSERT INTO TbUteMsg
	(IdUtente, Messaggio, Messaggio1, DataMsg, SysDateCreate, SysUserCreate, CodFnzTipoMsg,DataMsgAcq, MsgObj, MsgParam, MsgInfoEstese, MsgStato, SPID, IdDoc, IdDocDet, MsgLog, TipoDoc, ExecutionTime)
	VALUES     (@SysUser,@Msg,@Msg1, GETDATE(), GETDATE(),@SysUser,@CodFnzTipoMsg, @DataMsgAcq, @MsgObj,@Param, @KYInfoEst, @KYStato, @@SPID, @IdDoc, @IdDocDet, @MsgLog, @TipoDoc, @ExecutionTime)
		
    
END

GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'Messaggi utente', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpUteMsg';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '12/10/2012 18:02:00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpUteMsg';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'Dav', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpUteMsg';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'NO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpUteMsg';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'01.00.00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpUteMsg';


GO

