%% ACTUATORS

% Trim Conditions

if trim_enable == 1
    if trim_cond == 1
        del_e_trimmed = steady_level_flight_out(2) ;
        del_r_trimmed = 0 ;
        del_a_trimmed = 0 ;
        del_f_trimmed = 0 ;
        del_t_trimmed = steady_level_flight_out(3) ;
    elseif trim_cond == 2
        del_e_trimmed = steady_climb_descent_out(2) ;
        del_r_trimmed = 0 ;
        del_a_trimmed = 0 ;
        del_f_trimmed = 0 ;
        del_t_trimmed = steady_climb_descent_out(3) ;
    end
end

% Elevator
act_ang_lim_1 = 35*pi/180 ; % [rad]
act_rate_lim_1 = 180*pi/180 ; % [rad/s]

% Rudder
act_ang_lim_2 = 35*pi/180 ; % [rad]
act_rate_lim_2 = 180*pi/180 ; % [rad/s]

% Aileron
act_ang_lim_3 = 35*pi/180 ; % [rad]
act_rate_lim_3 = 180*pi/180 ; % [rad/s]

% Engine
act_ang_lim_4 = 10000 ; % [N]
act_rate_lim_4 = 2000 ; % [N/s]