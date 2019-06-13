function [val] = iif(boolean_expression, true_value, false_value)
    if boolean_expression
        val = true_value;
    else
        val = false_value;
    end
end