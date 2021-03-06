%% --------------------------
%   By Andres Mora; April 10, 2014
%   Kalman Filter to estimate the value of a random constant
%   In this case, the value of a resistor measured by a multimeter

% Clear screen and variable space
clc;
clear;

% Declare variables

% Voltage measurements: white noise corrupted, normally distributed around
% zero with standard deviation of 0.1 R = (0.1)*(0.1) = 0.01
z = [-0.46687,-0.36375,-0.39117,-0.49361,-0.2589,-0.37881,-0.32365,...
    -0.44891,-0.44283,-0.34583,-0.36659,-0.19245,-0.40478,-0.15601,-0.22642,...
    -0.57178,-0.54532,-0.43462,-0.39585,-0.37638,-0.29358,-0.4495,-0.44942,...
    -0.39739,-0.37932,-0.34938,-0.27144,-0.3151,-0.55233,-0.30754,-0.29612,...
    -0.31364,-0.24626,-0.34456,-0.44457,-0.3922,-0.62217,-0.32994,-0.36558,...
    -0.43638,-0.44274,-0.48534,-0.38204,-0.33934,-0.41031,-0.42726,-0.38087,...
    -0.39475,-0.473,-0.24802;];

z_true = ones(1, 50) * -0.37727; % True measurement of voltage: -0.37727 volts

A = 1;
B = 0;
H = 1;

Q = 1e-5;
R = 0.01;

u = zeros(1, 50);
I = ones (1, 50);

xhat_prior =  zeros(1, 50);           %<x_(k-1)
p_prior    =  zeros(1, 50);           %P_(k-1)
xhat_post = ones(1, 50);        %<x_k-
p_post = zeros(1, 50);          %P_k-
K_gain = zeros(1, 50);          %K_k, Kalman gain

xhat_prior(1) = 0;
p_prior(1) =   1;

xhat_post(1) = xhat_prior(1);
p_post(1) = p_prior(1) + Q;
K_gain(1) = p_post(1) / (p_post(1) + R);
xhat_prior(1) = xhat_post(1) + K_gain(1) * (z(1) - xhat_post(1));
p_prior(1) = (1 - K_gain(1)) * p_post(1);   

for i = 2: 50
    %project the state ahead
    %xhat_post(i) = A * xhat_prior(i) + B * u(i);
    xhat_post(i) = xhat_prior(i-1);
    
    %project the error covariance ahead
    %p_post(i) = (A * p_prior(i) * A') + Q;
    p_post(i) = p_prior(i-1) + Q;
    
    %Compute the Kalman gain
    %K_gain(i) = (p_post(i) * H') / (H* p_post(i) * H' + R);
    K_gain(i) = p_post(i) / (p_post(i) + R);
    
    %Update estimate with measurement z_k
    %xhat_prior(i) = xhat_post(i) + K_gain(i) * (z(i) - H * xhat_post(i));
    xhat_prior(i) = xhat_post(i) + K_gain(i) * (z(i) - xhat_post(i));

    %Update the error covariance
    %p_prior(i) = (I(i) - K_gain(i) * H) * p_post(i);   
    p_prior(i) = (1 - K_gain(i)) * p_post(i);   
end

for j = 1: 50
    x(j) = j;
end

subplot(3, 1, 1);
plot(x, xhat_post(x),'b', x, z(x),'g*', x, z_true(x),'r');
legend('estimation','noisy measurements','real constante value');
title('Predicted vs Estimated Voltage value');

subplot(3, 1, 2);
plot(x, p_post(x),'b', x, p_prior(x),'r');
%plot(p_post, 'color', 'r');
%hold on;
%plot(p_prior, 'color', 'b');
title('Error covariance');
%hold off;

subplot(3, 1, 3);
plot(x, K_gain(x), 'color', 'r');
title('Kalman Gain');
%hold off;







