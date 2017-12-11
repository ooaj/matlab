clear all ;
close all ;
clc ;

load longitudinal_matrices
s=tf('s') ;

%% Calculation for alpha
s=tf('s') ;
ka = -5 ;
kq = -7 ;

K_long =[ 0 ka 0 kq] ;
    
A_matrix_lon ;
B_matrix_lon ;
B_matrix_lon_dele = B_matrix_lon(:,1) ;
C_alpha_dele = [0 1 0 0 ; 0 0 0 1] ;

A_long_fb = (A_matrix_lon-B_matrix_lon_dele*K_long) ;
tf_pitch = C_alpha_dele*inv(s*eye(4)-A_long_fb)*B_matrix_lon_dele ;
tf_pitch = minreal(tf_pitch) ;

tf_pitch_ex = minreal(C_alpha_dele*inv(s*eye(4)-A_matrix_lon)*B_matrix_lon_dele) ;

figure
step(tf_pitch_ex(1))
hold on
step(tf_pitch(1),'r')
grid on
title('alpha')
legend('raw','augmented')

figure
step(tf_pitch_ex(2))
hold on
step(tf_pitch(2),'r')
grid on
title('theta')
legend('raw','augmented')



