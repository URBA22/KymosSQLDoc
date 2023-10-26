
-- ==========================================================================================
-- Entity Name:    VstSettingModuli
-- Author:         dav
-- Create date:    220818
-- Custom_Dbo:     NO
-- Standard_dbo:   YES
-- CustomNote:     
-- Description:    
-- History:
-- dav 220818 Creazione
-- dav 230130 FlgSelezione
-- dav 230208 FlgSelezione1, Disabilita
-- ==========================================================================================


CREATE VIEW [dbo].[VstSettingModuli]
AS
SELECT IdModulo,
	GrpModulo,
	DescModulo,
	NoteModulo,
	GGSetup,
	Importo,
    ROUND(CONVERT(MONEY,Importo * (15./100. + 1./5.)),2) as ImportoAnno,
    ROUND(CONVERT(MONEY,Importo * (15./100. + 1./5.) / 12.),2)  as ImportoMese,
	CodFnzTipoLicenza,
	NumLicenze,
    DataAttivazione,
    FlgSelezione,
    FlgSelezione1,
    Disabilita,
    NoteInterne,
	SysDateCreate,
	SysUserCreate,
	SysDateUpdate,
	SysUserUpdate,
	SysRowVersion
FROM TbSettingModuli

GO

