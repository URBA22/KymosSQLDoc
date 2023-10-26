
  CREATE VIEW [dbo].[vw_aspnet_WebPartState_User]
  AS SELECT [dbo].[aspnet_PersonalizationPerUser].[PathId], [dbo].[aspnet_PersonalizationPerUser].[UserId], [DataSize]=DATALENGTH([dbo].[aspnet_PersonalizationPerUser].[PageSettings]), [dbo].[aspnet_PersonalizationPerUser].[LastUpdatedDate]
  FROM [dbo].[aspnet_PersonalizationPerUser]

GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_aspnet_WebPartState_User';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_aspnet_WebPartState_User';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_aspnet_WebPartState_User';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_aspnet_WebPartState_User';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_aspnet_WebPartState_User';


GO

