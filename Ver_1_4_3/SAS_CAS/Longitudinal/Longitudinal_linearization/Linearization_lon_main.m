% Nazmi Kankaya
% 10.12.2017

States_lon = [States(1) ; States(2) ; States(5) ; States(8) ] ;
delta_states_lon = [1 0.01 0.01 0.01] ;

%% FUNCTION CALCULATIONS
FF_A_total_lon(length(States_lon),length(States_lon),2) = 0 ;
for ozgn=1:length(States_lon)
    States_lon(ozgn) = States_lon(ozgn) + delta_states_lon(ozgn) ;
    Functions_lon
    for nyn=1:length(States_lon) ;
        Func_name = ['Func_lon_',num2str(nyn)] ;
        FF_A_total_lon(nyn,ozgn,1) = eval(Func_name) ;
    end
    States_lon(ozgn) = States_lon(ozgn) - 2*delta_states_lon(ozgn) ;
    Functions_lon
    for nyn=1:length(States_lon) ;
        Func_name = ['Func_lon_',num2str(nyn)] ;
        FF_A_total_lon(nyn,ozgn,2) = eval(Func_name) ;
    end
    States_lon(ozgn) = States_lon(ozgn) + delta_states_lon(ozgn) ;
    
end

%% NUMERICAL DERIVATIVE CALCULATION

A_matrix_lon(length(States_lon),length(States_lon)) = 0 ;

for nyn=1:length(States_lon)
    for ozgn=1:length(States_lon)
        A_matrix_lon(nyn,ozgn) = (FF_A_total_lon(nyn,ozgn,1)-FF_A_total_lon(nyn,ozgn,2))/(delta_states_lon(ozgn)*2) ;
    end
end


