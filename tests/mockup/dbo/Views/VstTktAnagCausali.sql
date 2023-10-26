-- ==========================================================================================
-- Entity Name:	 VstTktAnagCausali
-- Author:		 auto
-- Create date:	 230724
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 230724 Creazione
-- FRA 230803 Aggiunta PrefDoc
-- ==========================================================================================
CREATE VIEW [dbo].[VstTktAnagCausali]
AS
	SELECT 
        IdCausaleTkt, 
        DescCausaleTkt, 
        Disabilita, 
        Predefinita, 
        SysDateCreate, 
        SysUserCreate, 
        SysDateUpdate, 
        SysUserUpdate, 
        SysRowVersion,
        PrefDoc
	FROM TbTktAnagCausali

GO

