export interface IUtilities {
    titlesDescription(content: string, titlesArr: string[]): Promise<string[]>;
    FileNameGuard(file: string): Promise<string>;
}

export class Utilities implements Utilities {

    constructor() {

    }

    public static tokens = ['@summary', '@author', '@custom', '@standard', '@version'];
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

    public async getObjectType(content: string): Promise<string> {

        const regEx = new RegExp('([ ]*[\\n]*)*[CREATE]*([ ]*[\\n]*)*[OR]*([ ]*[\\n]*)*[ALTER]*([ ]*[\\n]*)*[A-Z]*([ ]*[\\n]*)*\\[*[A-Z]*.*\\]*');
        const regExArr = regEx.exec(content.toUpperCase());
        const res = regExArr?.toString();
        console.log(res);

        return '';
    }

    public async getObjectName(type: string, content: string): Promise<string> {


        /*
        const objectName = content.substring(content.toUpperCase().indexOf('') + 15, content.indexOf('('));

        if (objectName.includes('.'))
            objectName.substring(objectName.lastIndexOf('.') + 1, objectName.length - 1);
        if (objectName.includes('[') && objectName.includes(']'))
            objectName.substring(objectName.lastIndexOf('[') + 1, objectName.lastIndexOf(']'));

        objectName.trim;
        
        return objectName;
        */
        return '';
    }

    public async tokensDescription(content: string): Promise<string[]> {
        const tokensDescriptionArr: string[] = [];
        for (let i = 0; i < Utilities.tokens.length - 1; i++) {
            tokensDescriptionArr.push(content.substring(content.indexOf(Utilities.tokens[i]) + Utilities.tokens[i].length, content.indexOf(Utilities.tokens[i] + 1)));
        }
        tokensDescriptionArr.push(content.substring(content.indexOf(Utilities.tokens[Utilities.tokens.length - 1]) + Utilities.tokens[Utilities.tokens.length - 1].length, content.indexOf('**/')));

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


