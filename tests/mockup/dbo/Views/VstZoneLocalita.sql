
-- ==========================================================================================
-- Entity Name:	 VstZoneLocalita
-- Author:		 auto
-- Create date:	 221127
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 221127 Creazione
-- dav 230320 Aggiunto IdPaese
-- fab 230323 Aggiunto DescZona
-- ==========================================================================================
CREATE VIEW [dbo].[VstZoneLocalita]
AS
SELECT 
    TbZoneLocalita.IdZonaLocalita,
	TbZoneLocalita.IdZona,
	TbZoneLocalita.IdProvincia,
	TbZoneLocalita.Citta,
	TbZoneLocalita.Localita,
	TbZoneLocalita.Cap,
	TbZoneLocalita.Disabilita,
	TbZoneLocalita.SysDateCreate,
	TbZoneLocalita.SysUserCreate,
	TbZoneLocalita.SysDateUpdate,
	TbZoneLocalita.SysUserUpdate,
	TbZoneLocalita.SysRowVersion,
	TbZoneLocalita.FlgFuoriZona,
	TbZoneLocalita.FlgFuoriZonaExtra,
	TbZoneLocalita.FlgListinoCtrl,
    TbZoneLocalita.IdPaese,
    TbZone.DescZona
FROM TbZoneLocalita LEFT OUTER JOIN TbZone ON TbZoneLocalita.IdZona = TbZone.IdZona

GO

