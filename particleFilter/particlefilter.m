clc
close all
clear all

% Receive target trajectory beforehand for convenience
targetAcquirePath

% State equation is 
%       x(t) =  [1 dt 0 0][x(t-1) ]  + [0.5nx*dt^2 ]
%       x'(t) = [0 1 0 0 ][x'(t-1)]  + [nx*dt      ]
%       y(t) =  [0 0 1 dt][y(t-1) ]  + [0.5*ny*dt^2]
%       y'(t) = [0 0 0 1 ][y'(t-1)]  + [ny*dt      ]
%
%   nx and ny are zero mean Gaussians with std = sqrt(2) (noise = acceleration)
%   Motion model follows s = ut + 1/2 a t^2

% Measurement equation is
%       z(t) = s(t) + nz
%       nz is zero mean Gaussian with std = 0.2

N_state = 4;            
processNoiseStdX = sqrt(2);                                           % S.D. of X and Y state noise
processNoiseStdY = sqrt(2);
delta_time = 1;                                                     % Unit time step
particleCount = 100;                                               % Number of particles
W = ones(1,particleCount);                                          % Initialize uniform weights

A = [1 1 0 0 ; 
    0 1 0 0 ; 
    0 0 1 1 ; 
    0 0 0 1];
noiseCoeff1 = [0.5; 1];
noiseCoeff2 = [0.5; 1];
noiseRandomized = processNoiseStdX*noiseCoeff1;
noiseRandomized = [noiseRandomized; processNoiseStdY*noiseCoeff2];

measurementNoiseStd = 0.2;                                         

x_prior = [];

% Initialize the first position of the box, known, (30, 0, 20, 0)
initialState = [targetPositionCorrected(1,1) ; 0 ; targetPositionCorrected(1,2) ; 0];
    
%For maximizing the figure initially using JAVA: not essential
figure;
pause(0.00001);
frame_h = get(handle(gcf),'JavaFrame');
set(frame_h,'Maximized',1);

for i=2:200
    %Receive the actual position of the target and store as observed state
    
    observedPositionX = targetPositionCorrected(i,1);
    observedPositionY = targetPositionCorrected(i,2);
    observedVelocityX = 0;
    observedVelocityY = 0;    
    observedState = [observedPositionX ; observedVelocityX ; observedPositionY ; observedVelocityY];
    
    %Corrupt it with measurement noise to simulate sensor measurement
    y = 1*observedState + measurementNoiseStd*randn(4,1);
    
    %Plot actual and measured positions of target
    subplot(2,2,1)
    h2 = plot(observedPositionX, observedPositionY, 'gx')
    hold on 
    h3 = plot(y(1), y(3), 'bx')
    hold on
    observationDistance = [];
    
    %Create new particles or propagate existing ones through state model to get new set of particles
    x_prior = []
    
    for j=1:particleCount
        nx = noiseRandomized(1:2)*randn;
        ny = noiseRandomized(3:4)*randn;
        x_prior(:,j) = A*initialState + [nx ; ny];
    end
    
    %Receive measurements for each state represented by a particle and
    %compare it with the measured position (by finding the distance between
    %the points). Calculate probability density/ likelihood function using this
    %distance as the metric.
    
    for j = 1:particleCount
        y_particle(:,j) = x_prior(:,j) + measurementNoiseStd*randn(4,1);
        observationDistance(j) = sqrt((y_particle(1,j)-y(1,1))^2 + (y_particle(3,j)-y(3,1))^2);
        P_ygivenx(j) = (1/(2*pi*measurementNoiseStd))*exp(-observationDistance(j)/(2*measurementNoiseStd^2)); 
    end
       
    %Normalize the probabilities
    P_ygivenx = P_ygivenx/sum(P_ygivenx);
    
    %Assign weights to the the members of the PDF and normalize
    for j=1:particleCount
        W(j) = W(j)*P_ygivenx(j);
    end
    
    W = W/sum(W);
    
    %Plot the weights
    subplot(2,2,3) 
    stem(W)
    title('Weights of particles at every iteration')
    
    %Find the best particle at every instant
    maxval = find(W==max(W));
    
    %Resample to find the set of closest particles by computing the
    %cumulative sum and finding the maximum values
    cdf = cumsum(W);
    cdf_length = length(cdf);
    counter = 1;
    u=([0:cdf_length-1]+(1/particleCount)*rand(1))/cdf_length;
    
    %For each particle, find what values in the CDF are lesser than the
    %uniform value computed above. This will let us know what the biggest
    %"jumps" are in the CDF, thus pointing us towards the most likely
    %particles. Update prior estimate with the most likely particles.
    
    for j = 1:particleCount
        while u(j) > cdf(counter)
            counter = counter+1;
        end
        importance(j) = counter;
        x_prior(:,j) = x_prior(:,counter);
        W(j) = 1/particleCount;
    end
   
    %Find posterior estimate by calculating mean of the most likely
    %particle states
    
    x_est = sum(x_prior(1,:))/particleCount;
    xv_est = sum(x_prior(2,:))/particleCount;
    y_est = sum(x_prior(3,:))/particleCount
    yv_est = sum(x_prior(4,:))/particleCount;
    
    %Plot estimate and the estimate of the target box in the original image
    %sequence
    
    subplot(2,2,2)
    imshow(imageinfo(:,:,i));
    hold on
    rectangle('Position',[x_est,y_est*-1,19,19])
    
    subplot(2,2,1)
    
    h4 = plot(x_est,y_est,'r.')
    hold on
    legend([h2(1) h3(1) h4(1)],'Actual position of target','Measurement of target','Estimate of target');
    drawnow
    
    %Compute error (in pixels) between the estimate and the actual position
    %of the target
    
    errorX(i) = x_est - observedPositionX;
    errorY(i) = y_est - observedPositionY;
    subplot(2,2,4)
    plot(errorX)
    hold on
    plot(errorY)
    hold on
    
    %Update initial state with the estimated values to kick off the next
    %iteration
    initialState = [x_est ; xv_est ; y_est ; yv_est];
    
end