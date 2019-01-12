%% OBJECTIVE FUNCTION
function [out]=obj(x)
out=x*(sin(10*pi*x))+1;  % function to minimize or maximize
end