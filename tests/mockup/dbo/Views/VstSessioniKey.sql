-- ==========================================================================================
-- Entity Name:	 VstSessioniKey
-- Author:		 auto
-- Create date:	 220222
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 220222 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstSessioniKey]
AS
	SELECT IdUteRptFilter, IdSUID, IdSessione, IdUtente, TipoDoc, IdDoc, IdKey, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion
	FROM TbSessioniKey

GO

