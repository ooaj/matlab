%% PARAMETER ASSIGNMENT
V_mag_ln   =   States(1) ;
alpha_ln   =   States(2) ;
beta_ln    =   States(3) ;
phi_ln     =   States(4) ;
theta_ln   =   States(5) ;
psi_ln     =   States(6) ;
p_ln       =   States(7) ;
q_ln       =   States(8) ;
r_ln       =   States(9) ;
mu_ln      =   States(10) ;
l_ln       =   States(11) ;
h_ln       =   States(12) ;

dele_ln    =   Inputs(1) ;
delr_ln    =   Inputs(2) ;
dela_ln    =   Inputs(3) ;
delt_ln    =   Inputs(4) ;

%% CALCULATION of SUBPARAMETERS for FUNCTIONS

% Environment
gravity_ln = gravitywgs84(h_ln,mu_ln) ; % Gravity calculation for latitude and altitude
[~, speed_of_sound, ~, rho] = atmosisa(h_ln) ; % Density calculation
delf_ln = 0 ; % For aero look-up tables

Mach_ln= V_mag_ln / speed_of_sound ; % Mach Number
Thrust_ratio = interpn(engine_lt_M_for_Thrust,engine_lt_h_for_Thrust,engine_lt_h_M_Thrust,Mach_ln,h_ln,'linear') ; % Pure engine thrust at desired Mach and h
Thrust_at_h_ln = Thrust_ratio*max_thrust*engine_number*delt_ln ;
I_tou = I_xx*I_zz-I_xz^2 ;

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

% CY calculation
CY_beta = interpn(aero_lt_beta_for_CY,aero_lt_beta_CY,beta_ln,'linear') ;
CY_ln = CY_beta ;

% Cl calculation
Cl_beta = interpn(aero_lt_beta_Cl0,aero_lt_beta_for_Cl0,beta_ln,'linear') ;
Cl_r = aero_Cl_r*r_ln ;
Cl_del_r = aero_Cl_del_r*delr_ln ;
Cl_del_a = aero_Cl_del_a*dela_ln ;
Cl_ln = Cl_beta + Cl_r + Cl_del_r + Cl_del_a ;

% Cm calculation
Cm_flap = interpn(aero_lt_flap_for_Cm0,aero_lt_flap_Cm0,delf_ln,'linear') ;
Cm_alpha = aero_Cm_alpha*alpha_ln ;
Cm_del_e = aero_Cm_del_e*dele_ln ;
Cm_q = aero_Cm_q*q_ln ;                                                     % 1_4_2'de yeni eklendi.
Cm_ln = Cm_flap + Cm_alpha + Cm_del_e +Cm_q ;
% Alpha will constant along trimmed flight. So alpha_dot can be taken as 0.

% Cn calculation
Cn_r = aero_Cn_r*r_ln ;
Cn_beta = aero_Cn_beta*beta_ln ;
Cn_delr = aero_Cn_del_r*delr_ln ;
Cn_ln = Cn_r + Cn_beta + Cn_delr ;

% CX - CY Calculation
CX_ln = -(cos(alpha_ln)* CD_ln - sin(alpha_ln)*CL_ln) ;
CZ_ln = -(sin(alpha_ln)* CD_ln + cos(alpha_ln)*CL_ln) ;

% Dynamic Pressure
q_dyn_ln = 1/2*rho*V_mag_ln^2 ;

% Aerodynamic Forces and Moment
Fx_ln = q_dyn_ln*Aircraft_referance_area*CX_ln ;
Fy_ln = q_dyn_ln*Aircraft_referance_area*CY_ln ;
Fz_ln = q_dyn_ln*Aircraft_referance_area*CZ_ln ;

M_roll_ln = q_dyn_ln*Aircraft_referance_area*Cl_ln*Aircraft_wingspan ;
M_pitch_ln = q_dyn_ln*Aircraft_referance_area*Cm_ln*Aircraft_mean_chord ;
M_yaw_ln = q_dyn_ln*Aircraft_referance_area*Cn_ln*Aircraft_wingspan ;

U_ln = V_mag_ln*cos(alpha_ln)*cos(beta_ln) ;
V_ln = V_mag_ln*sin(beta_ln) ;
W_ln = V_mag_ln*sin(alpha_ln)*cos(beta_ln) ;

%% FUNCTIONS

Func_1 = r_ln*V_ln - q_ln*W_ln - gravity_ln*sin(theta_ln) + (Fx_ln+Thrust_at_h_ln)/Aircraft_initial_mass ;
Func_2 = -r_ln*U_ln + p_ln*W_ln + gravity_ln*sin(phi_ln)*cos(theta_ln) + (Fy_ln)/Aircraft_initial_mass ;
Func_3 = q_ln*U_ln - p_ln*V_ln + gravity_ln*cos(phi_ln)*cos(theta_ln) + (Fz_ln)/Aircraft_initial_mass ;

if 1
    
    F_V_mag_dot =(Func_1*U_ln+Func_2*V_ln+Func_3*W_ln)/norm([U_ln V_ln W_ln]) ;
    F_alpha_dot = (U_ln*Func_3-W_ln*Func_1)/(U_ln^2+W_ln^2) ;
    F_beta_dot = (Func_2*norm([U_ln V_ln W_ln]) - V_ln*F_V_mag_dot)/(norm([U_ln V_ln W_ln])*sqrt(U_ln^2+V_ln^2)) ;
    
    Func_1 = F_V_mag_dot ;
    Func_2 = F_alpha_dot ;
    Func_3 = F_beta_dot ;
end


Func_4 = p_ln + tan(theta_ln)*(q_ln*sin(phi_ln) + r_ln*cos(phi_ln)) ;
Func_5 = q_ln*cos(phi_ln) - r_ln*sin(phi_ln) ;
Func_6 = (q_ln*sin(phi_ln)+r_ln*cos(phi_ln))/cos(theta_ln) ;

Func_7 = (I_xz*(I_xx-I_yy+I_zz)*p_ln*q_ln...
    -(I_zz*(I_zz-I_yy)+I_xz^2)*q_ln*r_ln ...
    +I_zz*M_roll_ln + I_xz*M_yaw_ln) / I_tou ;

Func_8 = ((I_zz-I_xx)*p_ln*r_ln-I_xz*(p_ln^2-r_ln^2)+M_pitch_ln) / I_yy ;

Func_9 = (((I_xx-I_yy)*I_xx+I_xz^2)*p_ln*q_ln ...
    -I_xz*(I_xx-I_yy+I_zz)*q_ln*r_ln ...
    +I_xz*M_roll_ln + I_xx*M_yaw_ln) / I_tou ;

Func_10 = U_ln*cos(theta_ln)*cos(psi_ln) ...
    +V_ln*(-cos(phi_ln)*sin(psi_ln)+sin(phi_ln)*sin(theta_ln)*cos(psi_ln))...
    +W_ln*(sin(phi_ln)*sin(psi_ln)+cos(phi_ln)*sin(theta_ln)*cos(psi_ln)) ;

Func_11 = U_ln*cos(theta_ln)*sin(psi_ln) ...
    +V_ln*(cos(phi_ln)*cos(psi_ln)+sin(phi_ln)*sin(theta_ln)*sin(psi_ln))...
    +W_ln*(-sin(phi_ln)*cos(psi_ln)+cos(phi_ln)*sin(theta_ln)*sin(psi_ln)) ;

Func_12 = U_ln*sin(theta_ln)...
    - V_ln*sin(phi_ln)*cos(theta_ln)...
    -W_ln*cos(phi_ln)*cos(theta_ln) ;
