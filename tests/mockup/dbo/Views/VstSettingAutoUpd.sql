-- ==========================================================================================
-- Entity Name:	 VstSettingAutoUpd
-- Author:		 auto
-- Create date:	 221123
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- fab 221123 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstSettingAutoUpd]
AS
	SELECT IdAutoUpd, Tabella, Campo, StoreProcedure, CodFncAct, EntityRefresh, IdGuid, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion
	FROM TbSettingAutoUpd

GO

