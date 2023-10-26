-- ==========================================================================================
-- Entity Name:	 VstUnitMConv
-- Author:		 auto
-- Create date:	 221127
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 221127 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstUnitMConv]
AS
	SELECT UnitMP, UnitMD, CoeffConv, Note, CodFnz, Disabilita, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion
	FROM TbUnitMConv

GO

