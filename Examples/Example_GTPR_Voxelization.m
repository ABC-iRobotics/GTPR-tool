% Voxelization example for GTPR Workspace.

clear; clc;
close all;
profile on

%%
% Turn off warnings since, for the three-spheres intersection it will give
% warnings in bad configurations
w = warning ('off','all');

%%
% Plotting Options
faceAlphas = [0.1, 0.1, 0.1, 1, 0.3, 0.3, 0.3];

edgeAlphas = [0.1, 0.1, 0.1, 1, 0.3, 0.3, 0.3];

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
% This differs only in the angles enclosed by the arms
GTPR1_alpha12 = 150; % [deg]
GTPR1_alpha13 = 210; % [deg]

% GTPR 2 Parameters:
GTPR2_a1 = 100; % [mm]
GTPR2_a2 = 90;  % [mm]
GTPR2_a3 = 80;  % [mm]
% Since the base and work triangles have to be similar triangles:
GTPR2_e1 = (GTPR2_a1/a)*e;  % [mm]
GTPR2_e2 = (GTPR2_a2/a)*e; % [mm]
GTPR2_e3 = (GTPR2_a3/a)*e; % [mm]

%%
% GTPR 3 Parameters:
GTPR3_a1 = GTPR2_a1; % [mm]
GTPR3_a2 = GTPR2_a2; % [mm]
GTPR3_a3 = GTPR2_a3; % [mm]

GTPR3_e1 = GTPR2_e1; % [mm]
GTPR3_e2 = GTPR2_e2; % [mm]
GTPR3_e3 = GTPR2_e3; % [mm]

GTPR3_L1 = 180; % [mm]
GTPR3_L2 = 170; % [mm]
GTPR3_L3 = 190; % [mm]

GTPR3_l1 = 190; % [mm]
GTPR3_l2 = 180; % [mm]
GTPR3_l3 = 200; % [mm]

%%
% Voxel function parameters
edgeLength = 10; % [mm]
NoOfRandomElements1 = 5000; % [pieces]
NoOfRandomElements2 = 10000; % [pieces]
NoOfRandomElements3 = 100000; % [pieces]

%%
% Declare GTPR objects:
Classic = GTPR(a,a,a,e,e,e,L,L,L,l,l,l,alpha12,alpha13);
GTPR1 = GTPR(a,a,a,e,e,e,L,L,L,l,l,l,GTPR1_alpha12, GTPR1_alpha13);
GTPR2 = GTPR(GTPR2_a1,GTPR2_a2,GTPR2_a3,GTPR2_e1,GTPR2_e2,GTPR2_e3,L,L,L,l,l,l,GTPR1_alpha12, GTPR1_alpha13);
GTPR3 = GTPR(GTPR3_a1,GTPR3_a2,GTPR3_a3,GTPR2_e1,GTPR3_e2,GTPR2_e3,GTPR3_L1,GTPR3_L2,GTPR3_L3,GTPR3_l1,GTPR3_l2,GTPR3_l3,GTPR1_alpha12, GTPR1_alpha13);

%% Classic 1
tic;
data_Classic1 = Classic.mapWorkSpace(NoOfRandomElements1);

data_Classic1_Voxelized = Classic.displayVoxels();

Classic1_fig = plotVoxelizedSpace(data_Classic1_Voxelized, 1, faceAlphas, edgeAlphas, voxelColors);
Time_Classic1 = toc;

%% Classic 2
tic;
data_Classic2 = Classic.mapWorkSpace(NoOfRandomElements2);

data_Classic2_Voxelized = Classic.displayVoxels();

Classic2_fig = plotVoxelizedSpace(data_Classic2_Voxelized, 2, faceAlphas, edgeAlphas, voxelColors);
Time_Classic2 = toc;

%% Classic 3
tic;
data_Classic3 = Classic.mapWorkSpace(NoOfRandomElements3);

data_Classic3_Voxelized = Classic.displayVoxels();

Classic3_fig = plotVoxelizedSpace(data_Classic3_Voxelized, 3, faceAlphas, edgeAlphas, voxelColors);
Time_Classic3 = toc;

%% GTPR1 1
tic;
data_GTPR1_1 = GTPR1.mapWorkSpace(NoOfRandomElements1);

data_GTPR1_1_Voxelized = GTPR1.displayVoxels();

GTPR1_1_fig = plotVoxelizedSpace(data_GTPR1_1_Voxelized, 4, faceAlphas, edgeAlphas, voxelColors);
Time_GTPR1_1 = toc;

%% GTPR1 2
tic;
data_GTPR1_2 = GTPR1.mapWorkSpace(NoOfRandomElements2);

data_GTPR1_2_Voxelized = GTPR1.displayVoxels();

GTPR1_2_fig = plotVoxelizedSpace(data_GTPR1_2_Voxelized, 5, faceAlphas, edgeAlphas, voxelColors);
Time_GTPR1_2 = toc;

%% GTPR1 3
tic;
data_GTPR1_3 = GTPR1.mapWorkSpace(NoOfRandomElements3);

data_GTPR1_3_Voxelized = GTPR1.displayVoxels();

GTPR1_3_fig = plotVoxelizedSpace(data_GTPR1_3_Voxelized, 6, faceAlphas, edgeAlphas, voxelColors);
Time_GTPR1_3 = toc;

%% GTPR2 1
tic;
data_GTPR2_1 = GTPR2.mapWorkSpace(NoOfRandomElements1);

data_GTPR2_1_Voxelized = GTPR2.displayVoxels();

GTPR2_1_fig = plotVoxelizedSpace(data_GTPR2_1_Voxelized, 7, faceAlphas, edgeAlphas, voxelColors);
Time_GTPR2_1 = toc;

%% GTPR2 2
tic;
data_GTPR2_2 = GTPR2.mapWorkSpace(NoOfRandomElements2);

data_GTPR2_2_Voxelized = GTPR2.displayVoxels();

GTPR2_2_fig = plotVoxelizedSpace(data_GTPR2_2_Voxelized, 8, faceAlphas, edgeAlphas, voxelColors);
Time_GTPR2_2 = toc;

%% GTPR2 3
tic;
data_GTPR2_3 = GTPR2.mapWorkSpace(NoOfRandomElements3);

data_GTPR2_3_Voxelized = GTPR2.displayVoxels();

GTPR2_3_fig = plotVoxelizedSpace(data_GTPR2_3_Voxelized, 9, faceAlphas, edgeAlphas, voxelColors);
Time_GTPR2_3 = toc;

%% GTPR3 1
tic;
data_GTPR3_1 = GTPR3.mapWorkSpace(NoOfRandomElements1);

data_GTPR3_1_Voxelized = GTPR3.displayVoxels();

GTPR3_1_fig = plotVoxelizedSpace(data_GTPR3_1_Voxelized, 10, faceAlphas, edgeAlphas, voxelColors);
Time_GTPR3_1 = toc;

%% GTPR3 2
tic;
data_GTPR3_2 = GTPR3.mapWorkSpace(NoOfRandomElements2);

data_GTPR3_2_Voxelized = GTPR3.displayVoxels();

GTPR3_2_fig = plotVoxelizedSpace(data_GTPR3_2_Voxelized, 11, faceAlphas, edgeAlphas, voxelColors);
Time_GTPR3_2 = toc;

%% GTPR3 3
tic;
data_GTPR3_3 = GTPR3.mapWorkSpace(NoOfRandomElements3);

data_GTPR3_3_Voxelized = GTPR3.displayVoxels();

GTPR3_3_fig = plotVoxelizedSpace(data_GTPR3_3_Voxelized, 12, faceAlphas, edgeAlphas, voxelColors);
Time_GTPR3_3 = toc;


%% Save the plot figures (only 4)
figure(1)
grid on;
set(gcf, 'Position', get(0, 'Screensize'));
view(40,50);
set(gcf, 'Color', 'w');
grid on;
export_fig Classic1.png -m2.5

figure(5)
grid on;
set(gcf, 'Position', get(0, 'Screensize'));
view(40,50);
set(gcf, 'Color', 'w');
grid on;
export_fig GTPR1_2.png -m2.5

figure(9)
grid on;
set(gcf, 'Position', get(0, 'Screensize'));
view(40,50);
set(gcf, 'Color', 'w');
grid on;
export_fig GTPR2_3.png -m2.5

figure(12)
grid on;
set(gcf, 'Position', get(0, 'Screensize'));
view(40,50);
set(gcf, 'Color', 'w');
grid on;
export_fig GTPR3_3.png -m2.5

profile viewer
