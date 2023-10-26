-- ==========================================================================================
-- Entity Name:	 VstSettingDocGenCausali
-- Author:		 auto
-- Create date:	 220725
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 220725 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstSettingDocGenCausali]
AS
	SELECT IdDocCausale, TipoDocMaster, IdCausaleDocMaster, TipoDocSlave, IdCausaleDocSlave, Predefinita, NoteDocCausale, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion, FatElTipoDoc
	FROM TbSettingDocGenCausali

GO

