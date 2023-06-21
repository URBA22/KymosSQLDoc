

export interface IUtilities {
    titlesDescription(content: string, titlesArr: string[]): Promise<string[]>;
    FileNameGuard(file: string): Promise<string>;
}

export class Utilities implements Utilities {

    constructor() {

    }

    public static tokens = ['@summary', '@author', '@custom', '@standard', '@version'];
    public static typesOfProcedures = ['PROCEDURE', 'TRIGGER', 'VIEW', 'FUNCTION', 'TABLE'];
    /**
     * 
     * @param file 
     * @returns 
     */
    public async FileNameGuard(file: string): Promise<string> {
        if (file.includes('.'))
            file.substring(0, file.indexOf('.'));
        return file;
    }

    /*public static getFullProcedureText(content: string) {

        let regEx = new RegExp('CREATE([ ]*[\\n]*)*OR([ ]*[\\n]*)*ALTER([ ]*[\\n]*)*[A-Z]*([ ]*[\\n]*)*(\\[*[A-Z]*.*\\]*)*');
        let regExArr = regEx.exec(content.toUpperCase());
        let res = regExArr?.toString();
        if (res != undefined)
            return res;

        regEx = new RegExp('ALTER([ ]*[\\n]*)*[A-Z]*([ ]*[\\n]*)*(\\[*[A-Z]*.*\\]*)*');
        regExArr = regEx.exec(content.toUpperCase());
        res = regExArr?.toString();
        if (res != undefined)
            return res;

        regEx = new RegExp('CREATE([ ]*[\\n]*)*[A-Z]*([ ]*[\\n]*)*(\\[*[A-Z]*.*\\]*)*');
        regExArr = regEx.exec(content.toUpperCase());
        res = regExArr?.toString();
        if (res != undefined)
            return res;


        throw new Error('couldnt find type');
    }*/

    public static checkIfType(content: string | undefined, target: string): string {
        if (content?.toUpperCase().includes(target.toUpperCase()))
            return target;
        else
            return '';
    }

    public checkIfCarriageReturn(target: string): string {

        if (target.includes('\r'))
            target = target.substring(0, target.indexOf('\r'));
        return target;
    }


    public static getObjectType(definition: string): string {

        const splitDefinition = Utilities.splitDefinitionComment(definition as string);

        if (splitDefinition.definition.toUpperCase().includes(this.typesOfProcedures[0]))
            return this.typesOfProcedures[0];
        if (splitDefinition.definition.toUpperCase().includes(this.typesOfProcedures[1]))
            return this.typesOfProcedures[1];
        return this.typesOfProcedures[2];


    }

    public static getObjectName(content: string, procedureType: string): string {


        const split = this.splitDefinitionComment(content);

        let objectName = split.definition.substring(split.definition.toUpperCase().indexOf(procedureType) + procedureType.length, split.definition.length);

        if (objectName?.includes('.'))
            objectName = objectName.substring(objectName.lastIndexOf('.') + 1, objectName.length - 1);
        if (objectName?.includes('[') && objectName?.includes(']'))
            objectName = objectName.substring(objectName.lastIndexOf('[') + 1, objectName.lastIndexOf(']'));


        if (objectName != undefined)
            return objectName;

        throw new Error('could not find procedure name');
    }

    public async getTokensDescription(content: string): Promise<string[]> {
        let tempString = content.substring(content.indexOf(Utilities.tokens[Utilities.tokens.length - 1]));
        tempString = tempString.substring(0, tempString.indexOf('\n') + 1);
        content = content.substring(content.indexOf(Utilities.tokens[0]), content.indexOf(Utilities.tokens[Utilities.tokens.length - 1]) + tempString.length);
        const tokensDescriptionArr: string[] = [];

        for (let i = 0; i < Utilities.tokens.length - 1; i++) {
            tokensDescriptionArr.push(this.checkIfCarriageReturn(content.substring(content.indexOf(Utilities.tokens[i]) + Utilities.tokens[i].length, content.indexOf('\n'))));

            content = content.substring(content.indexOf(Utilities.tokens[i + 1]));
        }
        tokensDescriptionArr.push(this.checkIfCarriageReturn(tempString.substring(tempString.indexOf(Utilities.tokens[Utilities.tokens.length - 1]) + Utilities.tokens[Utilities.tokens.length - 1].length, tempString.indexOf('\n'))));

        return tokensDescriptionArr;
    }

    public async getParameters(content: string, procedureName: string): Promise<string[]> {
        //conterrà i singoli parametri
        const parameters: string[] = [];
        //contiene il testo con tutti i parametri
        let fullText: string = content.substring(content.indexOf(procedureName) + procedureName.length);

        fullText = fullText.substring(fullText.indexOf('(') + 1, fullText.indexOf(')'));

        while (fullText.includes('@')) {
            fullText = fullText.substring(fullText.indexOf('@') + 1, fullText.length);
            parameters.push(fullText.substring(0, fullText.indexOf('@') - 1));
        }

        console.log(parameters);


        return parameters;
    }

    public static splitDefinitionComment(content: string): {
        definition: string;
        comments: string;

    } {
        //TODO: implementa metodo
        let commentedText = '';
        while (content.includes('--') || content.includes('/*')) {
        
            commentedText += Utilities.getComment(content)+'\n';
            content = content.replace(Utilities.getComment(content), '');
        }
        content.replace('\n', ' ');
        content.replace(/[ ]+/, ' ');
        return {
            definition: content,
            comments: commentedText,
        };
    }

    public static getComment(content: string): string {
        if (content.includes('/*') && content.indexOf('/*') < content.indexOf('--'))
            return content.substring(content.indexOf('/*'), content.indexOf('*/') + 2);
        return content.substring(content.indexOf('--'), content.indexOf('\n', content.indexOf('--')));


    }

}


