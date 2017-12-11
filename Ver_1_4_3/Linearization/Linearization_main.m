%% Will be changed ;
lin_loc = pwd ;

States = transpose(States) ;
Inputs = [del_e_trimmed ; del_r_trimmed ; del_a_trimmed ; del_t_trimmed] ;
delta_states = [0.01 ; 0.001 ; 0.001 ; 0.001 ; 0.001 ; 0.001 ; 10^-5 ; 10^-5 ; 10^-5 ; 0.01 ; 0.01 ; 1] ;
delta_inputs = [0.001 ; 0.001 ; 0.001 ; 0.01] ;

delta_states = [1 ; 0.01 ; 0.01 ; 0.01 ; 0.01 ; 0.01 ; 10^-3 ; 10^-3 ; 10^-3 ; 0.01 ; 0.01 ; 10] ;
delta_inputs = [0.001 ; 0.001 ; 0.001 ; 0.01] ;

del_f_trimmed = 0 ; % Flaps are holding at 0 radian

%% Load Specifications
cd ..
cd('A320_specs')
mat_files_in_folder = dir('*.m') ;

for i=1:length(mat_files_in_folder)
    m_name = mat_files_in_folder(i).name ;
    run([m_name]) ;
end
cd(lin_loc)

%% FUNCTION CALCULATIONS
FF_A_total(length(States),length(States),2) = 0 ;
for ozgn=1:length(States)
    States(ozgn) = States(ozgn) + delta_states(ozgn) ;
    Functions
    for nyn=1:length(States) ;
        Func_name = ['Func_',num2str(nyn)] ;
        FF_A_total(nyn,ozgn,1) = eval(Func_name) ;
    end
    States(ozgn) = States(ozgn) - 2*delta_states(ozgn) ;
    Functions
    for nyn=1:length(States) ;
        Func_name = ['Func_',num2str(nyn)] ;
        FF_A_total(nyn,ozgn,2) = eval(Func_name) ;
    end
    States(ozgn) = States(ozgn) + delta_states(ozgn) ;
    
end

FF_B_total(length(States),length(Inputs),2) = 0 ;
for ozgn=1:length(Inputs)
    Inputs(ozgn) = Inputs(ozgn) + delta_inputs(ozgn) ;
    Functions
    for nyn=1:length(States) ;
        Func_name = ['Func_',num2str(nyn)] ;
        FF_B_total(nyn,ozgn,1) = eval(Func_name) ;
    end
    Inputs(ozgn) = Inputs(ozgn) - 2*delta_inputs(ozgn) ;
    Functions
    for nyn=1:length(States) ;
        Func_name = ['Func_',num2str(nyn)] ;
        FF_B_total(nyn,ozgn,2) = eval(Func_name) ;
    end
    Inputs(ozgn) = Inputs(ozgn) + delta_inputs(ozgn) ;
    
end

%% NUMERICAL DERIVATIVE CALCULATION

A_matrix(length(States),length(States)) = 0 ;

for nyn=1:length(States)
    for ozgn=1:length(States)
        A_matrix(nyn,ozgn) = (FF_A_total(nyn,ozgn,1)-FF_A_total(nyn,ozgn,2))/(delta_states(ozgn)*2) ;
    end
end

B_matrix(length(States),length(Inputs)) = 0 ;

for nyn=1:length(States)
    for ozgn=1:length(Inputs)
        B_matrix(nyn,ozgn) = (FF_B_total(nyn,ozgn,1)-FF_B_total(nyn,ozgn,2))/(delta_inputs(ozgn)*2) ;
    end
end

