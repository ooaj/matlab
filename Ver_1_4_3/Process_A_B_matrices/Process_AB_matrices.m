% Here, 12x12 A matrix will be examined and new 'A' matrices for
% longitudinal and lateral behaviors will be obtained.

clear all ;
close all ;
clc ;

load matrices

States = {...
    'st_V_mag' ;
    'st_alpha' ;
    'st_beta' ;
    'st_phi' ;
    'st_teta' ;
    'st_psi' ;
    'st_p' ;
    'st_q' ;
    'st_r' ;
    'st_mu' ;
    'st_l' ;
    'st_h' ;
    } ;

inputs = {...
    'del_e' ;
    'del_r' ;
    'del_a' ;
    'del_t' ;
    } ;

%% Longitudinal
A_long_st_param_indexes = [1 2 5 8] ;
B_long_in_param_indexes = [4 1] ;

len_A_long = length(A_long_st_param_indexes) ;
len_B_long = length(B_long_in_param_indexes) ;

A_long = zeros(len_A_long) ;
A_long = zeros(len_A_long,len_B_long) ;

for i=1:len_A_long
    for j=1:len_A_long
        A_long(i,j) = A_matrix(A_long_st_param_indexes(i),A_long_st_param_indexes(j)) ;
    end
end

A_long_eig = eig(A_long) ;

for i=1:len_A_long
    for j=1:len_B_long
        B_long(i,j) = B_matrix(A_long_st_param_indexes(i),B_long_in_param_indexes(j)) ;
    end
end

%% Lateral

A_lat_st_param_indexes = [3 4 7 9] ;
B_lat_in_param_indexes = [3 2] ;

len_A_lat = length(A_lat_st_param_indexes) ;
len_B_lat = length(B_lat_in_param_indexes) ;

A_lat = zeros(len_A_lat) ;
B_lat = zeros(len_A_lat,len_B_lat) ;

for i=1:len_A_lat
    for j=1:len_A_lat
        A_lat(i,j) = A_matrix(A_lat_st_param_indexes(i),A_lat_st_param_indexes(j)) ;
    end
end

A_lat_eig = eig(A_lat) ;

for i=1:len_A_lat
    for j=1:len_B_lat
        B_lat(i,j) = B_matrix(A_lat_st_param_indexes(i),B_lat_in_param_indexes(j)) ;
    end
end






