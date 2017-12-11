%% PARAMETER ASSIGNMENT
V_mag_ln   =   States_lon(1) ;
alpha_ln   =   States_lon(2) ;
theta_ln   =   States_lon(3) ;
q_ln       =   States_lon(4) ;

dele_ln    =   Inputs(1) ;
delr_ln    =   Inputs(2) ;
dela_ln    =   Inputs(3) ;
delt_ln    =   Inputs(4) ;

%% CALCULATION of SUBPARAMETERS for FUNCTIONS

% Environment
gravity_ln = gravitywgs84(h_ln,mu_ln) ; % Gravity calculation for latitude and altitude
[~, speed_of_sound, ~, rho] = atmosisa(h_ln) ; % Density calculation
delf_ln = 0 ; % For aero look-up tables

Mach_ln = V_mag_ln / speed_of_sound ; % Mach Number
Thrust_ratio = interpn(engine_lt_M_for_Thrust,engine_lt_h_for_Thrust,engine_lt_h_M_Thrust,Mach_ln,h_ln,'linear') ; % Pure engine thrust at desired Mach and h
Thrust_at_h_ln = Thrust_ratio*max_thrust*engine_number*delt_ln ;

% Calculation of Aero Coeffs.
% CD calculation
CD_alpha = interpn(aero_lt_alpha_for_CD,aero_lt_flap_for_CD,aero_lt_alpha_flap_CD,alpha_ln,delf_ln,'linear') ;
CD_del_e = aero_CD_del_e*abs(dele_ln) ;
CD_beta = aero_CD_beta*abs(beta_ln);
CD_ln = aero_CD0 + CD_alpha + CD_del_e + CD_beta;

% CL calculation
CL_alpha = interpn(aero_lt_alpha_for_CL,aero_lt_flap_for_CL,aero_lt_alpha_flap_CL,alpha_ln,delf_ln,'linear') ;
CL_del_e = aero_CL_del_e*dele_ln ;
CL_ln = CL_alpha + CL_del_e ;

% Cm calculation
Cm_flap = interpn(aero_lt_flap_for_Cm0,aero_lt_flap_Cm0,delf_ln,'linear') ;
Cm_alpha = aero_Cm_alpha*alpha_ln ;
Cm_del_e = aero_Cm_del_e*dele_ln ;
Cm_q = aero_Cm_q*q_ln ;                                                     % 1_4_2'de yeni eklendi.
Cm_ln = Cm_flap + Cm_alpha + Cm_del_e +Cm_q ;
% Alpha will constant along trimmed flight. So alpha_dot can be taken as 0.


% Dynamic Pressure
q_dyn_ln = 1/2*rho*V_mag_ln^2 ;
M_pitch_ln = q_dyn_ln*Aircraft_referance_area*Cm_ln*Aircraft_mean_chord ;
F_drag = q_dyn_ln*Aircraft_referance_area*CD_ln ;
F_lift = q_dyn_ln*Aircraft_referance_area*CL_ln ;

%% Fnksyionlar

Func_lon_1 = (Thrust_at_h_ln*cos(alpha_ln) - F_drag - Aircraft_initial_mass*gravity_ln*sin(theta_ln-alpha_ln))/Aircraft_initial_mass ;
Func_lon_2 = (-Thrust_at_h_ln*sin(alpha_ln)- F_lift + Aircraft_initial_mass*gravity_ln*sin(theta_ln-alpha_ln) +  Aircraft_initial_mass * V_mag_ln*q_ln )/(Aircraft_initial_mass*V_mag_ln) ;
Func_lon_3 = q_ln ;
Func_lon_4 = M_pitch_ln/I_yy ;

