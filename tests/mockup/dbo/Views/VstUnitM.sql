-- ==========================================================================================
-- Entity Name:   VstUnitM
-- Author:        sim
-- Create date:   211115
-- Custom_Dbo:    NO
-- Standard_dbo:  YES
-- CustomNote:
-- Description:   Anagrafica Unità di Misura
-- History:
-- sim 211115 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstUnitM] AS
SELECT
	UnitM, DescUnitM, CodFnz, Disabilita, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion,
	Predefinita, UnitMFatel
FROM
	dbo.TbUnitM TbUnitM

GO

