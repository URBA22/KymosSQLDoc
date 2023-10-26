
-- ==========================================================================================
-- Entity Name:	 VstUtentiAnagMansioni
-- Author:		 auto
-- Create date:	 211219
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 211219 Creazione
-- dav 220426 Aggiunto costoora e prezzoora
-- ==========================================================================================
CREATE VIEW [dbo].[VstUtentiAnagMansioni]
AS
	SELECT IdMansione, DescMansione, Disabilita, NoteMansioni, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion, 
	CostoOra, PrezzoOra
	FROM  TbUtentiAnagMansioni

GO

