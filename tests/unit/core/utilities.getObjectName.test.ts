import { copyFileSync } from 'fs';
import { FsManager } from 'src/core/fsmanager/fsmanager';
import { Utilities } from 'src/services/parser/core/utilities';

describe('Utilities GetObjectName', () => {
    const fsManager = new FsManager();


    test('Should work if given right parameters', async () => {
        let content = await fsManager.readFileAsync('tests/mockup/examples', 'StpXImptPdm_Articolo.sql');
        content = Utilities.splitDefinitionComment(content).definition;
        const typeOfObject = Utilities.getObjectType(content, Utilities.getCreateOrAlter(content));
        const nameOfObject = Utilities.getObjectName(content, typeOfObject);

        expect(nameOfObject).toEqual('StpXImptPdm_Articolo');
    });





});