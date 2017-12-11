function [F_cost] = steady_climb_descent_trim(XXX)
alpha_tr = XXX(1) ;
dele_tr = XXX(2) ;
delt_tr = XXX(3) ;

F_cost = 0 ;

load trim_params.mat

phi_init_trim = gamma_trim_for_climb + alpha_tr ;

%% Load Specs
run('../A320_specs/A320_aerodynamics')
run('../A320_specs/A320_physical_specs')
run('../A320_specs/A320_engine')

%% COST FUNCT�ON FOR GIVEN INPUTS

gravity = gravitywgs84(h_des,latitude_des) ; % Gravity calculation for latitude and altitude
[~, speed_of_sound, ~, rho] = atmosisa(h_des) ; % Density calculation 
del_flap = 0 ; % For aero look-up tables

Mach_desired = Vel_des / speed_of_sound ;
Thrust_ratio = interpn(engine_lt_M_for_Thrust,engine_lt_h_for_Thrust,engine_lt_h_M_Thrust,Mach_desired,h_des,'linear') ; % Pure engine thrust at desired Mach and h
Thrust_at_h = Thrust_ratio*max_thrust*engine_number ;

weight_aircraft = Aircraft_initial_mass*gravity ;
 

% Some terms that are not using in steady state flight are eliminated.

% Calculation of Aero Coeffs.
% CD calculation 
CD_alpha = interpn(aero_lt_alpha_for_CD,aero_lt_flap_for_CD,aero_lt_alpha_flap_CD,alpha_tr,del_flap,'linear') ;
CD_del_e = aero_CD_del_e*abs(dele_tr) ;
CD_trim = aero_CD0 + CD_alpha + CD_del_e ;

% CL calculation
CL_alpha = interpn(aero_lt_alpha_for_CL,aero_lt_flap_for_CL,aero_lt_alpha_flap_CL,alpha_tr,del_flap,'linear') ;
CL_del_e = aero_CL_del_e*dele_tr ;
CL_trim = CL_alpha + CL_del_e ;

% Cm calculation
Cm_flap = interpn(aero_lt_flap_for_Cm0,aero_lt_flap_Cm0,del_flap,'linear') ;
Cm_alpha = aero_Cm_alpha*alpha_tr ;
Cm_del_e = aero_Cm_del_e*dele_tr ;
Cm_trim = Cm_flap + Cm_alpha + Cm_del_e ;
% Alpha will constant along trimmed flight. So alpha_dot can be taken as 0.

% Aerodynamic Forces and Moment
F_drag = 1/2*rho*Vel_des^2*Aircraft_referance_area*CD_trim ;
F_lift = 1/2*rho*Vel_des^2*Aircraft_referance_area*CL_trim ;
M_pitch = 1/2*rho*Vel_des^2*Aircraft_referance_area*Cm_trim*Aircraft_mean_chord ;

F_thrust = Thrust_at_h*delt_tr ;
% Weight was calculated at the beginning

% Cost Function - Must be '0' in the end
% Cost function must be positive defineds
F_cost = ((F_thrust*cos(alpha_tr+gamma_trim_for_climb)-F_drag*cos(gamma_trim_for_climb)-F_lift*sin(gamma_trim_for_climb))^2 + (F_lift*cos(gamma_trim_for_climb)+F_thrust*sin(alpha_tr+gamma_trim_for_climb)-weight_aircraft-F_drag*sin(gamma_trim_for_climb))^2 + M_pitch^2) ;

% F_cost = ((F_thrust*cos(alpha_tr)-F_drag)^2 + (F_lift+F_thrust*sin(alpha_tr)-weight_aircraft)^2 + M_pitch^2) ;
% Weight is constant, all other params are connected.


end
