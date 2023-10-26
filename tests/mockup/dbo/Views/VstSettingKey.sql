-- ==========================================================================================
-- Entity Name:	 VstSettingKey
-- Author:		 auto
-- Create date:	 211205
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 211205 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstSettingKey]
AS
	SELECT IdKey, Value, CodFnz, NoteSetting, IdGuid, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion, CodFnzTipo, DescSetting
	FROM TbSettingKey

GO

