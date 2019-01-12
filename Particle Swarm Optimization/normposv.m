%% MAPPING THE INITIAL RANDOM POSITION GENERATED WITHEN VELOCITY
%BOUNDARY LIMITS
function[out]=normposv(var1,max_vel)
X1=max(var1);
X2=min(var1);
Y2=-max_vel;
Y1=max_vel;
out=((var1-X1)*(Y2-Y1)/(X2-X1))+Y1; % Normalizing using a two line equation
end    