-- ==========================================================================================
-- Entity Name:	 VstZoneProvincie
-- Author:		 auto
-- Create date:	 221127
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 221127 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstZoneProvincie]
AS
	SELECT IdProvincia, IdZona, IdNazione, DescProvincia, CodFnzGruppo, Disabilita, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion, Regione
	FROM TbZoneProvincie

GO

