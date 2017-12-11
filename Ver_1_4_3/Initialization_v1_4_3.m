clear all ;
close all ;
clc ;
and_now_it_begins = tic ;

%% USER SELECTION
er_enable = 0 ; % Earth Rate open(1)\close(0)
tr_enable = 0 ; % Transport Rate open(1)\close(0)
trim_enable = 1 ; % Initial conditions are adjusted for trimmedcondition
trim_cond = 1 ; % Trim condition 1 for Steady level || 2 for climb\descent

%% TRIM INPUTS (if they are used)
Vel_des = 200 ; % [m/s] desired velocity that is given by user
h_des = 9000 ; % [m] desired altitude that is given by user
latitude_des =  41.108891 ; % [deg] for gravity calculation
gamma_trim_for_climb = 0.0349/2*3 ; % [rad] Adjusted both here and function

if trim_enable==1
    cd('Trim')
    save('trim_params','Vel_des','h_des','latitude_des','gamma_trim_for_climb')
    trim_general ;
    delete trim_params.mat
    cd ..
end
%% INITIALIZING

initial_mulh = [41.108891 29.021111 9000] ; % [deg deg m] Initial position (mulh) % Adjusted as Maslak/ISTANBUL
Euler_roll_init = 0 ; % [rad] Initial Roll Angle
Euler_pitch_init = 0 ; % [rad] Initial Pitch Angle
Euler_yaw_init = 0/180*pi ; % [rad] Initial Yaw Angle

if trim_enable == 1
    if trim_cond ==1
        alpha_init = steady_level_flight_out(1) ; % [rad]
        Euler_pitch_init = alpha_init ;
        V_mag_init = Vel_des ;
        initial_mulh(3) = h_des ;
        initial_mulh(1) = latitude_des ;
    elseif trim_cond ==2
        alpha_init = steady_climb_descent_out(1) ; % [rad]
        Euler_pitch_init = alpha_init + gamma_trim_for_climb ;
        V_mag_init = Vel_des ;
        initial_mulh(3) = h_des ;
        initial_mulh(1) = latitude_des ;
    end
else
    alpha_init = 2*pi/180 ;
    V_mag_init = 180 ; % [m/s]
end

beta_init = 0 ; % [rad]

Initial_angular_rates = [0 0 0] ;
initial_euler_angles = [Euler_roll_init Euler_pitch_init Euler_yaw_init]*180/pi ; % [deg] Initial Euler Angles
DCM_init = angle2dcm(pi/180*initial_euler_angles(3),pi/180*initial_euler_angles(2),pi/180*initial_euler_angles(1),'ZYX') ;

U_init = V_mag_init*cos(alpha_init)*cos(beta_init) ;
V_init = V_mag_init*sin(beta_init) ;
W_init = V_mag_init*sin(alpha_init)*cos(beta_init) ;
initial_vel_NED = transpose(DCM_init)*[U_init ; V_init ; W_init] ;

States = [V_mag_init alpha_init beta_init initial_euler_angles*pi/180 Initial_angular_rates initial_mulh(1:2)*pi/180 initial_mulh(3)] ;
%% LOAD  A320
cd('A320_specs')
A320_actuators
A320_aerodynamics
A320_engine
A320_environment
A320_navigation
A320_physical_specs
A320_sensor
cd ..

no_now_it_ends = toc(and_now_it_begins) ;

%% LINEARIZATION
cd('Linearization')
Linearization_main
cd ..
disp('Simulation is ready for working !!! ')

eigenvalues_A = eig(A_matrix) ;
figure
plot(eigenvalues_A,'x')
grid on
xlabel('Real Axis')
ylabel('Imaginer Axis')
title('Eigenvalues of A')

cd('Process_A_B_matrices')
save matrices A_matrix B_matrix
cd ..
