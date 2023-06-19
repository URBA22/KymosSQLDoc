import { Utilities } from 'src/services/parser/core/utilities';

describe('FsManager ReadFileAsync', () => {
    const utility = new Utilities();




    test('Should work fine', () => {
        const type = utility.getObjectType(' \noR \n  AlTER      \n        PROCEDURE [dbo].[stpciao]  ');
        expect('').toEqual('');
    });



});