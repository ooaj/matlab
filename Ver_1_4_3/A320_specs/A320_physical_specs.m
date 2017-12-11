%% PHYSICAL SPECIFICATIONS

Aircraft_mean_chord = 4.2977 ; % [m]
Aircraft_wingspan = 33.92 ; % [m]
rd = 4.2977 ; % [m]
Aircraft_referance_area = 122.3533 ; % [m^2]
Aircraft_initial_mass = 42400 ; % [kg]

% Moment_of_Inertia
I_xx = 942877*14.5939029/0.3048^2 ; % [kg/m^2]
I_yy = 2.78892*10^6*14.5939029/0.3048^2 ; % [kg/m^2]
I_zz = 3.59757*10^6*14.5939029/0.3048^2 ; % [kg/m^2]
I_xy = 0 ; % [kg/m^2]
I_xz = -10000*14.5939029/0.3048^2 ; % [kg/m^2]
I_yz = 0 ; % [kg/m^2]

Inertial_matrix = [I_xx I_xy I_xz ; -I_xy I_yy I_yz ; -I_xz -I_yz I_zz] ;
