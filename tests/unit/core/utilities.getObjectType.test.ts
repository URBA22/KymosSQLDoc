import { Utilities } from 'src/services/parser/core/utilities';

describe('FsManager ReadFileAsync', () => {
    const utility = new Utilities();




    test('Should work fine', async () => {
        const typeOfProcedure = await utility.getObjectType(' \noR \n  AlTER      \n        viEW [dbo].[stpciao]  ');
        console.log(typeOfProcedure);
        expect('').toEqual('');
    });



});