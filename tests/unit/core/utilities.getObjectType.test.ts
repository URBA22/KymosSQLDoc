import { copyFileSync } from 'fs';
import { Utilities } from 'src/services/parser/core/utilities';

describe('FsManager ReadFileAsync', () => {
    const utility = new Utilities();




    test('Should work fine', async () => {
        const typeOfProcedure = await utility.getObjectType(' \noR \n  AlTER      \n        TRIGGER [dbo].[stpciao]  ');
        const nameOfProcedure = await utility.getObjectName(' \noR \n  AlTER      \n        viEW [dbo].[stp#@P\\*-ciao1]  ');
        const tokens = await utility.getTokensDescription(' akfnao oasm asomasofm aonf \n  @summary sono  ainaifna\n @author nato asjbnasjn \n @custom il asfa\n @standard giorno\n\n @version non lo so\n ');
        console.log(typeOfProcedure + '.');
        console.log(nameOfProcedure + '.');
        console.log(tokens);
        expect(typeOfProcedure).toEqual('TRIGGER');
    });



});