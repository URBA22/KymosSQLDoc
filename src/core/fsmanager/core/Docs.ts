export interface IDocs {
    titlesDescription(content: string, titlesArr: string[]): Promise<string[]>;
}

export class Docs implements Docs {

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

    public async FileNameGuard(file: string) {
        if (file.includes('.'))
            file.substring(0, file.indexOf('.'));
    }


}