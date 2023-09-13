import SqlObjectBuilder from 'src/services/sqlObject/builder';

describe('SqlObject SplitDefinition', () => {

    test('Should split definition and comments', async () => {
        const definition = `
            aaa
            bbb cccc
            /*   commento 1
                -- multilinea
            */
           ddd eee -- commento /* 1 in linea
           fff /*
           ultimo commento
           ciaociao
        `;
        const expectedDefinition = 'aaa bbb cccc ddd eee fff';
        const expectedComments = `/*   commento 1
                -- multilinea
            */
-- commento /* 1 in linea

/*
           ultimo commento
           ciaociao`;

        const sqlObject = await SqlObjectBuilder
            .createSqlObject()
            .fromDefinition(definition)
            .build()
            .elaborateAsync();

        expect(sqlObject.definition).toEqual(expectedDefinition);
        expect(sqlObject.comments).toEqual(expectedComments);
    });

});