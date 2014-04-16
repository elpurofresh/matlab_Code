
clear all;

%% Repulsive forces variables
ep_0    = 8.85e-12;                 % Dielectric permittivity in vaccum
ep_r    = 80;                       % Relatively dielectric permittivity of water
a_p     = 0.68;                     % Bacteria's radius
psi_p   = -36.32;                   % Zeta potential bacteria
psi_c   = -14.06;                   % Zeta potential clay
k       = 2.9059e16;                % Debye's length
h       = [0 10 20 30 40 50];       % Separation distance
phi_edl = [0 0 0 0 0 0];            % Repulsive force

%% Attractive forces variables
A       = 6.5e-21;                  % Hamaker constant for interaction media
lambda  = 100;                      % Wavelength of dielectric
phi_vdw = [0 0 0 0 0 0];            % Attraction forces


%% Repulsive force equation

for i = 1:6
phi_edl(i) = pi * ep_0 * ep_r * a_p *...
    (... 
    (2 * psi_p * psi_c * ...
    log((1 + exp(-k * h(i)))/(1 - exp(-k * h(i)))) + ...
    (psi_p^2 + psi_c^2) * log(1 - exp(-2 * k * h(i)))...
    )...
    );
end

%% Attractive forces equation

phi_vdw = ((-A* a_p) / 6 * h(i)) * (1 + ((14 * h(i))/(lambda)))^(-1);




%% Plot 
plot(h, phi_edl);





