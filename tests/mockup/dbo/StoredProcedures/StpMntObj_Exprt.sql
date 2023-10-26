



-- ==========================================================================================
-- Entity Name:	StpMntObj_Exprt
-- Author:	Dav
-- Create date:	15.04.18
-- AutoCreate:	YES
-- Custom_Dbo:	NO
-- Standard_dbo: YES
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	Esporta file di configurazione, chiamata da powershell
-- History
-- dav 12.08.19 Gestione TbMntObjDbVrs
-- dav 190901 Aggiunti parametri per gesitone aggiornamento
-- dav 200322 Aggiunti TbMntObjKey e Tutorial, filtro tab nell'help (char(9))
-- dav 200330 Gestione con script unico
-- dav 200406 Aggiunto UPD su autoupdate
-- dav 200416 Aggiunto NoteCommand
-- dav 200425 Scrittura attività di aggiornamento su Kymos
-- dav 200601 Esporta versioni con filtro su data
-- dav 200601 Esporta report
-- dav 200728 Gestione CodFnzAmbito in Versioni
-- dav 200809 Aggiorna URL report per GUID
-- dav 200822 Gestione tutorial
-- dav 200828 Correzione inserimento TbSettingAutoUpd
-- dav 201011 Aggiunto [dbo].[TbMntObjKey]
-- dav 201017 Cotrolli su codfnztipo su key
-- dav 201110 Correzione update tutorial
-- dav 201206 Gestione SettingKeyIns
-- dav 201206 Aggiunto TbMntObjStd
-- dav 201208 Aggiunto INF su TbSettingAutoUpd
-- dav 210105 Tolto SettingKeyIns
-- dav 210131 Aggiunto inserimento menu
-- dav 210523 Aggiunto NOA su TbSettingAutoUpd
-- dav 210523 Aggiunto TbSysExecRequest
-- dav 210809 Aggiunto TbAdmDhSqlCommand, TbAdmDhForm, TbAdmDhMenu
-- dav 210814 Modifica nomi campi tabelle adm
-- dav 211101 Eliminato RoleName
-- dav 211102 Elimina semafori se  (NomeTabella,4) not in (''FncX'',''VstX'')
-- dav 220128 Aggiorna GUID se inserimento manuale per allineare le chiavi
-- dav 220304 Getione TbAdmDhCommand
-- dav 220512 Gestione TbAdmDhMenu.SysUserUpdate per modifiche manuali
-- dav 220813 Gestione FrmCode, CmdSql, CmdFilter, CmdOrderBy,
-- dav 220819 Gestione IdAdmDhObject
-- dav 221114 Getione allineamento TbAdmDhSqlCommand
-- dav 221212 Gestione CodFnzTipo = ''INS'' in TbSettingCodFnz
-- dav 221217 Correzione CodFnzTipo = ''INS'' in TbSettingCodFnz
-- dav 221229 Gestione update completo TbAdmDhCommand
-- dav 221231 Gestione update con aggiornamento stato
-- dav 221231 Gestione TbSettingError
-- dav 230105 Gestione TbAdmDhAlias
-- dav 230227 Gestione aggiornmaneto TbAdmDhCommand
-- dav 230228 Eliminazione TbSettingError
-- dav 230316 Gestione reset TbMntObjHelp 
-- dav 230321 Commentato FormOpen
-- dav 230426 Gestione TbSettingModuli
-- dav 230428 Correzione TbSettingModuli
-- dav 230501 Gestione TbAdmDhMenu.FlgStd
-- dav 230516 Gestione descrizione su moduli
-- dav 230522 Correzione descrizione su moduli
-- dav 230821 Aggiunta condizione di esclusione versioni con FlgRilascio = 1
-- fab 230828 Gestione TbAdmDhSqlCommand.IdImage
-- dav 230828 Corretto gesitone TbAdmDhSqlCommand.IdImage - > TbAdmDhCommand.IdImage
-- ==========================================================================================
CREATE Procedure [dbo].[StpMntObj_Exprt]
(
	@FilePath as nvarchar(300)
)
As
Begin
	
	Declare @FileName as nvarchar(300)
	Declare @sql as nvarchar(300)
				
	If DB_NAME() = 'dbo'
		BEGIN
			
			Execute StpUteMsg_Ins   'Export SqlData',
									'Esportazione Object su file',
									'',
									'INF',
									 NULL
									
			--SET @FilePath = 'F:\Kymos\'
			--SET @FileName = 'F:\Kymos\ScriptUpdate\000000_DboScript.sql'

			--SET @FilePath = isnull(@FilePath, 'E:\Build_Dbo\')
			SET @FileName = @FilePath + '\000000_DboScript.sql'

            --------------------------------
			-- Allineamento nuovi comandi
			--------------------------------

            Insert Into 
            TbAdmDhSqlCommand
            (CmdName, CmdSql, CmdDesc, CodFnzTipo , SysUserCreate)
            SELECT StoreProcedure as CmdName, StoreProcedure as CmdSql, 'Auto-created command' as CmdDesc, 'STP' as CodFnzTipo, 'dav' as SysUserCreate
            FROM [Dbo].[dbo].[TbSettingCommand]
            where StoreProcedure like 'stp%'
            and StoreProcedure not in (select cmdsql from TbAdmDhSqlCommand)
            group by StoreProcedure

			declare @SqlScript nvarchar(max)

			--------------------------------
			-- EXPORT TbMntObjHelp
			-- NB se va in errore controllare con select  NoteHelp from TbMntObjHelp where NoteHelp <> convert(varchar(max), NoteHelp)
			--------------------------------

			SET @SqlScript = '

                    -- Elimina Help non più presenti e non personalizzati   
                    DELETE FROM  TbMntObjHelp
					FROM TbMntObjHelp LEFT OUTER JOIN
					##TbMntObjHelp X ON X.IdObject = TbMntObjHelp.IdObject
					WHERE  X.IdObject IS NULL
                    AND TbMntObjHelp.NoteHelpLocal IS  NULL

                    -- Resetta chiave dboh per evitare conflitti IN INSERIMENTO 
                    UPDATE TbMntObjHelp
					SET 
                    IdAdmDhObject = NULL

					-- Inserisce nuovi Help
					INSERT INTO TbMntObjHelp
					(IdObject,IdAdmDhObject, IdTable, DescHelp, NoteHelp, IdUtente, Tag, Comando)
					SELECT TmpDbo.IdObject, TmpDbo.IdAdmDhObject, TmpDbo.IdTable, TmpDbo.DescHelp, TmpDbo.NoteHelp, TmpDbo.IdUtente, TmpDbo.Tag,  TmpDbo.Comando 
					FROM ##TbMntObjHelp AS TmpDbo LEFT OUTER JOIN
					TbMntObjHelp AS TbMntObjHelp_2 ON TbMntObjHelp_2.IdObject = TmpDbo.IdObject
					WHERE (TbMntObjHelp_2.IdObject IS NULL)

					-- Aggiorna Help esistenti
					UPDATE TbMntObjHelp
					SET 
                    IdTable = TmpDbo.IdTable, 
                    DescHelp = TmpDbo.DescHelp, 
                    NoteHelp = TmpDbo.NoteHelp, 
                    IdUtente = TmpDbo.IdUtente, 
                    Tag =TmpDbo.Tag,
                    IdAdmDhObject = TmpDbo.IdAdmDhObject
					FROM TbMntObjHelp LEFT OUTER JOIN
					##TbMntObjHelp AS TmpDbo ON TbMntObjHelp.IdObject = TmpDbo.IdObject'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'SELECT        
						IdObject, IdAdmDhObject,
						CASE WHEN left(IdTable,1) IN (''#'') THEN NULL ELSE IdTable END as IdTable,
						CASE WHEN left(IdTable,1) IN (''#'') THEN NULL ELSE DescHelp END as DescHelp, 
						CASE WHEN left(IdTable,1) IN (''#'') THEN NULL ELSE NoteHelp END AS NoteHelp, 
						CASE WHEN left(IdTable,1) IN (''#'') THEN NULL ELSE NoteHelpTec END AS NoteHelpTec,
						Comando, IdUtente, NoteHelpLocal, Tag, CodFnzStato
						FROM TbMntObjHelp',
					@TbOutName = N'TbMntObjHelp',
					@FileName = @FileName,
					@ActionFile ='DEL',
					@SqlScript = @SqlScript 


			--------------------------------
			-- EXPORT TbMntObjRlz
			--------------------------------

			SET @SqlScript = '
					-- Elimina tabella esistente 
					Delete from TbMntObjRlz

					-- Inserisce relazioni solo se esiste help 
					INSERT INTO TbMntObjRlz
					(IdRlz, RifRlz, IdObject, IdObjectRlz)
					SELECT  TmpDbo.IdRlz, TmpDbo.RifRlz, TmpDbo.IdObject, TmpDbo.IdObjectRlz
					FROM     ##TbMntObjRlz  TmpDbo
					WHERE IdObject in (SELECT IdObject From TbMntObjHelp)
					and IdObjectRlz in (SELECT IdObject From TbMntObjHelp)
					'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'SELECT IdRlz, RifRlz, IdObject, IdObjectRlz
								FROM  TbMntObjRlz',
					@TbOutName = N'TbMntObjRlz',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 
			
			--------------------------------
			-- EXPORT TbAdmDhImage
			--------------------------------

			SET @SqlScript = '
					-- Aggiorna TbAdmDhImage

					UPDATE TbAdmDhImage
					SET    
					ImageSvg = drvStd.ImageSvg, 
					ImageDesc = drvStd.ImageDesc,
					SysDateUpdate = GETDATE(), 
					SysUserUpdate = ''Cybe''
					FROM  TbAdmDhImage INNER JOIN
					##TbAdmDhImage AS drvStd ON TbAdmDhImage.IdGuid = drvStd.IdGuid
					
					-- Inserisce TbAdmDhImage

					INSERT INTO TbAdmDhImage
					(ImageSvg, ImageDesc, IdGuid, SysDateCreate, SysUserCreate)
					SELECT drvStd.ImageSvg, drvStd.ImageDesc, drvStd.IdGuid, GETDATE() AS SysDateCreate, ''Cybe'' as SysUserCreate
					FROM ##TbAdmDhImage AS drvStd LEFT OUTER JOIN
					TbAdmDhImage on TbAdmDhImage.IdGuid = drvStd.IdGuid
					WHERE (TbAdmDhImage.IdGuid IS NULL)
					'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'SELECT 
									IdImage, ImageSvg, ImageDesc, IdGuid
									FROM  TbAdmDhImage
									',
					@TbOutName = N'TbAdmDhImage',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 

            --------------------------------
			-- EXPORT TbSettingModuli
			--------------------------------

			SET @SqlScript = '

					-- Aggiorna TbSettingModuli

					UPDATE TbSettingModuli
					SET    
					GrpModulo = drvStd.GrpModulo,
                    DescModulo = drvStd.DescModulo, 
                    NoteModulo = drvStd.NoteModulo,
					SysDateUpdate = GETDATE(), 
					SysUserUpdate = ''Cybe''
					FROM  TbSettingModuli INNER JOIN
					##TbSettingModuli AS drvStd ON TbSettingModuli.IdModulo = drvStd.IdModulo
					
					-- Inserisce TbSettingModuli

					INSERT INTO TbSettingModuli
					(IdModulo, GrpModulo, DescModulo, NoteModulo, SysDateCreate, SysUserCreate)
					SELECT drvStd.IdModulo, drvStd.GrpModulo, drvStd.DescModulo, drvStd.NoteModulo, GETDATE() AS SysDateCreate, ''Cybe'' as SysUserCreate
					FROM ##TbSettingModuli AS drvStd LEFT OUTER JOIN
					TbSettingModuli on TbSettingModuli.IdModulo = drvStd.IdModulo
					WHERE (TbSettingModuli.IdModulo IS NULL)

					'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'SELECT 
									IdModulo, GrpModulo, DescModulo, NoteModulo
									FROM  TbSettingModuli
									',
					@TbOutName = N'TbSettingModuli',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 


			--------------------------------
			-- EXPORT TbAdmDhMenu
			--------------------------------

			SET @SqlScript = '

					-- Aggiorna TbAdmDhMenu

					UPDATE TbAdmDhMenu
					SET    
					MenuDesc = drvStd.MenuDesc, 
					MenuCmdPrm = drvStd.MenuCmdPrm, 
					MenuCmdScn = drvStd.MenuCmdScn, 
					MenuColor = drvStd.MenuColor,
					Ord = drvStd.Ord,
					SysDateUpdate = GETDATE(), 
					SysUserUpdate = ''Cybe'',
                    IdModulo = drvStd.IdModulo
					FROM  TbAdmDhMenu INNER JOIN
					##TbAdmDhMenu AS drvStd ON TbAdmDhMenu.IdGuid = drvStd.IdGuid

                    -- Toglie standard se comando non presente

					UPDATE TbAdmDhMenu
					SET    
					FlgStd = 0,
					SysDateUpdate = GETDATE(), 
					SysUserUpdate = ''Cybe''
					FROM  TbAdmDhMenu LEFT OUTER JOIN
					##TbAdmDhMenu AS drvStd ON TbAdmDhMenu.IdGuid = drvStd.IdGuid
					WHERE
					TbAdmDhMenu.FlgStd = 1 AND drvStd.IdGuid IS NULL
					
					-- Inserisce TbAdmDhMenu

					INSERT INTO TbAdmDhMenu
					(MenuDesc, MenuCmdPrm, MenuCmdScn, MenuColor, Ord, IdGuid, SysDateCreate, SysUserCreate, Disabilita, IdModulo, FlgStd)
					SELECT drvStd.MenuDesc, drvStd.MenuCmdPrm, drvStd.MenuCmdScn, drvStd.MenuColor, drvStd.Ord, drvStd.IdGuid, GETDATE() AS SysDateCreate, ''Cybe'' as SysUserCreate, 1 as Disabilita, drvStd.IdModulo, 1 as FlgStd
					FROM ##TbAdmDhMenu AS drvStd LEFT OUTER JOIN
					TbAdmDhMenu on TbAdmDhMenu.IdGuid = drvStd.IdGuid
					WHERE (TbAdmDhMenu.IdGuid IS NULL)

					-- Aggiorna relazione primario per menu inseriti

					UPDATE TbAdmDhMenu
					SET IdMenuPrm = drvAdmDhMenuPrm.IdMenu
					FROM TbAdmDhMenu inner join
					##TbAdmDhMenu AS drvStd ON TbAdmDhMenu.IdGuid = drvStd.IdGuid inner join
					##TbAdmDhMenu AS drvStdPrm ON drvStd.IdMenuPrm = drvStdPrm.IdMenu inner join
					TbAdmDhMenu drvAdmDhMenuPrm ON drvAdmDhMenuPrm.IdGuid = drvStdPrm.IdGuid
					where TbAdmDhMenu.IdMenuPrm is null

                    -- Aggiorna relazione secondario per menu inseriti

					UPDATE TbAdmDhMenu
					SET IdMenuScn = drvAdmDhMenuScn.IdMenu
					FROM TbAdmDhMenu inner join
					##TbAdmDhMenu AS drvStd ON TbAdmDhMenu.IdGuid = drvStd.IdGuid inner join
					##TbAdmDhMenu AS drvStdScn ON drvStd.IdMenuScn = drvStdScn.IdMenu inner join
					TbAdmDhMenu drvAdmDhMenuScn ON drvAdmDhMenuScn.IdGuid = drvStdScn.IdGuid
					where TbAdmDhMenu.IdMenuScn is null

					-- Aggiorna relazione immagini

					UPDATE TbAdmDhMenu
					SET IdImage = TbAdmDhImage.IdImage
					FROM TbAdmDhMenu inner join
					##TbAdmDhMenu AS drvStdMenu ON TbAdmDhMenu.IdGuid = drvStdMenu.IdGuid inner join
					##TbAdmDhImage AS drvStdImage ON drvStdMenu.IdImage = drvStdImage.IdImage inner join
					TbAdmDhImage ON TbAdmDhImage.IdGuid = drvStdImage.IdGuid
					'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'SELECT 
									IdMenu, IdMenuPrm, MenuDesc, MenuCmdPrm, MenuCmdScn, MenuColor, Ord, IdGuid, IdImage, IdModulo, IdMenuScn
									FROM  TbAdmDhMenu
									',
					@TbOutName = N'TbAdmDhMenu',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 

			--------------------------------
			-- EXPORT TbAdmDhForm
			--------------------------------

			SET @SqlScript = '
					-- Aggiorna TbAdmDhForm

					UPDATE TbAdmDhForm
					SET    
					FrmDesc = drvStd.FrmDesc, 
					FrmDefinition = drvStd.FrmDefinition, 
                    FrmCode =  drvStd.FrmCode,
					IdGuid = drvStd.IdGuid, 
					CodFnzStato = drvStd.CodFnzStato , 
					SysDateUpdate = GETDATE(), 
					SysUserUpdate = ''Cybe''
					FROM  TbAdmDhForm INNER JOIN
					##TbAdmDhForm AS drvStd ON TbAdmDhForm.FrmName = drvStd.FrmName
					
					-- Inserisce TbAdmDhForm
					INSERT INTO TbAdmDhForm
					(FrmName, FrmDesc, FrmDefinition,FrmCode, IdGuid, CodFnzStato, SysDateCreate, SysUserCreate)
					SELECT drvStd.FrmName, drvStd.FrmDesc, drvStd.FrmDefinition, drvStd.FrmCode, drvStd.IdGuid, drvStd.CodFnzStato, GETDATE() AS SysDateCreate, ''Cybe'' as SysUserCreate 
					FROM ##TbAdmDhForm AS drvStd LEFT OUTER JOIN
					TbAdmDhForm on TbAdmDhForm.FrmName = drvStd.FrmName
					WHERE (TbAdmDhForm.FrmName IS NULL)
										'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'SELECT 
									IdForm, FrmName, FrmDesc, FrmDefinition, 
									IdGuid, CodFnzStato, FrmCode
									FROM  TbAdmDhForm
									',
					@TbOutName = N'TbAdmDhForm',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 

            --------------------------------
			-- EXPORT TbAdmDhAlias
			--------------------------------

			SET @SqlScript = '
					-- Aggiorna TbAdmDhAlias

					UPDATE TbAdmDhAlias
					SET    
					DboHFrmName = drvStd.DboHFrmName,
					SysDateUpdate = GETDATE(), 
					SysUserUpdate = ''Cybe''
					FROM  TbAdmDhAlias INNER JOIN
					##TbAdmDhAlias AS drvStd ON TbAdmDhAlias.DboFrmName = drvStd.DboFrmName
					
					-- Inserisce TbAdmDhAlias
					INSERT INTO TbAdmDhAlias
					(DboFrmName, DboHFrmName, SysDateCreate, SysUserCreate)
					SELECT drvStd.DboFrmName, drvStd.DboHFrmName, GETDATE() AS SysDateCreate, ''Cybe'' as SysUserCreate 
					FROM ##TbAdmDhAlias AS drvStd LEFT OUTER JOIN
					TbAdmDhAlias on TbAdmDhAlias.DboFrmName = drvStd.DboFrmName
					WHERE (TbAdmDhAlias.DboFrmName IS NULL)
										'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'SELECT 
									DboFrmName, DboHFrmName
									FROM  TbAdmDhAlias
									',
					@TbOutName = N'TbAdmDhAlias',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 

			--------------------------------
			-- EXPORT TbAdmDhSqlCommand
			--------------------------------

			SET @SqlScript = '

					-- Aggiorna GUID se inserimento manuale per allineare le chiavi

					UPDATE TbAdmDhSqlCommand
					SET    
					IdGuid = drvStd.IdGuid,
					SysDateUpdate = GETDATE(), 
					SysUserUpdate = ''Cybe''
					FROM  TbAdmDhSqlCommand INNER JOIN
					##TbAdmDhSqlCommand AS drvStd ON TbAdmDhSqlCommand.CmdName = drvStd.CmdName

					-- Aggiorna TbAdmDhSqlCommand

					UPDATE TbAdmDhSqlCommand
					SET    
					CmdName = drvStd.CmdName, 
					CmdDesc = drvStd.CmdDesc, 
					CmdSql = drvStd.CmdSql, 
					CmdFilter = drvStd.CmdFilter, 
					CodFnzTipo = drvStd.CodFnzTipo, 
					CodFnzStato = drvStd.CodFnzStato, 
					CmdTimeout = drvStd.CmdTimeout, 
					SysDateUpdate = GETDATE(), 
					SysUserUpdate = ''Cybe''
					FROM  TbAdmDhSqlCommand INNER JOIN
					##TbAdmDhSqlCommand AS drvStd ON TbAdmDhSqlCommand.IdGuid = drvStd.IdGuid

					
					-- Inserisce TbAdmDhSqlCommand
					INSERT INTO TbAdmDhSqlCommand
					(CmdName, CmdDesc, CmdSql, CmdFilter, CmdOrderBy, CodFnzTipo, CodFnzStato, IdGuid, CmdTimeout, SysUSerCreate, SysDateCreate)
					SELECT drvStd.CmdName, drvStd.CmdDesc, drvStd.CmdSql, drvStd.CmdFilter, drvStd.CmdOrderBy, drvStd.CodFnzTipo, drvStd.CodFnzStato, drvStd.IdGuid, drvStd.CmdTimeout, ''Cybe'' AS SysUSerCreate, Getdate()  AS SysDateCreate
					FROM  ##TbAdmDhSqlCommand AS drvStd LEFT OUTER JOIN
					TbAdmDhSqlCommand AS TbAdmDhSqlCommand_1 ON TbAdmDhSqlCommand_1.IdGuid = drvStd.IdGuid
					WHERE (TbAdmDhSqlCommand_1.IdCmd IS NULL)
                    '

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'SELECT 
									IdCmd, CmdName, CmdDesc, CmdSql, CmdFilter, CmdOrderBy, 
									CodFnzTipo, CodFnzStato, 
									IdGuid, CmdTimeout
									FROM  TbAdmDhSqlCommand AS drvStd
									',
					@TbOutName = N'TbAdmDhSqlCommand',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 


			--------------------------------
			-- EXPORT TbAdmDhCommand
			--------------------------------

			-- Inserisce nuovi comandi di dbo in dboh

			INSERT INTO TbAdmDhCommand
			(NameCommand, DescCommand, TypeCommand, FormKey, TableStart, ColumnsStart, TableOpen, FormOpen, Command, StoreProcedure, CodFnzPos, Ordinamento, Gruppo, TimeoutCommand, IdGuid, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, ViewInfo, Disabilita, NoteCommand, CodFnzTipo)
			SELECT TbSettingCommand.NameCommand, TbSettingCommand.DescCommand, TbSettingCommand.TypeCommand, TbSettingCommand.FormKey, TbSettingCommand.TableStart, TbSettingCommand.ColumnsStart, TbSettingCommand.TableOpen, TbSettingCommand.FormOpen, TbSettingCommand.Command, TbSettingCommand.StoreProcedure, TbSettingCommand.CodFnzPos, 
			TbSettingCommand.Ordinamento, TbSettingCommand.Gruppo, TbSettingCommand.TimeoutCommand, TbSettingCommand.IdGuid, TbSettingCommand.SysDateCreate, TbSettingCommand.SysUserCreate, TbSettingCommand.SysDateUpdate, TbSettingCommand.SysUserUpdate, TbSettingCommand.ViewInfo, TbSettingCommand.Disabilita, TbSettingCommand.NoteCommand, 
			TbSettingCommand.CodFnzTipo
			FROM  TbSettingCommand LEFT OUTER JOIN
			TbAdmDhCommand ON TbAdmDhCommand.IdGuid = TbSettingCommand.IdGuid
			WHERE (TbAdmDhCommand.IdGuid IS NULL)
			ORDER BY TbSettingCommand.IdCmd

            -- dav 230227 Gestione aggiornmaneto TbAdmDhCommand
            UPDATE TbAdmDhCommand
            SET 
                NameCommand = TmpDbo.NameCommand,
                DescCommand = TmpDbo.DescCommand,
                TypeCommand = TmpDbo.TypeCommand,
                --FormKey = TmpDbo.FormKey,
                TableStart = TmpDbo.TableStart,
                ColumnsStart = TmpDbo.ColumnsStart,
                TableOpen = TmpDbo.TableOpen,
                --FormOpen = TmpDbo.FormOpen,
                Command = TmpDbo.Command,
                StoreProcedure = TmpDbo.StoreProcedure,
                CodFnzPos = TmpDbo.CodFnzPos,
                --Ordinamento = TmpDbo.Ordinamento,
                Gruppo = TmpDbo.Gruppo,
                TimeoutCommand = TmpDbo.TimeoutCommand,
                ViewInfo = TmpDbo.ViewInfo,
                --Disabilita = TmpDbo.Disabilita,
                NoteCommand = TmpDbo.NoteCommand
            FROM TbSettingCommand AS TmpDbo
            INNER JOIN TbAdmDhCommand
                ON TmpDbo.IdGuid = TbAdmDhCommand.IdGuid
            WHERE (TmpDbo.CodFnzTipo IN ('INS', 'UPD'))

            -- Contrassegna record doppi

            DECLARE @I AS INT = 0
            WHILE @I < 10
            BEGIN
                SET @I = @I + 1
                Update TbAdmDhCommand
                SET TbAdmDhCommand.NameCommand = LEFT('#E00001-ComandoDoppio#' + TbAdmDhCommand.NameCommand,50)
                WHERE IdGuid IN (
                select max(IdGuid)
                FROM  TbAdmDhCommand 
                WHERE LEFT (TbAdmDhCommand.NameCommand,7) <> '#E00001'
                Group by
                TbAdmDhCommand.NameCommand,TbAdmDhCommand.TypeCommand,TbAdmDhCommand.FormKey,TbAdmDhCommand.TableStart,
                TbAdmDhCommand.CodFnzPos,TbAdmDhCommand.ColumnsStart,TbAdmDhCommand.TableOpen,TbAdmDhCommand.FormOpen,
                TbAdmDhCommand.StoreProcedure,TbAdmDhCommand.ViewInfo
                having count(1) > 1)

                IF @@Rowcount > 0 
                BEGIN
                    Print 'Comandi doppi individuati e contrassegnati'
                END
                ELSE
                BEGIN
                    SET @I = 10
                END

            END

            -- Select * from TbAdmDhCommand  WHERE LEFT (TbAdmDhCommand.NameCommand,7) = '#E00001'

			SET @SqlScript = '
					
                    -- Contrassegna comandi doppi

                    DECLARE @I_ctrl AS INT = 0
                    WHILE @I_ctrl < 10
                    BEGIN
                        SET @I_ctrl = @I_ctrl + 1
                        
                        Update TbAdmDhCommand
                        SET 
                            TbAdmDhCommand.NameCommand = LEFT(''#E00001-ComandoDoppio#'' + TbAdmDhCommand.NameCommand,50),
                            IdGuid = NEWID()
                        WHERE IdGuid IN (
                        select max(IdGuid)
                        FROM  TbAdmDhCommand 
                        WHERE LEFT (TbAdmDhCommand.NameCommand,7) <> ''#E00001''
                        Group by
                        TbAdmDhCommand.NameCommand,TbAdmDhCommand.TypeCommand,TbAdmDhCommand.FormKey,TbAdmDhCommand.TableStart,
                        TbAdmDhCommand.CodFnzPos,TbAdmDhCommand.ColumnsStart,TbAdmDhCommand.TableOpen,TbAdmDhCommand.FormOpen,
                        TbAdmDhCommand.StoreProcedure,TbAdmDhCommand.ViewInfo
                        having count(1) > 1)

                        IF @@Rowcount > 0 
                        BEGIN
                            Print ''Comandi doppi individuati e contrassegnati''
                        END
                        ELSE
                        BEGIN
                            SET @I_ctrl = 10
                        END
                    END

					-- Aggiorna IdGuid per comandi inseriti manualmente

					UPDATE TbAdmDhCommand
					SET    IdGuid = TmpDbo.IdGuid
					FROM  TbAdmDhCommand INNER JOIN
					##TbAdmDhCommand  TmpDbo ON 
					ISNULL(TbAdmDhCommand.NameCommand,'''') = ISNULL(TmpDbo.NameCommand,'''') AND 
					ISNULL(TbAdmDhCommand.TypeCommand,'''') = ISNULL(TmpDbo.TypeCommand,'''') AND 
					ISNULL(TbAdmDhCommand.FormKey,'''') = ISNULL(TmpDbo.FormKey,'''') AND 
					ISNULL(TbAdmDhCommand.TableStart,'''') = ISNULL(TmpDbo.TableStart,'''') AND 
					ISNULL(TbAdmDhCommand.CodFnzPos,'''') = ISNULL(TmpDbo.CodFnzPos,'''') AND 
					ISNULL(TbAdmDhCommand.ColumnsStart,'''') = ISNULL(TmpDbo.ColumnsStart,'''') AND 
					ISNULL(TbAdmDhCommand.TableOpen,'''') = ISNULL(TmpDbo.TableOpen,'''') AND 
					ISNULL(TbAdmDhCommand.FormOpen,'''') = ISNULL(TmpDbo.FormOpen,'''') AND 
					ISNULL(TbAdmDhCommand.StoreProcedure,'''') = ISNULL(TmpDbo.StoreProcedure,'''') AND 
					ISNULL(TbAdmDhCommand.ViewInfo,'''') = ISNULL(TmpDbo.ViewInfo,'''') AND 
					TbAdmDhCommand.IdGuid <> TmpDbo.IdGuid 
                    WHERE
					TmpDbo.IdGuid NOT IN (SELECT IdGuid FROM TbAdmDhCommand)

					-- Aggiorna righe di tipo INS e UPD

					UPDATE TbAdmDhCommand
					SET   Disabilita = TmpDbo.Disabilita
					FROM TbAdmDhCommand  INNER JOIN
					##TbAdmDhCommand AS TmpDbo ON TmpDbo.IdGuid = TbAdmDhCommand.IdGuid
					WHERE (TmpDbo.CodFnzTipo IN (''INS'',''UPD''))

                    -- Aggiorna sempre tutto, ## da definire in seguito le personalizzazioni

					UPDATE TbAdmDhCommand
                    SET [NameCommand] = TmpDbo.NameCommand,
                        [DescCommand] = TmpDbo.DescCommand,
                        [TypeCommand] = TmpDbo.TypeCommand,
                        [FormKey] = TmpDbo.FormKey,
                        [TableStart] = TmpDbo.TableStart,
                        [ColumnsStart] = TmpDbo.ColumnsStart,
                        [TableOpen] = TmpDbo.TableOpen,
                        [FormOpen] = TmpDbo.FormOpen,
                        [Command] = TmpDbo.Command,
                        [StoreProcedure] = TmpDbo.StoreProcedure,
                        [CodFnzPos] = TmpDbo.CodFnzPos,
                        [Ordinamento] = TmpDbo.Ordinamento,
                        [Gruppo] = TmpDbo.Gruppo,
                        [TimeoutCommand] = TmpDbo.TimeoutCommand,
                        [IdGuid] = TmpDbo.IdGuid,
                        [ViewInfo] = TmpDbo.ViewInfo,
                        [NoteCommand] = TmpDbo.NoteCommand,
                        [CodFnzTipo] = TmpDbo.CodFnzTipo,
                        [CmdSql] = TmpDbo.CmdSql,
                        [CmdFilter] = TmpDbo.CmdFilter,
                        [CmdOrderBy] = TmpDbo.CmdOrderBy,
                        [IdImage] = TmpDbo.IdImage
                    FROM TbAdmDhCommand
                    INNER JOIN ##TbAdmDhCommand AS TmpDbo
                        ON TmpDbo.IdGuid = TbAdmDhCommand.IdGuid

                    -- Contrassegna comandi personalizzati come tali

					UPDATE TbAdmDhCommand
                    SET 
                        [DescCommand] = ''°'' + TmpDbo.DescCommand,
                        [CodFnzTipo] = ''PRS''
                    FROM TbAdmDhCommand
                    LEFT OUTER JOIN ##TbAdmDhCommand AS TmpDbo
                        ON TmpDbo.IdGuid = TbAdmDhCommand.IdGuid
                    WHERE
                        TmpDbo.IdGuid IS NULL AND
                        ISNULL(TbAdmDhCommand.[CodFnzTipo],'''') <> ''PRS''

                    -- Aggiunge in tabella dei comandi standard dboh disabilitati

					INSERT INTO TbAdmDhCommand
					(NameCommand, DescCommand,CmdSql, CmdFilter, CmdOrderBy, TypeCommand, FormKey, TableStart, 
									ColumnsStart, TableOpen, FormOpen, Command, StoreProcedure, CodFnzPos, 
									Ordinamento, Gruppo, TimeoutCommand, IdGuid, ViewInfo, Disabilita, NoteCommand, CodFnzTipo, IdKey, SysDateCreate, SysUserCreate)
					SELECT TmpDbo.NameCommand, TmpDbo.DescCommand, TmpDbo.CmdSql, TmpDbo.CmdFilter, TmpDbo.CmdOrderBy, TmpDbo.TypeCommand, TmpDbo.FormKey, TmpDbo.TableStart, TmpDbo.ColumnsStart, TmpDbo.TableOpen, TmpDbo.FormOpen, TmpDbo.Command, TmpDbo.StoreProcedure, TmpDbo.CodFnzPos, 
					TmpDbo.Ordinamento, TmpDbo.Gruppo, TmpDbo.TimeoutCommand, TmpDbo.IdGuid, TmpDbo.ViewInfo, 
					1 as Disabilita, TmpDbo.NoteCommand, TmpDbo.CodFnzTipo, TmpDbo.IdKey, GETDATE(), ''cybe''
					FROM ##TbAdmDhCommand TmpDbo  LEFT OUTER JOIN
					TbAdmDhCommand ON TbAdmDhCommand.IdGuid = TmpDbo.IdGuid
					WHERE (TbAdmDhCommand.IdGuid IS NULL)
					ORDER BY TmpDbo.IdCmd

					'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'	SELECT NameCommand, DescCommand,CmdSql, CmdFilter, CmdOrderBy, TypeCommand, FormKey, TableStart, 
									ColumnsStart, TableOpen, FormOpen, Command, StoreProcedure, CodFnzPos, 
									Ordinamento, Gruppo, TimeoutCommand, IdGuid, ViewInfo, Disabilita, NoteCommand, CodFnzTipo, IdKey, IdCmd, IdImage
									FROM  TbAdmDhCommand
                                    WHERE LEFT (TbAdmDhCommand.NameCommand,7) <> ''#E00001''
                                    ',
					@TbOutName = N'TbAdmDhCommand',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 


			--------------------------------
			-- EXPORT TbMntObjVrs
			--------------------------------

			SET @SqlScript = '
					-- Elimina versioning
					Delete from TbMntObjVrs

					-- Inserisce versioning
					INSERT INTO TbMntObjVrs
					(IdObjVrs, IdVrs, IdObject, DescVrs,NoteVrs, CodFnzAmbito)
					SELECT   TmpDbo.IdObjVrs, TmpDbo.IdVrs, TmpDbo.IdObject, TmpDbo.DescVrs, 
					TmpDbo.NoteVrs, TmpDbo.CodFnzAmbito
					FROM   ##TbMntObjVrs TmpDbo
					WHERE IdObject in (SELECT IdObject From TbMntObjHelp)
					'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'SELECT IdObjVrs, IdVrs, IdObject, DescVrs, NoteVrs, CodFnzAmbito
									FROM TbMntObjVrs 
									WHERE 
									IdVrs <= CONVERT(NVARCHAR(20),GETDATE(),12)
									AND LEN(IdVrs) = 6
									AND ISNUMERIC(IdVrs) = 1
                                    AND FlgRilascio = 1
									',
					@TbOutName = N'TbMntObjVrs',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 

			--------------------------------
			-- EXPORT TbSettingMenu
			-- Decidere che voci attivare
			--------------------------------

			SET @SqlScript = '
					-- Aggiunge righe di tipo ins

					Declare @IdMenuPadre as int
					Select @IdMenuPadre = IdMenu From TbSettingMenu where Descrizione =''Setting''
					IF NOT EXISTS(SELECT IdMenu FROM TbSettingMenu  where Descrizione =''New'' and IdMenuPadre = @IdMenuPadre)
						BEGIN
							INSERT INTO TbSettingMenu
							(IdMenuPadre, Ordinamento, Descrizione, SysUserCreate, SysDateUpdate)
							VALUES (@IdMenuPadre, 99, N''New'', N''Cybe'', GETDATE())
						END
					Select @IdMenuPadre = IdMenu From TbSettingMenu where Descrizione =''New'' and IdMenuPadre = @IdMenuPadre

					If @IdMenuPadre is not null
					BEGIN
					
						INSERT INTO TbSettingMenu
						(IdMenuPadre, Descrizione, SysUserCreate, SysDateUpdate, IdGuid, Comando, Comando1)
						SELECT @IdMenuPadre, TmpDbo.Descrizione, ''Cybe'', SysDateUpdate, TmpDbo.IdGuid, TmpDbo.Comando, TmpDbo.Comando1
						FROM  ##TbSettingMenu AS TmpDbo LEFT OUTER JOIN
						TbSettingMenu AS TbSettingMenu_1 ON TmpDbo.IdGuid = TbSettingMenu_1.IdGuid
						WHERE (TmpDbo.CodFnzTipo IN (''INS'')) 
						AND (TbSettingMenu_1.IdMenu IS NULL)
					END
					'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'SELECT IdMenu, IdGruppoMenu, IdMenuPadre, Ordinamento, Descrizione, Comando, Comando1, Colore, Note, Tipo, IdGuid, ClassImg, FlgPortal, Disabilita, IdModulo, CodFnzTipo
									FROM  TbSettingMenu',
					@TbOutName = N'TbSettingMenu',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 

			
			--------------------------------
			-- EXPORT TbSettingCommand
			--------------------------------

            -- Contrassegna record doppi

            Update TbSettingCommand
            SET TbSettingCommand.NameCommand = LEFT('#E00001-ComandoDoppio#' + TbSettingCommand.NameCommand,50)
            WHERE IdGuid IN (
            select max(IdGuid)
            FROM  TbSettingCommand 
            WHERE LEFT (TbSettingCommand.NameCommand,7) <> '#E00001'
            Group by
            TbSettingCommand.NameCommand,TbSettingCommand.TypeCommand,TbSettingCommand.FormKey,TbSettingCommand.TableStart,
            TbSettingCommand.CodFnzPos,TbSettingCommand.ColumnsStart,TbSettingCommand.TableOpen,TbSettingCommand.FormOpen,
            TbSettingCommand.StoreProcedure,TbSettingCommand.ViewInfo
            having count(1) > 1)

			SET @SqlScript = '
					
					-- Aggiunge in tabella dei comandi standard dbo

					Truncate Table TbSettingCommandStd

					INSERT INTO TbSettingCommandStd
					(NameCommand, DescCommand, TypeCommand, FormKey, TableStart, ColumnsStart, TableOpen, FormOpen, Command, StoreProcedure, CodFnzPos, Ordinamento, Gruppo, TimeoutCommand, IdGuid, ViewInfo, Disabilita,CodFnzTipo,NoteCommand)
					SELECT TmpDbo.NameCommand, TmpDbo.DescCommand, TmpDbo.TypeCommand, TmpDbo.FormKey, TmpDbo.TableStart, TmpDbo.ColumnsStart, TmpDbo.TableOpen, TmpDbo.FormOpen, TmpDbo.Command, TmpDbo.StoreProcedure, 
					TmpDbo.CodFnzPos, TmpDbo.Ordinamento, TmpDbo.Gruppo, TmpDbo.TimeoutCommand, TmpDbo.IdGuid, TmpDbo.ViewInfo, TmpDbo.Disabilita, TmpDbo.CodFnzTipo, TmpDbo.NoteCommand
					FROM  ##TbSettingCommand AS TmpDbo 

                    -- Controlla e contrassegna comandi doppi

                    Update TbSettingCommand
                    SET 
                    TbSettingCommand.NameCommand = LEFT(''#E00001-ComandoDoppio#'' + TbSettingCommand.NameCommand,50),
                    IdGuid = NewId()
                    WHERE IdGuid IN (
                    select max(IdGuid)
					FROM  TbSettingCommand 
                    WHERE LEFT (TbSettingCommand.NameCommand,7) <> ''#E00001''
                    Group by
                    TbSettingCommand.NameCommand,TbSettingCommand.TypeCommand,TbSettingCommand.FormKey,TbSettingCommand.TableStart,
                    TbSettingCommand.CodFnzPos,TbSettingCommand.ColumnsStart,TbSettingCommand.TableOpen,TbSettingCommand.FormOpen,
                    TbSettingCommand.StoreProcedure,TbSettingCommand.ViewInfo
                    having count(1) > 1)

					-- Aggiorna IdGuid per comandi inseriti manualmente

					UPDATE TbSettingCommand
					SET    IdGuid = TmpDbo.IdGuid
					FROM  TbSettingCommand INNER JOIN
					##TbSettingCommand  TmpDbo ON 
					ISNULL(TbSettingCommand.NameCommand,'''') = ISNULL(TmpDbo.NameCommand,'''') AND 
					ISNULL(TbSettingCommand.TypeCommand,'''') = ISNULL(TmpDbo.TypeCommand,'''') AND 
					ISNULL(TbSettingCommand.FormKey,'''') = ISNULL(TmpDbo.FormKey,'''') AND 
					ISNULL(TbSettingCommand.TableStart,'''') = ISNULL(TmpDbo.TableStart,'''') AND 
					ISNULL(TbSettingCommand.CodFnzPos,'''') = ISNULL(TmpDbo.CodFnzPos,'''') AND 
					ISNULL(TbSettingCommand.ColumnsStart,'''') = ISNULL(TmpDbo.ColumnsStart,'''') AND 
					ISNULL(TbSettingCommand.TableOpen,'''') = ISNULL(TmpDbo.TableOpen,'''') AND 
					ISNULL(TbSettingCommand.FormOpen,'''') = ISNULL(TmpDbo.FormOpen,'''') AND 
					ISNULL(TbSettingCommand.StoreProcedure,'''') = ISNULL(TmpDbo.StoreProcedure,'''') AND 
					ISNULL(TbSettingCommand.ViewInfo,'''') = ISNULL(TmpDbo.ViewInfo,'''') AND 
					TbSettingCommand.IdGuid <> TmpDbo.IdGuid 

					-- Aggiunge righe di tipo INS

					INSERT INTO TbSettingCommand
					(NameCommand, DescCommand, TypeCommand, FormKey, TableStart, ColumnsStart, TableOpen, FormOpen, Command, StoreProcedure, CodFnzPos, Ordinamento, Gruppo, TimeoutCommand, IdGuid, ViewInfo, Disabilita, NoteCommand)
					SELECT TmpDbo.NameCommand, TmpDbo.DescCommand, TmpDbo.TypeCommand, TmpDbo.FormKey, TmpDbo.TableStart, TmpDbo.ColumnsStart, TmpDbo.TableOpen, TmpDbo.FormOpen, TmpDbo.Command, TmpDbo.StoreProcedure, 
					TmpDbo.CodFnzPos, TmpDbo.Ordinamento, TmpDbo.Gruppo, TmpDbo.TimeoutCommand, TmpDbo.IdGuid, TmpDbo.ViewInfo, TmpDbo.Disabilita, TmpDbo.NoteCommand
					FROM  ##TbSettingCommand AS TmpDbo LEFT OUTER JOIN
					TbSettingCommand AS TbSettingCommand_1 ON TmpDbo.IdGuid = TbSettingCommand_1.IdGuid
					WHERE (TmpDbo.CodFnzTipo IN (''INS'')) 
					AND (TbSettingCommand_1.IdCmd IS NULL)
					
					-- Aggiorna righe di tipo INS e UPD

					UPDATE TbSettingCommand
					SET    NameCommand = TmpDbo.NameCommand, DescCommand = TmpDbo.DescCommand, TypeCommand = TmpDbo.TypeCommand, FormKey = TmpDbo.FormKey, TableStart = TmpDbo.TableStart, ColumnsStart = TmpDbo.ColumnsStart, TableOpen = TmpDbo.TableOpen, 
					FormOpen = TmpDbo.FormOpen, Command = TmpDbo.Command, StoreProcedure = TmpDbo.StoreProcedure, CodFnzPos = TmpDbo.CodFnzPos, Ordinamento = TmpDbo.Ordinamento, Gruppo = TmpDbo.Gruppo, TimeoutCommand = TmpDbo.TimeoutCommand, ViewInfo = TmpDbo.ViewInfo, 
					Disabilita = TmpDbo.Disabilita, NoteCommand = TmpDbo.NoteCommand
					FROM  ##TbSettingCommand AS TmpDbo INNER JOIN
					TbSettingCommand ON TmpDbo.IdGuid = TbSettingCommand.IdGuid
					WHERE (TmpDbo.CodFnzTipo IN (''INS'',''UPD''))

					'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'	SELECT NameCommand, DescCommand, TypeCommand, FormKey, TableStart, 
									ColumnsStart, TableOpen, FormOpen, Command, StoreProcedure, CodFnzPos, 
									Ordinamento, Gruppo, TimeoutCommand, IdGuid, ViewInfo, Disabilita, NoteCommand, CodFnzTipo, IdKey
									FROM  TbSettingCommand
                                    WHERE LEFT (TbSettingCommand.NameCommand,7) <> ''#E00001''
                                    ',
					@TbOutName = N'TbSettingCommand',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 

			--------------------------------
			-- EXPORT TbSettingRepport
			--------------------------------

			SET @SqlScript = '
					
					-- Aggiunge in tabella dei comandi standard dbo

					Truncate Table TbSettingReportStd

					INSERT INTO TbSettingReportStd
					(Id, NomeForm, NomeReport, DescReport, UrlReport, 
					FlgRptServer, FlgRptPdf, FlgRptXls, FlgRptPdfMail, 
					FlgRptXlsMail, MailOggetto, MailTesto, Mailto, 
					Ordinamento, StoreProcedure, EntityName, IdGuid,  FlgRptPdfMulti, 
					FlgRptDoc, KeyReport, FlgRptPdf_Storico, NoteReport, FlgFascia, XMLFascia, 
					FlgRptCsv, FlgRptCsvMail, Disabilita, CodFnzTipo)
					SELECT TmpDbo.Id, TmpDbo.NomeForm, TmpDbo.NomeReport, TmpDbo.DescReport, TmpDbo.UrlReport, 
					TmpDbo.FlgRptServer, TmpDbo.FlgRptPdf, TmpDbo.FlgRptXls, TmpDbo.FlgRptPdfMail, 
					TmpDbo.FlgRptXlsMail, TmpDbo.MailOggetto, TmpDbo.MailTesto, TmpDbo.Mailto, 
					TmpDbo.Ordinamento, TmpDbo.StoreProcedure, TmpDbo.EntityName, TmpDbo.IdGuid,  TmpDbo.FlgRptPdfMulti, 
					TmpDbo.FlgRptDoc, TmpDbo.KeyReport, TmpDbo.FlgRptPdf_Storico, TmpDbo.NoteReport, 
					TmpDbo.FlgFascia, TmpDbo.XMLFascia, 
					TmpDbo.FlgRptCsv, TmpDbo.FlgRptCsvMail, TmpDbo.Disabilita, TmpDbo.CodFnzTipo
					FROM  ##TbSettingReport AS TmpDbo 

					-- Aggiorna Url report standard

					UPDATE TbSettingReport
					SET    UrlReport = TbSettingReportStd.UrlReport
					FROM  TbSettingReportStd INNER JOIN
					TbSettingReport ON 
					TbSettingReport.IdGuid = TbSettingReportStd.IdGuid AND 
					TbSettingReport.UrlReport <> TbSettingReportStd.UrlReport

					-- Aggiorna dati fascia

					UPDATE TbSettingReport
					SET 
					FlgFascia = TbSettingReportStd.FlgFascia,
					XMLFascia = TbSettingReportStd.XMLFascia
					FROM TbSettingReportStd INNER JOIN
					TbSettingReport ON 
					TbSettingReport.IdGuid = TbSettingReportStd.IdGuid AND 
					isnull(TbSettingReport.XMLFascia,'''') <> isnull(TbSettingReportStd.XMLFascia,'''')

					'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'	SELECT Id, NomeForm, NomeReport, DescReport, UrlReport, FlgRptServer, FlgRptPdf, FlgRptXls, FlgRptPdfMail, FlgRptXlsMail, MailOggetto, MailTesto, Mailto, Ordinamento, StoreProcedure, EntityName, IdGuid,  FlgRptPdfMulti, FlgRptDoc, KeyReport, FlgRptPdf_Storico, NoteReport, FlgFascia, XMLFascia, 
									FlgRptCsv, FlgRptCsvMail, Disabilita, CodFnzTipo
									FROM  TbSettingReport
									WHERE DataRilascio <= Getdate() ',
					@TbOutName = N'TbSettingReport',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 

			--------------------------------
			-- EXPORT TbSettingKey
			--------------------------------

			SET @SqlScript = '
					
					Truncate Table TbSettingKeyStd

					INSERT INTO TbSettingKeyStd
					(IdKey, Value, CodFnz, NoteSetting, IdGuid, CodFnzTipo, DescSetting)
					SELECT TmpDbo.IdKey, TmpDbo.Value, TmpDbo.CodFnz, TmpDbo.NoteSetting, TmpDbo.IdGuid, TmpDbo.CodFnzTipo, TmpDbo.DescSetting
					FROM  ##TbSettingKey AS TmpDbo

					-- Aggiorna descrizioni in TbSettingKey

					UPDATE TbSettingKey
					SET    CodFnz = TmpDbo.CodFnz, NoteSetting = TmpDbo.NoteSetting, IdGuid = TmpDbo.IdGuid, CodFnzTipo = TmpDbo.CodFnzTipo, DescSetting = TmpDbo.DescSetting
					FROM  TbSettingKeyStd AS TmpDbo INNER JOIN
					TbSettingKey ON TmpDbo.IdKey = TbSettingKey.IdKey

					-- Aggiunge nuove chiavi KEY, KEYE

					INSERT INTO TbSettingKey
					(IdKey, Value, CodFnz, NoteSetting, IdGuid, DescSetting)
					SELECT TmpDboKey.IdKey, NULL AS Value, TmpDboKey.CodFnz, TmpDboKey.NoteSetting, TmpDboKey.IdGuid, TmpDboKey.DescSetting
					FROM TbSettingKeyStd AS TmpDboKey LEFT OUTER JOIN
					TbSettingKey AS TbSettingKey_1 ON TmpDboKey.IdKey = TbSettingKey_1.IdKey
					WHERE TbSettingKey_1.idkey is null
					AND isnull(TmpDboKey.CodFnz,'''') IN ( ''KEYE'',''KEY'')
						
					Print ''      >> Inserimento nuove chiavi''
					
					-- Aggiunge righe di tipo INS  in base a TbSettingCommand

					INSERT INTO TbSettingKey
					(IdKey, Value, CodFnz, NoteSetting, IdGuid, DescSetting)
					SELECT TmpDboKey.IdKey, TmpDboKey.Value, TmpDboKey.CodFnz, TmpDboKey.NoteSetting, TmpDboKey.IdGuid, TmpDboKey.DescSetting
					FROM  ##TbSettingCommand AS TmpDbo INNER JOIN
					##TbSettingKey AS TmpDboKey ON TmpDbo.IdKey = TmpDboKey.IdKey LEFT OUTER JOIN
					TbSettingKey AS TbSettingKey_1 ON TmpDboKey.IdKey = TbSettingKey_1.IdKey
					WHERE (TmpDbo.CodFnzTipo IN (''INS'')) AND (TbSettingKey_1.IdKey IS NULL)
					
					-- Aggiorna righe di tipo INS e UPD in base a TbSettingCommand

					UPDATE TbSettingKey
					SET    Value = TmpDboKey.Value, CodFnz = TmpDboKey.CodFnz, NoteSetting = TmpDboKey.NoteSetting, IdGuid = TmpDboKey.IdGuid, CodFnzTipo = TmpDboKey.CodFnzTipo, DescSetting = TmpDboKey.DescSetting
					FROM  ##TbSettingCommand AS TmpDbo INNER JOIN
					##TbSettingKey AS TmpDboKey ON TmpDbo.IdKey = TmpDboKey.IdKey INNER JOIN
					TbSettingKey ON TmpDboKey.IdKey = TbSettingKey.IdKey
					WHERE (TmpDbo.CodFnzTipo IN (''INS'',''UPD''))


					-- Aggiunge righe di tipo ins e upd in base a settingkey

					INSERT INTO TbSettingKey
					(IdKey, Value, CodFnz, NoteSetting, IdGuid, DescSetting)
					SELECT TmpDboKey.IdKey, NULL AS Value, TmpDboKey.CodFnz, TmpDboKey.NoteSetting, TmpDboKey.IdGuid, TmpDboKey.DescSetting
					FROM  ##TbSettingKey AS TmpDboKey LEFT OUTER JOIN
					TbSettingKey AS TbSettingKey_1 ON TmpDboKey.IdKey = TbSettingKey_1.IdKey
					WHERE (TmpDboKey.CodFnzTipo IN (''INS'')) AND (TbSettingKey_1.IdKey IS NULL)
					
					-- Aggiorna righe di tipo INS e UPD in base a settingkey (non il valore)

					UPDATE TbSettingKey
					SET 
					CodFnz = TmpDboKey.CodFnz, 
					NoteSetting = TmpDboKey.NoteSetting, IdGuid = TmpDboKey.IdGuid, CodFnzTipo = TmpDboKey.CodFnzTipo, DescSetting = TmpDboKey.DescSetting
					FROM  ##TbSettingKey AS TmpDboKey  INNER JOIN
					TbSettingKey ON TmpDboKey.IdKey = TbSettingKey.IdKey
					WHERE (TmpDboKey.CodFnzTipo IN (''INS'',''UPD''))

					-- Aggiorna righe di tipo INS e UPD in base a settingkey (il valore se chiave di tipo xml)

					UPDATE TbSettingKey
					SET    Value = TmpDboKey.Value
					FROM  ##TbSettingKey AS TmpDboKey  INNER JOIN
					TbSettingKey ON TmpDboKey.IdKey = TbSettingKey.IdKey
					WHERE (TmpDboKey.CodFnzTipo IN (''INS'',''UPD''))
					AND TmpDboKey.value like''%<?xml version="1.0"?>%''

					'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'	SELECT IdKey, Value, CodFnz, NoteSetting, IdGuid, CodFnzTipo, DescSetting
									FROM  TbSettingKey',
					@TbOutName = N'TbSettingKey',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 

			--------------------------------
			-- EXPORT TbMntObjKey
			--------------------------------

			SET @SqlScript = '
					
					INSERT INTO TbMntObjKey
					(IdKey, IdObject)
					SELECT  TmpDbo.IdKey, TmpDbo.IdObject
					FROM  ##TbMntObjKey TmpDbo LEFT OUTER JOIN
					TbMntObjKey  ON TmpDbo.IdKey = TbMntObjKey.IdKey AND TmpDbo.IdObject = TbMntObjKey.IdObject
					WHERE TmpDbo.IdKey in (SELECT IdKey From TbSettingKey)
					AND TbMntObjKey.IdKey IS NULL
					
					'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'	SELECT IdKey, IdObject
									FROM  TbMntObjKey',
					@TbOutName = N'TbMntObjKey',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 

			--------------------------------
			-- EXPORT TbSettingCodFnz
			--------------------------------

			SET @SqlScript = '
					-- Elimina semafori
					DELETE FROM TbSettingCodFnz
					WHERE Tipo in (''sem1'', ''sem2'',''sem3'',''sem4'',''TbSettingAutoUpd'')
					and left (NomeTabella,4) not in (''FncX'',''VstX'')

					-- Inserisce semafori
					INSERT INTO TbSettingCodFnz
					(NomeTabella, CodFnz, Tipo, DescCodFnz, Gruppo, Ordinamento, IdGuid)
					SELECT        NomeTabella, CodFnz, Tipo, DescCodFnz, Gruppo, Ordinamento, IdGuid
					FROM      ##TbSettingCodFnz AS TmpDbo
					WHERE
                    (Tipo IN (''sem1'', ''sem2'', ''sem3'', ''sem4'',''TbSettingAutoUpd'')) 
                   

                    -- Inserisce INS se non già presente
					INSERT INTO TbSettingCodFnz
					(NomeTabella, CodFnz, Tipo, DescCodFnz, Gruppo, Ordinamento, IdGuid)
					SELECT        TmpDbo.NomeTabella, TmpDbo.CodFnz, TmpDbo.Tipo, TmpDbo.DescCodFnz, TmpDbo.Gruppo, TmpDbo.Ordinamento, TmpDbo.IdGuid
					FROM      ##TbSettingCodFnz AS TmpDbo
                    LEFT OUTER JOIN TbSettingCodFnz
                    ON TbSettingCodFnz.NomeTabella = TmpDbo.NomeTabella and TbSettingCodFnz.CodFnz = TmpDbo.CodFnz 
					WHERE
                    (TmpDbo.CodFnzTipo = ''INS'') AND
                    (TbSettingCodFnz.CodFnz is null)
                    
					'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'SELECT NomeTabella, CodFnz, Tipo, DescCodFnz, Gruppo, Ordinamento, IdGuid, CodFnzTipo
									FROM  TbSettingCodFnz',
					@TbOutName = N'TbSettingCodFnz',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 

			--------------------------------
			-- EXPORT TbSettingAutoUpd
			--------------------------------
			-- dav 210523 riabilitato, non aggiorna se nel db di destinazione il campo vale NOA
			SET @SqlScript = '

					INSERT INTO TbSettingAutoUpd
					(Tabella, Campo, StoreProcedure, CodFncAct, EntityRefresh, IdGuid)
					SELECT TmpDbo.Tabella, TmpDbo.Campo, TmpDbo.StoreProcedure, TmpDbo.CodFncAct, TmpDbo.EntityRefresh, TmpDbo.IdGuid
					FROM  ##TbSettingAutoUpd AS TmpDbo LEFT OUTER JOIN
					TbSettingAutoUpd  ON 
						TbSettingAutoUpd.Tabella = TmpDbo.Tabella AND 
						ISNULL(TbSettingAutoUpd.StoreProcedure,'''') = ISNULL(TmpDbo.StoreProcedure ,'''') AND 
						ISNULL(TbSettingAutoUpd.Campo,'''') = ISNULL(TmpDbo.Campo ,'''') AND
						(TbSettingAutoUpd.CodFncAct = TmpDbo.CodFncAct OR TbSettingAutoUpd.CodFncAct = ''NoA'')
					WHERE (TmpDbo.CodFncAct IN (''CLS'', ''CLSA'', ''OPN'',''INF'',''UPD'')) AND (TbSettingAutoUpd.IdAutoUpd IS NULL)
					'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'SELECT IdAutoUpd, Tabella, Campo, StoreProcedure, CodFncAct, EntityRefresh, IdGuid
									FROM  TbSettingAutoUpd',
					@TbOutName = N'TbSettingAutoUpd',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 

			--------------------------------
			-- EXPORT TbSysExecRequest
			--------------------------------
			SET @SqlScript = '

					INSERT INTO TbSysExecRequest
					(IdRequest)
					SELECT TmpDbo.IdRequest
					FROM  ##TbSysExecRequest AS TmpDbo LEFT OUTER JOIN
					TbSysExecRequest  ON 
						TbSysExecRequest.IdRequest = TmpDbo.IdRequest 
					WHERE (TbSysExecRequest.IdRequest IS NULL)
					'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'SELECT IdRequest
									FROM  TbSysExecRequest',
					@TbOutName = N'TbSysExecRequest',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 

			--------------------------------
			-- EXPORT TbMntTutorial
			--------------------------------

			SET @SqlScript = '
				
					INSERT INTO TbMntTutorial
					(IdTutorial, DescTutorial, UrlTutorial, NoteTutorial, CodFnzAmbito, CodFnzStato)
					SELECT IdTutorial, DescTutorial, UrlTutorial, NoteTutorial, CodFnzAmbito, CodFnzStato
					FROM  ##TbMntTutorial AS TbMntTutorial_STD
					WHERE TbMntTutorial_STD.IdTutorial NOT IN ( SELECT IdTutorial FROM TbMntTutorial)

					UPDATE TbMntTutorial
					SET UrlTutorial = TbMntTutorial_STD.UrlTutorial, DescTutorial = TbMntTutorial_STD.DescTutorial,
					NoteTutorial = TbMntTutorial_STD.NoteTutorial, CodFnzAmbito = TbMntTutorial_STD.CodFnzAmbito, CodFnzStato = TbMntTutorial_STD.CodFnzStato,
					SysDateUpdate = Getdate(), SysUserUpdate = ''Cybe''
					FROM  TbMntTutorial INNER JOIN
					##TbMntTutorial AS TbMntTutorial_STD ON TbMntTutorial.IdTutorial = TbMntTutorial_STD.IdTutorial


					'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'SELECT IdTutorial, DescTutorial, UrlTutorial, NoteTutorial, CodFnzAmbito, CodFnzStato
									FROM  TbMntTutorial
									WHERE DataRilascio <= Getdate() ',
					@TbOutName = N'TbMntTutorial',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 

			--------------------------------
			-- EXPORT TbMntObjTutorial
			--------------------------------

			SET @SqlScript = '

					INSERT INTO TbMntObjTutorial
					(IdObject, IdTutorial, RifTutorial)
					SELECT  TbMntObjTutorial_STD.IdObject, TbMntObjTutorial_STD.IdTutorial, TbMntObjTutorial_STD.RifTutorial
					FROM  ##TbMntObjTutorial AS TbMntObjTutorial_STD INNER JOIN
					TbMntTutorial ON TbMntObjTutorial_STD.IdTutorial = TbMntTutorial.IdTutorial LEFT OUTER JOIN
					TbMntObjTutorial AS TbMntObjTutorial_1 ON TbMntObjTutorial_STD.IdObject = TbMntObjTutorial_1.IdObject AND TbMntObjTutorial_STD.IdTutorial = TbMntObjTutorial_1.IdTutorial
					WHERE (TbMntObjTutorial_1.IdObjTutorial IS NULL)
					'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'SELECT IdObjTutorial, IdObject, IdTutorial, RifTutorial
									FROM  TbMntObjTutorial',
					@TbOutName = N'TbMntObjTutorial',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 

			--------------------------------
			-- EXPORT TbMntObjStd
			--------------------------------

			Delete from TbMntObjDbStd
			INSERT INTO TbMntObjDbStd
			(IdObj, Type)
			Select
			y.name   + '.' + x.name  as IdObj , x.Type
			FROM
			dbo_build.SYS.OBJECTS x
			INNER JOIN dbo_build.sys.schemas y  ON x.schema_id   = y.schema_id 
			where x.type in ( 'U','P', 'FN', 'SN','TF','V')

			SET @SqlScript = '

					Delete from TbMntObjDbStd

					INSERT INTO TbMntObjDbStd
					(IdObj, Type)
					SELECT  IdObj, Type
					FROM  ##TbMntObjDbStd 
					'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'	SELECT
									IdObj, Type
									FROM
									TbMntObjDbStd',
					@TbOutName = N'TbMntObjDbStd',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 
			
			--------------------------------
			-- EXPORT FncMntDboVrs
			--------------------------------

			SET @SqlScript = '

					DECLARE @ObjType nvarchar(20)
					DECLARE @ObjVersion1 nvarchar(20)
					DECLARE @ObjVersion2 nvarchar(20)
					Declare @Msg as nvarchar(200)
					Declare @Msg1 as nvarchar(200)

					IF NOT EXISTS (select Tmp.ObjType, TmpMntDboVrs.ObjVersion, Tmp.ObjVersion from ##TmpMntDboVrs TmpMntDboVrs inner join [dbo].[FncMntDboVrs] () Tmp ON Tmp.ObjType = TmpMntDboVrs.ObjType
					where Tmp.ObjVersion <> TmpMntDboVrs.ObjVersion )
						BEGIN
							Print ''      >> Controllo versioni OK''
						END

					DECLARE stp_cursor CURSOR FOR    
		
					select Tmp.ObjType, TmpMntDboVrs.ObjVersion, Tmp.ObjVersion from ##TmpMntDboVrs TmpMntDboVrs inner join [dbo].[FncMntDboVrs] () Tmp ON Tmp.ObjType = TmpMntDboVrs.ObjType
					where Tmp.ObjVersion <> TmpMntDboVrs.ObjVersion 

					OPEN stp_cursor

					FETCH NEXT FROM stp_cursor INTO @ObjType, @ObjVersion1, @ObjVersion2    

					WHILE @@FETCH_STATUS = 0    
					BEGIN    

						Print ''      >> ## Controllo ''  + isnull(@ObjType,''--'')  + '' prevista '' + @ObjVersion1 + '' riscontrata '' + @ObjVersion2 


						SET @Msg =  ''### Attenzione incongruenza versioni ###''
						SET @Msg1  =left(''>>>>>> Versione '' + @ObjType + '' prevista '' + @ObjVersion1 + '' riscontrata '' + @ObjVersion2 +'' <<<<<<<'',200)

						print ''''
						Print ''################################################''
						Print @Msg
						Print @Msg1
						Print ''################################################''
						print ''''

						Execute StpUteMsg_Ins @Msg,@Msg1,''AggDbo'',''ALR'',''cybe''


						FETCH NEXT FROM stp_cursor     
						INTO @ObjType, @ObjVersion1, @ObjVersion2   
   
					END     
					CLOSE stp_cursor;    
					DEALLOCATE stp_cursor; 
					'

			EXEC	[dbo].[StpMntData_Exprt]
					@StrSelect = N'SELECT ObjType, ObjVersion FROM  dbo.FncMntDboVrs()',
					@TbOutName = N'TmpMntDboVrs',
					@FileName = @FileName,
					@ActionFile ='ADD',
					@SqlScript = @SqlScript 

			--------------------------------
			-- Scrittura attività di aggiornamento su Kymos
			--------------------------------

			Declare @Obj as NVARCHAR(300)
			Set @Obj = 'Aggiornamento DBO Azure - ' + DB_NAME() + ' Server ' +  @@servername

			-- Scrive attività su dbo
			EXEC StpDboConnect_KyMsg 'MSG', @Obj, 'Cybe'




			/*************************************
			 * Export con bcp
			 * Richiede la procedura di import sincrona
			 * Difficile da debugare
			 *************************************/
			/*
			-- Prepara export oggetti

			Truncate table TbMntObjDef

			INSERT INTO TbMntObjDef
			(ObjNameId, ObjSchema, ObjName, ObjDefinition, ObjType, ObjTypeId, ObjDateCreate, ObjDateModify, SysDateCreate)

			SELECT SCHEMA_NAME(sys.objects.schema_id) +'.' + sys.objects.name AS ObjNameId,
			SCHEMA_NAME(sys.objects.schema_id) AS ObjSchema, 
			sys.objects.name AS ObjName, 
			sys.sql_modules.definition AS ObjDefinition,
			CASE 
			WHEN sys.objects.type in (N'U') THEN 'TB' 
			WHEN sys.objects.type in (N'FN', N'IF', N'TF', N'FS', N'FT') THEN 'FNC'
			WHEN sys.objects.type in (N'P', N'PC') THEN 'STP'
			WHEN sys.objects.type in (N'V') THEN 'VST' 
			WHEN sys.objects.type in (N'TR') THEN 'TR'
			END AS ObjType,
			sys.objects.type as ObjTypeId,
			sys.objects.create_date AS ObjDateCreate, 
			sys.objects.modify_date AS ObjDateModify,
			GETDATE() SysDateCreate
			FROM            sys.objects INNER JOIN
			sys.sql_modules ON sys.sql_modules.object_id = sys.objects.object_id
			WHERE        (left (sys.objects.name,4) not in ( 'STPX','VSTX','FNCX')) AND
			(left (sys.objects.name,3) not in ( 'TBX')) and (left (sys.objects.name,2) not in ('zz'))
			AND dbo.FncStrExtract(LEFT(sys.sql_modules.definition,5000),'Standard_Dbo',' ',' ') = 'YES'
			ORDER BY  SCHEMA_NAME(sys.objects.schema_id), sys.objects.name 

			-- Senza file di formato ci possono essere problemi con l'import

			-- Genera file di formato
			SET @sql = 'bcp dbo.dbo.TbMntObjHelp format nul -f '+ @FilePath  + 'TbMntObjHelp.fmt' + ' -T -w' 
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbMntObjRlz format nul -f '+ @FilePath  + 'TbMntObjRlz.fmt' + ' -T -w' 
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbMntObjVrs format nul -f '+ @FilePath  + 'TbMntObjVrs.fmt' + ' -T -w' 
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbSettingMenu format nul -f '+ @FilePath  + 'TbSettingMenu.fmt' + ' -T -w' 
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbSettingCommand format nul -f '+ @FilePath  + 'TbSettingCommand.fmt' +  ' -T -w'
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbSettingKey format nul -f '+ @FilePath  + 'TbSettingKey.fmt' + ' -T -w' 
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbSettingCodFnz format nul -f '+ @FilePath  + 'TbSettingCodFnz.fmt' + ' -T -w' 
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbSettingAutoUpd format nul -f '+ @FilePath  + 'TbSettingAutoUpd.fmt' + ' -T -w' 
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbMntObjDef format nul -f '+ @FilePath  + 'TbMntObjDef.fmt' + ' -T -N' 
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbMntObjDbVrs format nul -f '+ @FilePath  + 'TbMntObjDbVrs.fmt' + ' -T -w' 
			EXEC xp_cmdshell @sql

			SET @sql = 'bcp dbo.dbo.TbMntTutorial format nul -f '+ @FilePath  + 'TbMntTutorial.fmt' + ' -T -w' 
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbMntObjTutorial format nul -f '+ @FilePath  + 'TbMntObjTutorial.fmt' + ' -T -w' 
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbMntObjKey format nul -f '+ @FilePath  + 'TbMntObjKey.fmt' + ' -T -w' 
			EXEC xp_cmdshell @sql
			
			-- Genera file di dati

			-- Aggiorna  command per sostituire i ritorni a capo 10 + 13 con 13 altrimenti va in errore l'import (li legge come nuova riga)
			
			UPDATE TbSettingCommand
			SET  Command = Replace (Command, char(13) + char(10),  char(13))

			UPDATE TbSettingKey
			SET  
			Value = Replace (Value, char(13) + char(10),  char(13)),
			NoteSetting = Replace (NoteSetting, char(13) + char(10),  char(13))

			-- -t "|" terminatore di colonna, default è tab , ma ci può essere nell'xml
			-- -r \n@\n terminatore di riga, default è 13+10 ma ci può essere nel testo

			IF OBJECT_ID('tempdb..##TbMntObjHelp') IS NOT NULL DROP TABLE ##TbMntObjHelp

			SELECT        
			IdObject, 
			CASE WHEN left(IdTable,2) IN ('#2','#3','#4','#5') THEN NULL ELSE IdTable end as IdTable,
			CASE WHEN left(IdTable,2) IN ('#2','#3','#4','#5') THEN NULL ELSE DescHelp end as DescHelp, 
			CASE WHEN left(IdTable,2) IN ('#2','#3','#4','#5') THEN NULL ELSE replace(NoteHelp,char(9),'  ') END AS NoteHelp, 
			IdUtente, NoteHelpLocal, Tag, SysDateCreate, SysUserCreate, SysDateUpdate, SysUserUpdate, SysRowVersion, Comando,
			replace(NoteHelpTec,char(9),'  ') AS  NoteHelpTec , 
			CodFnzStato
			INTO ##TbMntObjHelp
			FROM TbMntObjHelp

			SET @sql = 'bcp ##TbMntObjHelp out '+ @FilePath  + 'TbMntObjHelp.bcp' + ' -T -w' 
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbMntObjRlz out '+ @FilePath  + 'TbMntObjRlz.bcp' + ' -T -w' 
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbMntObjVrs out '+ @FilePath  + 'TbMntObjVrs.bcp' + ' -T -w' 
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbSettingMenu out '+ @FilePath  + 'TbSettingMenu.bcp' + ' -T -w' 
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbSettingCommand OUT '+ @FilePath  + 'TbSettingCommand.bcp' +  ' -T -w -t "|" -r \n@\n'
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbSettingKey out '+ @FilePath  + 'TbSettingKey.bcp' + '  -T -w -t "|" -r \n@\n' 
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbSettingCodFnz out '+ @FilePath  + 'TbSettingCodFnz.bcp' + ' -T -w' 
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbSettingAutoUpd out '+ @FilePath  + 'TbSettingAutoUpd.bcp' + ' -T -w' 
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbMntObjDef out '+ @FilePath  + 'TbMntObjDef.bcp' + ' -T -N' 
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbMntObjDbVrs out '+ @FilePath  + 'TbMntObjDbVrs.bcp' + ' -T -N' 
			EXEC xp_cmdshell @sql

			SET @sql = 'bcp dbo.dbo.TbMntTutorial out '+ @FilePath  + 'TbMntTutorial.bcp' +  ' -T -w -t "|" -r \n@\n' 
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbMntObjTutorial out '+ @FilePath  + 'TbMntObjTutorial.bcp' +  ' -T -w -t "|" -r \n@\n' 
			EXEC xp_cmdshell @sql
			SET @sql = 'bcp dbo.dbo.TbMntObjKey out '+ @FilePath  + 'TbMntObjKey.bcp' +  ' -T -w -t "|" -r \n@\n' 
			EXEC xp_cmdshell @sql
			
			*/
		END

End

GO

