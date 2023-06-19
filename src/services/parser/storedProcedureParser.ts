import { IParser } from './parser';

export class StoredProcedureParser implements IParser {
    private definition: string;
    public static tokens = ['@summary', '@author', '@custom', '@standard', '@version'];


    public constructor(definition: string) {
        this.definition = definition;
    }
    public async parseAsync() {

        return this.definition;
    }
    public async tokensDescription(content: string): Promise<string[]> {
        const tokensDescriptionArr: string[] = [];
        for (let i = 0; i < StoredProcedureParser.tokens.length - 1; i++) {
            tokensDescriptionArr.push(content.substring(content.indexOf(StoredProcedureParser.tokens[i]) + StoredProcedureParser.tokens[i].length, content.indexOf(StoredProcedureParser.tokens[i] + 1)));
        }
        tokensDescriptionArr.push(content.substring(content.indexOf(StoredProcedureParser.tokens[StoredProcedureParser.tokens.length - 1]) + StoredProcedureParser.tokens[StoredProcedureParser.tokens.length - 1].length, content.indexOf('**/')));

        return tokensDescriptionArr;
    }

    public async getParameters(content: string, procedureName: string): Promise<string[]> {
        //conterrà i singoli parametri
        const parameters: string[] = [];
        //contiene il testo con tutti i parametri
        let fullText: string = content.substring(content.indexOf(procedureName) + procedureName.length, content.indexOf(')') + 1);
        fullText = fullText.substring(fullText.indexOf('(') + 1, fullText.indexOf(')'));

        while (fullText.includes('@')) {
            fullText = fullText.substring(fullText.indexOf('@') + 1, fullText.length);
            parameters.push(fullText.substring(0, fullText.indexOf('@') - 1));
        }

        console.log(parameters);

        return parameters;
    }
}