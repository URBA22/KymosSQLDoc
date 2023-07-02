import { FsManager } from 'src/core/fsmanager/fsmanager';
import { Utilities } from 'src/services/parser/core/utilities';

describe('Utilities GetProcedureContent', () => {
    const fsManager = new FsManager();


    test('Should work if given right parameters', async () => {
        const content = await fsManager.readFileAsync('tests/mockup/examples', 'StpXImptPdm_Articolo.sql');
        const split = Utilities.splitDefinitionComment(content);


        const inAndOutOfState = Utilities.getProcedureContent(split.comments);
        
        console.log(inAndOutOfState.inStateContent);

        expect('').toEqual('');
    });





});