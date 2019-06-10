function [exp] = stop1_initialize_daq(exp)
exp.daq = input(sprintf('Do you want to send pulses with the daq? (press Enter if not, 1 is yes)'));
if isempty(exp.daq)
    exp.daq = 0;
elseif exp.daq ==1
     [exp] = send_ttl_pulse_with_daq(exp,'initialize');
end
    