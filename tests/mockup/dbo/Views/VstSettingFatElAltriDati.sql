-- ==========================================================================================
-- Entity Name:	 VstSettingFatElAltriDati
-- Author:		 auto
-- Create date:	 221212
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 221212 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstSettingFatElAltriDati]
AS
	SELECT IdSettingFatEl, TipoDato, RiferimentoTesto, RiferimentoNumero, RiferimentoData, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion
	FROM TbSettingFatElAltriDati

GO

