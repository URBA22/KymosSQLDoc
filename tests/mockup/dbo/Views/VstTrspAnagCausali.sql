-- ==========================================================================================
-- Entity Name:	 VstTrspAnagCausali
-- Author:		 auto
-- Create date:	 221214
-- Custom_Dbo:	 NO
-- Standard_dbo: YES
-- CustomNote:
-- Description:
-- History:
-- dav 221214 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[VstTrspAnagCausali]
AS
	SELECT IdCausaleTrsp, DescCausaleTrsp, FlgAdeguamento, CodFnz, PrefDoc, Predefinita, NoteCausaleTrsp, IdCausaleFat, Disabilita, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion
	FROM TbTrspAnagCausali

GO

