-- ==========================================================================================
-- Entity Name:	 VstUtentiCode
-- Author:		 auto
-- Create date:	 220312
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 220312 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstUtentiCode]
AS
	SELECT IdUtenteCoda, IdUtente, IdAttivitaCoda, FlgMaster, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion
	FROM TbUtentiCode

GO

