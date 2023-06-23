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
        console.log(tokens);
        newDefinition += tokens[0].trim() + '\n';
        newDefinition += '- autore:' + tokens[1].trim() + '\n';
        newDefinition += '- custom:' + tokens[2].trim() + '\n';
        newDefinition += '- standard:' + tokens[3].trim() + '\n';

        newDefinition += '\n## Versioni\nAutore | Versione | Descrizione\n--- | --- | --- \n';
        for (let i = 4; i < tokens.length; i++) {
            tokens[i] = tokens[i].trim();
            tokens[i] = tokens[i].replace('[ ]+', ' ');

            newDefinition += tokens[i].substring(0, tokens[i].indexOf(' ')) + ' | ';
            newDefinition += tokens[i].substring(tokens[i].indexOf(' '), tokens[i].indexOf(' ', tokens[i].indexOf(' ') + 1)) + ' | ';
            newDefinition += tokens[i].substring(tokens[i].lastIndexOf(' ')) + '\n';
        }

        const parameters = Utilities.getParameters(split.definition, Utilities.getObjectName(this.definition, Utilities.getObjectType(this.definition, Utilities.getCreateOrAlter(this.definition))));
        parameters[0] = parameters[0].substring(2);
        newDefinition += '\n## Parametri\nNome | Tipo | Null | Output | Descrizione\n--- | --- | --- | --- | --- \n';
        for (const param of parameters) {
            newDefinition += param.substring(0, param.indexOf(' ')) + ' | ';
            newDefinition += Utilities.getParameterType(param) + ' | ';
            newDefinition += Utilities.getParameterOutPut(param) + ' | descrizione? \n';
        }

        return newDefinition;
    }

}