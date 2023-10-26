-- ==========================================================================================
-- Entity Name:	 VstSpedImballi
-- Author:		 auto
-- Create date:	 221115
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- sim 221115 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstSpedImballi]
AS
	SELECT IdImballo, DescImballo, Disabilita, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion
	FROM TbSpedImballi

GO

