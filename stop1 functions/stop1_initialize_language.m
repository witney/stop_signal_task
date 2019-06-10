%%modified by Nicki Swann 4/22/09 for standard stopping

function [exp] = stop1_initialize_language(exp)

    if exp.debug || isempty(input('What language (Type ''s'' for spanish, press ENTER for English): ', 's'))
        exp.language.language = 'english';
        exp.language.fixation_cue = '+';
        exp.language.rest_text = 'You may rest until you are ready to proceed\n\n(press any key to continue)';
    else
        exp.language.language = 'spanish';
        exp.language.fixation_cue = '+';
        exp.language.rest_text = 'Usted puede descansar hasta que usted esté listo para continuar\n\n(pulse la barra espaciadora para continuar)';
    end

end