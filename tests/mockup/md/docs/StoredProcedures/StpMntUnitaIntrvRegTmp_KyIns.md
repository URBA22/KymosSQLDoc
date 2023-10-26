# StpMntUnitaIntrvRegTmp_KyIns
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
| dbo | TbMntUnitaIntrvRegTmp | 1 | (dependecy as ISqlObject).desc |
# Usages 

| schema      | name      | type       | desc          |
| ------ | -------- | -------- | ------ |
# Parameter

| name      | type      | nullable      | output       | desc          |
| ------ | -------- | -------- | -------- | ------ |
| IdIntrvRegTmp | INT | false | true | undefined |
| IdIntrv | NVARCHAR(20) | false | false | undefined |
| IdUtente | NVARCHAR(256) | false | false | undefined |
| DataReg | DATE | false | false | undefined |
| DataInizio | DATETIME | false | false | undefined |
| DataFine | DATETIME | false | false | undefined |
| Durata | REAL | false | false | undefined |
| IdTipoAtvt | NVARCHAR(20) | false | false | undefined |
| NoteRegTmp | NVARCHAR(MAX) | false | false | undefined |
| SysUserCreate | NVARCHAR(256) | false | false | undefined |
| KYStato | INT | true | true | undefined |
| KYMsg | NVARCHAR(MAX) | true | true | undefined |
| KYRes | INT | true | false | undefined |
