CREATE VIEW dbo.VstWebPagineSorted
AS
WITH AreaTree(ID, ParentID, SortKey, WebPath) AS (SELECT     TOP (100) PERCENT IdPagina, IdPaginaPadre, CAST(ISNULL(Ordinamento, 100) 
                                                                                                                                       * 65535 + IdPagina AS VARBINARY(900)) AS SortKey, CAST(' » ' + ISNULL(DescMenu, '') AS nvarchar(255)) 
                                                                                                                                       AS WebPath
                                                                                                                 FROM         dbo.TbWebPagine AS a
                                                                                                                 WHERE     (IdPaginaPadre IS NULL)
                                                                                                                 UNION ALL
                                                                                                                 SELECT     TOP (100) PERCENT a.IdPagina, a.IdPaginaPadre, CAST(b.SortKey + CAST(ISNULL(a.Ordinamento, 100) 
                                                                                                                                       * 65535 + a.IdPagina AS BINARY(4)) AS VARBINARY(900)) AS SortKey, 
                                                                                                                                       CAST(b.WebPath + ' » ' + ISNULL(a.DescMenu, '') AS Nvarchar(255)) AS WebPath
                                                                                                                 FROM         dbo.TbWebPagine AS a INNER JOIN
                                                                                                                                       AreaTree AS b ON a.IdPaginaPadre = b.ID
                                                                                                                 ORDER BY Ordinamento)
    SELECT     TOP (100) PERCENT ID, ParentID, SortKey, WebPath
     FROM         AreaTree AS AreaTree_1
     ORDER BY SortKey

GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'Miki', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagineSorted';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'01.00.00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagineSorted';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '01/26/2013 11:53:17', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagineSorted';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagineSorted';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'NO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagineSorted';


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
         Begin Table = "AreaTree_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 198
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
      Begin ColumnWidths = 9
         Width = 284
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagineSorted';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'Web', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagineSorted';


GO

