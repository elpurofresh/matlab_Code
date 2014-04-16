
%% Define the velocity vector that will be used as one of the inputs'
% vector
%vel = zeros(size(ELd));

%for i = 1:size(vel)-1
 %   vel(i) = abs(ELd(i+1) - ELd(i));
%end

%vel(length(vel)) = abs(ELd(length(ELd)) - ELd(length(ELd)-1));

numPatterns = 4;
numCols = 2;
u = zeros(length(TempEL), numCols, numPatterns);
yFinal = zeros(length(TempEL), numCols, numPatterns);
tFinal = zeros(length(TempEL), numCols, numPatterns);

u(1:end,1:end,1) = TempEL;
u(1:end,1:end,2) = TempES;
u(1:end,1:end,3) = TempRL;
u(1:end,1:end,4) = TempRS;

%% Implement the state-space system
t = 1:1:length(TempEL);
x0 = [0 0 0];
A = n4s3.A;
B = n4s3.B;
C = n4s3.C;
D = n4s3.D;

for i = 1:numPatterns
    %     t = 0:1:length(vel)-1;
    %     t = 0:1:length(gpsSpd1)-1;
    %     u = [vel ELa];
    %     x0 = [0 0 0];
    %     A = n4s3.A;
    %     B = n4s3.B;
    %     C = n4s3.C;
    %     D = n4s3.D;
    if i == 1
        u = TempEL;
        [y1, t1] = lsim(A, B, C, D, u, t);
        figure(i);
        plot(t, y1);
    else
        if i == 2
            u = TempES;
            [y1, t1] = lsim(A, B, C, D, u, t);
            figure(i);
            plot(t, y1);
        else
            if i == 3
                u = TempRL;
                [y1, t1] = lsim(A, B, C, D, u, t);
                figure(i);
                plot(t, y1);
            else
                u = TempRS;
                [y1, t1] = lsim(A, B, C, D, u, t);
                figure(i);
                plot(t, y1);
            end
        end
    end
    
    %   [yFinal(1:end, 1:end, i), tFinal(1:end, 1:end, i)] = lsim(A, B, C, D, u, t);
    %   [y1 , t1] = lsim(A, B, C, D, u, t); %, x0);
    %   [b, a] = ss2tf(A, B, C, D, u);
    %   lsim(num, den, u, t);
    %   lsimplot(A, B, C, D, u, t, x0);
end

% for i = 1:length(TempEL)
%     figure(i);
%     %plot(tFinal(1:end, i), yFinal(1:end, i));
%     plot(tFinal(1:end, i), yFinal(1:end, i));
% end


%% unused stuff
% t = 0:1:length(gpsSpd1)-1;
% x0 = [0.5 0 0];
% [y, t] = lsim(n4s3.A,n4s3.B,n4s3.C,0,u,t,x0);
% plot(t, y);
