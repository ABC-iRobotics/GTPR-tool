% GTPR Voxelization, classic


% [fList,pList] = matlab.codetools.requiredFilesAndProducts('Example_GTPR_Voxelization.m');

clear; clc;
close all;
% profile on

%%
% Turn off warnings since, for the three-spheres intersection it will give
% warnings in bad configurations
% w = warning ('off','all');

%%
% Plotting stuff
faceAlphas = [0.03, 0.03, 0.03, 1, 0.1, 0.1, 0.1];

edgeAlphas = [0.01, 0.01, 0.01, 1, 0.075, 0.075, 0.075];

voxelColors = [1 0 0;
               0 0 1;
               0 1 0;
               1 1 0;
               1 0 0;
               0 0 1;
               0 1 0;];

           
%%
% Classic Robot Parameters:
a = 100; % [mm]
e = 80;  % [mm]
L = 100; % [mm]
l = 190; % [mm]

alpha12 = 120; % [deg]
alpha13 = 240; % [deg]

%%
% GTPR 1 Parameters:
GTPR1_alpha12 = 15; % [deg]
GTPR1_alpha13 = 345; % [deg]

GTPR1_a1 = 30; % [mm]
GTPR1_a2 = 30;  % [mm]
GTPR1_a3 = 30;  % [mm]
% Since the base and work triangles have to be similar triangles:
GTPR1_e1 = 140;  % [mm]
GTPR1_e2 = 70; % [mm]
GTPR1_e3 = 70; % [mm]

% GTPR 1 Parameters:
GTPR1_L1 = 100; % [mm]
GTPR1_L2 = 290; % [mm]
GTPR1_L3 = 290; % [mm]

GTPR1_l1 = 350; % [mm]
GTPR1_l2 = 120; % [mm]
GTPR1_l3 = 120; % [mm]


q = 0:90;

q = combvec(q,q,q)';

% Voxel function parameters
edgeLength1 = 5; % [mm]
edgeLength2 = 10;
edgeLength3 = 20;
NoOfRandomElements1 = 100000; % [pieces]
NoOfRandomElements2 = 500000; % [pieces]
NoOfRandomElements3 = 1000000; % [pieces]



%
% Declare GTPR objects:
Classic = GTPR(a,a,a,e,e,e,L,L,L,l,l,l,alpha12,alpha13);
GTPR1 = GTPR(GTPR1_a1,GTPR1_a2,GTPR1_a3,GTPR1_e1,GTPR1_e2,GTPR1_e3,GTPR1_L1,GTPR1_L2,GTPR1_L3,GTPR1_l1,GTPR1_l2,GTPR1_l3,GTPR1_alpha12, GTPR1_alpha13);
save("baseParameters.mat");







tic;
data_Classic0190 = Classic.mapWorkSpace2(q);
Time_data_Classic0190 = toc;

save("ClassicData_0190_raw.mat");
clear; clc;

load("baseParameters.mat");
tic;
data_GTPR0190 = GTPR1.mapWorkSpace2(q);
Time_data_GTPR0190 = toc;

save("GTPRData_0190_raw.mat");
clear; clc;






load("ClassicData_0190_raw.mat");
tic
data_Classic0190_5_Voxelized = Classic.displayVoxels(data_Classic0190, edgeLength1);
Classic0190_5_fig = plotVoxelizedSpace(data_Classic0190_5_Voxelized, 1, faceAlphas, edgeAlphas, voxelColors);
grid on;
set(gcf, 'Position', get(0, 'Screensize'));
% view(azimuth,elevation);
set(gcf, 'Color', 'w');
% export_fig Classic_NoofElements0190_edgeLength5.png -m2.5
Time_voxelization_Classic0190_5 = toc;

save("Classic0190_5_VoxelizedData.mat");
clear; clc;



load("ClassicData_0190_raw.mat");
tic
data_Classic0190_10_Voxelized = Classic.displayVoxels(data_Classic0190, edgeLength1);
Classic0190_10_fig = plotVoxelizedSpace(data_Classic0190_10_Voxelized, 1, faceAlphas, edgeAlphas, voxelColors);
grid on;
set(gcf, 'Position', get(0, 'Screensize'));
% view(azimuth,elevation);
set(gcf, 'Color', 'w');
% export_fig Classic_NoofElements0190_edgeLength10.png -m2.10
Time_voxelization_Classic0190_10 = toc;

save("Classic0190_10_VoxelizedData.mat");
clear; clc;



load("ClassicData_0190_raw.mat");
tic
data_Classic0190_20_Voxelized = Classic.displayVoxels(data_Classic0190, edgeLength1);
Classic0190_20_fig = plotVoxelizedSpace(data_Classic0190_20_Voxelized, 1, faceAlphas, edgeAlphas, voxelColors);
grid on;
set(gcf, 'Position', get(0, 'Screensize'));
% view(azimuth,elevation);
set(gcf, 'Color', 'w');
% export_fig Classic_NoofElements0190_edgeLength20.png -m2.20
Time_voxelization_Classic0190_20 = toc;

save("Classic0190_20_VoxelizedData.mat");
clear; clc;





load("Classic0190_5_VoxelizedData.mat");
WCI_Classic_0190_5 = workspaceCoverageIndex(data_Classic0190_5_Voxelized);
save("Classic0190_5_VoxelizedData.mat");
clear; clc;


load("Classic1000000_10_VoxelizedData.mat", "data_Classic1000000_10_Voxelized");
WCI_Classic_1000000_10 = workspaceCoverageIndex(data_Classic1000000_10_Voxelized);
save("Classic1000000_10_VoxelizedData.mat");
clear; clc;


load("Classic1000000_20_VoxelizedData.mat");
WCI_Classic_1000000_20 = workspaceCoverageIndex(data_Classic1000000_20_Voxelized);
save("Classic1000000_20_VoxelizedData.mat");
clear; clc;