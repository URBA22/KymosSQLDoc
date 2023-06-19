export interface IDocumentation {
    titlesDescription(content: string, titlesArr: string[]): Promise<string[]>;
    FileNameGuard(file: string): Promise<string>;
}

export class Documentation implements Documentation {

    //costruttore della classse Docs
    constructor() {

    }


    public async titlesDescription(content: string, titlesArr: string[]): Promise<string[]> {
        const titlesDescriptionArr: string[] = [];
        for (let i = 0; i < titlesArr.length - 1; i++) {
            titlesDescriptionArr.push(content.substring(content.indexOf(titlesArr[i]) + titlesArr[i].length, content.indexOf(titlesArr[i] + 1)));
        }
        titlesDescriptionArr.push(content.substring(content.indexOf(titlesArr[titlesArr.length - 1]) + titlesArr[titlesArr.length - 1].length, content.indexOf('**/')));

        return titlesDescriptionArr;
    }
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

    public async getProcedureName(content: string): Promise<string> {

        const procedureName = content.substring(content.toUpperCase().indexOf('ALTER PROCEDURE') + 15, content.indexOf('('));

        if (procedureName.includes('.'))
            procedureName.substring(procedureName.lastIndexOf('.') + 1, procedureName.length - 1);
        if (procedureName.includes('[') && procedureName.includes(']'))
            procedureName.substring(procedureName.lastIndexOf('[') + 1, procedureName.lastIndexOf(']'));

        procedureName.trim;

        return procedureName;
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


