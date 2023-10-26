import { Directory } from 'src/core/fsmanager/core/Directory';
import { FsManager } from 'src/core/fsmanager/fsmanager';
import { DocsCreatorBuilder } from 'src/services/docsCreator';
import { Mode } from 'src/services/docsCreator/builder';
import { SqlObjectBuilder } from 'src/services/sqlObject';
import { IStoredSqlObject } from 'src/services/storedSqlObject';
import { StoredSqlObjectBuilder } from 'src/services/storedSqlObject';


describe('create docs md', ()=>{

    const expettedDocs = `# StpZone_KyDel
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
| IdZona | NVARCHAR(20) | false | false | undefined |
| SysRowVersion | TIMESTAMP | false | false | undefined |
| SysUserUpdate | NVARCHAR(256) | false | false | undefined |
| KYStato | INT | true | true | undefined |
| KYMsg | NVARCHAR(MAX) | true | true | undefined |
| KYRes | INT | true | false | undefined |
`;


    const storedSqlObjects: IStoredSqlObject[] = []; 
    const dir = new Directory('./tests', 'tests');
    const destination = new Directory('./tests/mockup/md/docs/', 'StoredProcedures');
    const fsmanager = new FsManager('./tests');
    beforeAll(async ()=>{
        const rawDefinition = await fsmanager.readFileAsync('/mockup/dbo/StoredProcedures', 'StpZone_KyDel.sql');

        const sqlObject = await SqlObjectBuilder
            .createSqlObject()
            .fromDefinition(rawDefinition)
            .build()
            .elaborateAsync();
        
        storedSqlObjects.push(StoredSqlObjectBuilder
            .createStoredSqlObject()
            .fromDirectory(dir)
            .withSqlObject(sqlObject)
            .build()
        );
    });
    test('should create md with docs',async ()=>{
        await DocsCreatorBuilder.createDocsCreator()
            .withDestination(destination)
            .withStoredSqlObjects(storedSqlObjects)
            .withMode(Mode.md)
            .build()
            .executeAsync();

        const reader = new FsManager();
        const readed = await reader.readFileAsync('./tests/mockup/md/docs/StoredProcedures', 'StpZone_KyDel.md');

        expect(readed).toEqual(expettedDocs);
    });

    afterAll(()=>{

    });
});