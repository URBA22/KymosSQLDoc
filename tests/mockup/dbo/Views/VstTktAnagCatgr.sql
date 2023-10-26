-- ==========================================================================================
-- Entity Name:	 VstTktAnagCatgr
-- Author:		 auto
-- Create date:	 230808
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 230808 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstTktAnagCatgr]
AS
	SELECT IdCategoriaTkt, DescCategoria, Disabilita, Predefinito, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion
	FROM TbTktAnagCatgr

GO

