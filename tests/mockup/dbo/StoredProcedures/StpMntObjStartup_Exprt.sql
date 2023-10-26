



-- ==========================================================================================
-- Entity Name:	StpMntObjStartup_Exprt
-- Author:	Dav
-- Create date:	211111
-- AutoCreate:	YES
-- Custom_Dbo:	NO
-- Standard_dbo: YES
-- Generator:	01.00.01
-- CustomNote:	Write custom note here 
-- Description:	Esporta file di configurazione per STARTUP
-- History
-- dav 211111 Creazione
-- dav 220627 Attività inizizali
-- dav 220629 Aggiunto ambito e tipo in TbAttivita
-- dav 221121 Aggiunta creaizone utenti all'inizio
-- dav 221202 Filtro su TKT
-- dav 221224 Gestione TbCntAnagCespitiMovCausali
-- dav 230125 Gestione DboConfig
-- FRA 230125 Aggiunta TbForAnagDocDetCausali e TbCliAnagDocDetCausali
-- FRA 230126 Aggiunta TbCliAnagFatelTipo
-- dav 230126 Tolti filtri Disabilita = 0 per carico da dboconfig
-- dav 230131 Corretto carico attività, sfondava 4000 caratteri
-- dav 230426 Disabilita TbSettingModuli
-- dav 230724 Aggiunto attività per resp. utenti
-- ==========================================================================================
CREATE Procedure [dbo].[StpMntObjStartup_Exprt]
(
	@FilePath as nvarchar(300)
)
As
Begin


    --SET @FilePath =  'E:\Build_Dbo\SqlData\ScriptUpdate' 

	Declare @FileName as nvarchar(300)
	Declare @sql as nvarchar(300)
				
	If DB_NAME() = 'dboconfig'
		BEGIN
			
            
			Execute StpUteMsg_Ins   'Export SqlData',
									'Esportazione Object su file',
									'',
									'INF',
									 NULL
									

			--SET @FilePath = isnull(@FilePath, 'E:\Build_Dbo\')
			SET @FileName = @FilePath + '\000001_DboScript.sql'

            Print 'Genera script ' + @FileName
			-----------------------------------------------
			-- SCRIPT INIZIALI
			-----------------------------------------------

			DECLARE @sql_script AS Nvarchar(4000)
			SET @sql_script = '	
								Print ''----------------------------------------''
								Print ''Script STARTUP dbo''
                                Print ''Versione '' + ''' + CONVERT(NVARCHAR(20), GETDATE(),112) + '''
                                Print ''Sorgente '' + ''' + DB_NAME() + '''
								Print ''Predipone tabelle iniziali''
								Print ''----------------------------------------''

								SET LANGUAGE us_english
								
								-- To allow advanced options to be changed.  
								-- EXEC sp_configure ''show advanced options'', 1;   
								-- RECONFIGURE

								-- To enable the feature.  
								-- EXEC sp_configure ''xp_cmdshell'', 1;  
								-- RECONFIGURE 


                                Print ''----------------------------------------''
								Print ''Precarica attività da generare ''
								Print ''----------------------------------------''

                                IF NOT EXISTS (SELECT 1 FROM TbUtenti WHERE IdUtente = ''Cybe'')
                                BEGIN
                                    INSERT INTO TbUtenti (IdUtente, DescUtente,EMail, SysUserCreate)
                                    VALUES (''Cybe'',''Utente autogenerato per attività automatiche'',''cybe@kymos.eu'',''Cybe'')
                                    PRINT  '' Aggiunta utente Cybe''
                                END

                                IF NOT EXISTS (SELECT 1 FROM TbUtenti WHERE IdUtente = ''dav'')
                                BEGIN
                                    INSERT INTO TbUtenti (IdUtente, DescUtente,EMail,FlgComm,FlgMaster,FlgAmministrazione,FlgResponsabile,SysUserCreate)
                                    VALUES (''dav'',''Utente di accesso KYMOS'',''info@kymos.eu'',1,1,1,1,''dav'')
                                    PRINT  '' Aggiunta utente dav''
                                END

								'
			-- Toglie il tab
			SET @sql_script = REPLACE (@sql_script,char(9),'')

			If @FileName is not null
			BEGIN

				-- Elimina file esistente
				DECLARE @cmd NVARCHAR(MAX) 
				SET @cmd = 'xp_cmdshell ''del "' + @FileName + '"'''
				EXEC (@cmd)

				DECLARE @OLE INT
				DECLARE @FileID INT

				DECLARE @hr INT
				EXECUTE sp_OACreate 'Scripting.FileSystemObject', @OLE OUT
			
				EXECUTE sp_OAMethod @OLE, 'OpenTextFile', @FileID OUT, @filename , 8, 1

				EXECUTE  @hr = sp_OAMethod @FileID, 'WriteLine', Null, @sql_script

				EXECUTE sp_OADestroy @FileID
				EXECUTE sp_OADestroy @OLE
			END

			
			-- inserisce come primo elemento il tipo attività (serve nei passaggi successivi)

            EXECUTE StpMntDataTable_Exprt 'TbAttAnagTipo', @file_name = @FileName --  Disabilita = 0 and 

            -- Crea Utenti >> Disabilitato,  già creato in modo statico prima
            -- EXECUTE StpMntDataTable_Exprt 'TbUtenti' ,@cols_to_include ="'IdUtente','DescUtente','Email''",@where = " WHERE IdUtente IN( 'dav','CYBE')", @file_name = @FileName

			-- EXECUTE StpMntDataTable_Exprt 'aspnet_Applications',@ActionFile= "DEL", @where = " WHERE ApplicationName IN ('CRM','DBO','DBOC') ", @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'aspnet_Applications',@where = " WHERE ApplicationName IN ('CRM','DBO','DBOC') ", @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'aspnet_Membership',@where = " WHERE userid IN ( '3AA03E70-C607-4EA6-896F-FDC0330D9AEB','FC6AAEC8-5110-40E0-AC26-49462DC98426')  ", @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'aspnet_Roles',@where = " WHERE rolename in ('Admin','Dev','Helper','DboConnector','ServiceUsers')  ", @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'aspnet_SchemaVersions', @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'aspnet_Users',@where = " WHERE userid IN ( '3AA03E70-C607-4EA6-896F-FDC0330D9AEB','FC6AAEC8-5110-40E0-AC26-49462DC98426')  ", @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'aspnet_UsersInRoles',@where = " WHERE userid IN ( '3AA03E70-C607-4EA6-896F-FDC0330D9AEB','FC6AAEC8-5110-40E0-AC26-49462DC98426')  " , @file_name = @FileName -- and roleid in (select roleid from aspnet_Roles WHERE rolename in ('Admin')   "

			EXECUTE StpMntDataTable_Exprt 'AspNetUsers',@where = " WHERE USERNAME = 'dav'  ", @file_name = @FileName

			EXECUTE StpMntDataTable_Exprt 'TbArtAnagQlaCriticita', @file_name = @FileName --  @where = " WHERE Disabilita = 0 ",
			EXECUTE StpMntDataTable_Exprt 'TbArtAnagCriticita',  @file_name = @FileName -- @where = " WHERE Disabilita = 0 ",
			EXECUTE StpMntDataTable_Exprt 'TbArtAnagFigGeometriche', @file_name = @FileName -- , @where = " WHERE Disabilita = 0 "
			EXECUTE StpMntDataTable_Exprt 'TbArtAnagMateriali',  @file_name = @FileName -- @where = " WHERE Disabilita = 0 ",
			EXECUTE StpMntDataTable_Exprt 'TbArtAnagQlaEsiti',  @file_name = @FileName -- @where = " WHERE Disabilita = 0 ",
			EXECUTE StpMntDataTable_Exprt 'TbArtAnagQlaTipoMisure', @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbArtAnagQlaTipoStrumenti' , @file_name = @FileName

			EXECUTE StpMntDataTable_Exprt 'TbCliAnagDdtCausali', @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbCliAnagFatCausali' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbCliAnagOffCausaliEsito' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbCliAnagOrdCausali' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbCliAnagPrjCausali' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbCliAnagPrpListCausali' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbCliAnagRcvDdtCausali' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbCliAnagDocDetCausali' ,  @file_name = @FileName -- @where = " WHERE Disabilita = 0 " ,
			EXECUTE StpMntDataTable_Exprt 'TbCliAnagFatelTipo' , @file_name = @FileName

			EXECUTE StpMntDataTable_Exprt 'TbCntAnagBancheTipoFido' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbCntAnagPrmNotaCausali' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbCntAnagPrmNotaRegIva' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbCntAnagTesoreriaCausali' , @file_name = @FileName
            EXECUTE StpMntDataTable_Exprt 'TbCntAnagCespitiMovCausali' , @file_name = @FileName
            
			EXECUTE StpMntDataTable_Exprt 'TbCntCoge' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbCntCogeRicl' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbCntCondPag' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbCntCondPagDef' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbCntIva' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbCntSocieta' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbCntValute',  @file_name = @FileName
			
			EXECUTE StpMntDataTable_Exprt 'TbDocAnagCatgr' , @file_name = @FileName

			EXECUTE StpMntDataTable_Exprt 'TbForAnagDdtCausali' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbForAnagFatCausali' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbForAnagOffCausali' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbForAnagOffCausaliEsito' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbForAnagOrdCausali' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbForAnagPrpListCausali' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbForAnagRcvDdtCausali' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbForAnagTipo' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbForAnagDocDetCausali' ,  @file_name = @FileName --  @where = " WHERE Disabilita = 0 " ,

			EXECUTE StpMntDataTable_Exprt 'TbLingue' , @file_name = @FileName --  @where = " WHERE Disabilita = 0 ",

			EXECUTE StpMntDataTable_Exprt 'TbMageAnag' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbMageAnagMovCausali' , @file_name = @FileName

			EXECUTE StpMntDataTable_Exprt 'TbMatrAnagConformita'  , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbMatrAnagStato' ,  @file_name = @FileName -- @where = " WHERE Disabilita = 0 ",

			EXECUTE StpMntDataTable_Exprt 'TbMntAnagDpi' ,  @file_name = @FileName -- @where = " WHERE Disabilita = 0 ",
			EXECUTE StpMntDataTable_Exprt 'TbMntAnagIntrvCausali' , @file_name = @FileName -- @where = " WHERE Disabilita = 0 ", 
			EXECUTE StpMntDataTable_Exprt 'TbMntAnagIntrvTipoAtvt' , @file_name = @FileName -- @where = " WHERE Disabilita = 0 ", 
			EXECUTE StpMntDataTable_Exprt 'TbMntAnagPianiTipo' , @file_name = @FileName -- @where = " WHERE Disabilita = 0 ", 
			EXECUTE StpMntDataTable_Exprt 'TbMntAnagUnitaTipo' ,  @file_name = @FileName -- @where = " WHERE Disabilita = 0 ",

			EXECUTE StpMntDataTable_Exprt 'TbOdlAnagCausali' ,  @file_name = @FileName -- @where = " WHERE Disabilita = 0 ",
			EXECUTE StpMntDataTable_Exprt 'TbOdlAnagCausaliCosti' ,  @file_name = @FileName -- @where = " WHERE Disabilita = 0 ",
			EXECUTE StpMntDataTable_Exprt 'TbOdlAnagCausaliScarto' , @file_name = @FileName -- @where = " WHERE Disabilita = 0 ", 

			EXECUTE StpMntDataTable_Exprt 'TbPaesi' ,  @file_name = @FileName -- @where = " WHERE Disabilita = 0 ",

			EXECUTE StpMntDataTable_Exprt 'TbProdAnagUtnTipo' ,  @file_name = @FileName -- @where = " WHERE Disabilita = 0 ",

			EXECUTE StpMntDataTable_Exprt 'TbProdLottiAnagCausali' , @file_name = @FileName -- @where = " WHERE Disabilita = 0 ", 
			EXECUTE StpMntDataTable_Exprt 'TbProdLottiAnagCmdStatoCausali' , @file_name = @FileName -- @where = " WHERE Disabilita = 0 ", 

			EXECUTE StpMntDataTable_Exprt 'TbProdPartiteAnagStato' ,  @file_name = @FileName -- @where = " WHERE Disabilita = 0 ",

			EXECUTE StpMntDataTable_Exprt 'TbQaAnagCause' ,  @file_name = @FileName -- @where = " WHERE Disabilita = 0 ",
			EXECUTE StpMntDataTable_Exprt 'TbQaAnagDocTipo' , @file_name = @FileName -- @where = " WHERE Disabilita = 0 ", 
			EXECUTE StpMntDataTable_Exprt 'TbQaAnagEsiti' ,  @file_name = @FileName -- @where = " WHERE Disabilita = 0 ",

			--EXECUTE StpMntDataTable_Exprt 'TbRlvSocieta' , @where = " WHERE Disabilita = 0 ", @file_name = @FileName

			EXECUTE StpMntDataTable_Exprt 'TbSetting', @cols_to_include ="'IdSetting','RagSoc','MesiAnalsi','MesiLog'", @where = " WHERE IdSetting = 1", @file_name = @FileName
			
			EXECUTE StpMntDataTable_Exprt 'TbSettingAutoUpd' , @file_name = @FileName
			
			EXECUTE StpMntDataTable_Exprt 'TbSettingCodFnz' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbSettingCommand' , @file_name = @FileName
			
			EXECUTE StpMntDataTable_Exprt 'TbSettingKey' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbSettingMenu' , @file_name = @FileName
			--EXECUTE StpMntDataTable_Exprt 'TbSettingModuli' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbSettingRcrDoc' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbSettingReport' , @where = " WHERE DataRilascio is not null ", @file_name = @FileName
			
			
			EXECUTE StpMntDataTable_Exprt 'TbSpedMezzo' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbSpedPorto' , @file_name = @FileName

			EXECUTE StpMntDataTable_Exprt 'TbTrspAnagCausali' , @file_name = @FileName
			
			EXECUTE StpMntDataTable_Exprt 'TbUnitM' , @file_name = @FileName --  @where = " WHERE Disabilita = 0 ",
			EXECUTE StpMntDataTable_Exprt 'TbUnitMConv' , @file_name = @FileName --  @where = " WHERE Disabilita = 0 ",

			
			EXECUTE StpMntDataTable_Exprt 'TbZoneLocalita' ,  @file_name = @FileName -- @where = " WHERE Disabilita = 0 ",
			EXECUTE StpMntDataTable_Exprt 'TbZoneProvincie' , @file_name = @FileName -- @where = " WHERE Disabilita = 0 ", 
			
			EXECUTE StpMntDataTable_Exprt 'TbAdmDhForm' , @file_name = @FileName
			--EXECUTE StpMntDataTable_Exprt 'TbAdmDhFormRole' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbAdmDhImage' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbAdmDhMenu' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbAdmDhRole', @where = " WHERE IdRole IN ('dbo','cli') " , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbAdmDhSqlCommand' , @file_name = @FileName
            EXECUTE StpMntDataTable_Exprt 'TbAdmDhCommand' , @file_name = @FileName
			EXECUTE StpMntDataTable_Exprt 'TbAdmDhUserRole', @where = " WHERE IdUtente = 'dav' and IdRole ='dbo' ", @file_name = @FileName

            -- Aggiunge setup Attivita
			-- Lo fa in un secondo batch perchè @sql_script è di 4000 caratteri

			SET @sql_script = '	
								
								Print ''----------------------------------------''
								Print ''Carica Attività  ''
								Print ''----------------------------------------''

								INSERT INTO TbAttivita
                                (TipoDoc, IdDoc, DataAttivita, IdAttivitaTipo, Ambito, DescAttivita, NoteAttivita, NoteInterne, IdUtenteDest, IdUtente, DataFineRichiesta, FlgAperta, SysDateCreate, SysUserCreate)
                                VALUES 
                                 (N''STARTUP'', N''000'', GETDATE(), ''TKT'', N''ISTRUZIONE'',N''ISTRUZIONE Utente Admin, tipi di accesso: psw, filtro ip, doppia autenticazione'', NULL, NULL, N''dav'', N''cybe'', GETDATE(), 1, GETDATE(), N''CYBE'')
                                ,(N''STARTUP'', N''000'', GETDATE(), ''TKT'', N''ISTRUZIONE'',N''ISTRUZIONE Utente Admin, sicurezza: complessità psw, gestione utenti admin, firma, ruoli e permessi '', NULL, NULL, N''dav'', N''cybe'', GETDATE(), 1, GETDATE(), N''CYBE'')
                                ,(N''STARTUP'', N''000'', GETDATE(), ''TKT'', N''ISTRUZIONE'',N''ISTRUZIONE ambiente: istruzione su barra dei comandi, menu, help, tutorial (in help e da menu) '', NULL, NULL, N''dav'', N''cybe'', GETDATE(), 1, GETDATE(), N''CYBE'')
                                ,(N''STARTUP'', N''000'', GETDATE(), ''TKT'', N''ISTRUZIONE'',N''ISTRUZIONE ambiente: se richiesto definire colore schede e colore menu'', NULL, NULL, N''dav'', N''cybe'', GETDATE(), 1, GETDATE(), N''CYBE'')
                                
                                ,(N''STARTUP'', N''000'', GETDATE(), ''TKT'', N''CONFIGURA'',N''CONFIGURA Scheda Società: Dati società e logo'', NULL, NULL, N''dav'', N''cybe'', GETDATE(), 1, GETDATE(), N''CYBE'')
                                ,(N''STARTUP'', N''000'', GETDATE(), ''TKT'', N''CONFIGURA'',N''CONFIGURA Key: DbName'', NULL, NULL, N''dav'', N''cybe'', GETDATE(), 1, GETDATE(), N''CYBE'')
                                ,(N''STARTUP'', N''000'', GETDATE(), ''TKT'', N''CONFIGURA'',N''CONFIGURA Utente: Cybe'', NULL, NULL, N''dav'', N''cybe'', GETDATE(), 1, GETDATE(), N''CYBE'')
                                ,(N''STARTUP'', N''000'', GETDATE(), ''TKT'', N''CONFIGURA'',N''CONFIGURA Report: Crea Path e User'', NULL, NULL, N''dav'', N''cybe'', GETDATE(), 1, GETDATE(), N''CYBE'')
                                ,(N''STARTUP'', N''000'', GETDATE(), ''TKT'', N''CONFIGURA'',N''CONFIGURA App: Configura App e verifica risorse PC'', NULL, NULL, N''dav'', N''cybe'', GETDATE(), 1, GETDATE(), N''CYBE'')
                                ,(N''STARTUP'', N''000'', GETDATE(), ''TKT'', N''CONFIGURA'',N''CONFIGURA key: NumDdtCongiunta tipo di numerazione DDT clienti e fornitori  '', NULL, NULL, N''dav'', N''cybe'', GETDATE(), 1, GETDATE(), N''CYBE'')
                                ,(N''STARTUP'', N''000'', GETDATE(), ''TKT'', N''CONFIGURA'',N''CONFIGURA ambiente: configura dbo, dboh, dbox (se richiesto) '', NULL, NULL, N''dav'', N''cybe'', GETDATE(), 1, GETDATE(), N''CYBE'')
                                ,(N''STARTUP'', N''000'', GETDATE(), ''TKT'', N''CONFIGURA'',N''CONFIGURA ambiente: configura service connect (se richiesto) '', NULL, NULL, N''dav'', N''cybe'', GETDATE(), 1, GETDATE(), N''CYBE'')
                                

                                ,(N''STARTUP'', N''000'', GETDATE(), ''TKT'', N''CONFIGURA'', N''CONFIGURA ambiente: configura ARUBA (se richiesto) '', NULL, NULL, N''dav'', N''cybe'', GETDATE(), 1, GETDATE(), N''CYBE'')
                                ,(N''STARTUP'', N''000'', GETDATE(), ''TKT'', N''CONFIGURA'', N''CONFIGURA Utenti: Creazione utenti e definizione responsabile utente '', NULL, NULL, N''dav'', N''cybe'', GETDATE(), 1, GETDATE(), N''CYBE'')
								
								Print ''----------------------------------------''
								Print ''Carica tabelle ''
								Print ''----------------------------------------''
								'
			
			-- Toglie il tab
			SET @sql_script = REPLACE (@sql_script,char(9),'')
                                

			If @FileName is not null
			BEGIN
				EXECUTE sp_OACreate 'Scripting.FileSystemObject', @OLE OUT
			
				EXECUTE sp_OAMethod @OLE, 'OpenTextFile', @FileID OUT, @filename , 8, 1

				EXECUTE  @hr = sp_OAMethod @FileID, 'WriteLine', Null, @sql_script

				EXECUTE sp_OADestroy @FileID
				EXECUTE sp_OADestroy @OLE
			END
			
			SET @sql_script = '	
								
								Print ''----------------------------------------''
								Print ''Aggiorna Key versionne
								Print ''----------------------------------------''

								UPDATE TbSettingKey 
								SET VALUE = ' + right(convert(nvarchar(20),getdate(), 112),6) + '
								WHERE IdKey = ''MntScriptVer'' 

								Print ''----------------------------------------''
								Print ''Fine ''
								Print ''----------------------------------------''

								'
			-- Toglie il tab
			SET @sql_script = REPLACE (@sql_script,char(9),'')

			If @FileName is not null
			BEGIN
				EXECUTE sp_OACreate 'Scripting.FileSystemObject', @OLE OUT
			
				EXECUTE sp_OAMethod @OLE, 'OpenTextFile', @FileID OUT, @filename , 8, 1

				EXECUTE  @hr = sp_OAMethod @FileID, 'WriteLine', Null, @sql_script

				EXECUTE sp_OADestroy @FileID
				EXECUTE sp_OADestroy @OLE
			END

	END
			

End

GO

