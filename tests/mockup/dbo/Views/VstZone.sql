-- ==========================================================================================
-- Entity Name:	 VstZone
-- Author:		 auto
-- Create date:	 221127
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 221127 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstZone]
AS
	SELECT IdZona, DescZona, Disabilita, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion
	FROM TbZone

GO

