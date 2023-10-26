# StpMntUnitaIntrvPiani_KyUpd
sqlObject.desc

# Info 
@Summary undefined
@Author undefined
@Custom undefined
@Standard undefined
# Versions 
# Dependecies 

| schema      | name      | type       | desc          |
| ------ | -------- | -------- | ------ |
| dbo | StpUteMsg | 2 | (dependecy as ISqlObject).desc |
| dbo | TbMntUnitaIntrvPiani | 1 | (dependecy as ISqlObject).desc |
# Usages 

| schema      | name      | type       | desc          |
| ------ | -------- | -------- | ------ |
# Parameter

| name      | type      | nullable      | output       | desc          |
| ------ | -------- | -------- | -------- | ------ |
| IdPiano | INT | false | false | undefined |
| IdUnita | INT | false | false | undefined |
| NRiga | INT | false | false | undefined |
| IdPianoTipo | NVARCHAR(20) | false | false | undefined |
| Periodicita | INT | false | false | undefined |
| CodFnzTipoPeriodicita | NVARCHAR(5) | false | false | undefined |
| Descrizione | NVARCHAR(MAX) | false | false | undefined |
| DPI | NVARCHAR(50) | false | false | undefined |
| NotePiano | NVARCHAR(MAX) | false | false | undefined |
| FlgInterna | BIT | false | false | undefined |
| SysRowVersion | TIMESTAMP | false | false | undefined |
| DataDisabilita | DATETIME | false | false | undefined |
| IdArticolo | NVARCHAR(50) | false | false | undefined |
| DurataPrevIntrv | INT | false | false | undefined |
| SysUserUpdate | NVARCHAR(256) | false | false | undefined |
| KYStato | INT | true | true | undefined |
| KYMsg | NVARCHAR(MAX) | true | true | undefined |
| KYRes | INT | true | false | undefined |
