-- ==========================================================================================
-- Entity Name:	 VstSettingKeyUte
-- Author:		 auto
-- Create date:	 211205
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 211205 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstSettingKeyUte]
AS
	SELECT IdKey, IdUtente, Value, NoteSetting, CodFnz, IdGuid, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion
	FROM TbSettingKeyUte

GO

