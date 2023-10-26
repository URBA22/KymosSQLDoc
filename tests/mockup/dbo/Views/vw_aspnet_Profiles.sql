
  CREATE VIEW [dbo].[vw_aspnet_Profiles]
  AS SELECT [dbo].[aspnet_Profile].[UserId], [dbo].[aspnet_Profile].[LastUpdatedDate],
      [DataSize]=  DATALENGTH([dbo].[aspnet_Profile].[PropertyNames])
                 + DATALENGTH([dbo].[aspnet_Profile].[PropertyValuesString])
                 + DATALENGTH([dbo].[aspnet_Profile].[PropertyValuesBinary])
  FROM [dbo].[aspnet_Profile]

GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_aspnet_Profiles';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_aspnet_Profiles';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_aspnet_Profiles';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_aspnet_Profiles';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_aspnet_Profiles';


GO

