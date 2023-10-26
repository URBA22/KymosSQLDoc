


-- ==========================================================================================
-- Entity Name:   VstSetting
-- Author:        fab
-- Create date:   15.11.19
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   
-- History:
-- dav 28.02.15 FePa
-- dav 05.03.15 FlgDboPrint
-- dav 13.04.15 MailFattureFrom
-- fab 27.04.17	NewsLetterSMTP, NewsLetterPort, NewsLetterUser, NewsLetterPassword, NewsLetterEnableSSL, NewsLetterUnsubscribe
-- fab 11.12.17	aggiunto TbSetting.AdmURLDbo, TbSetting.AdmURLConnect, TbSetting.AdmURLCrm
-- dav 15.10.18 Aggiunto parametri fatel
-- dav 15.10.18 Aggiunti campi PercRitAcnt, PercContrPrev, FlgIvaContrPrev, FatelTipoContrPrev
-- dav 03.11.18 Aggiunti AdmServerIP 
-- dav 02.11.18 Aggiunto RptSrvrPath
-- fab 14.11.18	Totlto FatelNaturaContrPrev
-- mik 10.01.19	Aggiunto campi FatEl Emittente e Trasmittente
-- mik 18.02.19	Aggiunto campo FatEl FatelCompany
-- mik 22.05.19 Aggiunto campi FatelCaricaRappr e FatelCodFiscaleRappr
-- mik 23.05.19 Aggiunto campi FatelCaricaDich e FatelCodFiscaleDich
-- fab 11.09.19	Aggiunti i campi dbo.TbSetting.DataBloccoCnt e dbo.TbSetting.DataBloccoMage
-- mik 21.10.19 Aggiunto campo FlgMonitorMailSrv
-- fab 200210 Aggiunti FatelImpgPresentazioneIncr, FatelCodFiscaleIncr, DicImpgPresentazioneIncrData, DicNomeDich, DicCognomeDich, DicCognomeIncr e DicNomeIncr
-- fab 200318 Aggiunto DicPIvaIncr
-- fab 200407 Aggiunto FlgTraceMail
-- fab 200423 Aggiunto FlgIncrLipe e FlgIncrIntra
-- lisa 211006 Aggiunto CodiceDestinatario
-- sim 211102 Aggiunto IPFilter
-- sim 211108 Aggiunto NoteGDPR, NoteWelcome
-- dav 220117 Aggiutno TbSetting.PercImpRitAcnt
-- fab 220216 Aggiunto PrefDoc
-- sim 220222 Aggiunto AdmURLDboH
-- lisa 220324 Aggiunti PercEnasarco, FatelTipoEnasarco, FatelCausaleEnasarco, PercImpEnasarco
-- mik 220629 Aggiunti MailFattureCC e MailFattureCCN
-- dav 220611 Aggiunto RagSocAcronimo
-- lisa 230223 Aggiunto CodUteAbilitatoIntra
-- FRA 230421 Aggiunto FlgRptLogo
-- dav 230428 Aggiunti campi M365EmailTenantId, M365EmailSecret, M365EmailAppId
-- mik 230516 Aggiunto campo AzureStorageSasUri, AzureADAppId, AzureADUserName, AzureADPassword
-- ==========================================================================================
CREATE VIEW [dbo].[VstSetting]
AS
SELECT TbSettingElab.DataElaborazione,
	TbSettingElab.InfoElaborazione,
	TbSetting.IdSetting,
	TbSetting.RagSoc,
	TbSetting.Indirizzo,
	TbSetting.RegImp,
	TbSetting.PIVA,
	TbSetting.CodFiscale,
	TbSetting.REA,
	TbSetting.EMail,
	TbSetting.Fax,
	TbSetting.Tel,
	TbSetting.CodIstat,
	TbSetting.Logo,
	TbSetting.MesiAnalisi,
	TbSetting.MesiLog,
	TbSetting.DatiTestaDoc,
	TbSetting.DatiPiePDoc,
	TbSetting.Acronimo,
	TbSetting.ServerFax,
	TbSetting.MailServerSMTP,
	TbSetting.MailUserName,
	TbSetting.MailPassword,
	TbSetting.MailReturnTo,
	TbSetting.MailFrom,
	TbSetting.MailFattureTesto,
	TbSetting.MailObj,
	TbSetting.MailPort,
	TbSetting.MailEnableSSL,
	TbSetting.IdFornitore,
	TbSetting.IdValuta,
	TbSetting.IdLingua,
	TbSetting.RptSrvrUrl,
	TbSetting.RptSrvrUrlRptViewer,
	TbSetting.RptSrvrUserName,
	TbSetting.RptSrvrPassword,
	TbSetting.RptSrvrDomain,
	TbSetting.WebEmailInfo,
	TbSetting.ImgWatermark,
	TbSetting.WebEmailOrder,
	TbSetting.ImgWatermarkOpacity,
	TbSetting.ImgFlgUseWatermark,
	TbSetting.PrezzoUnitDcm,
	TbSettingElab.FlgInvioInCorso,
	TbSetting.IdGuid,
	TbSetting.SysDateCreate,
	TbSetting.SysUserCreate,
	TbSetting.SysDateUpdate,
	TbSetting.SysUserUpdate,
	TbSetting.SysRowVersion,
	TbSetting.FlgTraceNewsLetter,
	TbSetting.UrlTraceNewsLetter,
	TbSetting.DataInventario,
	TbSetting.ServStampePolling,
	TbSetting.ServStampeWcfUrl,
	TbSetting.ServStampeUser,
	TbSetting.ServStampePassword,
	TbSetting.ServStampeWCFEnabled,
	TbSetting.ServStampeGSViewPath,
	TbSetting.RptSrvrCulture,
	TbSetting.CoeffDurataFasi,
	TbSetting.FlgCntPrtFor,
	TbSetting.FlgCntPrtCli,
	TbSetting.FatelFax,
	TbSetting.FlgInLiquidazione,
	TbSetting.FatelMail,
	TbSetting.FatelNote,
	TbSetting.FatelRegimeFiscale,
	TbSetting.FatelRegImpPrv,
	TbSetting.FlgSocioUnico,
	TbSetting.FatelTel,
	TbSetting.FatelCAP,
	TbSetting.FatelCitta,
	TbSetting.FatelProvincia,
	TbSetting.FatelIdPaese,
	TbSetting.CapitaleSociale,
	TbSetting.FatelCodFiscaleTrasm,
	TbSetting.FatelIdPaeseTrasm,
	TbSetting.FlgDboPrint,
	TbSetting.MailFattureFrom,
	TbSetting.NewsLetterSMTP,
	TbSetting.NewsLetterPort,
	TbSetting.NewsLetterUser,
	TbSetting.NewsLetterPassword,
	TbSetting.NewsLetterEnableSSL,
	TbSetting.NewsLetterUnsubscribe,
	TbSetting.AdmURLDbo,
	TbSetting.AdmURLConnect,
	TbSetting.AdmURLCrm,
	TbSetting.FatelAuthUrl,
	TbSetting.FatelServiceUrl,
	TbSetting.FatelHUB,
	TbSetting.FatelUser,
	TbSetting.FatelPsw,
	TbSetting.FatelCausalePagRitAcnt,
	TbSetting.FatelTipoRitAcnt,
	TbSetting.PercRitAcnt,
	TbSetting.PercContrPrev,
	TbSetting.FlgRitAcntContrPrev,
	TbSetting.FatelTipoContrPrev,
	TbSetting.AdmServerIP,
	TbSetting.RptSrvrPath,
	TbSetting.FatelEmailTrasm,
	TbSetting.FatelCognomeEmit,
	TbSetting.FatelNomeEmit,
	TbSetting.FatelDenominazioneEmit,
	TbSetting.FatelCodFiscaleEmit,
	TbSetting.FatelPIvaEmit,
	TbSetting.FatelIdPaeseEmit,
	TbSetting.FatelTelTrasm,
	TbSetting.FatelCompany,
	TbSetting.FatelCaricaDich,
	TbSetting.FatelCodFiscaleDich,
	TbSetting.DataBloccoCnt,
	TbSetting.DataBloccoMage,
	TbSetting.FlgMonitorMailSrv,
	TbSetting.FatelImpgPresentazioneIncr,
	TbSetting.FatelCodFiscaleIncr,
	TbSetting.DicImpgPresentazioneIncrData,
	TbSetting.DicNomeDich,
	TbSetting.DicCognomeDich,
	TbSetting.DicCognomeIncr,
	TbSetting.DicNomeIncr,
	TbSetting.DicPIvaIncr,
	TbSetting.FlgTraceMail,
	TbSetting.FlgIncrLipe,
	TbSetting.FlgIncrIntra,
	TbSetting.IPFilter,
	TbSetting.CodiceDestinatario,
	TbSetting.NoteGDPR,
	TbSetting.NoteWelcome,
	TbSetting.PercImpRitAcnt,
	TbSetting.PrefDoc,
	TbSetting.AdmURLDboH,
	TbSetting.PercEnasarco,
	TbSetting.FatelTipoEnasarco,
	TbSetting.FatelCausaleEnasarco,
	TbSetting.MailFattureCC,
	TbSetting.MailFattureCCN,
	COALESCE(TbSetting.Acronimo, TbSetting.RagSoc) AS RagSocAcronimo,
	TbSetting.CodUteAbilitatoIntra,
	FlgRptLogo,
	TbSetting.M365EmailTenantId,
	TbSetting.M365EmailSecret,
	TbSetting.M365EmailAppId,
	TbSetting.AzureStorageSasUri,
	TbSetting.AzureADAppId, 
	TbSetting.AzureADUserName, 
	TbSetting.AzureADPassword
FROM dbo.TbSetting TbSetting
INNER JOIN dbo.TbSettingElab TbSettingElab
	ON TbSettingElab.IdSetting = TbSetting.IdSetting

GO

