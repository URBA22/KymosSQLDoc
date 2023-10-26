CREATE VIEW dbo.VstWebNewsInScorrimento
AS
SELECT     TOP (100) PERCENT dbo.TbWebPagine.IdPagina, dbo.TbWebPagine.Titolo, dbo.TbWebPagine.Data, dbo.TbWebPagine.Autore, dbo.TbWebPagine.IdTemplate, 
                      dbo.TbWebPagine.Descrizione, LOWER(ISNULL(dbo.TbWebPagine.UrlEsterno, DrvCNews.UrlOriginale + '#' + CAST(dbo.TbWebPagine.IdPagina AS nvarchar(5)))) 
                      AS UrlOriginale, LOWER(ISNULL(dbo.TbWebPagine.UrlEsterno, DrvCNews.Url + '#' + CAST(dbo.TbWebPagine.IdPagina AS nvarchar(5)))) AS Url, 
                      dbo.TbWebPagine.IdAmbito, dbo.TbWebPagine.Sottotitolo, dbo.TbWebPagine.ContenutoHtml, dbo.TbWebPagine.ContenutoHtml1, dbo.TbWebPagine.CodFnzTipo, 
                      dbo.TbWebPagine.CodFnzStato, dbo.TbWebPagine.IdLingua
FROM         dbo.TbWebPagine LEFT OUTER JOIN
                      dbo.TbWebTemplate ON dbo.TbWebPagine.IdTemplate = dbo.TbWebTemplate.IdTemplate LEFT OUTER JOIN
                          (SELECT     dbo.VstWebPagine.IdPagina, dbo.VstWebPagine.Titolo, dbo.VstWebPagine.IdAmbito, dbo.VstWebPagine.IdLingua, dbo.VstWebPagine.UrlOriginale, 
                                                   dbo.VstWebPagine.Url
                            FROM          dbo.VstWebPagine INNER JOIN
                                                       (SELECT     MIN(IdPagina) AS IdPagina
                                                         FROM          dbo.TbWebPagine AS TbWebPagine_1
                                                         WHERE      (CodFnzTipo = 'CNEWS')
                                                         GROUP BY IdAmbito, IdLingua) AS Tb1 ON dbo.VstWebPagine.IdPagina = Tb1.IdPagina
                            WHERE      (dbo.VstWebPagine.CodFnzTipo = 'CNEWS')) AS DrvCNews ON dbo.TbWebPagine.IdLingua = DrvCNews.IdLingua AND 
                      dbo.TbWebPagine.IdAmbito = DrvCNews.IdAmbito
WHERE     (dbo.TbWebPagine.CodFnzTipo = 'NEWS') AND (dbo.TbWebPagine.Disabilita = 0) AND (dbo.TbWebPagine.DataValiditaA IS NULL) AND 
                      (dbo.TbWebPagine.DataValiditaDa IS NULL OR
                      dbo.TbWebPagine.DataValiditaDa <= GETDATE()) OR
                      (dbo.TbWebPagine.CodFnzTipo = 'NEWS') AND (dbo.TbWebPagine.Disabilita = 0) AND (dbo.TbWebPagine.DataValiditaDa IS NULL OR
                      dbo.TbWebPagine.DataValiditaDa <= GETDATE()) AND (DATEADD(d, 1, dbo.TbWebPagine.DataValiditaA) >= GETDATE())
ORDER BY dbo.TbWebPagine.Data DESC

GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'Web', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebNewsInScorrimento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "TbWebPagine"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 426
               Right = 220
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "TbWebTemplate"
            Begin Extent = 
               Top = 6
               Left = 258
               Bottom = 125
               Right = 427
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DrvCNews"
            Begin Extent = 
               Top = 6
               Left = 465
               Bottom = 125
               Right = 625
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 16
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebNewsInScorrimento';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '01/26/2013 11:53:14', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebNewsInScorrimento';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'Miki', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebNewsInScorrimento';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebNewsInScorrimento';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'01.00.00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebNewsInScorrimento';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'NO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebNewsInScorrimento';


GO

