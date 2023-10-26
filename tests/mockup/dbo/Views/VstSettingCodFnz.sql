-- ==========================================================================================
-- Entity Name:	 VstSettingCodFnz
-- Author:		 auto
-- Create date:	 211223
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 211223 Creazione
-- dav 221212 Gestione CodFnzTipo
-- ==========================================================================================
CREATE VIEW [dbo].[VstSettingCodFnz]
AS
	SELECT NomeTabella, CodFnz, Tipo, DescCodFnz, Gruppo, Ordinamento, IdGuid, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion, WhereDefinition,
    CodFnzTipo
	FROM TbSettingCodFnz

GO

