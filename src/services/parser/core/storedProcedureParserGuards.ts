import { Utilities } from './utilities';

export namespace StoredProcedureParserGuard {
    export class Guard {

        private constructor() { }

        static stateGuard(comment: string) {
            if (comment.replace(/((\n)|(\t)|(\r)|[ ])+/, '') == '')
                throw new Error('The string is empty');

            if (comment.toUpperCase().includes('@STATE') && comment.toUpperCase().split('@STATE').length != comment.toUpperCase().split('@ENDSTATE').length)
                throw new Error('Number of @state and @ENDSTATE isnt equal');

            //----------------------------------------------------

            if (comment.toUpperCase().includes('@STATE') && comment.toUpperCase().includes('@IF') && comment.toUpperCase().indexOf('@STATE') > comment.toUpperCase().indexOf('@IF') && comment.toUpperCase().indexOf('@STATE') > comment.toUpperCase().indexOf('@ENDIF'))
                this.stateGuard(comment.toUpperCase().replace(comment.toUpperCase().substring(comment.toUpperCase().indexOf('@IF'), comment.toUpperCase().indexOf('\n', comment.toUpperCase().indexOf('@ENDIF')) + 1), ''));
            else
            if (comment.toUpperCase().includes('@IF') && comment.toUpperCase().indexOf('@STATE') > comment.toUpperCase().indexOf('@IF'))
                throw new Error('@state cannot be nested');
            
            if (comment.toUpperCase().includes('@STATE') && comment.toUpperCase().includes('@WHILE') && comment.toUpperCase().indexOf('@STATE') > comment.toUpperCase().indexOf('@WHILE') && comment.toUpperCase().indexOf('@STATE') > comment.toUpperCase().indexOf('@ENDWHILE'))
                this.stateGuard(comment.toUpperCase().replace(comment.toUpperCase().substring(comment.toUpperCase().indexOf('@IF'), comment.toUpperCase().indexOf('\n', comment.toUpperCase().indexOf('@ENDWHILE')) + 1), ''));
            else
            if (comment.toUpperCase().includes('@WHILE') && comment.toUpperCase().indexOf('@STATE') > comment.toUpperCase().indexOf('@WHILE'))
                throw new Error('@state cannot be nested');

            if (comment.toUpperCase().includes('@STATE') && comment.toUpperCase().includes('@SECTION') && comment.toUpperCase().indexOf('@STATE') > comment.toUpperCase().indexOf('@SECTION') && comment.toUpperCase().indexOf('@STATE') > comment.toUpperCase().indexOf('@ENDSECTION'))
                this.stateGuard(comment.toUpperCase().replace(comment.toUpperCase().substring(comment.toUpperCase().indexOf('@SECTION'), comment.toUpperCase().indexOf('\n', comment.toUpperCase().indexOf('@ENDSECTION')) + 1), ''));
            else
            if (comment.toUpperCase().includes('@STATE') && comment.toUpperCase().includes('@SECTION') && comment.toUpperCase().indexOf('@STATE') > comment.toUpperCase().indexOf('@SECTION'))
                throw new Error('@state cannot be nested');
            
            //------------------------------------------------------------

            if (comment.toUpperCase().includes('@STATE') && comment.toUpperCase().indexOf('@STATE') < comment.toUpperCase().indexOf('@ENDSTATE'))
                this.stateGuard(comment.toUpperCase().substring(comment.toUpperCase().indexOf('\n', comment.toUpperCase().indexOf('@ENDSTATE'))));
            else
            if (comment.toUpperCase().includes('@STATE'))
                throw new Error('There might be badly nested @STATE');


        }


        static whileGuard(comment: string) {
            if (comment.toUpperCase().includes('@WHILE') && comment.toUpperCase().split('@WHILE').length != comment.toUpperCase().split('@ENDWHILE').length)
                throw new Error('Number of @WHILE and @ENDWHILE isnt equal');


        }

        static ifGuard(comment: string) {
            if (comment.toUpperCase().includes('@IF') && comment.toUpperCase().split('@IF').length != comment.toUpperCase().split('@ENDIF').length)
                throw new Error('Number of @IF and @ENDIF isnt equal');


        }

        static sectionGuard(comment: string) {
            if (comment.toUpperCase().includes('@SECTION') && comment.toUpperCase().split('@SECTION').length != comment.toUpperCase().split('@ENDSECTION').length)
                throw new Error('Number of @SECTION and @ENDSECTION isnt equal');

        }

        static checkIfWrittenCorrectly(content:string, arr:string[]){
            
            const index = Utilities.getProcedureFirstIndex(content);


            if (content.toUpperCase().substring(index, content.indexOf(' ', index)).includes('@END')){
                this.checkIfCorrectType(arr[arr.length - 1], content.toUpperCase().substring(index, content.indexOf(' ', index)));
                arr.pop();
            }else
                arr.push(content.toUpperCase().substring(index, content.indexOf(' ', index)));

            if (content.toUpperCase().substring(content.indexOf(' ', index)).includes('@END'))
                this.checkIfWrittenCorrectly(content.toUpperCase().substring(content.indexOf(' ', index)), arr);
            
            arr.pop();
            if(arr.length!=0)
                throw new Error('Procedure is nested wrong');
        }
        static checkIfCorrectType(expected:string, expectedend:string){
            expected=expected.substring(1);
            expectedend = expectedend.substring(4);
            if(expected!=expectedend)
                throw new Error('@'+expected+' is nested wrong');
        }
    }
}