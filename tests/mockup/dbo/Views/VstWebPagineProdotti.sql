/*
 * History
 * MIK 22.12.15: Sulle pagine prodotti degli articoli (Tipo = 3) ho aggiunto l'ordinamento usando il campo WebOrdinamento 
 *               presente su TbArticolo.
 */

CREATE VIEW [dbo].[VstWebPagineProdotti]
AS
SELECT DrvLingue.IdLingua, dbo.TbArtAnagCatgrMacroLingue.WebTitolo AS TitoloLocalizzato, ISNULL(dbo.TbArtAnagCatgrMacro.WebTitolo, dbo.TbArtAnagCatgrMacro.DescCategoriaMacro) AS Titolo, dbo.TbArtAnagCatgrMacroLingue.WebDescrizione AS DescrizioneLocalizzata, dbo.TbArtAnagCatgrMacro.WebDescrizione AS Descrizione, 
         dbo.TbArtAnagCatgrMacro.Immagine, dbo.TbArtAnagCatgrMacro.FlgVisibilitaWeb, dbo.TbArtAnagCatgrMacro.Ordinamento, ('mcr_' + dbo.TbArtAnagCatgrMacro.IdCategoriaMacro1) AS IdPaginaPadre, ('mcr_' + dbo.TbArtAnagCatgrMacro.IdCategoriaMacro) AS IdPagina, (CASE WHEN dbo.TbArtAnagCatgrMacro.IdCategoriaMacro1 IS NULL 
         THEN 0 ELSE 1 END) AS Tipo, (ISNULL(DrvAmbiti.UrlTemplateArtCatgrMacro, '') + '?id=' + ('mcr_' + dbo.TbArtAnagCatgrMacro.IdCategoriaMacro) + ISNULL('&lang=' + DrvLingue.IdLingua, '')) AS Url, 0.0 AS Prezzo, dbo.TbArtAnagCatgrMacroLingue.DescCategoriaMacro AS NomeLocalizzato, dbo.TbArtAnagCatgrMacro.DescCategoriaMacro AS Nome, 
         dbo.TbArtAnagCatgrMacro.IdCategoriaMacro AS Id, NULL AS PrezzoVendita, NULL AS IdOrig, DrvAmbiti.IdAmbito
FROM  dbo.TbArtAnagCatgrMacro CROSS JOIN
             (SELECT IdLingua
            FROM  TbLingue
            WHERE Disabilita = 0) AS DrvLingue CROSS JOIN
             (SELECT IdAmbito, UrlTemplateArt, UrlTemplateArtCatgr, UrlTemplateArtCatgrMacro
            FROM  TbWebAmbiti) AS DrvAmbiti LEFT OUTER JOIN
         dbo.TbArtAnagCatgrMacroLingue ON dbo.TbArtAnagCatgrMacro.IdCategoriaMacro = dbo.TbArtAnagCatgrMacroLingue.IdCategoriaMacro AND DrvLingue.IdLingua = dbo.TbArtAnagCatgrMacroLingue.IdLingua
UNION ALL
SELECT DrvLingue.IdLingua, dbo.TbArtAnagCatgrLingue.WebTitolo AS TitoloLocalizzato, ISNULL(dbo.TbArtAnagCatgr.WebTitolo, dbo.TbArtAnagCatgr.DescCategoria) AS Titolo, dbo.TbArtAnagCatgrLingue.WebDescrizione AS DescrizioneLocalizzata, dbo.TbArtAnagCatgr.WebDescrizione AS Descrizione, dbo.TbArtAnagCatgr.Immagine, 
         dbo.TbArtAnagCatgr.FlgVisibilitaWeb, dbo.TbArtAnagCatgr.Ordinamento AS Ordinamento, ('mcr_' + dbo.TbArtAnagCatgr.IdCategoriaMacro) AS IdPaginaPadre, ('grp_' + dbo.TbArtAnagCatgr.IdCategoria) AS IdPagina, 2 AS Tipo, (ISNULL(DrvAmbiti.UrlTemplateArtCatgr, '') + '?id=' + ('grp_' + dbo.TbArtAnagCatgr.IdCategoria) 
         + ISNULL('&lang=' + DrvLingue.IdLingua, '')) AS Url, 0.0 AS Prezzo, dbo.TbArtAnagCatgrLingue.DescCategoria AS NomeLocalizzato, dbo.TbArtAnagCatgr.DescCategoria AS Nome, dbo.TbArtAnagCatgr.IdCategoria AS Id, NULL AS PrezzoVendita, NULL AS IdOrig, DrvAmbiti.IdAmbito
FROM  dbo.TbArtAnagCatgr CROSS JOIN
             (SELECT IdLingua
            FROM  TbLingue
            WHERE Disabilita = 0) AS DrvLingue CROSS JOIN
             (SELECT IdAmbito, UrlTemplateArt, UrlTemplateArtCatgr, UrlTemplateArtCatgrMacro
            FROM  TbWebAmbiti) AS DrvAmbiti LEFT OUTER JOIN
         dbo.TbArtAnagCatgrLingue ON dbo.TbArtAnagCatgr.IdCategoria = dbo.TbArtAnagCatgrLingue.IdCategoria AND DrvLingue.IdLingua = dbo.TbArtAnagCatgrLingue.IdLingua
UNION ALL
SELECT DrvLingue.IdLingua, TbArtDescLingua.WebTitolo AS TitoloLocalizzato, ISNULL(TbArticoli.WebTitolo, TbArticoli.DescArticolo) AS Titolo, TbArtDescLingua.WebDescrizione AS DescrizioneLocalizzata, TbArticoli.WebDescrizione AS Descrizione, TbArticoli.Immagine, TbArticoli.FlgVisibilitaWeb, TbArticoli.WebOrdinamento AS Ordinamento, 'grp_' + TbArticoli.IdCategoria AS IdPaginaPadre, 
         'art_' + TbArticoli.IdArticolo AS IdPagina, 3 AS Tipo, (ISNULL(DrvAmbiti.UrlTemplateArt, '') + '?id=') + ('art_' + TbArticoli.IdArticolo) + ISNULL('&lang=' + DrvLingue.IdLingua, N'') AS Url, TbArticoli.PrezzoVendita AS Prezzo, ISNULL(TbArtDescLingua.DescLingua, N'') + ' ' + ISNULL(TbArtDescLingua.DescLingua1, N'') AS NomeLocalizzato, 
         ISNULL(TbArticoli.DescArticolo, N'') + ISNULL(TbArticoli.DescArticolo1, N'') AS Nome, TbArticoli.IdArticolo AS Id, TbArticoli.PrezzoVendita, CASE WHEN (IdArticoloOrigine = '') THEN NULL ELSE IdArticoloOrigine END AS IdOrig, DrvAmbiti.IdAmbito
FROM  TbArticoli CROSS JOIN
             (SELECT IdLingua
            FROM  TbLingue
            WHERE (Disabilita = 0)) AS DrvLingue CROSS JOIN
             (SELECT IdAmbito, UrlTemplateArt, UrlTemplateArtCatgr, UrlTemplateArtCatgrMacro
            FROM  TbWebAmbiti) AS DrvAmbiti LEFT OUTER JOIN
         TbArtDescLingua ON TbArticoli.IdArticolo = TbArtDescLingua.IdArticolo AND DrvLingue.IdLingua = TbArtDescLingua.IdLingua

GO

