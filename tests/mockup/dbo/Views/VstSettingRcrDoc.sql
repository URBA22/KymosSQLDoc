-- ==========================================================================================
-- Entity Name:	 VstSettingRcrDoc
-- Author:		 auto
-- Create date:	 230126
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 230126 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstSettingRcrDoc]
AS
	SELECT IdRcrDoc, CategoriaDoc, DescDoc, FrmDoc, Ordinamento, CodFnzKey, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion
	FROM TbSettingRcrDoc

GO

