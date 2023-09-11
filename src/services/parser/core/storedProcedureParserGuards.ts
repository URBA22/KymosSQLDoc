// import { Utilities } from './utilities';

// export namespace StoredProcedureParserGuard {
//     export class Guard {

//         private constructor() { }

//         /**
//           * checks if the passed string is empty, if the number of '@state' and '@endstate' in  the string is equal, and if they are in right order 
//           * @param comment string, contains a file sql commented part
//           */
//         static stateGuard(comment: string) {
//             if (comment.replace(/((\n)|(\t)|(\r)|[ ])+/, '') == '')
//                 throw new Error('The string is empty');

//             if (comment.toUpperCase().includes('@STATE') && comment.toUpperCase().split('@STATE').length != comment.toUpperCase().split('@ENDSTATE').length)
//                 throw new Error('Number of @state and @ENDSTATE isnt equal');

//             if (comment.toUpperCase().includes('@STATE') && comment.toUpperCase().indexOf('@STATE') < comment.toUpperCase().indexOf('@ENDSTATE'))
//                 this.stateGuard(comment.toUpperCase().substring(comment.toUpperCase().indexOf('\n', comment.toUpperCase().indexOf('@ENDSTATE'))));
//             else
//                 if (comment.toUpperCase().includes('@STATE'))
//                     throw new Error('There might be badly nested @STATE');


//         }

//         /**
//          * checks if an '@state-@endstate' is nested
//          * @param comment string, contains a file sql commented part
//          */
//         static checkIfStateNested(comment: string) {
//             comment = comment.toUpperCase();
//             this.StateNestGuard(comment, '@IF');
//             this.StateNestGuard(comment, '@WHILE');
//             this.StateNestGuard(comment, '@SECTION');

//         }

//         /**
//          * checks if a '@state-@endstate' is nested
//          * @param content string, contains a file sql commented part
//          * @param checkVar string, contains the string we want to check doesnt nest a '@state-@endstate'
//          */
//         static StateNestGuard(content: string, checkVar: string) {
//             checkVar = checkVar.toUpperCase();
//             const checkEnd = '@END' + checkVar.substring(1);
//             if (content.includes('@STATE') && content.includes(checkVar))
//                 this.checkOrder(content, checkVar, checkEnd);
//         }

//         /**
//          * checks if the "nests" contains or not the '@state-@endstate'
//          * @param content string, contains a file sql commented part
//          * @param checkVar string, contains the string we want to check doesnt nest a '@state-@endstate'
//          * @param checkEnd string, contains the string that represents the end of the string that we want to check doesnt nest a '@state-@endstate'
//          */
//         public static checkOrder(content: string, checkVar: string, checkEnd: string) {
//             if (content.indexOf(checkVar) < content.indexOf('@STATE') && content.indexOf(checkEnd) > content.indexOf('@STATE'))
//                 throw new Error('@STATE cannot be nested');
//             if (content.indexOf(checkVar) > content.indexOf('@ENDSTATE'))
//                 this.StateNestGuard(content.replace(content.substring(content.indexOf(checkVar), content.indexOf(checkEnd) + checkEnd.length), ''), checkVar);
//             if (content.indexOf(checkVar) < content.indexOf('@STATE') && content.indexOf(checkEnd) < content.indexOf('@STATE'))
//                 this.StateNestGuard(content.replace(content.substring(content.indexOf(checkVar), content.indexOf(checkEnd) + checkEnd.length), ''), checkVar);
//             if (content.includes('@STATE'))
//                 this.StateNestGuard(content.replace(content.substring(content.indexOf('@STATE'), content.indexOf('@ENDSTATE') + 9), ''), checkVar);

//         }

//         /**
//          * checks if the number of '@while' and '@endwhile' is equal
//          * @param comment string, contains a file sql commented part
//          */
//         static whileGuard(comment: string) {
//             if (comment.toUpperCase().includes('@WHILE') && comment.toUpperCase().split('@WHILE').length != comment.toUpperCase().split('@ENDWHILE').length)
//                 throw new Error('Number of @WHILE and @ENDWHILE isnt equal');


//         }


//         /**
//          * checks if the number of '@if' and '@endif' is equal
//          * @param comment string, contains a file sql commented part
//          */
//         static ifGuard(comment: string) {
//             if (comment.toUpperCase().includes('@IF') && comment.toUpperCase().split('@IF').length != comment.toUpperCase().split('@ENDIF').length)
//                 throw new Error('Number of @IF and @ENDIF isnt equal');


//         }


//         /**
//          * checks if the number of '@section' and '@endsection' is equal
//          * @param comment string, contains a file sql commented part
//          */
//         static sectionGuard(comment: string) {
//             if (comment.toUpperCase().includes('@SECTION') && comment.toUpperCase().split('@SECTION').length != comment.toUpperCase().split('@ENDSECTION').length)
//                 throw new Error('Number of @SECTION and @ENDSECTION isnt equal');

//         }

//         /**
//          * checks if the order in which 2 or more nests are written is right
//          * @param content string, contains a file sql commented part
//          * @param arr string array, ideally starts from empty, will contain one or more '@if', '@while', '@section' or '@state'
//          */
//         static checkIfWrittenCorrectly(content: string, arr: string[]) {

//             const index = Utilities.getProcedureFirstIndex(content);


//             if (content.toUpperCase().substring(index, content.indexOf(' ', index)).includes('@END')) {
//                 this.checkIfCorrectType(arr[arr.length - 1], content.toUpperCase().substring(index, content.indexOf(' ', index)));
//                 arr.pop();
//             } else
//                 arr.push(content.toUpperCase().substring(index, content.indexOf(' ', index)));

//             if (content.toUpperCase().substring(content.indexOf(' ', index)).includes('@END'))
//                 this.checkIfWrittenCorrectly(content.toUpperCase().substring(content.indexOf(' ', index)), arr);

//             arr.pop();
//             if (arr.length != 0)
//                 throw new Error('Procedure is nested wrong');
//         }
//         /**
//          * checks if two specific strings' substrings are equal
//          * @param expected string, contains a '@state' or '@if' or '@while' or '@section'  string from which we'll get a substring that we want to check if is equal to the expectedend substring
//          * @param expectedend string, contains a '@end' string we will from which we'll get a substring that we want to check if is equal to the expected substring
//          */
//         static checkIfCorrectType(expected: string, expectedend: string) {
//             expected = expected.substring(1);
//             expectedend = expectedend.substring(4);
//             if (expected != expectedend)
//                 throw new Error('@' + expected + ' is nested wrong');
//         }
//     }
// }