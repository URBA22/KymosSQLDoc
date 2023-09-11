// import { IParser } from './parser';
// import { Utilities } from './core/utilities';
// import { setPriority } from 'os';
// import { StoredProcedureParserGuard } from './core/storedProcedureParserGuards';
// export class StoredProcedureParser implements IParser {
//     private definition: string;
//     private static index: number[] = [0];
//     private static indexArrDepth = 0;
//     private static inIfOrWhile = 0;


//     public constructor(definition: string) {
//         this.definition = definition;
//     }




//     public async parseAsync() {
//         let newDefinition = '';

//         //constant that contains both commented part and non-commented part of definition
//         const split = Utilities.splitDefinitionComment(this.definition);

//         const content = split.comments.toUpperCase().replace(/((@STEP)|(\n)|(\t)|(\r)|[ ]|-)+/g, ' ');

//         try {
//             StoredProcedureParserGuard.Guard.stateGuard(split.comments);
//             StoredProcedureParserGuard.Guard.checkIfStateNested(split.comments);
//             StoredProcedureParserGuard.Guard.checkIfWrittenCorrectly(content, []);
//             StoredProcedureParserGuard.Guard.ifGuard(split.comments);
//             StoredProcedureParserGuard.Guard.sectionGuard(split.comments);
//             StoredProcedureParserGuard.Guard.whileGuard(split.comments);

//             newDefinition = await this.getFileText();

//         } catch (error: any) {
//             console.log(error);
//         }
//         return newDefinition;

//     }

//     /**
//      * gets the formatted content of the file that is going to be created, takes the content of a file and formats it
//      * @returns string, the formatted content of the file that is going to be created, takes the content of a file and modifies it
//      */
//     public async getFileText(): Promise<string> {


//         //constant that contains both commented part and non-commented part of definition
//         const split = Utilities.splitDefinitionComment(this.definition);

//         //writes the name of the procedure 
//         let newDefinition = '# ' + Utilities.getObjectName(split.definition, Utilities.getObjectType(this.definition, Utilities.getCreateOrAlter(this.definition))) + '\n';

//         //obtain and write tokens
//         const tokens = Utilities.getTokensDescription(split.comments);
//         newDefinition += tokens[0].trim() + '\n';
//         newDefinition += '- Autore : ' + tokens[1].trim() + '\n';
//         newDefinition += '- Custom : ' + tokens[2].trim() + '\n';
//         newDefinition += '- Standard : ' + tokens[3].trim() + '\n';

//         //writes the title of the versions and initzializes the table
//         newDefinition += '\n## Versioni\nAutore | Versione | Descrizione\n--- | --- | --- \n';
//         //writes the versions in a table
//         for (let i = 4; i < tokens.length; i++) {
//             let tokensTemp: string[] = [];
//             tokens[i] = tokens[i].replace(/[ ]+/g, ' ');
//             tokens[i] = tokens[i].replace(/(\t|\n|\r)+/g, '');
//             tokensTemp = Utilities.getVersionDescription(tokens[i].split(' '));
//             newDefinition += tokensTemp[0] + ' | ';
//             newDefinition += tokensTemp[1] + ' | ';
//             newDefinition += tokensTemp[2] + '\n';
//         }

//         //gets all the parameters and writes them
//         const parameters = Utilities.getParameters(split.definition, Utilities.getObjectName(this.definition, Utilities.getObjectType(this.definition, Utilities.getCreateOrAlter(this.definition))));

//         //writes parameters title and initializes the parameters table
//         newDefinition += '\n## Parametri\nNome | Tipo | Null | Output | Descrizione\n--- | --- | --- | --- | --- \n';
//         //writes the parameters in a table
//         for (const param of parameters) {
//             newDefinition += param.substring(0, param.indexOf(' ')) + ' | ';
//             newDefinition += Utilities.getParameterType(param) + ' | ';
//             newDefinition += Utilities.getParameterOutPut(param) + ' | descrizione? \n';
//         }


//         const inAndOutOfState = Utilities.getProcedureContent(split.comments);

//         newDefinition += '\n### Nessuno Stato\nStep di esecuzione che vengono eseguiti indipendentemente dallo stato della procedura\n';

//         for (let i = 0; i < inAndOutOfState.outOfStateContent.length; i++) {
//             newDefinition += StoredProcedureParser.getFormattedProcedureStep(inAndOutOfState.outOfStateContent[i]);
//         }

//         for (let i = 0; i < inAndOutOfState.inStateContent.length; i++) {
//             newDefinition += StoredProcedureParser.getFormattedProcedureStep(inAndOutOfState.inStateContent[i]);
//         }


//         return newDefinition;
//     }

//     /**
//      * gets the formatted string of a step, a section, a state or an if, or and end of
//      * the same ones
//      * @param procedureStep string, contains a string which is either a step, a section, a state or an if, or and end of
//      * the same ones
//      * @returns string, based on what type of "step" procedureStep is, returns a formatted string
//      */
//     public static getFormattedProcedureStep(procedureStep: string): string {

//         let formattedString = '';

//         if (procedureStep.includes('@ENDSTATE')) {
//             return '\n';
//         }


//         if (procedureStep.includes('@STEP'))
//             formattedString = this.writeStep(procedureStep);


//         if (procedureStep.includes('@ENDWHILE')) {
//             this.index.pop();
//             this.indexArrDepth--;
//             this.inIfOrWhile--;
//             return '';
//         }


//         if (procedureStep.includes('@WHILE')) {

//             this.index[this.indexArrDepth]++;
//             const format = this.getTabs() + this.index.join('.');
//             this.indexArrDepth++;
//             this.index.push(0);
//             this.inIfOrWhile++;
//             return format + '. WHILE ' + (procedureStep.substring(procedureStep.indexOf(' '))).trim() + '\n\n';
//         }



//         if (procedureStep.includes('@ENDIF')) {
//             this.index.pop();
//             this.indexArrDepth--;
//             this.inIfOrWhile--;
//             return '';
//         }

//         if (procedureStep.includes('@IF')) {

//             this.index[this.indexArrDepth]++;
//             const format = this.getTabs() + this.index.join('.');
//             this.indexArrDepth++;
//             this.index.push(0);
//             this.inIfOrWhile++;
//             return format + '. IF ' + (procedureStep.substring(procedureStep.indexOf(' '))).trim() + '\n\n';
//         }



//         if (procedureStep.includes('@ENDSECTION')) {
//             this.index.pop();
//             this.indexArrDepth--;
//             return '</details>\n\n';
//         }

//         if (procedureStep.includes('@SECTION')) {
//             this.index[this.indexArrDepth]++;
//             const format = this.index.join('.');
//             this.indexArrDepth++;
//             this.index.push(0);
//             return format + '. <details>\n' + '\t<summary>' + (procedureStep.substring(procedureStep.indexOf(' '))).trim() + '</summary>\n\n';
//         }



//         if (procedureStep.includes('@STATE')) {
//             this.index = [0];
//             this.indexArrDepth = 0;
//             const number = procedureStep.substring(7, procedureStep.indexOf(' ', 8));
//             const res = this.getRes(procedureStep);
//             const description = this.getDescription(procedureStep, res, number);
//             return '\n### Stato ' + number + res + '\n' + description + '\n\n';
//         }



//         return formattedString;
//     }

//     /**
//      * gets the formatted text for a step type of "step"
//      * @param step step contains a string which refers to a string that contains '@step' and it's descritpion
//      * @returns string, a formatted string of a '@step'
//      */
//     public static writeStep(step: string): string {

//         this.index[this.indexArrDepth]++;
//         const format = this.index.join('.');


//         return this.getTabs() + format + '. ' + (step.substring(step.indexOf(' '))).trim() + '\n\n';
//     }

//     /**
//      * its used to get the amount of &nbsp; and if there is going to be a \t
//      * @returns string, that could cointain one tab and many &nbsp;, 4 for the amount of if and while we're in
//      */
//     public static getTabs(): string {
//         let tabs = '';
//         if (this.indexArrDepth > 0)
//             tabs += '\t';
//         for (let i = 0; i < this.inIfOrWhile; i++)
//             tabs += '&nbsp;&nbsp;&nbsp;&nbsp;';
//         return tabs;
//     }

//     /**
//      * gets the result of a '@state' type of "step"
//      * @param procedureStep contains a '@state' "step", meaning '@state' + its description
//      * @returns string, if the string that is passed doesnt contain '@RES', a null string, if it did, it returns a formatted string containing res + a number
//      */
//     public static getRes(procedureStep: string): string {
//         if (!procedureStep.toUpperCase().includes('@RES'))
//             return '';
//         return ' ' + procedureStep.substring(procedureStep.toUpperCase().indexOf('@RES') + 1, procedureStep.indexOf(' ', procedureStep.toUpperCase().indexOf('@RES') + 5));

//     }
//     /**
//      * gets the descritption of a '@state' type of "step"
//      * @param procedureStep contains a '@state' "step", meaning '@state' + its description
//      * @param res contains a part of procedureStep which is, if it exist, res + a number
//      * @param number contains a part of procedureStep which is the number after '@state'
//      * @returns string, the description of a '@state' "step"
//      */
//     public static getDescription(procedureStep: string, res: string, number: string): string {
//         if (!procedureStep.toUpperCase().includes('@RES'))
//             return (procedureStep.substring(procedureStep.toUpperCase().indexOf(number) + number.length)).trim();
//         return (procedureStep.substring(procedureStep.toUpperCase().indexOf(' ', procedureStep.toUpperCase().indexOf('@RES') + res.length))).trim();

//     }

// }