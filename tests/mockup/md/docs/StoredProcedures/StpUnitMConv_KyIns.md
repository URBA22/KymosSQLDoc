# StpUnitMConv_KyIns
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
| UnitMP | NVARCHAR(20) | false | true | undefined |
| UnitMD | NVARCHAR(20) | false | true | undefined |
| CoeffConv | REAL | false | false | undefined |
| Note | NVARCHAR(200) | false | false | undefined |
| CodFnz | NVARCHAR(5) | false | false | undefined |
| Disabilita | BIT | false | false | undefined |
| SysUserCreate | NVARCHAR(256) | false | false | undefined |
| KYStato | INT | true | true | undefined |
| KYMsg | NVARCHAR(MAX) | true | true | undefined |
| KYRes | INT | true | false | undefined |
