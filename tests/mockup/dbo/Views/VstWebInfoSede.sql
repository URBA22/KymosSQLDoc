CREATE VIEW dbo.VstWebInfoSede
AS
SELECT     drvP01.NRiga, drvP01.IdWebAmbitoPrt, drvP01.IdAmbito, drvP01.RagSocPrt, drvP01.IndirizzoPrt, drvP01.EMail, drvP01.UrlEsterno, drvP01.DescPrt, drvP01.IdImg, 
                      drvP01.ContenutoHTML, drvP01.ContenutoHTML1, drvP02.IdWebAmbitoPrt_1, drvP02.RagSocPrt_1, drvP02.IndirizzoPrt_1, drvP02.Email_1, drvP02.UrlEsterno_1, 
                      drvP02.DescPrt_1, drvP02.IdImg_1, drvP02.ContenutoHTML_1, drvP02.ContenutoHTML1_1
FROM         (SELECT     ROW_NUMBER() OVER (ORDER BY Ordinamento ASC) AS NRiga, IdWebAmbitoPrt, IdAmbito, RagSocPrt, IndirizzoPrt, EMail, UrlEsterno, DescPrt, IdImg, 
                      ContenutoHTML, ContenutoHTML1, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion
FROM         TbWebAmbitiPrt
WHERE     (CodFnzPosiz = N'P01') AND (CodFnzTipo = N'SEDE') AND (FlgVisibile = 1)) AS drvP01 FULL OUTER JOIN
    (SELECT     ROW_NUMBER() OVER (ORDER BY Ordinamento ASC) AS NRiga, IdWebAmbitoPrt AS IdWebAmbitoPrt_1, RagSocPrt AS RagSocPrt_1, 
IndirizzoPrt AS IndirizzoPrt_1, EMail AS Email_1, UrlEsterno AS UrlEsterno_1, DescPrt AS DescPrt_1, IdImg AS IdImg_1, ContenutoHTML AS ContenutoHTML_1, 
ContenutoHTML1 AS ContenutoHTML1_1
FROM         TbWebAmbitiPrt AS TbWebAmbitiPrt_1
WHERE     (CodFnzPosiz = N'P02') AND (CodFnzTipo = N'SEDE') AND (FlgVisibile = 1)) AS drvP02 ON drvP01.NRiga = drvP02.NRiga

GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebInfoSede';


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
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebInfoSede';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '04/25/2013 21:44:35', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebInfoSede';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebInfoSede';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebInfoSede';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebInfoSede';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebInfoSede';


GO

