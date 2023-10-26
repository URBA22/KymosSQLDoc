-- ==========================================================================================
-- Entity Name:	 VstTktAnagStati
-- Author:		 auto
-- Create date:	 230724
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 230724 Creazione
-- FRA 230803 Aggiunta gestione FlgChiuso
-- ==========================================================================================
CREATE VIEW [dbo].[VstTktAnagStati]
AS
	SELECT 
        TbTktAnagStati.IdStatoTkt, 
        TbTktAnagStati.DescStato, 
        TbTktAnagStati.Disabilita, 
        TbTktAnagStati.Predefinito, 
        TbTktAnagStati.SysDateCreate, 
        TbTktAnagStati.SysUserCreate, 
        TbTktAnagStati.SysDateUpdate, 
        TbTktAnagStati.SysUserUpdate, 
        TbTktAnagStati.SysRowVersion,
        TbTktAnagStati.FlgChiuso
	FROM TbTktAnagStati

GO

