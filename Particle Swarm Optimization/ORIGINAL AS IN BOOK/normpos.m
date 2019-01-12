%% MAPPING THE INITIAL RANDOM POSITIONS GENERATED WITHEN VARIABLE'S 
%BOUNDARY LIMITS
function [out]=normpos(var1,dimcnt,var2)
X1=max(var1);
X2=min(var1);
Y1=var2(dimcnt,2);
Y2=var2(dimcnt,1);
out=((var1-X1)*(Y2-Y1)/(X2-X1))+Y1;  % Normalizing using two line equation
end