CREATE VIEW dbo.VstWebPagine
AS
SELECT        DrvWebMenuPagine.IdPagina, DrvWebMenuPagine.IdPaginaPadre, DrvWebMenuPagine.Ordinamento, DrvWebMenuPagine.DescMenu, DrvWebMenuPagine.IdTemplate, DrvWebMenuPagine.DataValiditaDa, 
                         DrvWebMenuPagine.DataValiditaA, ISNULL(DrvWebMenuPagine.UrlEsterno, LOWER(dbo.TbWebTemplate.UrlTemplate + '?id=' + CAST(DrvWebMenuPagine.IdPagina AS nvarchar(5)))) AS UrlOriginale, 
                         ISNULL(DrvWebMenuPagine.UrlEsterno, '~/' + LOWER(dbo.FncWebCleanUrl(DrvWebMenuPagine.Titolo) + '_' + CAST(DrvWebMenuPagine.IdPagina AS nvarchar(5)))) AS Url, DrvWebMenuPagine.IdAmbito, 
                         DrvWebMenuPagine.IdLingua, dbo.VstWebPagineSorted.SortKey, DrvWebMenuPagine.CodFnzStato, DrvWebMenuPagine.CodFnzTipo, DrvWebMenuPagine.ContenutoHtml1, DrvWebMenuPagine.ContenutoHtml, 
                         DrvWebMenuPagine.Sottotitolo, DrvWebMenuPagine.Titolo, DrvWebMenuPagine.Data, DrvWebMenuPagine.Descrizione, DrvWebMenuPagine.Autore, DrvWebMenuPagine.IdUtente, 
                         DrvWebMenuPagine.IdPaginaLngOrigine, DrvWebMenuPagine.Disabilita, DrvWebMenuPagine.UrlEsterno, DrvWebMenuPagine.MetaDescription, DrvWebMenuPagine.MetaKeyWords, 
                         CAST((CASE WHEN DrvWEbMenuPagine.UrlEsterno IS NOT NULL THEN 1 ELSE 0 END) AS bit) AS HasUrlEsterno, DrvWebMenuPagine.UrlEsternoTarget, DrvWebMenuPagine.FlgMenu, 
                         DrvWebMenuPagine.FlgMenuSecondario, DrvWebMenuPagine.IdDoc, UPPER(ISNULL(dbo.TbWebAmbiti.Descrizione, N'') + ISNULL(dbo.VstWebPagineSorted.WebPath, N'')) AS WebPath, 
                         ISNULL(DrvWebMenuPagine.MetaTitolo, DrvWebMenuPagine.Titolo) AS MetaTitolo
FROM            (SELECT        IdPagina, IdPaginaPadre, Ordinamento, FlgMenu, FlgMenuSecondario, DescMenu, IdAmbito, Descrizione, Data, Titolo, Sottotitolo, ContenutoHtml, ContenutoHtml1, CodFnzTipo, CodFnzStato, 
                                                    IdTemplate, DataValiditaDa, DataValiditaA, Autore, IdUtente, IdLingua, IdPaginaLngOrigine, Versione, DataVersione, DescVersione, Disabilita, UrlEsterno, UrlEsternoTarget, MetaTitolo, 
                                                    MetaDescription, MetaKeyWords, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion, IdDoc
                          FROM            dbo.TbWebPagine
                          WHERE        (Disabilita = 0) AND (DataValiditaA IS NULL) AND (DataValiditaDa IS NULL OR
                                                    DataValiditaDa <= GETDATE()) OR
                                                    (Disabilita = 0) AND (DataValiditaDa IS NULL OR
                                                    DataValiditaDa <= GETDATE()) AND (DATEADD(d, 1, DataValiditaA) >= GETDATE())) AS DrvWebMenuPagine INNER JOIN
                         dbo.TbWebAmbiti ON DrvWebMenuPagine.IdAmbito = dbo.TbWebAmbiti.IdAmbito LEFT OUTER JOIN
                         dbo.VstWebPagineSorted ON DrvWebMenuPagine.IdPagina = dbo.VstWebPagineSorted.ID LEFT OUTER JOIN
                         dbo.TbWebTemplate ON DrvWebMenuPagine.IdTemplate = dbo.TbWebTemplate.IdTemplate

GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'Web', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
         Begin Table = "DrvWebMenuPagine"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 199
               Right = 220
            End
            DisplayFlags = 280
            TopColumn = 27
         End
         Begin Table = "TbWebAmbiti"
            Begin Extent = 
               Top = 193
               Left = 407
               Bottom = 312
               Right = 571
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VstWebPagineSorted"
            Begin Extent = 
               Top = 6
               Left = 258
               Bottom = 110
               Right = 485
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TbWebTemplate"
            Begin Extent = 
               Top = 71
               Left = 507
               Bottom = 190
               Right = 671
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
      Begin ColumnWidths = 30
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1575
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
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width =', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagine';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '03/12/2013 18:02:23', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagine';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'Miki', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagine';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'01.00.00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagine';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'NO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N' 1500
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagine';


GO

