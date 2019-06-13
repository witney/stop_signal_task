function [x] = round_decimal(x, decimal_places)
% Round a matrix to a given number of decimal places

    x = round(x * 10^decimal_places) / 10^decimal_places;
end