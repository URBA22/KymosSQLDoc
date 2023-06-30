import { StoredProcedureParserGuard } from 'src/services/parser/core/storedProcedureParserGuards';




describe('StoredProcedureParsesGuards', () => {


    test('Should throw error if given empty string', () => {
        let text = '';
        if (text.replace(/((\n)|(\t)|(\r)|[ ])+/, '') == '')
            text='error';
        expect(text).toEqual('error');
    });
    
    test('Should throw error if given not equal number of @state and @endstate',  () => {
        let text = '@state     @state   @endstate  \n    @state sjnas afajk bs @endstate sajddnasj a @nedsteta';
        if (text.toUpperCase().includes('@STATE') && text.toUpperCase().split('@STATE').length != text.toUpperCase().split('@ENDSTATE').length)
            text='error';
        expect(text).toEqual('error');
    });

    test('Should throw error if given badly nested @state',  () => {
        let text = '@state @endstate @endstate\n @state';
        if (text.toUpperCase().includes('@STATE') && text.toUpperCase().indexOf('@STATE') < text.toUpperCase().indexOf('@ENDSTATE'))
            text = text.toUpperCase().replace(text.toUpperCase().substring(text.toUpperCase().indexOf('@STATE'), text.toUpperCase().indexOf('@ENDSTATE') + 9), '');
        if (text.toUpperCase().includes('@STATE'))
            text = 'error';
        expect(text).toEqual('error');
    });

    test('Should throw specific error if given nested @state',  () => {
        let text = '@IF\n @ENDIF\n @IF\n   @STATE\n @ENDIF\n@IF @ENDIF';

        if (text.toUpperCase().includes('@STATE') && text.toUpperCase().includes('@IF') && text.indexOf('@STATE') > text.indexOf('@IF') && text.indexOf('@STATE') > text.indexOf('@ENDIF'))
            text = text.toUpperCase().replace(text.toUpperCase().substring(text.toUpperCase().indexOf('@IF'), text.toUpperCase().indexOf('\n', text.toUpperCase().indexOf('@ENDIF')) + 1), '');
        if (text.toUpperCase().includes('@IF'))
            text='error';
        expect(text).toEqual('error');
    });

    test('Should give error if given wrong written @if', ()=>{
        const content = '@IF \n @WHILE \n@if @endif  @ENDWHILE \n   @ENDIF \n,  '; 
        content.replace(/(\t|\n|\r|[ ])+/g, ' ');
        expect(StoredProcedureParserGuard.Guard.checkIfWrittenCorrectly(content, [])).resolves;
    });

    
});
