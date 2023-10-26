
-- ==========================================================================================
-- Entity Name:   VstUteAtvtDbo
-- Author:        dav
-- Create date:   14/04/2020 10:35:11
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   
-- History:
-- fab 200428 Messo ISNULL(...,'') AS IdUtente perché rappresenta chiave e non può essere NULL
-- ==========================================================================================
CREATE VIEW [dbo].[VstUteAtvtDbo]
AS

SELECT ISNULL(IdUtente,'') AS IdUtente, SysDateCreate AS DataAtvt, 'MSG' AS Tipo, IsNull(MsgObj,'') +  ' ' + IsNull(MsgParam,'') AS DescTipo
FROM  dbo.TbUteMsg

UNION ALL

SELECT ISNULL(UserName,'') as IdUtente, SysDateCreate AS DataAtvt, 'LOG' AS Tipo, IsNull(TipoLog,'') + ' ' +  IsNull(DescLog,'') AS DescTipo
FROM  dbo.TbLog

UNION ALL

SELECT  ISNULL(SysUserCreate,'') as IdUtente, SysDateCreate AS DataAtvt, 'CLIOFF' AS Tipo, IsNull(IdCliOff,'') + ' ' +  IsNull(convert(nvarchar(20),NRiga),'') AS DescTipo
FROM  dbo.TbCliOffDet

UNION ALL

SELECT  ISNULL(SysUserCreate,'') as IdUtente, SysDateCreate AS DataAtvt, 'CLIORD' AS Tipo, IsNull(IdCliOrd,'') + ' ' +  IsNull(convert(nvarchar(20),NRiga),'') AS DescTipo
FROM  dbo.TbCliOrdDet

UNION ALL

SELECT  ISNULL(SysUserCreate,'') as IdUtente, SysDateCreate AS DataAtvt, 'CLIDDT' AS Tipo, IsNull(IdCliDdt,'') + ' ' +  IsNull(convert(nvarchar(20),NRiga),'') AS DescTipo
FROM  dbo.TbCliDdtDet

UNION ALL

SELECT  ISNULL(SysUserCreate,'') as IdUtente, SysDateCreate AS DataAtvt, 'CLIFAT' AS Tipo, IsNull(IdCliFat,'') + ' ' +  IsNull(convert(nvarchar(20),NRiga),'') AS DescTipo
FROM  dbo.TbCliFatDet

UNION ALL

SELECT  ISNULL(SysUserCreate,'') as IdUtente, SysDateCreate AS DataAtvt, 'CLIRCVDDT' AS Tipo, IsNull(IdCliRcvDdt,'') + ' ' +  IsNull(convert(nvarchar(20),NRiga),'') AS DescTipo
FROM  dbo.TbCliRcvDdtDet

UNION ALL

SELECT  ISNULL(SysUserCreate,'') as IdUtente, SysDateCreate AS DataAtvt, 'FOROFF' AS Tipo, IsNull(IdForOff,'') + ' ' +  IsNull(convert(nvarchar(20),NRiga),'') AS DescTipo
FROM  dbo.TbForOffDet

UNION ALL

SELECT  ISNULL(SysUserCreate,'') as IdUtente, SysDateCreate AS DataAtvt, 'FORORD' AS Tipo, IsNull(IdForOrd,'') + ' ' +  IsNull(convert(nvarchar(20),NRiga),'') AS DescTipo
FROM  dbo.TbForOrdDet

UNION ALL

SELECT  ISNULL(SysUserCreate,'') as IdUtente, SysDateCreate AS DataAtvt, 'FORDDT' AS Tipo, IsNull(IdForDdt,'') + ' ' +  IsNull(convert(nvarchar(20),NRiga),'') AS DescTipo
FROM  dbo.TbForDdtDet

UNION ALL

SELECT  ISNULL(SysUserCreate,'') as IdUtente, SysDateCreate AS DataAtvt, 'FORFAT' AS Tipo, IsNull(IdForFat,'') + ' ' +  IsNull(convert(nvarchar(20),NRiga),'') AS DescTipo
FROM  dbo.TbForFatDet

UNION ALL

SELECT  ISNULL(SysUserCreate,'') as IdUtente, SysDateCreate AS DataAtvt, 'FORRCVDDT' AS Tipo, IsNull(IdForRcvDdt,'') + ' ' +  IsNull(convert(nvarchar(20),NRiga),'') AS DescTipo
FROM  dbo.TbForRcvDdtDet

UNION ALL

SELECT  ISNULL(SysUserCreate,'') as IdUtente, SysDateCreate AS DataAtvt, 'ARTICOLO' AS Tipo, IsNull(IdArticolo,'') AS DescTipo
FROM  dbo.TbArticoli

UNION ALL

SELECT  ISNULL(TbArtDistDet.SysUserCreate,'') as IdUtente, TbArtDistDet.SysDateCreate AS DataAtvt, 'ARTDIST' AS Tipo,  IsNull(IdArticolo,'') + ' ' + IsNull(convert(nvarchar(20),DistVer),'') + ' ' +  IsNull(convert(nvarchar(20),NRiga),'') AS DescTipo
FROM  dbo.TbArtDistDet Inner Join dbo.TbArtDist ON TbArtDist.IdArtDist = TbArtDistDet.IdArtDist

UNION ALL

SELECT  ISNULL(TbArtCicliFasi.SysUserCreate,'') as IdUtente, TbArtCicliFasi.SysDateCreate AS DataAtvt, 'ARTDCICLO' AS Tipo, IsNull(IdArticolo,'') + ' ' + IsNull(convert(nvarchar(20),CicloVer),'') + ' ' + IsNull(convert(nvarchar(20),NFase),'')  AS DescTipo
FROM  dbo.TbArtCicliFasi Inner Join dbo.TbArtCicli ON TbArtCicli.IdArtCiclo = TbArtCicliFasi.IdArtCiclo

UNION ALL

SELECT  ISNULL(SysUserCreate,'') as IdUtente, SysDateCreate AS DataAtvt, 'ODL' AS Tipo, IsNull(IdOdl,'') + ' ' + IsNull(convert(nvarchar(20),NRiga),'')  AS DescTipo
FROM  dbo.TbOdlDet

GO

