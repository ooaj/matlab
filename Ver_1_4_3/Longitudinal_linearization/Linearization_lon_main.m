States_lon = [States(1) ; States(2) ; States(5) ; States(8) ] ;
Inputs_lon = [del_e_trimmed   del_t_trimmed] ;
delta_states_lon = [1 0.01 0.01 0.01] ;
delta_inputs_lon = [0.001 0.01] ;

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

for ozgn=1:length(Inputs_lon)
    Inputs_lon(ozgn) = Inputs_lon(ozgn) + delta_inputs_lon(ozgn) ;
    Functions_lon
    for nyn=1:length(States_lon) ;
        Func_name = ['Func_lon_',num2str(nyn)] ;
        FF_B_total_lon(nyn,ozgn,1) = eval(Func_name) ;
    end
    Inputs_lon(ozgn) = Inputs_lon(ozgn) - 2*delta_inputs_lon(ozgn) ;
    Functions_lon
    for nyn=1:length(States_lon) ;
        Func_name = ['Func_lon_',num2str(nyn)] ;
        FF_B_total_lon(nyn,ozgn,2) = eval(Func_name) ;
    end
    Inputs_lon(ozgn) = Inputs_lon(ozgn) + delta_inputs_lon(ozgn) ;
    
end
%% NUMERICAL DERIVATIVE CALCULATION

A_matrix_lon(length(States_lon),length(States_lon)) = 0 ;

for nyn=1:length(States_lon)
    for ozgn=1:length(States_lon)
        A_matrix_lon(nyn,ozgn) = (FF_A_total_lon(nyn,ozgn,1)-FF_A_total_lon(nyn,ozgn,2))/(delta_states_lon(ozgn)*2) ;
    end
end

B_matrix_lon(length(States_lon),length(Inputs_lon)) = 0 ;

for nyn=1:length(States_lon)
    for ozgn=1:length(Inputs_lon)
        B_matrix_lon(nyn,ozgn) = (FF_B_total_lon(nyn,ozgn,1)-FF_B_total_lon(nyn,ozgn,2))/(delta_inputs_lon(ozgn)*2) ;
    end
end

save longitudinal_matrices A_matrix_lon B_matrix_lon

