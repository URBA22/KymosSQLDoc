# StpMntUnitaIntrvDist_KyUpd
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
| dbo | TbMntUnitaIntrvDist | 1 | (dependecy as ISqlObject).desc |
# Usages 

| schema      | name      | type       | desc          |
| ------ | -------- | -------- | ------ |
# Parameter

| name      | type      | nullable      | output       | desc          |
| ------ | -------- | -------- | -------- | ------ |
| IdIntrvDist | INT | false | false | undefined |
| IdIntrv | NVARCHAR(20) | false | false | undefined |
| IdArticolo | NVARCHAR(50) | false | false | undefined |
| Descrizione | NVARCHAR(MAX) | false | false | undefined |
| UnitM | NVARCHAR(20) | false | false | undefined |
| UnitMCoeff | REAL | false | false | undefined |
| Qta | REAL | false | false | undefined |
| CostoUnit | MONEY | false | false | undefined |
| Tavola | NVARCHAR(15) | false | false | undefined |
| TavolaPosiz | NVARCHAR(10) | false | false | undefined |
| SysRowVersion | TIMESTAMP | false | false | undefined |
| SysUserUpdate | NVARCHAR(256) | false | false | undefined |
| KYStato | INT | true | true | undefined |
| KYMsg | NVARCHAR(MAX) | true | true | undefined |
| KYRes | INT | true | false | undefined |
