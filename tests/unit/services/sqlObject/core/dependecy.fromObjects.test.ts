import { stringify } from 'querystring';
import { FsManager } from 'src/core/fsmanager/fsmanager';
import { SqlObjectBuilder } from 'src/services/sqlObject';
import { Dependecy } from 'src/services/sqlObject/core';
import { ISqlObject } from 'src/services/sqlObject/sqlObject';


describe('dependecy from sqlObjects', ()=>{
    

    const sqlObjects: ISqlObject[] = []; 
    beforeAll(async ()=>{
        const fsmanager = new FsManager();
        let rawDefinition = await fsmanager.readFileAsync('./tests/mockup/examples/', 'StpXImptPdm_Articolo.sql');

        sqlObjects.push( 
            await SqlObjectBuilder
                .createSqlObject()
                .fromDefinition(rawDefinition)
                .build()
                .elaborateAsync()
        );

        rawDefinition = await fsmanager.readFileAsync('./tests/mockup/examples/', 'StpXImptPdm_ArticoloBadNest.sql');

        sqlObjects.push( 
            await SqlObjectBuilder
                .createSqlObject()
                .fromDefinition(rawDefinition)
                .build()
                .elaborateAsync()
        );

    });
    
    test('Should values dependecys and usages',async () =>{
        const returned = Dependecy.fromObjects(sqlObjects);

    });


    afterAll(()=>{

    });
});