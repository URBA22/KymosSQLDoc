

export interface IUtilities {
    titlesDescription(content: string, titlesArr: string[]): Promise<string[]>;
    FileNameGuard(file: string): Promise<string>;
}

export class Utilities implements Utilities {

    constructor() {

    }

    public static tokens = ['@summary', '@author', '@custom', '@standard', '@version'];
    public static typesOfObjects = ['PROCEDURE', 'TRIGGER', 'VIEW', 'FUNCTION', 'TABLE'];
    public static createOrAlterArr = ['CREATE OR ALTER', 'ALTER', 'CREATE'];
    /**
     * 
     * @param file 
     * @returns 
     */
    public static FileNameGuard(file: string): string {
        if (file.includes('.'))
            file.substring(0, file.indexOf('.'));
        return file;
    }


    public static checkIfType(content: string | undefined, target: string): string {
        if (content?.toUpperCase().includes(target.toUpperCase()))
            return target;
        else
            return '';
    }

    public static checkIfCarriageReturn(target: string): string {

        if (target.includes('\r'))
            target = target.substring(0, target.indexOf('\r'));
        return target;
    }


    public static getObjectType(content: string, createOrAlter: string): string {
        content = content.substring(content.indexOf(createOrAlter), content.indexOf(' ', content.indexOf(createOrAlter) + createOrAlter.length + 1));

        return this.typesOfObjects[this.checkStringOfArrayInString(content, this.typesOfObjects)];
    }

    public static getObjectName(content: string, objectType: string): string {
        let objectName = content.substring(content.indexOf(objectType) + objectType.length + 1, content.indexOf(' ', content.indexOf(objectType) + objectType.length + 1));

        if (objectName?.includes('.'))
            objectName = objectName.substring(objectName.lastIndexOf('.') + 1, objectName.length);
        if (objectName?.includes('[') && objectName?.includes(']'))
            objectName = objectName.substring(objectName.lastIndexOf('[') + 1, objectName.indexOf(']'));

        return objectName;
    }

    public static getTokensDescription(content: string): string[] {
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

    public static getParameters(content: string, procedureName: string): string[] {
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
        let commentedText = '';
        while (content.includes('--') || content.includes('/*')) {

            commentedText += Utilities.getComment(content);
            content = content.replace(Utilities.getComment(content), '');
        }
        content = content.replace(/(\n)+/g, ' ');
        content = content.replace(/[ ]+/g, ' ');

        return {
            definition: content,
            comments: commentedText,
        };
    }

    public static getComment(content: string): string {
        const indexMulti = content.indexOf('/*');
        const indexSingle = content.indexOf('--');
        let index = -1;
        let eol = '';
        if (indexMulti == -1) 
            index = indexSingle;
        else
        if (indexSingle == -1)
            index = indexMulti;
        else
            index = Math.min(indexMulti, indexSingle);
  
        if (index == indexSingle)
            eol = '\n';
        if (index == indexMulti)
            eol = '*/';

        return content.substring(index, content.indexOf(eol, index) + 2);

    }

    public static getCreateOrAlter(content: string): string {
        return this.createOrAlterArr[this.checkStringOfArrayInString(content, this.createOrAlterArr)];
    }

    public static checkStringOfArrayInString(content: string, arr: string[]): number {
        let index = -1;
        let boolGuard = false;
        do {
            index++;
            boolGuard = content.toUpperCase().includes(arr[index]);
        } while (!boolGuard);
        return index;

    }

}


