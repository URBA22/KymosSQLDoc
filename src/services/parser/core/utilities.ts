export interface IUtilities {
    titlesDescription(content: string, titlesArr: string[]): Promise<string[]>;
    FileNameGuard(file: string): Promise<string>;
}

export class Utilities implements Utilities {

    constructor() {

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
    public async getObjectName (type: string, content: string): Promise<string>{
        const regex = /([CREATE][ALTER])+([ \n])+[A-Za-z]+([ \n])+\[[A-Za-z]+\]\.\[[A-Za-z]+\]/gm; 
        const objectName = content.substring(content.toUpperCase().indexOf('') + 15, content.indexOf('('));

        if (objectName.includes('.'))
            objectName.substring(objectName.lastIndexOf('.') + 1, objectName.length - 1);
        if (objectName.includes('[') && objectName.includes(']'))
            objectName.substring(objectName.lastIndexOf('[') + 1, objectName.lastIndexOf(']'));

        objectName.trim;

        return objectName;
    }
    



}


