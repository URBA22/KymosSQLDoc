

-- ==========================================================================================
-- Entity Name:   VstMatricoleStato
-- Author:        vale
-- Create date:   
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   
-- History:
-- vale  230118 Creazione
-- ==========================================================================================
CREATE VIEW [dbo].[zzz_VstMatricoleStato]
AS

SELECT IdMatricola
    , IdArticolo
    , IdMatrTipo
    , IdMatrConformita
    , MatricolaCli
    , NoteMatricola
    , Tensione
    , Frequenza
    , Velocita
    , Fasi
    , Potenza
    , Phase
    , Ampere
    , DescTipo
    , IdCliente
    , RagSoc
    , Sem1
    , Sem2
    , Sem3
    , Sem4
    , DescConformita
    , Ord
    , DataMatricola
    , DescCompleta
    , Modello
    , MatricolaStr
    , DataInizioGaranzia
    , DataFineGaranzia
    , IdFornitore
    , MatricolaFor
    , Matricola
    , IdLotto
    , RagSocFor
    , IdClienteFinale
    , RagSocFinale
    , CodFnzStato
    , CodFnzControllo
    , DataControllo
    , IdUtenteControllo
    , NoteControllo
    , DataProd
    , UnitMPeso
    , DimPeso
    , IdUtenteProd
    , NotePord
    , QtaDaProd
    , QtaProd
    , QtaControllo
    , UnitM
    , NMatricola
    , CmpOpz01
    , CmpOpz02
    , CmpOpz03
    , CmpOpz04
    , CmpOpz05
    , Qta
    , DimPesoTara
    , DimPesoLordo
    , FlgPrenotata
    , IdMatrStato
    , QtaAbbuono
    , TipoDoc
    , IdDoc
    , DataMov
    , NoteMov
    , QtaFase
    , IdMagePosiz
    , MagePosiz
    , IdMage
    , DescMage
    , IdArtVrt
    , DescVrt
    , IdColore
    , CodVrt
    , MatricolaElab
FROM VstMatricole
WHERE (FlgDisponibile = 1)
    AND (Qta > 0)

UNION

SELECT VstMatricole.IdMatricola
    , VstMatricole.IdArticolo
    , VstMatricole.IdMatrTipo
    , VstMatricole.IdMatrConformita
    , VstMatricole.MatricolaCli
    , VstMatricole.NoteMatricola
    , VstMatricole.Tensione
    , VstMatricole.Frequenza
    , VstMatricole.Velocita
    , VstMatricole.Fasi
    , VstMatricole.Potenza
    , VstMatricole.Phase
    , VstMatricole.Ampere
    , VstMatricole.DescTipo
    , VstMatricole.IdCliente
    , VstMatricole.RagSoc
    , VstMatricole.Sem1
    , VstMatricole.Sem2
    , VstMatricole.Sem3
    , VstMatricole.Sem4
    , VstMatricole.DescConformita
    , VstMatricole.Ord
    , VstMatricole.DataMatricola
    , VstMatricole.DescCompleta
    , VstMatricole.Modello
    , VstMatricole.MatricolaStr
    , VstMatricole.DataInizioGaranzia
    , VstMatricole.DataFineGaranzia
    , VstMatricole.IdFornitore
    , VstMatricole.MatricolaFor
    , VstMatricole.Matricola
    , VstMatricole.IdLotto
    , VstMatricole.RagSocFor
    , VstMatricole.IdClienteFinale
    , VstMatricole.RagSocFinale
    , VstMatricole.CodFnzStato
    , VstMatricole.CodFnzControllo
    , VstMatricole.DataControllo
    , VstMatricole.IdUtenteControllo
    , VstMatricole.NoteControllo
    , VstMatricole.DataProd
    , VstMatricole.UnitMPeso
    , VstMatricole.DimPeso
    , VstMatricole.IdUtenteProd
    , VstMatricole.NotePord
    , VstMatricole.QtaDaProd
    , VstMatricole.QtaProd
    , VstMatricole.QtaControllo
    , VstMatricole.UnitM
    , VstMatricole.NMatricola
    , VstMatricole.CmpOpz01
    , VstMatricole.CmpOpz02
    , VstMatricole.CmpOpz03
    , VstMatricole.CmpOpz04
    , VstMatricole.CmpOpz05
    , VstMatricole.Qta
    , VstMatricole.DimPesoTara
    , VstMatricole.DimPesoLordo
    , VstMatricole.FlgPrenotata
    , COALESCE(drvStatoMatr.IdMatrStato, VstMatricole.IdMatrStato) AS IdMatrStato
    , VstMatricole.QtaAbbuono
    , VstMatricole.TipoDoc
    , VstMatricole.IdDoc
    , VstMatricole.DataMov
    , VstMatricole.NoteMov
    , VstMatricole.QtaFase
    , VstMatricole.IdMagePosiz
    , VstMatricole.MagePosiz
    , VstMatricole.IdMage
    , VstMatricole.DescMage
    , VstMatricole.IdArtVrt
    , VstMatricole.DescVrt
    , VstMatricole.IdColore
    , VstMatricole.CodVrt
    , VstMatricole.MatricolaElab
FROM VstMatricole
INNER JOIN (
    SELECT TbCliPrpListDetVrt.IdCliPrpListDet
        , TbCliPrpListDetVrt.IdMatricola
    FROM TbCliPrpListDetVrt
    LEFT OUTER JOIN (
        SELECT IdCliPrpListDet
        FROM TbCliDdtDet
        GROUP BY IdCliPrpListDet
        ) AS drvCliDdtDet
        ON TbCliPrpListDetVrt.IdCliPrpListDet = drvCliDdtDet.IdCliPrpListDet
    WHERE (drvCliDdtDet.IdCliPrpListDet IS NULL)
    ) AS DrvPrpTgl
    ON VstMatricole.IdMatricola = DrvPrpTgl.IdMatricola
INNER JOIN (
    SELECT drvMatrStato.IdMatricola
        , drvMatrStato.IdMatrMovMax
        , TbMatrStato_1.IdMatrStato
    FROM (
        SELECT IdMatricola
            , MAX(IdMatrMov) AS IdMatrMovMax
        FROM TbMatrStato
        GROUP BY IdMatricola
        ) AS drvMatrStato
    INNER JOIN TbMatrStato AS TbMatrStato_1
        ON drvMatrStato.IdMatricola = TbMatrStato_1.IdMatricola
            AND drvMatrStato.IdMatrMovMax = TbMatrStato_1.IdMatrMov
    ) AS drvStatoMatr
    ON VstMatricole.IdMatricola = drvStatoMatr.IdMatricola

GO

