import { FsManager } from 'src/core/fsmanager/fsmanager';
import { SqlObjectBuilder } from 'src/services/sqlObject';
import { Dependecy } from 'src/services/sqlObject/core';
import { ISqlObject} from 'src/services/sqlObject/sqlObject';


describe('dependecy from sqlObjects', ()=>{
    

    const sqlObjects: ISqlObject[] = []; 
    beforeAll(async ()=>{
        const fsmanager = new FsManager();
        let rawDefinition = await fsmanager.readFileAsync('./tests/mockup/dbo/StoredProcedures/', 'StpZone_KyDel.sql');

        sqlObjects.push( 
            await SqlObjectBuilder
                .createSqlObject()
                .fromDefinition(rawDefinition)
                .build()
                .elaborateAsync()
        );

        rawDefinition = await fsmanager.readFileAsync('./tests/mockup/dbo/StoredProcedures/', 'StpUteMsg.sql');

        sqlObjects.push( 
            await SqlObjectBuilder
                .createSqlObject()
                .fromDefinition(rawDefinition)
                .build()
                .elaborateAsync()
        );

    });
    
    test('Should values dependecys and usages',async () =>{


        await Dependecy.fromObjects(sqlObjects);
        expect((sqlObjects[0].dependecies?.pop() as ISqlObject).name).toEqual(sqlObjects[1].name);

        expect((sqlObjects[1].usages?.pop() as ISqlObject).name).toEqual(sqlObjects[0].name);
    });


    afterAll(()=>{

    });
});