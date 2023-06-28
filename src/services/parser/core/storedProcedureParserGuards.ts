import { Utilities } from './utilities';

export namespace StoredProcedureParserGuard {
    export class Guard {

        private constructor() { }

        static stateGuard(comment: string) {
            if (comment.replace(/((\n)|(\t)|(\r)|[ ])+/, '') == '')
                throw new Error('The string is empty');

            if (comment.toUpperCase().includes('@STATE') && comment.toUpperCase().split('@ENDSTATE').length != comment.toUpperCase().split('@ENDSTATE').length)
                throw new Error('Number of @state and @ENDSTATE isnt equal');

            //----------------------------------------------------
            if (comment.toUpperCase().includes('@STATE') && comment.toUpperCase().includes('@IF') && comment.indexOf('@STATE') > comment.indexOf('@IF') && comment.indexOf('@STATE') > comment.indexOf('@ENDIF'))
                this.stateGuard(comment.toUpperCase().replace(comment.toUpperCase().substring(comment.toUpperCase().indexOf('@IF'), comment.toUpperCase().indexOf('\n', comment.toUpperCase().indexOf('@ENDIF')) + 1), ''));
            else
                if (comment.toUpperCase().includes('@IF'))
                    throw new Error('@state cannot be nested');

            if (comment.toUpperCase().includes('@STATE') && comment.toUpperCase().includes('@WHLE') && comment.indexOf('@STATE') > comment.indexOf('@WHILE') && comment.indexOf('@STATE') > comment.indexOf('@ENDWHILE'))
                this.stateGuard(comment.toUpperCase().replace(comment.toUpperCase().substring(comment.toUpperCase().indexOf('@WHILE'), comment.toUpperCase().indexOf('\n', comment.toUpperCase().indexOf('@ENDWHILE')) + 1), ''));
            else
                if (comment.toUpperCase().includes('@WHILE'))
                    throw new Error('@state cannot be nested');

            if (comment.toUpperCase().includes('@STATE') && comment.toUpperCase().includes('@SECTION') && comment.indexOf('@STATE') > comment.indexOf('@SECTION') && comment.indexOf('@STATE') > comment.indexOf('@ENDSECTION'))
                this.stateGuard(comment.toUpperCase().replace(comment.toUpperCase().substring(comment.toUpperCase().indexOf('@SECTION'), comment.toUpperCase().indexOf('\n', comment.toUpperCase().indexOf('@ENDSECTION')) + 1), ''));
            else
                if (comment.toUpperCase().includes('@SECTION'))
                    throw new Error('@state cannot be nested');

            //------------------------------------------------------------

            if (comment.toUpperCase().includes('@STATE') && comment.toUpperCase().indexOf('@STATE') < comment.toUpperCase().indexOf('@ENDSTATE'))
                this.stateGuard(comment.toUpperCase().replace(comment.toUpperCase().substring(comment.toUpperCase().indexOf('@STATE'), comment.toUpperCase().indexOf('\n', comment.toUpperCase().indexOf('@ENDSTATE')) + 1), ''));
            else
                if (comment.toUpperCase().includes('@STATE'))
                    throw new Error('There might be badly nested @STATE');
        }

        static whileGuard(comment: string) {
            if (comment.toUpperCase().split('@WHILE').length != comment.toUpperCase().split('@ENDWHILE').length)
                throw new Error('Number of @WHILE and @ENDWHILE isnt equal');

            this.checkIfWrittenCorrectly(comment, '@WHILE', '@STATE');
            this.checkIfWrittenCorrectly(comment, '@WHILE', '@IF');
            this.checkIfWrittenCorrectly(comment, '@WHILE', '@SECTION');

        }

        static ifGuard(comment: string) {
            if (comment.toUpperCase().split('@IF').length != comment.toUpperCase().split('@ENDIF').length)
                throw new Error('Number of @IF and @ENDIF isnt equal');

            this.checkIfWrittenCorrectly(comment, '@IF', '@STATE');
            this.checkIfWrittenCorrectly(comment, '@IF', '@WHILE');
            this.checkIfWrittenCorrectly(comment, '@IF', '@SECTION');

        }

        static sectionGuard(comment: string) {
            if (comment.toUpperCase().split('@SECTION').length != comment.toUpperCase().split('@ENDSECTION').length)
                throw new Error('Number of @SECTION and @ENDSECTION isnt equal');


            this.checkIfWrittenCorrectly(comment, '@SECTION', '@STATE');
            this.checkIfWrittenCorrectly(comment, '@SECTION', '@WHILE');
            this.checkIfWrittenCorrectly(comment, '@SECTION', '@IF');


        }


        static checkIfWrittenCorrectly(content: string, target: string, contentTarget: string) {
            const endtarget = '@END' + target.substring(1);
            const endContentTarget = '@END' + contentTarget.substring(1);
            if (content.toUpperCase().includes(contentTarget) && content.toUpperCase().includes(target) && content.toUpperCase().indexOf(target) < content.toUpperCase().indexOf(contentTarget) && content.toUpperCase().indexOf(endtarget) < content.toUpperCase().indexOf(contentTarget))
                this.checkIfWrittenCorrectly(content.toUpperCase().replace(content.toUpperCase().substring(content.toUpperCase().indexOf(target), content.toUpperCase().indexOf('\n', content.toUpperCase().indexOf(endtarget)) + 1), ''), target, contentTarget);
            else
            if (content.toUpperCase().includes(contentTarget) && content.toUpperCase().includes(target) && content.toUpperCase().indexOf(target) > content.toUpperCase().indexOf(contentTarget) && content.toUpperCase().indexOf(endtarget) < content.toUpperCase().indexOf(endContentTarget))
                this.sectionGuard(content.toUpperCase().replace(content.toUpperCase().substring(content.toUpperCase().indexOf(target), content.toUpperCase().indexOf('\n', content.toUpperCase().indexOf(endtarget)) + 1), ''));
            else
                throw new Error(target + '/' + endtarget + 'is written wrong');
        }
    }
}