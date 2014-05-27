%% Clear
clear
clc

%% Position equations from problem formulation

tmaks=1.1804601871256573; % tiden der g�r f�r duen n�r shooting boundery p� 40,3 m fra HH.
td=1/120;
t=0 : td : tmaks;





% PTS offset
PTSoffx = 19.2;
PTSoffy = 0; 
PTSoffz = 0.45;
PCx = -9.34*t+5.5;
PCy = 32.851*t-19.3;
PCz = -4.91*power(t,2)+5.473*t+3.05;

% Cartesian coordinates for plotting in tikzpicture. 
% csvwrite('path_certes/home/niko/Dropbox/Semesterprojekt F14/Path Skeetian.csv',[PCx ; PCy ; PCz*-1]'/10)


% Med offset
PCxcc = PCx-PTSoffx;
PCycc = PCy-PTSoffy;
PCzcc = PCz-PTSoffz;

PC=[PCxcc ; PCycc ; PCzcc]';


%% print H file

clc
display('#pragma once')
display('static const coordinate_type coor_list[MATLAB_COOR_LIST_SIZE] =')
display('{')
len = length(PCxcc);
for i=1:(len-1)
display(sprintf('{%3.4f, %3.4f, %3.4f},', PCxcc(i),PCycc(i),PCzcc(i)))
end
display(sprintf('{%3.4f, %3.4f, %3.4f}', PCxcc(len),PCycc(len),PCzcc(len)))
display('};')

%% From cartesian to spherical coordinates 
%(Adam cap 10.6, pp. 598)
rho=sqrt(power(PCxcc,2)+power(PCycc,2)+power(PCzcc,2));
% atan = radians
% atand = degree
TILT=atand(PCzcc./(sqrt(power(PCxcc,2)+power(PCycc,2)))); % phi
PAN=atand(PCycc./PCxcc); % theta

% Angle (degree) for pan and tilt 

PTS=[(TILT)*3 ; 3*PAN]';
csvwrite('path_phi_theta.csv',PTS)
csvwrite('x_y_z.csv',PC)
