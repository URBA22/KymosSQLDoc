-- ==========================================================================================
-- Entity Name:	 VstUnitMAlias
-- Author:		 auto
-- Create date:	 221203
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 221203 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstUnitMAlias]
AS
	SELECT IdUnitMAlias, UnitM, UnitMAlias, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion
	FROM TbUnitMAlias

GO

