
-- ==========================================================================================
-- Entity Name:   StpUteMsg_KyUpd
-- Author:        dav
-- Create date:   27/12/2012 18:50:40
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   Aggiorna lo stato dle messaggio, lanciato da x su popup 
-- History:
-- dav 190916 Aggiunta descrizione
-- ==========================================================================================
 
CREATE Procedure [dbo].[StpUteMsg_KyUpd] 
	(
		@SysUserUpdate as nvarchar(255),
		@IdMsg int
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if @IdMsg is null
		BEGIN
			-- Se non è definito il singolo oggetto acquisisci tutti gli aperti
			UPDATE    TbUteMsg
			SET              SysUserUpdate = @SysUserUpdate, SysDateUpdate = GETDATE(), DataMsgAcq = GETDATE()
			WHERE     (IdUtente = @SysUserUpdate) AND (DataMsgAcq IS NULL)
		END
	else
		BEGIN
			-- Se è definito il singolo oggetto acquisisci il singolo
			UPDATE    TbUteMsg
			SET              SysUserUpdate = @SysUserUpdate, SysDateUpdate = GETDATE(), DataMsgAcq = GETDATE()
			WHERE     (IdMsg = @IdMsg)
		END
    
END

GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'Dav', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpUteMsg_KyUpd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'NO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpUteMsg_KyUpd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'01.00.00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpUteMsg_KyUpd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'Messaggi utente', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpUteMsg_KyUpd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '12/12/2012 00:00:00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpUteMsg_KyUpd';


GO

