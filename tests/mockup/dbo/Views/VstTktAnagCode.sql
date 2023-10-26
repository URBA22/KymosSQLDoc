-- ==========================================================================================
-- Entity Name:	 VstTktAnagCode
-- Author:		 auto
-- Create date:	 230724
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 230724 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstTktAnagCode]
AS
	SELECT IdCodaTkt, DescCoda, Disabilita, Predefinita, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion
	FROM TbTktAnagCode

GO

