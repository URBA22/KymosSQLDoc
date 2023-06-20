

export interface IUtilities {
    titlesDescription(content: string, titlesArr: string[]): Promise<string[]>;
    FileNameGuard(file: string): Promise<string>;
}

export class Utilities implements Utilities {

    constructor() {

    }

    public static tokens = ['@summary', '@author', '@custom', '@standard', '@version'];
    public static typesOfProcedures = ['PROCEDURE' , 'TRIGGER' , 'VIEW' , 'FUNCTION' , 'TABLE'];
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

    public async getFullProcedureText(content: string) {

        const regEx = new RegExp('([ ]*[\\n]*)*[CREATE]*([ ]*[\\n]*)*[OR]*([ ]*[\\n]*)*[ALTER]*([ ]*[\\n]*)*[A-Z]*([ ]*[\\n]*)*(\\[*[A-Z]*.*\\]*)*');
        const regExArr = regEx.exec(content.toUpperCase());
        const res = regExArr?.toString();

        return res;
    }

    public async checkIfType(content:string|undefined, target:string):Promise<string>{
        if(content?.toUpperCase().includes(target.toUpperCase()))
            return target;
        else
            return '';
    }


    public async getObjectType(definition:string): Promise<string> {

        const content = await this.getFullProcedureText(definition);
        let typeOfProcedure = '';
        for (let i = 0; i < Utilities.typesOfProcedures.length && typeOfProcedure==''; i++){
            typeOfProcedure = await this.checkIfType(content, Utilities.typesOfProcedures[i]);
        }
        if(typeOfProcedure=='')
            throw new Error('type of procedure not valid or nonexistant');
        return typeOfProcedure;
    }

    public async getObjectName(content: string): Promise<string> {


        const fullText= await this.getFullProcedureText(content);
        const procedureType = await this.getObjectType(content);
        let objectName = fullText?.substring(fullText.toUpperCase().indexOf(procedureType) + procedureType.length, fullText?.length);

        if (objectName?.includes('.'))
            objectName = objectName.substring(objectName.lastIndexOf('.') + 1, objectName.length - 1);
        if (objectName?.includes('[') && objectName?.includes(']'))
            objectName = objectName.substring(objectName.lastIndexOf('[') + 1, objectName.lastIndexOf(']'));


        if(objectName!=undefined)
            return objectName;

        throw new Error('could not find procedure name');
    }

    public async getTokensDescription(content: string): Promise<string[]> {
        let tempString = content.substring(content.indexOf(Utilities.tokens[Utilities.tokens.length-1]));
        tempString = tempString.substring(0, tempString.indexOf('\n')+1);
        content = content.substring(content.indexOf(Utilities.tokens[0]), content.indexOf(Utilities.tokens[Utilities.tokens.length-1])+tempString.length);
        const tokensDescriptionArr: string[] = [];

        for (let i = 0; i < Utilities.tokens.length-1 ; i++) {
            tokensDescriptionArr.push(content.substring(content.indexOf(Utilities.tokens[i]) + Utilities.tokens[i].length, content.indexOf('\n')));
            content = content.substring(content.indexOf(Utilities.tokens[i+1]));
        }
        tokensDescriptionArr.push(tempString.substring(tempString.indexOf(Utilities.tokens[Utilities.tokens.length - 1]) + Utilities.tokens[Utilities.tokens.length - 1].length, tempString.indexOf('\n')));
        
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


