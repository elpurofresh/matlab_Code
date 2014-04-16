clear all;

%% Repulsive forces variables                   % Description & Units
ep_0    = 8.85e-12;                             % Dielectric permittivity in vaccum             (C^2/J*m)
ep_r    = 80;                                   % Relatively dielectric permittivity of water   (Dimensionless)
a_p     = 1.2e-6; %0.68e-6; %1.2e-6;               % Bacteria's radius                             (m)
psi_p   = -35.01e-3; %-36.32e-3; %-35.01e-3;       % Zeta potential bacteria @ pH 4                (V)
psi_c   = -14.06e-3;                               % Zeta potential clay @ pH 4                    (V)
k_debye = [7.57e-9^-1 7.13e-9^-1 13.44e-9^-1];           % Debye's length                                (m)
h       = [0.05e-9 10e-9 20e-9 30e-9 40e-9 50e-9 60e-9 70e-9 80e-9];       % Separation distance     (m)
phi_edl = zeros(3, 9);                          % Repulsive force                               (N)

%% Attractive forces variables
A       = 6.5e-21 ;                              % Hamaker constant for interaction media        (J)
lambda  = 100e-9;                                  % Wavelength of dielectric                      (nm)
phi_vdw = zeros(1,9);                           % Attraction forces                             (N)


%% Final result matrix
final = zeros(3,9);                             % Final value


%% Repulsive force equation

for m = 1:3
    for i = 1:9
        phi_edl(m,i) = pi * ep_0 * ep_r * a_p *...
        (... 
        (2 * psi_p * psi_c * ...
        log( (1 + exp(-k_debye(m) * h(i))) / (1 - exp(-k_debye(m) * h(i))) ) + ...
        (psi_p^2 + psi_c^2) * log(1 - exp(-2 * k_debye(m) * h(i)))...
        )...
        );
    end
end

%% Attractive forces equation

for j = 1:9
    phi_vdw(j) = ((-A* a_p) / 6 * h(j)) * (1 + ((14 * h(j))/(lambda)))^-1;
end

%% Final equation
for m = 1:3
    for k = 1:9
        final(m,k) = phi_edl(m,k) + phi_vdw(k);
    end
end

%% Plot 

ylim([-0.00003 0.00001]);

plot(h, final(1,:), 'bo-');
hold on;
plot(h, final(2,:), 'rx-');
hold on;
plot(h, final(3,:), 'k*-');
hold on;




