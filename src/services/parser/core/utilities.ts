

export interface IUtilities {
    titlesDescription(content: string, titlesArr: string[]): Promise<string[]>;
}

export class Utilities implements Utilities {

    constructor() {

    }

    public static tokens = ['@summary', '@author', '@custom', '@standard', '@version'];
    public static typesOfObjects = ['PROCEDURE', 'TRIGGER', 'VIEW', 'FUNCTION', 'TABLE'];
    public static createOrAlterArr = ['CREATE OR ALTER', 'ALTER', 'CREATE'];




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

    /**
     * 
     * @param content string where we search for the type of the object
     * @param createOrAlter string that contains either CREATE, ALTER or CREATE OR ALTER
     * @returns the type of the object
     */
    public static getObjectType(content: string, createOrAlter: string): string {
        content = content.substring(content.indexOf(createOrAlter), content.indexOf(' ', content.indexOf(createOrAlter) + createOrAlter.length + 1));

        return this.typesOfObjects[this.checkStringOfArrayInString(content, this.typesOfObjects)];
    }

    /**
     * 
     * @param content string where we search for the name of the object
     * @param objectType string that contains the type of the object
     * @returns the name of the object
     */
    public static getObjectName(content: string, objectType: string): string {
        let objectName = content.substring(content.indexOf(objectType) + objectType.length + 1, content.indexOf(' ', content.indexOf(objectType) + objectType.length + 1));

        if (objectName?.includes('.'))
            objectName = objectName.substring(objectName.lastIndexOf('.') + 1, objectName.length);
        if (objectName?.includes('[') && objectName?.includes(']'))
            objectName = objectName.substring(objectName.lastIndexOf('[') + 1, objectName.indexOf(']'));

        return objectName;
    }

    public static getVersionDescription(splittedVersion: string[]): string[] {
        const versionDescription: string[] = [];
        versionDescription[0] = splittedVersion[1];
        versionDescription[1] = splittedVersion[2];
        const temp = splittedVersion.slice(3);
        versionDescription[2] = temp.join(' ');
        return versionDescription;
    }
    /**
     * 
     * @param content string where we search for tokens descriptions, tokens from an array
     * @returns an array that contains all descriptions of token found
     */
    public static getTokensDescription(content: string): string[] {

        let tempString = content.substring(content.lastIndexOf(Utilities.tokens[Utilities.tokens.length - 1]));
        tempString = tempString.substring(0, tempString.indexOf('\n') + 1);
        content = content.substring(content.indexOf(Utilities.tokens[0]), content.lastIndexOf(Utilities.tokens[Utilities.tokens.length - 1]) + tempString.length);
        const tokensDescriptionArr: string[] = [];


        for (let i = 0; i < this.tokens.length - 1; i++) {
            tokensDescriptionArr.push(this.checkIfCarriageReturn(content.substring(content.indexOf(Utilities.tokens[i]) + Utilities.tokens[i].length, content.indexOf('\n'))));

            content = content.substring(content.indexOf(Utilities.tokens[i + 1]));
        }

        for (let i = 0; i < content.split('@version').length - 1; i++) {
            tokensDescriptionArr.push(content.substring(0, content.indexOf('\n')));
            content = content.substring(content.indexOf('@version', content.indexOf('\n')));
        }
        tokensDescriptionArr.push(content);
        return tokensDescriptionArr;
    }
    /**
     * 
     * @param content string where we check if FOR, AS or WITH is first
     * @returns the index of the first one contained in content
     */
    public static getWithForAs(content: string): number {
        let index = content.toUpperCase().indexOf(' AS ');
        const indexWith = content.toUpperCase().indexOf(' WITH ');
        const indexFor = content.toUpperCase().indexOf(' FOR ');
        if (indexWith >= 0 && indexWith < index)
            index = indexWith;
        if (indexFor >= 0 && indexFor < index)
            index = indexFor;
        return index;
    }
    /**
     * 
     * @param content String where the parameters are searched
     * @param procedureName String which represent the name of the procedure
     * @returns Array of strings that contains all found parameters with their description
     */
    public static getParameters(content: string, procedureName: string): string[] {
        let parameters: string[] = [];
        content = content.substring(content.indexOf(procedureName) + procedureName.length + 1, this.getWithForAs(content)).trim();
        if (content[0] == '(')
            content = content.substring(1, content.length - 1).trim();
        if (!content.includes('@'))
            return parameters;

        parameters = content.split(/,[ ]*@/);
        for (let i = 1; i < parameters.length; i++) {
            parameters[i] = '@' + parameters[i];
        }
        return parameters;
    }

    /**
     * 
     * @param content the string that will be divided in commented string and non-commented string
     * @returns the commented string and non-commented string
     */
    public static splitDefinitionComment(content: string): {
        definition: string;
        comments: string;

    } {
        let commentedText = '';
        while (content.includes('--') || content.includes('/*')) {

            commentedText += Utilities.getComment(content);
            content = content.replace(Utilities.getComment(content), '');
        }
        //replaces \n, \t, \r and multiple spaces with one single space
        content = content.replace(/(\t|\n|\r)+/g, ' ');
        content = content.replace(/[ ]+/g, ' ');

        return {
            definition: content,
            comments: commentedText,
        };
    }

    //checks wheter the passed string contains comments
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
    /**
     * 
     * @param content the string were you want to check
     * @returns 'CREATE' or 'CREATE OR ALTER' or 'ALTER'
     */
    public static getCreateOrAlter(content: string): string {
        return this.createOrAlterArr[this.checkStringOfArrayInString(content, this.createOrAlterArr)];
    }

    // checks if a string contains a string that is part of an array
    public static checkStringOfArrayInString(content: string, arr: string[]): number {
        let index = -1;
        let boolGuard = false;
        do {
            index++;
            boolGuard = content.toUpperCase().includes(arr[index]);
        } while (!boolGuard);
        return index;

    }

    /**
     * 
     * @param param 
     * @returns the type of the parameter, such as BIT or NVARCHAR
     */
    public static getParameterType(param: string): string {
        //takes away the @{name} and gets the rest
        param = param.substring(param.indexOf(' '));
        //check if it contains '=', if it does it returns a string from the parameters beginning to the '='
        if (param.includes('=')) {
            param = param.substring(0, param.indexOf('='));
        }
        //if it doesnt contain '=' it returns the string if it doesnt contain anymore spaces,
        // otherwise it returns a string from the parameters beginning to the first space that can be found
        param.trim();
        if (!param.includes(' '))
            return param;
        return param.substring(param.indexOf(' ') + 1);
    }

    /**
     * 
     * @param param single parameter where we get if it is null or what output it has
     * @returns NO or YES and NO or YES based on what the parameters contains
     */
    public static getParameterOutPut(param: string): string {
        if (!param.includes('=')) {
            return 'NO | YES';
        }
        param = param.substring(param.indexOf('=') + 1);
        let res = '';
        if (param.toUpperCase().includes('NULL'))
            res = 'YES';
        else
            res = 'NO';

        if (param.toUpperCase().includes('OUT') || param.toUpperCase().includes('OUTPUT') || param.toUpperCase().includes('READONLY'))
            res += '| YES';
        else
            res += '| NO';
        return res;
    }

}


