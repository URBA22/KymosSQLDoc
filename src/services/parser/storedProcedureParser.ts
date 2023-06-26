import { IParser } from './parser';
import { Utilities } from './core/utilities';

export class StoredProcedureParser implements IParser {
    private definition: string;


    public constructor(definition: string) {
        this.definition = definition;
    }
    public async parseAsync() {
        //constant that contains both commented part and non-commented part of definition
        const split = Utilities.splitDefinitionComment(this.definition);
        //writes the name of the procedure 
        let newDefinition = '# ' + Utilities.getObjectName(split.definition, Utilities.getObjectType(this.definition, Utilities.getCreateOrAlter(this.definition))) + '\n';

        //obtain and write tokens
        const tokens = Utilities.getTokensDescription(split.comments);
        newDefinition += tokens[0].trim() + '\n';
        newDefinition += '- Autore : ' + tokens[1].trim() + '\n';
        newDefinition += '- Custom : ' + tokens[2].trim() + '\n';
        newDefinition += '- Standard : ' + tokens[3].trim() + '\n';

        //writes the title of the versions and initzializes the table
        newDefinition += '\n## Versioni\nAutore | Versione | Descrizione\n--- | --- | --- \n';
        //writes the versions in a table
        for (let i = 4; i < tokens.length; i++) {
            let tokensTemp: string[]= [];
            tokens[i] = tokens[i].replace(/[ ]+/g, ' ');
            tokens[i] = tokens[i].replace(/(\t|\n|\r)+/g, '');
            tokensTemp = Utilities.getVersionDescription(tokens[i].split(' '));
            newDefinition += tokensTemp[0] + ' | ';
            newDefinition += tokensTemp[1] + ' | ';
            newDefinition += tokensTemp[2] + '\n';
        }

        //gets all the parameters and writes them
        const parameters = Utilities.getParameters(split.definition, Utilities.getObjectName(this.definition, Utilities.getObjectType(this.definition, Utilities.getCreateOrAlter(this.definition))));
        
        //writes parameters title and initializes the parameters table
        newDefinition += '\n## Parametri\nNome | Tipo | Null | Output | Descrizione\n--- | --- | --- | --- | --- \n';
        //writes the parameters in a table
        for (const param of parameters) {
            newDefinition += param.substring(0, param.indexOf(' ')) + ' | ';
            newDefinition += Utilities.getParameterType(param) + ' | ';
            newDefinition += Utilities.getParameterOutPut(param) + ' | descrizione? \n';
        }


        return newDefinition;
    }

}