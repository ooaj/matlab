%% Stady Level Flight Trim
x0 = [0.2,0.2,0.4] ;

steady_level_flight_out = fminsearch(@steady_level_flight_trim,x0) ;

alpha_trim = steady_level_flight_out(1) ;
del_e_trim = steady_level_flight_out(2) ;
del_t_trim = steady_level_flight_out(3) ;

%% Stady Climb Descent Trim
x0 = [0.2,0.2,0.4] ;

steady_climb_descent_out = fminsearch(@steady_climb_descent_trim,x0) ;

alpha_trim = steady_climb_descent_out(1) ;
del_e_trim = steady_climb_descent_out(2) ;
del_t_trim = steady_climb_descent_out(3) ;


