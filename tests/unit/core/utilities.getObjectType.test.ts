import { FsManager } from 'src/core/fsmanager/fsmanager';
import { Utilities } from 'src/services/parser/core/utilities';

describe('Utilities GetObjectType', () => {
    const fsManager = new FsManager();
    

    test('Should work if given right parameters', async () => {
        const content = await fsManager.readFileAsync('tests/mockup/examples', 'StpXImptPdm_Articolo.sql');

        const typeOfObject = Utilities.getObjectType(content, Utilities.getCreateOrAlter(content));
        
        expect(typeOfObject).toEqual('PROCEDURE');
    });

   



});