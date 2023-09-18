import { ISqlObject } from '../sqlObject';

export class Dependecy {

    private constructor() {
    }

    public static async fromObjects(sqlObjects: ISqlObject[]) {
        //                 async ??
        sqlObjects.forEach(async sqlObject =>{
            
            await this.getDependecys(sqlObject.definition as string, sqlObject, sqlObjects);
        });
    }

    private static async getDependecys(sqlObjDefinition : string, sqlObject: ISqlObject, sqlObjects: ISqlObject[]) {
        if(sqlObjDefinition == undefined) return;
        if(sqlObject.dependecies == undefined) sqlObject.dependecies = [];
        const extTbAndVst:Promise<string[]> = this.extractTbAndVst(sqlObjDefinition);
        const extStpAndFnc:Promise<string[]> = this.extractStpAndFnc(sqlObjDefinition);
        const dependecys:string[] = (await extStpAndFnc).concat(await extTbAndVst);
        this.areValidDependecys(dependecys, sqlObject, sqlObjects);
    }

    private static async extractTbAndVst(sqlObjDefinition: string):Promise<string[]>{
        const dependecys:Set<string> = new Set();
        let start = 0;
        while((start = sqlObjDefinition.toUpperCase().indexOf(' FROM ', start + 1)) > 0){
            let toAdd = sqlObjDefinition.substring(sqlObjDefinition.indexOf(' ', start + 1) + 1, sqlObjDefinition.indexOf(' ', start + 6));
            toAdd = toAdd.substring(0, toAdd.indexOf('.'));
            dependecys.add(toAdd);
        }

        start = 0;
        while((start = sqlObjDefinition.toUpperCase().indexOf(' JOIN ', start + 1)) > 0){
            let toAdd = sqlObjDefinition.substring(sqlObjDefinition.indexOf(' ', start + 1) + 1, sqlObjDefinition.indexOf(' ', start + 6));
            toAdd = toAdd.substring(0, toAdd.indexOf('.'));
            dependecys.add(toAdd);
        }
        return Array.from(dependecys);
    }
    

    private static async extractStpAndFnc(sqlObjDefinition: string):Promise<string[]>{
        const dependecys:Set<string> = new Set();
        let start = 0;
        while((start = sqlObjDefinition.toUpperCase().indexOf(' EXECUTE ', start + 1)) > 0){
            let toAdd = sqlObjDefinition.substring(sqlObjDefinition.indexOf(' ', start + 1) + 1, sqlObjDefinition.indexOf(' ', start + 9));
            toAdd = toAdd.substring(0, toAdd.indexOf('.'));
            dependecys.add(toAdd);
        }
        
        start = 0;
        while((start = sqlObjDefinition.toUpperCase().indexOf(' EXEC ', start + 1)) > 0){
            let toAdd = sqlObjDefinition.substring(sqlObjDefinition.indexOf(' ', start + 1) + 1, sqlObjDefinition.indexOf(' ', start + 9));
            toAdd = toAdd.substring(0, toAdd.indexOf('.'));
            dependecys.add(toAdd);
        }

        start = 0;
        while((start = sqlObjDefinition.search(/[dbo.][\w]{0, 100}[(]/)) > 0){
            sqlObjDefinition = sqlObjDefinition.substring(start);
            const end = sqlObjDefinition.indexOf('(', start);
            dependecys.add(sqlObjDefinition.substring(sqlObjDefinition.indexOf('.', start) + 1, end));
            sqlObjDefinition = sqlObjDefinition.substring(end + 1);
        }
        return Array.from(dependecys);
    }

    /**
     * for every checked dependecy, verify if are valid
     * @param ObjectDetectedDependecys array of checked dependecys
     * @param sqlObject object on checked dependecys
     * @param sqlObjects array of objects to check if ODB are valid dependecys
     */
    private static async areValidDependecys(ObjectDetectedDependecys: string[], sqlObject: ISqlObject, sqlObjects: ISqlObject[]){
        ObjectDetectedDependecys.forEach(objDetDep => {
            this.isValidDependecy(objDetDep, sqlObject, sqlObjects);
        });
    }

    /**
     * check if is validDependecy and push dependecy and usages
     * @param ObjectDetectedDependecy 
     * @param sqlObject 
     * @param sqlObjects 
     * @returns 
     */
    private static async isValidDependecy(ObjectDetectedDependecy: string, sqlObject: ISqlObject, sqlObjects: ISqlObject[]){
        const index = sqlObjects.findIndex(obj => obj.name == ObjectDetectedDependecy);
        if(index < 0) return;
        sqlObject.dependecies?.push(sqlObjects[index]);
        if(sqlObjects[index].usages == undefined) sqlObject.dependecies = []; // is passed by value or ref?
        sqlObjects[index].usages?.push(sqlObject); // is passed by value or ref?
    }
}