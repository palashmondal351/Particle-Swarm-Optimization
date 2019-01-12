%% This code is wtiten from book soft computing with matlab programming 
%with not changing any value of the code that is mention in the book of 
%soft computing with matlab programming by simon and padhy.................
% code self type by PALASH MONDAL, CSE, MTECH, NIT DURGAPUR................
%%
clear all; % clear all the previous variable ..............................

%% INITIAL PSO PARAMETER...................................................
minmax=0;       % minmax-(0-minimize)(1-maximize)..........................
max_epch=100;   % maximum no of iteration (epochs) to train................
ps_size=10;     % population size..........................................
max_vel=4;      % maximum particle velocity................................
ac1=2;          % acceleration const 1( local best influrence)............. 
ac2=2;          % acceleration const 2( global best influrence)............
iw1=0.9;        % initial inertia weight...................................
iw2=0.9;        % final inertia weight.....................................
iwe=100;        % iteration (epoch) by which inertial weight should be at.. 
                % final value..............................................
D=1;            % number of variable in the object function................
 
%% INITIALIZING THE DOMAIN RANGE FOR THE INPUT VARIABLE, -1 TO 2,..........
VRmin=ones(D,1)*-1;
VRmax=ones(D,1)*2;
VR=[VRmin,VRmax];
%% INITIALIZE POPULATION OF PARTICLE AND THERE VELOCITIES..................
for dimcnt=1:D
   pos(1:ps_size,dimcnt)=normpos(randn([ps_size,1]),dimcnt,VR); 
   % construct of random population positions bounded by VR................
   vel(1:ps_size,dimcnt)= normposv(rand([ps_size,1]),max_vel);
   % costruct random velocities between -max_vel,max_vel ..................
end

%% INITIAL PBEST POSITION VALUES ..........................................
pbest=pos;
for j=1:ps_size        % start particle loop...............................
    numin='0';
    for i=1:D
       numin=strcat(numin, ',', num2str(pos(j,i)));
    end
   evstrg=strcat('feval(''','obj','''',numin(2:end),')');
   out(j)=eval(evstrg);    % Evalute desired function with Particle j......
end
evstrg;
pbestval=out;              % initially pbest is the same as pos............

%% ASSIGN INITIAL GBEST VALUES (GBEST AND GBESTVAL)

if minmax==1 
  [gbestval,idx1]=max(pbestval); % this picks maximum value when we want to
elseif minmax==0                 % maximize the function...................          
  [gbestval,idx1]=min(pbestval); % this work for straight maximization.....           
end
gbest=pbest(idx1,:);              % This is gbest position.................
tr(1)=gbestval;                   % Save for output........................

%% START PSO ITERATION PROCEDURES
cnt=0;                           % Counter use for the stopping subrutin... 
for i=1:100                      % start epoch loop (iteration)............
    for j=1:ps_size              % start particle loop.....................
        particle =j;
        numin='0';
        

%% GETS NEW VELOCITYS, POSITIONS
if i<=iwe
    iwt(i)=((iw2-iw1)/(iwe-1))*(i-1)+iw1; % get inertia weight just a .....
else                                      % linear function w.r.t epoch ...
    iwt(1)=iw2;                           % parameter iwe..................
end 
iwt;
for dimcnt=1:D
    rannum1=rand(1);
    rannum2=rand(1);
    nc(j,1)=rannum1;
    nc(j,2)=rannum2;
    vel(j,dimcnt)=iwt(i)*vel(j,dimcnt)+ac1*rannum1*(pbest(j,dimcnt)-pos(j,dimcnt))...
        +ac2*rannum2*(gbest(1,dimcnt)-pos(j,dimcnt));
end

%% UPDATE NEW POSITION
pos(j,:)=pos(j,:)+vel(j,:);
psotb=pos;
veltb(j,:)=vel(j,:);

%% LIMIT VELICITY/POSITION COMPONENT TO MAXIMUM EXTERMES
for dimcnt=1:D
    if vel(j,dimcnt)>max_vel
        vel(j,dimcnt)=max_vel;
    end
    if vel(j,dimcnt)<-max_vel
        vel(j,dimcnt)=-max_vel;
    end
    if pos(j,dimcnt)>=VR(dimcnt,2)
        pos(j,dimcnt)=VR(dimcnt,2);
    end
    
    if pos(j,dimcnt)<=VR(dimcnt,1)
        pos(j,dimcnt)=VR(dimcnt,1);
    end
end
post=pos;
velt(j,:)=vel(j,:);
for dimcnt=1:D
    numin=strcat(numin,',',num2str(pos(j,dimcnt)));
end
evstrg=strcat('feval(''','obj','''',numin(2:end),')');
out(j)=eval(evstrg);       % Evaluate desire function with particle j......
e(j)=out(j);               % Use to minimize or maximize function to ......
                           % unknown values................................
                           
%% UPDATE PBEST TO TEFLECT SEARCHING FOR MAX OR MIN OF FUNCTION
if minmax==0
    if pbestval(j)>=e(j);
        pbestval(j)=e(j);
        pbest(j,:)=pos(j,:);
    end
elseif minmax==1
    if pbestval(j)<=e(j);
        pbest(j,:)=pos(j,:);
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
tr(i+1)=gbestval;                    % keep track of global best value ....
te=i;                                % This will the epoch no.to calling ..
                                     % program when done...................
end                                  % end particle loop...................

disp('Best Varialbe (X):');
disp(gbest);
disp('Best Solution obtain so far:');
disp(gbestval);
gbestfnplot(i,1)=gbestval;
disp('Number of Epochs:');
disp(te);
end                                   % End Epochs loop....................

%% DISPLAY OF RESULTS
figure(1)
plot(1:100,gbestfnplot);
xlabel('Number of Iteration/Epoch');
ylabel('f(x)');
title('Convergence plot using PSO')






