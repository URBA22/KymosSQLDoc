



-- ==========================================================================================
-- Entity Name:   VstVettoriCosti
-- Author:        Dav
-- Create date:   03/01/2013 14:12:17
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:	Write custom note here
-- Description:	
-- History:
-- dav 160830 Aggiunto GenDocTipo
-- dav 161014 Aggiunto campi
-- vale 161117 Costi vettori solo se le fatture di vendita sono immediate
-- sim 220728 Aggiunto Sem1 Aperti o chiusi, FrmOpen
-- dav 220809 Aggiunto Valori di dettaglio
-- dav 220912 Modifica Key di riga per non avere doppioni con testate
-- sim 221007 Aggiunto FORRCVDDTR
-- ==========================================================================================
CREATE VIEW [dbo].[VstVettoriCosti]
AS

    ------------------------------
    -- Valori di testa
    ------------------------------

    SELECT
            'CLIDDT' + '#' +  TbCliDdt.IdCliDdt AS IdKey,
            TbCliDdt.IdCliDdt AS IdDoc,
            'CLIDDT' AS TipoDoc,
            TbCliDdt.DataCliDdt AS DataDoc, 
            TbCliDdt.IdVettore, 
            TbFornitori.RagSoc AS RagSocVettore, 
            TbCliDdt.CostoTrasp, 
            TbForFatDet.IdForFat, 
            CONVERT(smallint, IIF(TbForFatDet.IdForFat IS NULL, 1, 4)) AS Sem1, 
            CONVERT(smallint,0) AS Sem2, 
            CONVERT(smallint,0) AS Sem3, 
            CONVERT(smallint,0) AS Sem4, 
            CONVERT(nvarchar(max), NULL) AS Ord, 
            'TbCliDdt' as GenDocTipo, 
            IdCliDdt as RifDoc, 
            drvRagSoc.RagSoc,
            CONVERT(NVARCHAR(300), CONCAT('Kymos.Clienti.FrmCliDdtScheda("', TbCliDdt.IdCliDdt, '")')) AS FrmOpen
        FROM 
            TbCliDdt INNER JOIN
            TbFornitori ON TbCliDdt.IdVettore = TbFornitori.IdFornitore LEFT OUTER JOIN
            TbForFatDet ON TbCliDdt.IdCliDdt = TbForFatDet.GenIdDoc AND TbForFatDet.GenDocTipo = 'TbCliDdt' LEFT OUTER JOIN
            TbClienti drvRagSoc ON  TbCliDdt.IdCliente = drvRagSoc.IdCliente
        WHERE        
            (TbCliDdt.IdVettore IS NOT NULL) AND 
            (ISNULL(TbCliDdt.CostoTrasp, 0) <> 0)

    UNION ALL

        SELECT 
            'CLIFAT' + '#' + TbCliFat.IdCliFat AS IdKey, 
            TbCliFat.IdCliFat AS IdDoc, 
            'CLIFAT' AS TipoDoc, 
            TbCliFat.DataCliFat AS DataDoc, 
            TbCliFat.IdVettore, 
            TbFornitori.RagSoc AS RagSocVettore, 
            TbCliFat.CostoTrasp,
            TbForFatDet.IdForFat, CONVERT(smallint, 0) AS Sem1, 
            CONVERT(smallint, 0) AS Sem2, 
            CONVERT(smallint, 0) AS Sem3, 
            CONVERT(smallint, 0) AS Sem4, 
            CONVERT(nvarchar(MAX), NULL) AS Ord,
            'TbCliFat' AS GenDocTipo, 
            TbCliFat.IdCliFat AS RifDoc, 
            drvRagSoc.RagSoc, 
            CONCAT('Kymos.Clienti.FrmCliFatScheda("', TbCliFat.IdCliFat, '")') AS FrmOpen
        FROM 
            TbCliFat INNER JOIN
            TbFornitori ON TbCliFat.IdVettore = TbFornitori.IdFornitore LEFT OUTER JOIN
            TbCliAnagFatCausali ON TbCliFat.IdCausaleFat = TbCliAnagFatCausali.IdCausaleFat LEFT OUTER JOIN
            TbForFatDet ON TbCliFat.IdCliFat = TbForFatDet.GenIdDoc AND TbForFatDet.GenDocTipo = 'TbCliFat' LEFT OUTER JOIN
            TbClienti AS drvRagSoc ON TbCliFat.IdCliente = drvRagSoc.IdCliente
        WHERE        
            (TbCliFat.IdVettore IS NOT NULL) AND 
            (ISNULL(TbCliFat.CostoTrasp, 0) <> 0) AND 
            (TbCliAnagFatCausali.FlgFatImmediata = 1)

    UNION ALL

        SELECT 
            'FORDDT' + '#' + TbForDdt.IdForDdt AS IdKey, 
            TbForDdt.IdForDdt AS IdDoc, 
            'FORDDT' AS TipoDoc, 
            TbForDdt.DataForDdt AS DataDoc, 
            TbForDdt.IdVettore, 
            TbFornitori.RagSoc AS RagSocVettore, 
            TbForDdt.CostoTrasp, 
            TbForFatDet.IdForFat, 
            CONVERT(smallint, IIF(TbForFatDet.IdForFat IS NULL, 1, 4)) AS Sem1, 
            CONVERT(smallint,0) AS Sem2, 
            CONVERT(smallint,0) AS Sem3, 
            CONVERT(smallint,0) AS Sem4, 
            CONVERT(nvarchar(max), NULL) AS Ord, 
            'TbForDdt' as GenDocTipo, 
            IdForDdt as RifDoc, 
            drvRagSoc.RagSoc,
            CONCAT('Kymos.Fornitori.FrmForDdtScheda("', TbForDdt.IdForDdt, '")') AS FrmOpen
        FROM 
            TbForDdt INNER JOIN
            TbFornitori ON TbForDdt.IdVettore = TbFornitori.IdFornitore LEFT OUTER JOIN
            TbForFatDet ON TbForDdt.IdForDdt = TbForFatDet.GenIdDoc AND TbForFatDet.GenDocTipo = 'TbForDdt' LEFT OUTER JOIN
            TbFornitori drvRagSoc ON  TbForDdt.IdFornitore = drvRagSoc.IdFornitore
        WHERE        
            (TbForDdt.IdVettore IS NOT NULL) AND 
            (ISNULL(TbForDdt.CostoTrasp, 0) <> 0)

    UNION ALL

        SELECT 
            'CLIRCVDDT' + '#' +  TbCliRcvDdt.IdCliRcvDdt AS IdKey, 
            TbCliRcvDdt.IdCliRcvDdt AS IdDoc, 
            'CLIRCVDDT' AS TipoDoc, 
            TbCliRcvDdt.DataDdt AS DataDoc, 
            TbCliRcvDdt.IdVettore, 
            TbFornitori.RagSoc AS RagSocVettore, 
            TbCliRcvDdt.CostoTrasp, 
            TbForFatDet.IdForFat, 
            CONVERT(smallint, IIF(TbForFatDet.IdForFat IS NULL, 1, 4)) AS Sem1, 
            CONVERT(smallint,0) AS Sem2, 
            CONVERT(smallint,0) AS Sem3, 
            CONVERT(smallint,0) AS Sem4, 
            CONVERT(nvarchar(max), NULL) AS Ord, 
            'TbCliRcvDdt' as GenDocTipo, 
            CodDdt as RifDoc, 
            drvRagSoc.RagSoc,
            CONCAT('Kymos.Clienti.FrmCliRcvDdtScheda("', TbCliRcvDdt.IdCliRcvDdt, '")') AS FrmOpen
        FROM 
            TbCliRcvDdt INNER JOIN
            TbFornitori ON TbCliRcvDdt.IdVettore = TbFornitori.IdFornitore LEFT OUTER JOIN
            TbForFatDet ON TbCliRcvDdt.IdCliRcvDdt = TbForFatDet.GenIdDoc AND TbForFatDet.GenDocTipo = 'TbCliRcvDdt' LEFT OUTER JOIN
            TbClienti drvRagSoc ON  TbCliRcvDdt.IdCliente = drvRagSoc.IdCliente
        WHERE        
            (TbCliRcvDdt.IdVettore IS NOT NULL) AND 
            (ISNULL(TbCliRcvDdt.CostoTrasp, 0) <> 0)


    UNION ALL

        SELECT 
            'FORRCVDDT' + '#' +  TbForRcvDdt.IdForRcvDdt AS IdKey, 
            TbForRcvDdt.IdForRcvDdt AS IdDoc, 
            'FORRCVDDT' AS TipoDoc, 
            TbForRcvDdt.DataDdt AS DataDoc, 
            TbForRcvDdt.IdVettore, 
            TbFornitori.RagSoc AS RagSocVettore, 
            TbForRcvDdt.CostoTrasp, 
            TbForFatDet.IdForFat, 
            CONVERT(smallint, IIF(TbForFatDet.IdForFat IS NULL, 1, 4)) AS Sem1, 
            CONVERT(smallint,0) AS Sem2, 
            CONVERT(smallint,0) AS Sem3, 
            CONVERT(smallint,0) AS Sem4, 
            CONVERT(nvarchar(max), NULL) AS Ord, 
            'TbForRcvDdt' as GenDocTipo, 
            CodDdt as RifDoc, 
            drvRagSoc.RagSoc,
            CONCAT('Kymos.Fornitori.FrmForRcvDdtScheda("', TbForRcvDdt.IdForRcvDdt, '")') AS FrmOpen
        FROM 
            TbForRcvDdt INNER JOIN
            TbFornitori ON TbForRcvDdt.IdVettore = TbFornitori.IdFornitore LEFT OUTER JOIN
            TbForFatDet ON TbForRcvDdt.IdForRcvDdt = TbForFatDet.GenIdDoc AND TbForFatDet.GenDocTipo = 'TbForRcvDdt' LEFT OUTER JOIN
            TbFornitori drvRagSoc ON  TbForRcvDdt.IdFornitore = drvRagSoc.IdFornitore
        WHERE        
            (TbForRcvDdt.IdVettore IS NOT NULL) AND 
            (ISNULL(TbForRcvDdt.CostoTrasp, 0) <> 0)

    UNION ALL

    ------------------------------
    -- Valori di riga
    ------------------------------
    
    SELECT
            'CLIDDTR' + '#' +  CONVERT(NVARCHAR(20),TbCliDdtDet.IdCliDdtDet)  AS IdKey,
            TbCliDdt.IdCliDdt AS IdDoc,
            'CLIDDT' AS TipoDoc,
            TbCliDdt.DataCliDdt AS DataDoc, 
            TbCliDdt.IdVettore, 
            TbFornitori.RagSoc AS RagSocVettore, 
            TbCliDdtDet.CostoUnit, 
            TbForFatDet.IdForFat, 
            CONVERT(smallint, IIF(TbForFatDet.IdForFat IS NULL, 1, 4)) AS Sem1, 
            CONVERT(smallint,0) AS Sem2, 
            CONVERT(smallint,0) AS Sem3, 
            CONVERT(smallint,0) AS Sem4, 
            CONVERT(nvarchar(max), NULL) AS Ord, 
            'TbCliDdt' as GenDocTipo, 
            TbCliDdt.IdCliDdt as RifDoc, 
            drvRagSoc.RagSoc,
            CONVERT(NVARCHAR(300), CONCAT('Kymos.Clienti.FrmCliDdtScheda("', TbCliDdt.IdCliDdt, '")')) AS FrmOpen
        FROM 
            TbCliDdt INNER JOIN
            TbCliDdtDet ON TbCliDdtDet.IdCliDdt = TbCliDdt.IdCliDdt INNER JOIN
            TbCliAnagDocDetCausali ON TbCliAnagDocDetCausali.IdDocDetCausale = TbCliDdtDet.IdDocDetCausale INNER JOIN
            TbFornitori ON TbCliDdt.IdVettore = TbFornitori.IdFornitore LEFT OUTER JOIN
            TbForFatDet ON TbCliDdt.IdCliDdt = TbForFatDet.GenIdDoc AND TbForFatDet.GenDocTipo = 'TbCliDdt' LEFT OUTER JOIN
            TbClienti drvRagSoc ON  TbCliDdt.IdCliente = drvRagSoc.IdCliente
        WHERE        
            (TbCliDdt.IdVettore IS NOT NULL) AND 
            (ISNULL(TbCliDdtDet.CostoUnit, 0) <> 0) AND
            (TbCliAnagDocDetCausali.FlgTrasporto = 1)

    UNION ALL

        SELECT 
            'CLIFAR' + '#' +  CONVERT(NVARCHAR(20),TbCliFatDet.IdCliFatDet) AS IdKey, 
            TbCliFat.IdCliFat AS IdDoc, 
            'CLIFAT' AS TipoDoc, 
            TbCliFat.DataCliFat AS DataDoc, 
            TbCliFat.IdVettore, 
            TbFornitori.RagSoc AS RagSocVettore, 
            TbCliFatDet.CostoUnit,
            TbForFatDet.IdForFat, CONVERT(smallint, 0) AS Sem1, 
            CONVERT(smallint, 0) AS Sem2, 
            CONVERT(smallint, 0) AS Sem3, 
            CONVERT(smallint, 0) AS Sem4, 
            CONVERT(nvarchar(MAX), NULL) AS Ord,
            'TbCliFat' AS GenDocTipo, 
            TbCliFat.IdCliFat AS RifDoc, 
            drvRagSoc.RagSoc, 
            CONCAT('Kymos.Clienti.FrmCliFatScheda("', TbCliFat.IdCliFat, '")') AS FrmOpen
        FROM 
            TbCliFat INNER JOIN
            TbCliFatDet  ON TbCliFatDet.IdCliFat = TbCliFat.IdCliFat INNER JOIN
            TbCliAnagDocDetCausali ON TbCliAnagDocDetCausali.IdDocDetCausale = TbCliFatDet.IdDocDetCausale INNER JOIN
            TbFornitori ON TbCliFat.IdVettore = TbFornitori.IdFornitore LEFT OUTER JOIN
            TbCliAnagFatCausali ON TbCliFat.IdCausaleFat = TbCliAnagFatCausali.IdCausaleFat LEFT OUTER JOIN
            TbForFatDet ON TbCliFat.IdCliFat = TbForFatDet.GenIdDoc AND TbForFatDet.GenDocTipo = 'TbCliFat' LEFT OUTER JOIN
            TbClienti AS drvRagSoc ON TbCliFat.IdCliente = drvRagSoc.IdCliente
        WHERE        
            (TbCliFat.IdVettore IS NOT NULL) AND 
            (ISNULL(TbCliFatDet.CostoUnit, 0) <> 0) AND 
            (TbCliAnagFatCausali.FlgFatImmediata = 1)  AND
            (TbCliAnagDocDetCausali.FlgTrasporto = 1)

    UNION ALL

        SELECT 
            'FORDDTR' + '#' +  CONVERT(NVARCHAR(20),TbForDdtDet.IdForDdtDet) AS IdKey, 
            TbForDdt.IdForDdt AS IdDoc, 
            'FORDDT' AS TipoDoc, 
            TbForDdt.DataForDdt AS DataDoc, 
            TbForDdt.IdVettore, 
            TbFornitori.RagSoc AS RagSocVettore, 
            TbForDdtDet.CostoUnit, 
            TbForFatDet.IdForFat, 
            CONVERT(smallint, IIF(TbForFatDet.IdForFat IS NULL, 1, 4)) AS Sem1, 
            CONVERT(smallint,0) AS Sem2, 
            CONVERT(smallint,0) AS Sem3, 
            CONVERT(smallint,0) AS Sem4, 
            CONVERT(nvarchar(max), NULL) AS Ord, 
            'TbForDdt' as GenDocTipo, 
            TbForDdt.IdForDdt as RifDoc, 
            drvRagSoc.RagSoc,
            CONCAT('Kymos.Fornitori.FrmForDdtScheda("', TbForDdt.IdForDdt, '")') AS FrmOpen
        FROM 
            TbForDdt INNER JOIN
            TbForDdtDet ON TbForDdtDet.IdForDdt = TbForDdt.IdForDdt INNER JOIN
            TbCliAnagDocDetCausali ON TbCliAnagDocDetCausali.IdDocDetCausale = TbForDdtDet.IdDocDetCausale INNER JOIN
            TbFornitori ON TbForDdt.IdVettore = TbFornitori.IdFornitore LEFT OUTER JOIN
            TbForFatDet ON TbForDdt.IdForDdt = TbForFatDet.GenIdDoc AND TbForFatDet.GenDocTipo = 'TbForDdt' LEFT OUTER JOIN
            TbFornitori drvRagSoc ON  TbForDdt.IdFornitore = drvRagSoc.IdFornitore
        WHERE        
            (TbForDdt.IdVettore IS NOT NULL) AND 
            (ISNULL(TbForDdtDet.CostoUnit, 0) <> 0)  AND
            (TbCliAnagDocDetCausali.FlgTrasporto = 1)

    UNION ALL

        SELECT 
            'CLIRCVDDTR' + '#' +  CONVERT(NVARCHAR(20),TbCliRcvDdtDet.IdCliRcvDdtDet) AS IdKey, 
            TbCliRcvDdt.IdCliRcvDdt AS IdDoc, 
            'CLIRCVDDT' AS TipoDoc, 
            TbCliRcvDdt.DataDdt AS DataDoc, 
            TbCliRcvDdt.IdVettore, 
            TbFornitori.RagSoc AS RagSocVettore, 
            TbCliRcvDdtDet.CostoUnit, 
            TbForFatDet.IdForFat, 
            CONVERT(smallint, IIF(TbForFatDet.IdForFat IS NULL, 1, 4)) AS Sem1, 
            CONVERT(smallint,0) AS Sem2, 
            CONVERT(smallint,0) AS Sem3, 
            CONVERT(smallint,0) AS Sem4, 
            CONVERT(nvarchar(max), NULL) AS Ord, 
            'TbCliRcvDdt' as GenDocTipo, 
            CodDdt as RifDoc, 
            drvRagSoc.RagSoc,
            CONCAT('Kymos.Clienti.FrmCliRcvDdtScheda("', TbCliRcvDdt.IdCliRcvDdt, '")') AS FrmOpen
        FROM 
            TbCliRcvDdt INNER JOIN
            TbCliRcvDdtDet ON TbCliRcvDdtDet.IdCliRcvDdt = TbCliRcvDdt.IdCliRcvDdt INNER JOIN
            TbCliAnagDocDetCausali ON TbCliAnagDocDetCausali.IdDocDetCausale = TbCliRcvDdtDet.IdDocDetCausale INNER JOIN
            TbFornitori ON TbCliRcvDdt.IdVettore = TbFornitori.IdFornitore LEFT OUTER JOIN
            TbForFatDet ON TbCliRcvDdt.IdCliRcvDdt = TbForFatDet.GenIdDoc AND TbForFatDet.GenDocTipo = 'TbCliRcvDdt' LEFT OUTER JOIN
            TbClienti drvRagSoc ON  TbCliRcvDdt.IdCliente = drvRagSoc.IdCliente
        WHERE        
            (TbCliRcvDdt.IdVettore IS NOT NULL) AND 
            (ISNULL(TbCliRcvDdtDet.CostoUnit, 0) <> 0)  AND
            (TbCliAnagDocDetCausali.FlgTrasporto = 1)

    UNION ALL

        SELECT 
            'FORRCVDDTR' + '#' +  CONVERT(NVARCHAR(20),TbForRcvDdtDet.IdForRcvDdtDet) AS IdKey, 
            TbForRcvDdt.IdForRcvDdt AS IdDoc, 
            'FORRCVDDT' AS TipoDoc, 
            TbForRcvDdt.DataDdt AS DataDoc, 
            TbForRcvDdt.IdVettore, 
            TbFornitori.RagSoc AS RagSocVettore, 
            TbForRcvDdtDet.CostoTrasp, 
            TbForFatDet.IdForFat, 
            CONVERT(smallint, IIF(TbForFatDet.IdForFat IS NULL, 1, 4)) AS Sem1, 
            CONVERT(smallint,0) AS Sem2, 
            CONVERT(smallint,0) AS Sem3, 
            CONVERT(smallint,0) AS Sem4, 
            CONVERT(nvarchar(max), NULL) AS Ord, 
            'TbForRcvDdt' as GenDocTipo, 
            CodDdt as RifDoc, 
            drvRagSoc.RagSoc,
            CONCAT('Kymos.Fornitori.FrmForRcvDdtScheda("', TbForRcvDdt.IdForRcvDdt, '")') AS FrmOpen
        FROM 
            TbForRcvDdt INNER JOIN
            TbForRcvDdtDet ON TbForRcvDdtDet.IdForRcvDdt = TbForRcvDdt.IdForRcvDdt INNER JOIN
            TbCliAnagDocDetCausali ON TbCliAnagDocDetCausali.IdDocDetCausale = TbForRcvDdtDet.IdDocDetCausale INNER JOIN
            TbFornitori ON TbForRcvDdt.IdVettore = TbFornitori.IdFornitore LEFT OUTER JOIN
            TbForFatDet ON TbForRcvDdt.IdForRcvDdt = TbForFatDet.GenIdDoc AND TbForFatDet.GenDocTipo = 'TbForRcvDdt' LEFT OUTER JOIN
            TbFornitori drvRagSoc ON  TbForRcvDdt.IdFornitore = drvRagSoc.IdFornitore
        WHERE        
            (TbForRcvDdt.IdVettore IS NOT NULL) AND 
            (ISNULL(TbForRcvDdtDet.CostoTrasp, 0) <> 0)
    /*
    UNION ALL

        SELECT 
            'FORRCVDDT' + '#' +  TbForRcvDdt.IdForRcvDdt AS IdKey, 
            TbForRcvDdt.IdForRcvDdt AS IdDoc, 
            'FORRCVDDT' AS TipoDoc, 
            TbForRcvDdt.DataDdt AS DataDoc, 
            TbForRcvDdt.IdVettore, 
            TbFornitori.RagSoc AS RagSocVettore, 
            TbForRcvDdtDet.CostoUnit, 
            TbForFatDet.IdForFat, 
            CONVERT(smallint, IIF(TbForFatDet.IdForFat IS NULL, 1, 4)) AS Sem1, 
            CONVERT(smallint,0) AS Sem2, 
            CONVERT(smallint,0) AS Sem3, 
            CONVERT(smallint,0) AS Sem4, 
            CONVERT(nvarchar(max), NULL) AS Ord, 
            'TbForRcvDdt' as GenDocTipo, 
            CodDdt as RifDoc, 
            drvRagSoc.RagSoc,
            CONCAT('Kymos.Fornitori.FrmForRcvDdtScheda("', TbForRcvDdt.IdForRcvDdt, '")') AS FrmOpen
        FROM 
            TbForRcvDdt INNER JOIN
            TbForRcvDdtDet ON TbForRcvDdtDet.IdForRcvDdt = TbForRcvDdt.IdForRcvDdt INNER JOIN
            TbCliAnagDocDetCausali ON TbCliAnagDocDetCausali.IdDocDetCausale = TbForRcvDdtDet.IdDocDetCausale INNER JOIN
            TbFornitori ON TbForRcvDdt.IdVettore = TbFornitori.IdFornitore LEFT OUTER JOIN
            TbForFatDet ON TbForRcvDdt.IdForRcvDdt = TbForFatDet.GenIdDoc AND TbForFatDet.GenDocTipo = 'TbForRcvDdt' LEFT OUTER JOIN
            TbFornitori drvRagSoc ON  TbForRcvDdt.IdFornitore = drvRagSoc.IdFornitore
        WHERE        
            (TbForRcvDdt.IdVettore IS NOT NULL) AND 
            (ISNULL(TbForRcvDdtDet.CostoUnit, 0) <> 0)  AND
            (TbCliAnagDocDetCausali.FlgTrasporto = 1)
    */

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstVettoriCosti';


GO

