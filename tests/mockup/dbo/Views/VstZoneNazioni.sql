-- ==========================================================================================
-- Entity Name:	 VstZoneNazioni
-- Author:		 auto
-- Create date:	 221127
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 221127 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstZoneNazioni]
AS
	SELECT IdNazione, IdZona, DescNazione, CodFnzGruppo, Disabilita, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion
	FROM TbZoneNazioni

GO

