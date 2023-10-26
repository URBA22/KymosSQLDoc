
-- ==========================================================================================
-- Entity Name:	 VstUtentiLogDisps
-- Author:		 auto
-- Create date:	 221025
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 221025 Creazione
-- matteo 230113 ritorno tutti i campi
-- ==========================================================================================
CREATE VIEW [dbo].[VstUtentiLogDisps]  
AS
	SELECT IdUteDsps, IdUtente, Fingerprint, Ip, Location, Browser, Os, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion, PNEndpoint, PNAuth, PN256Dh
    FROM  TbUtentiLogDisps

GO

