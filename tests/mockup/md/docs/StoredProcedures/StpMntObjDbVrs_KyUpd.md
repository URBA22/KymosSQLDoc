# StpMntObjDbVrs_KyUpd
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
# Usages 

| schema      | name      | type       | desc          |
| ------ | -------- | -------- | ------ |
# Parameter

| name      | type      | nullable      | output       | desc          |
| ------ | -------- | -------- | -------- | ------ |
| IdObjVrs | INT | false | false | undefined |
| IdObj | NVARCHAR(200) | false | false | undefined |
| SchemaName | NVARCHAR(256) | false | false | undefined |
| ObjName | NVARCHAR(256) | false | false | undefined |
| ObjType | NVARCHAR(256) | false | false | undefined |
| IdVrs | NVARCHAR(20) | false | false | undefined |
| DescVrs | NVARCHAR(200) | false | false | undefined |
| ObjDefinition | NVARCHAR(MAX) | false | false | undefined |
| SysRowVersion | TIMESTAMP | false | false | undefined |
| ObjStandard | NVARCHAR(10) | false | false | undefined |
| FlgTest | BIT | false | false | undefined |
| IdUtenteTest | NVARCHAR(256) | false | false | undefined |
| DescTest | NVARCHAR(MAX) | false | false | undefined |
| EsitoTest | NVARCHAR(MAX) | false | false | undefined |
| SysUserUpdate | NVARCHAR(256) | false | false | undefined |
| KYStato | INT | true | true | undefined |
| KYMsg | NVARCHAR(MAX) | true | true | undefined |
| KYRes | INT | true | false | undefined |
