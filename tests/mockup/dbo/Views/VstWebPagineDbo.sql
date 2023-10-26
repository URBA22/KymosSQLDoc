
-- ==========================================================================================
-- Entity Name:   VstWebPagineDbo
-- Author:        dav
-- Create date:   26.04.12
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   
-- History:
-- fab 201130 Aggiunto IdDOc
-- ==========================================================================================
CREATE VIEW [dbo].[VstWebPagineDbo]
AS
SELECT        dbo.TbWebPagine.IdPagina, dbo.TbWebPagine.IdPaginaPadre, dbo.TbWebPagine.Ordinamento, dbo.TbWebPagine.FlgMenu, dbo.TbWebPagine.FlgMenuSecondario,
                          dbo.TbWebPagine.DescMenu, dbo.TbWebPagine.IdAmbito, dbo.TbWebPagine.Descrizione, dbo.TbWebPagine.Data, dbo.TbWebPagine.Titolo, 
                         dbo.TbWebPagine.Sottotitolo, dbo.TbWebPagine.ContenutoHtml, dbo.TbWebPagine.ContenutoHtml1, dbo.TbWebPagine.CodFnzTipo, 
                         dbo.TbWebPagine.CodFnzStato, dbo.TbWebPagine.IdTemplate, dbo.TbWebPagine.DataValiditaDa, dbo.TbWebPagine.DataValiditaA, dbo.TbWebPagine.Autore, 
                         dbo.TbWebPagine.IdUtente, dbo.TbWebPagine.IdLingua, dbo.TbWebPagine.IdPaginaLngOrigine, dbo.TbWebPagine.Versione, dbo.TbWebPagine.DataVersione, 
                         dbo.TbWebPagine.DescVersione, dbo.TbWebPagine.Disabilita, dbo.TbWebPagine.UrlEsterno, dbo.TbWebPagine.MetaKeyWords, dbo.TbWebPagine.SysDateCreate, 
                         dbo.TbWebPagine.SysUserCreate, dbo.TbWebPagine.SysDateUpdate, dbo.TbWebPagine.SysUserUpdate, dbo.TbWebPagine.SysRowVersion, 
                         dbo.TbWebTemplate.Descrizione AS DescTemplate, dbo.TbWebPagine.BlocDoc, ISNULL(dbo.TbWebAmbiti.Descrizione, dbo.TbWebAmbiti.IdAmbito) AS DescAmbito, 
                         dbo.TbUtenti.CognomeNome, CONVERT(smallint, 
                         CASE WHEN CodFnzTipo = 'NEWS' THEN 1 WHEN CodFnzTipo = 'HOME' THEN 2 WHEN CodFnzTipo = 'PAGE' THEN 4 ELSE 0 END) AS Sem1, CONVERT(smallint, 0) 
                         AS Sem2, CONVERT(smallint, 0) AS Sem3, CONVERT(smallint, 0) AS Sem4, CAST(ISNULL(dbo.TbWebPagine.IdAmbito, N'') + ISNULL(dbo.TbWebPagine.IdLingua, N'') 
                         + ISNULL(dbo.TbWebPagine.CodFnzTipo, N'') + CAST(ISNULL(dbo.TbWebPagine.Ordinamento, 0) AS nvarchar(20)) AS nvarchar(MAX)) AS Ord, 0 AS Livello, 
                         dbo.TbWebPagine.UrlEsternoTarget, dbo.TbWebPagine.MetaDescription, dbo.TbWebPagine.MetaTitolo, dbo.TbWebPagine.IdDoc
FROM            dbo.TbWebPagine LEFT OUTER JOIN
                         dbo.TbUtenti ON dbo.TbWebPagine.IdUtente = dbo.TbUtenti.IdUtente LEFT OUTER JOIN
                         dbo.TbWebAmbiti ON dbo.TbWebPagine.IdAmbito = dbo.TbWebAmbiti.IdAmbito LEFT OUTER JOIN
                         dbo.TbWebTemplate ON dbo.TbWebPagine.IdTemplate = dbo.TbWebTemplate.IdTemplate

GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'Dav', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagineDbo';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'01.00.00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagineDbo';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '03/12/2013 18:02:30', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagineDbo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagineDbo';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'NO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagineDbo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'     Width = 1500
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
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 9900
         Alias = 1575
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagineDbo';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'Web', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagineDbo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[39] 4[23] 2[20] 3) )"
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
               Top = 45
               Left = 38
               Bottom = 238
               Right = 233
            End
            DisplayFlags = 280
            TopColumn = 25
         End
         Begin Table = "TbUtenti"
            Begin Extent = 
               Top = 187
               Left = 353
               Bottom = 316
               Right = 543
            End
            DisplayFlags = 344
            TopColumn = 6
         End
         Begin Table = "TbWebAmbiti"
            Begin Extent = 
               Top = 103
               Left = 352
               Bottom = 232
               Right = 541
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "TbWebTemplate"
            Begin Extent = 
               Top = 146
               Left = 353
               Bottom = 275
               Right = 542
            End
            DisplayFlags = 344
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 46
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
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
    ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebPagineDbo';


GO

