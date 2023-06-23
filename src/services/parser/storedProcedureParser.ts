import { IParser } from './parser';
import { Utilities } from './core/utilities';

export class StoredProcedureParser implements IParser {
    private definition: string;


    public constructor(definition: string) {
        this.definition = definition;
    }
    public async parseAsync() {
        const split = Utilities.splitDefinitionComment(this.definition);
        let newDefinition = '# ' + Utilities.getObjectName(split.definition, Utilities.getObjectType(this.definition, Utilities.getCreateOrAlter(this.definition))) + '\n';

        //obtain and write tokens
        const tokens = Utilities.getTokensDescription(split.comments);
        newDefinition += tokens[0].trim() + '\n';
        newDefinition += '- Autore : ' + tokens[1].trim() + '\n';
        newDefinition += '- Custom : ' + tokens[2].trim() + '\n';
        newDefinition += '- Standard : ' + tokens[3].trim() + '\n';

        newDefinition += '\n## Versioni\nAutore | Versione | Descrizione\n--- | --- | --- \n';
        for (let i = 4; i < tokens.length; i++) {
            let tokensTemp: string[]= [];
            tokens[i] = tokens[i].replace(/[ ]+/g, ' ');
            tokens[i] = tokens[i].replace(/(\t|\n|\r)+/g, '');
            tokensTemp = Utilities.getVersionDescription(tokens[i].split(' '));
            newDefinition += tokensTemp[0] + ' | ';
            newDefinition += tokensTemp[1] + ' | ';
            newDefinition += tokensTemp[2] + '\n';
        }

        const parameters = Utilities.getParameters(split.definition, Utilities.getObjectName(this.definition, Utilities.getObjectType(this.definition, Utilities.getCreateOrAlter(this.definition))));
        
        newDefinition += '\n## Parametri\nNome | Tipo | Null | Output | Descrizione\n--- | --- | --- | --- | --- \n';
        for (const param of parameters) {
            newDefinition += param.substring(0, param.indexOf(' ')) + ' | ';
            newDefinition += Utilities.getParameterType(param) + ' | ';
            newDefinition += Utilities.getParameterOutPut(param) + ' | descrizione? \n';
        }

        return newDefinition;
    }

}