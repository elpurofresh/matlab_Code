
clear all;

%% Repulsive forces variables
ep_0    = 8.85e-12;                 % Dielectric permittivity in vaccum
ep_r    = 80;                       % Relatively dielectric permittivity of water
a_p     = 0.68;                     % Bacteria's radius
psi_p   = -36.32;                   % Zeta potential bacteria
psi_c   = -14.06;                   % Zeta potential clay
k       = 7.1725e-12;               % Debye's length 2.9059e16
h       = [0.05 10 20 30 40 50 60 70 80];       % Separation distance
phi_edl = [0 0 0 0 0 0 0 0 0];            % Repulsive force

%% Attractive forces variables
A       = 6.5e-21;                  % Hamaker constant for interaction media
lambda  = 100;                      % Wavelength of dielectric
phi_vdw = [0 0 0 0 0 0 0 0 0];            % Attraction forces

final = [0 0 0 0 0 0 0 0 0];              % Final value


%% Repulsive force equation

for i = 1:9
phi_edl(i) = pi * ep_0 * ep_r * a_p *...
    (... 
    (2 * psi_p * psi_c * ...
    log((1 + exp(-k * h(i)))/(1 - exp(-k * h(i)))) + ...
    (psi_p^2 + psi_c^2) * log(1 - exp(-2 * k * h(i)))...
    )...
    );
end

%% Attractive forces equation

for j = 1:9
    phi_vdw(j) = ((-A* a_p) / 6 * h(j)) * (1 + ((14 * h(j))/(lambda)))^-1;
end

%% Final equation
for k = 1:9
    final(j) = phi_edl(j) + phi_vdw(j);
end


%% Plot 
plot(h, final);
ylim([-0.00003 0.00001]);





