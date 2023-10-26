-- ==========================================================================================
-- Entity Name:	 VstUtentiLogAccessi
-- Author:		 auto
-- Create date:	 221025
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 221025 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstUtentiLogAccessi]
AS
	SELECT IdAccesso, IdUtente, Fingerprint, Ip, Location, Browser, Os, TipoLog, DescLog, NoteLog, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion
	FROM TbUtentiLogAccessi

GO

