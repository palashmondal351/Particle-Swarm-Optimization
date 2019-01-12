%% This code is wtiten from book soft computing with matlab programming 
% soft computing with matlab programming by simon and padhy................
% self type and modified by PALASH MONDAL, CSE, MTECH, NIT DURGAPUR, India.
% Email id: palashmondal351@gmail.com......................................

%% CLEARING WINDOWS VARIABLE COMMAND
tic
clear all              % Clear all the previous variable .................
close all              % Close all the working MatLab windows.............
clc

%% INITIAL PSO PARAMETER...................................................

minmax=0;               % minmax-(0-minimize)(1-maximize)..................
max_epch=100;           % maximum no of iteration (epochs) to train........
particle_size=100;      % population size..................................
max_vel=4;              % maximum particle velocity........................
accleration_1=1.0;      % acceleration const 1( local best influrence)..... 
accleration_2=1.5;      % acceleration const 2( global best influrence)....
initial_iteration_wt=0.9;% initial inertia weight..........................
final_iteration_wt=0.2; % final inertia weight.............................
iwe=100;                % iteration (epoch) by which inertial weight should 
                        %  be at final value...............................
D=1;                    % number of variable in the object function........

%% CONSTRUCTION COFFICIENT 
% This concept taken from (Yarzip, propose by Eberhart & Keneedi)..........
kappa=1;
phi1=2.05;
phi2=2.05;
phi=phi1+phi2;
chi=2*kappa/abs(2-phi-sqrt(phi^2-4*phi));

%% INITIALIZING THE DOMAIN RANGE FOR THE INPUT VARIABLE, -1 TO 2,..........

VRmin=ones(D,1)*-1;
VRmax=ones(D,1)*2;
VR=[VRmin,VRmax];

%% INITIALIZE POPULATION OF PARTICLE AND THERE VELOCITIES..................

for dimcnt=1:D
   particle_position(1:particle_size,dimcnt)=normpos(randn([particle_size,1]),dimcnt,VR); 
   % construct of random population positions bounded by VR................
   particle_velocity(1:particle_size,dimcnt)= normposv(rand([particle_size,1]),max_vel);
   % costruct random velocities between -max_vel,max_vel ..................
end

%% INITIAL PBEST POSITION VALUES ..........................................

pbest=particle_position;
for j=1:particle_size                    % start particle loop.............
    numin='0';
    for i=1:D
       numin=strcat(numin, ',', num2str(particle_position(j,i)));
    end
   evstrg=strcat('feval(''','obj','''',numin(2:end),')');
   out(j)=eval(evstrg);  % Evalute desired function with Particle j........
end
evstrg;
pbestval=out;            % initially pbest is the same as particle_position

%% ASSIGN INITIAL GBEST VALUES (GBEST AND GBESTVAL)

if minmax==1 
  [gbestval,idx1]=max(pbestval);      % this picks maximum value when we... 
elseif minmax==0                      % want to maximize the function......          
  [gbestval,idx1]=min(pbestval);      % this work for straight maximization          
end
gbest=pbest(idx1,:);                  % This is gbest position.............
tr(1)=gbestval;                       % Save for output....................

%% START PSO ITERATION PROCEDURES

cnt=0;                              % Counter use for the stopping subrutin
for i=1:100                         % start epoch loop (iteration).........
    for j=1:particle_size           % start particle loop..................
        particle =j;
        numin='0';
        
%% GETS NEW VELOCITYS, POSITIONS

if i<=iwe
    inertia_weight(i)=((final_iteration_wt-initial_iteration_wt)/(iwe-1))*(i-1)+initial_iteration_wt;
    % get inertia weight just a linear function w.r.t epoch (padhy & simon)
else                                     
    inertia_weight(1)=final_iteration_wt; % parameter iwe..................
end 
inertia_weight;
for dimcnt=1:D
    rannum1=rand(1);
    rannum2=rand(1);
    nc(j,1)=rannum1;
    nc(j,2)=rannum2;
    particle_velocity(j,dimcnt) = chi.*(inertia_weight(i)*particle_velocity(j,dimcnt)...
    +accleration_1*rannum1.*(pbest(j,dimcnt)-particle_position(j,dimcnt))...
        +accleration_2*rannum2.*(gbest(1,dimcnt)-particle_position(j,dimcnt)));
    % the parameter proved to be very critical because large values could 
    % result in particle moving away from good solution, wheres small
    % values results in in efficient expolaration in search space the lack
    % of control mechanism for velocity poor results in PSO to adjust
    % velocity multiply it with chi ( in book simon and padhy )...........
end

%% UPDATE NEW POSITION

particle_position(j,:)=particle_position(j,:)+particle_velocity(j,:);
psotb=particle_position;
particle_velocitytb(j,:)=particle_velocity(j,:);

%% LIMIT VELICITY/POSITION COMPONENT TO MAXIMUM EXTERMES

for dimcnt=1:D
    if particle_velocity(j,dimcnt)>max_vel
        particle_velocity(j,dimcnt)=max_vel;
    end
    if particle_velocity(j,dimcnt)<-max_vel
        particle_velocity(j,dimcnt)=-max_vel;
    end
    if particle_position(j,dimcnt)>=VR(dimcnt,2)
        particle_position(j,dimcnt)=VR(dimcnt,2);
    end
    
    if particle_position(j,dimcnt)<=VR(dimcnt,1)
        particle_position(j,dimcnt)=VR(dimcnt,1);
    end
end
post=particle_position;
velt(j,:)=particle_velocity(j,:);
for dimcnt=1:D
    numin=strcat(numin,',',num2str(particle_position(j,dimcnt)));
end
evstrg=strcat('feval(''','obj','''',numin(2:end),')');
out(j)=eval(evstrg);       % Evaluate desire function with particle j......
e(j)=out(j);               % Use to minimize or maximize function to ......
                           % unknown values................................
                           
%% UPDATE PBEST TO REFLECT SEARCHING FOR MAX OR MIN OF FUNCTION

if minmax==0
    if pbestval(j)>=e(j)
        pbestval(j)=e(j);
        pbest(j,:)=particle_position(j,:);
    end
elseif minmax==1
    if pbestval(j)<=e(j)
        pbest(j,:)=particle_position(j,:);
    end
end

%% ASSIGN GBEST BY FINDING MINIMUM OF ALL PARTICLE PBESTS

if minmax==1
    [iterbestval,idx1]=max(pbestval);
    if gbestval<=iterbestval
        gbestval=iterbestval;
        gbest=pbest(idx1,:);
    end
elseif minmax==0
    [iterbestval,idx1]=min(pbestval); % it picks gbestval when we want to..
    if gbestval>iterbestval           % minimize the function..............
    gbestval=iterbestval;
    gbest=pbest(idx1,:);
    end 
end
tr(i+1)=gbestval;     % keep track of global best value ...................
te=i;                 % This will return the epoch no.to calling program when done                                      
end                   % end particle loop..................................
gbestfnplot(i,1)=gbestval;
fprintf('No.of Epochs    Best variable(x)     Best sol. obtain so far\n');
fprintf('%8g           %8.4f               %8.4f\n', te, gbest, gbestval);
disp('..................................................................');
end                                  % End Epochs loop.....................

%% DISPLAY OF RESULTS

figure(1)
plot(1:100,gbestfnplot,'-*green');
xlabel('Number of Iteration/Epoch');
ylabel('Best variable (x) for Global Best');
title('Convergence Plot using PSO');
legend(['curve shows results of' newline 'Iteration vs. Best Variable']);
toc;

