clear all ;
close all ;
clc ;

load longitudinal_matrices
s=tf('s') ;

%% Calculation for alpha
B_alpha_dele = B_matrix_lon(:,1) ;
C_alpha_dele = [0 1 0 0] ;

tf_alpha_dele = minreal(C_alpha_dele*inv(s*eye(4)-A_matrix_lon)*B_alpha_dele) ;

ka = 01 ; % Will be selected
tf_alpha_dele_fb = series(tf_alpha_dele,ka) ;
pole(tf_alpha_dele_fb)
figure
rlocus(tf_alpha_dele)
figure
step(tf_alpha_dele)
hold on
step(tf_alpha_dele_fb,'r')

%% Calculation for q
B_q_dele = B_matrix_lon(:,2) ;
C_q_dele = [0 0 0 1] ;
tf_q_dele = minreal(C_q_dele*inv(s*eye(4)-A_matrix_lon)*B_q_dele) ;

kq = 0.5 ; % Will be selected
tf_q_dele_fb = feedback(tf_q_dele,kq) ;
pole(tf_q_dele_fb)
figure
rlocus(tf_q_dele)
figure
step(tf_q_dele)
hold on
step(tf_q_dele_fb,'r')

