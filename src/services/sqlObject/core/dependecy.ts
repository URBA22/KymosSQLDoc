import { ISqlObject } from '../sqlObject';

export class Dependecy {

    private constructor() {
    }

    public static async fromObjects(sqlObjects: ISqlObject[]) {
        await sqlObjects.forEach(sqlObject =>{
            this.getDependecys(sqlObject.definition as string, sqlObject, sqlObjects);
        });
        return;
    }

    private static async getDependecys(sqlObjDefinition : string, sqlObject: ISqlObject, sqlObjects: ISqlObject[]) {
        if(sqlObjDefinition == undefined) return;
        const extTbAndVst:Promise<string[]> = this.extractTbAndVst(sqlObjDefinition);
        const extStpAndFnc:Promise<string[]> = this.extractStpAndFnc(sqlObjDefinition);
        const dependecys:string[] = (await extStpAndFnc).concat(await extTbAndVst);        
        this.areValidDependecys(dependecys, sqlObject, sqlObjects);
        return;
    }

    private static async extractTbAndVst(sqlObjDefinition: string):Promise<string[]>{
        const dependecys:Set<string> = new Set();

        let start = 0;
        while((start = sqlObjDefinition.toUpperCase().indexOf(' FROM ', start + 1)) > 0){
            const toAdd = sqlObjDefinition.substring(sqlObjDefinition.indexOf(' ', start + 1) + 1, sqlObjDefinition.indexOf(' ', start + 6)).replace('dbo.', '').replace(/\([\w]{0,100}[,]/, '').replace(')', '');
            dependecys.add(toAdd.trim());
        }

        start = 0;
        while((start = sqlObjDefinition.toUpperCase().indexOf(' JOIN ', start + 1)) > 0){
            const toAdd = sqlObjDefinition.substring(sqlObjDefinition.indexOf(' ', start + 1) + 1, sqlObjDefinition.indexOf(' ', start + 6)).replace('dbo.', '').replace(/\([\w]{0,100}[,]/, '').replace(')', '');
            dependecys.add(toAdd.trim());
        }

        start = 0;
        while((start = sqlObjDefinition.toUpperCase().indexOf(' INSERT INTO ', start + 1)) > 0){
            const toAdd = sqlObjDefinition.substring(sqlObjDefinition.indexOf(' ', start + 8) + 1, sqlObjDefinition.indexOf(' ', start + 13)).replace('dbo.', '').replace(/\([\w]{0,100}[,]/, '').replace(')', '');
            dependecys.add(toAdd.trim());
        }
        
        start = 0;
        while((start = sqlObjDefinition.toUpperCase().indexOf(' UPDATE ', start + 1)) > 0){
            const toAdd = sqlObjDefinition.substring(sqlObjDefinition.indexOf(' ', start + 1) + 1, sqlObjDefinition.indexOf(' ', start + 8)).replace('dbo.', '').replace(/\([\w]{0,100}[,]/, '').replace(')', '');
            dependecys.add(toAdd.trim());
        }
        start = 0;
        while((start = sqlObjDefinition.toUpperCase().indexOf(' DELETE ', start + 1)) > 0){
            const toAdd = sqlObjDefinition.substring(sqlObjDefinition.indexOf(' ', start + 1) + 1, sqlObjDefinition.indexOf(' ', start + 8)).replace('dbo.', '').replace(/\([\w]{0,100}[,]/, '').replace(')', '');
            dependecys.add(toAdd.trim());
        }
        return Array.from(dependecys);
    }
    

    private static async extractStpAndFnc(sqlObjDefinition: string):Promise<string[]>{
        const dependecys:Set<string> = new Set();
        let start = 0;
        while((start = sqlObjDefinition.toUpperCase().indexOf(' EXECUTE ', start + 1)) > 0){
            const toAdd = sqlObjDefinition.substring(sqlObjDefinition.indexOf(' ', start + 1) + 1, sqlObjDefinition.indexOf(' ', start + 9)).replace('dbo.', '').replace(/\([\w]{0,100}[,]/, '').replace(')', '');
            dependecys.add(toAdd.trim());
        }
        
        start = 0;
        while((start = sqlObjDefinition.toUpperCase().indexOf(' EXEC ', start + 1)) > 0){
            const toAdd = sqlObjDefinition.substring(sqlObjDefinition.indexOf(' ', start + 1) + 1, sqlObjDefinition.indexOf(' ', start + 9)).replace('dbo.', '').replace(/\([\w]{0,100}[,]/, '').replace(')', '');
            dependecys.add(toAdd.trim());
        }

        start = 0;
        while((start = sqlObjDefinition.search(/[dbo.][\w]{0, 100}[(]/)) > 0){
            sqlObjDefinition = sqlObjDefinition.substring(start);
            const end = sqlObjDefinition.indexOf('(', start);
            dependecys.add(sqlObjDefinition.substring(0, end).replace('dbo.', '').trim());
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
        sqlObject.pushDependecy(sqlObjects[index]); // is passed by value or ref?
        sqlObjects[index].pushUsage(sqlObject); // is passed by value or ref?
    }
}