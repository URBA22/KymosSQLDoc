-- ==========================================================================================
-- Entity Name:	 VstUtentiPNSubscriptions
-- Author:		 auto
-- Create date:	 230406
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 230406 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstUtentiPNSubscriptions]
AS
	SELECT PNEndpoint, PNAuth, PN256Dh, IdUtente, SysDateCreate, Id
	FROM TbUtentiPNSubscriptions

GO

