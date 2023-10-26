-- ==========================================================================================
-- Entity Name:	 VstSpedMezzo
-- Author:		 auto
-- Create date:	 221115
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- sim 221115 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstSpedMezzo]
AS
	SELECT IdTraspMezzo, DescTraspMezzo, Disabilita, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion, CodiceInt
	FROM TbSpedMezzo

GO

