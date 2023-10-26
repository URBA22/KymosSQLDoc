-- ==========================================================================================
-- Entity Name:	 VstSpedPorto
-- Author:		 auto
-- Create date:	 221115
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- sim 221115 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstSpedPorto]
AS
	SELECT IdPorto, DescPorto, Disabilita, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion, CodiceInt, CodiceIntGruppo, FlgSpeseTrasp
	FROM TbSpedPorto

GO

