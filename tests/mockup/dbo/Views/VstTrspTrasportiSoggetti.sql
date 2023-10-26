


CREATE VIEW [dbo].[VstTrspTrasportiSoggetti]
AS
SELECT ISNULL(TbForProd.IndirizzoCompleto, TbFornitori.IndirizzoCompleto) AS IndirizzoCompleto, TbFornitori.IdFornitore, TbClienti.IdCliente, TbForProd.IdForProd AS IdDest, ISNULL(TbForProd.RagSoc, TbFornitori.RagSoc) + ' ' + isnull(DescProd, '') AS RagSoc
FROM  TbFornitori LEFT OUTER JOIN
         TbForProd ON TbFornitori.IdFornitore = TbForProd.IdFornitore LEFT OUTER JOIN
         TbClienti ON TbFornitori.PIva = TbClienti.PIva AND isnull(FlgMarketing,0) = 0
WHERE (TbFornitori.Disabilita = 0)
UNION
SELECT TbFornitori.IndirizzoCompleto, TbFornitori.IdFornitore, TbClienti.IdCliente, NULL AS IdDest, TbFornitori.RagSoc
FROM  TbFornitori LEFT OUTER JOIN
         TbClienti ON TbFornitori.PIva = TbClienti.PIva AND isnull(FlgMarketing,0) = 0
WHERE (TbFornitori.Disabilita = 0) 
UNION
SELECT ISNULL(TbCliDest.IndirizzoCompleto, TbClienti.IndirizzoCompleto) AS IndirizzoCompleto, TbFornitori.IdFornitore, TbClienti.IdCliente, TbCliDest.IdCliDest AS IdDest, ISNULL(TbCliDest.RagSoc, TbClienti.RagSocCompleta) + ' ' + isnull(DescDest, '') AS RagSoc
FROM  TbClienti LEFT OUTER JOIN
         TbCliDest ON TbClienti.IdCliente = TbCliDest.IdCliente LEFT OUTER JOIN
         TbFornitori ON TbClienti.PIva = TbFornitori.PIva
WHERE (TbFornitori.IdFornitore IS NULL) AND TbClienti.Disabilita = 0 AND isnull(FlgMarketing,0) = 0
UNION
SELECT TbClienti.IndirizzoCompleto, TbFornitori.IdFornitore, TbClienti.IdCliente, NULL AS IdDest, TbClienti.RagSocCompleta
FROM  TbClienti LEFT OUTER JOIN
         TbFornitori ON TbClienti.PIva = TbFornitori.PIva
WHERE (TbFornitori.IdFornitore IS NULL) AND TbClienti.Disabilita = 0 AND isnull(FlgMarketing,0) = 0

GO

