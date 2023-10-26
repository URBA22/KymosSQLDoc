-- ==========================================================================================
-- Entity Name:	 VstSpedAspetto
-- Author:		 auto
-- Create date:	 221122
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 221122 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstSpedAspetto]
AS
	SELECT IdAspetto, DescAspetto, Disabilita, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion
	FROM TbSpedAspetto

GO

