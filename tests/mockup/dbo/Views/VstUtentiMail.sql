-- ==========================================================================================
-- Entity Name:	 VstUtentiMail
-- Author:		 auto
-- Create date:	 230417
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 230417 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstUtentiMail]
AS
	SELECT IdUtenteMail, IdUtente, EMail, FlgMailIn, Predefinita, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion
	FROM TbUtentiMail

GO

