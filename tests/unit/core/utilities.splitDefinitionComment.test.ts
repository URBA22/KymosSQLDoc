import exp from 'constants';
import { Utilities } from 'src/services/parser/core/utilities';

describe('Utilities SplitDefinitionComment', () => {


    test('Should work if given right parameters', async () => {
        const content = ('/*   */ ciao --luca  \n */  è/*mattina */\n     pomeriggio ');
        const split = Utilities.splitDefinitionComment(content);

        expect(split.comments).toEqual('/*   */--luca  \n /*mattina */');
        expect(split.definition).toEqual(' ciao */ è pomeriggio ');
    });





});