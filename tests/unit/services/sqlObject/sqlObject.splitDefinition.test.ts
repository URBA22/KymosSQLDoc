import SqlObjectBuilder from 'src/services/sqlObject/builder';

describe('SqlObject SplitDefinition', () => {

    test('Should split definition and comments', async () => {
        const definition = `
            CREATE PROCEDURE [dbo].[StpProva]
            AS BEGIN
            aaa
            bbb cccc
            /*   commento 1
                -- multilinea
            */
           ddd eee -- commento /* 1 in linea
           fff /*
           ultimo commento
           ciaociao
           END
        `;
        const expectedDefinition = 'CREATE PROCEDURE [dbo].[StpProva] AS BEGIN aaa bbb cccc ddd eee fff';
        const expectedComments = `/*   commento 1
                -- multilinea
            */
-- commento /* 1 in linea

/*
           ultimo commento
           ciaociao
           END`;

        const sqlObject = await SqlObjectBuilder
            .createSqlObject()
            .fromDefinition(definition)
            .build()
            .elaborateAsync();

        expect(sqlObject.definition).toEqual(expectedDefinition);
        expect(sqlObject.comments).toEqual(expectedComments);
    });

});