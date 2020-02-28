% Voxelization example for GTPR Workspace.

% [fList,pList] = matlab.codetools.requiredFilesAndProducts('Example_GTPR_Voxelization_Simple.m');

clear; clc;
close all;
% profile on

%%
% Turn off warnings since, for the three-spheres intersection it will give
% warnings in bad configurations
w = warning ('off','all');

%%
% Plotting stuff
faceAlphas1 = [0.03, 0.03, 0.03, 1, 0.1, 0.1, 0.1];
faceAlphas2 = [0.1, 0.1, 0.1, 1, 0.1, 0.1, 0.1];
faceAlphas3 = [0.1, 0.1, 0.1, 1, 0.1, 0.1, 0.1];

edgeAlphas1 = [0.01, 0.01, 0.01, 1, 0.075, 0.075, 0.075];
edgeAlphas2 = [0.01, 0.01, 0.01, 1, 0.075, 0.075, 0.075];
edgeAlphas3 = [0.01, 0.01, 0.01, 1, 0.075, 0.075, 0.075];

voxelColors = [1 0 0;
               0 0 1;
               0 1 0;
               1 1 0;
               1 0 0;
               0 0 1;
               0 1 0;];

         
%%
% The numbers denote the associated arm of the robot.
% alpha angles are measured relative to the first arm.

% Robot Parameters:
% Angles enclosed by the arms
alpha12 = 90; % [deg]
alpha13 = 180; % [deg]

% Base Triangle Radius
a1 = 60; % [mm]
a2 = 20;  % [mm]
a3 = 60;  % [mm]

% Work Triangle radius
e1 = 40;  % [mm]
e2 = 20; % [mm]
e3 = 40; % [mm]

% Upper Arm lengths
L1 = 240; % [mm]
L2 = 200; % [mm]
L3 = 240; % [mm]

% Lower arm lengths
l1 = 180; % [mm]
l2 = 200; % [mm]
l3 = 180; % [mm]

% Edge length of a voxel
edgeLength = 10;

% Number of random arm positions to investigate:
NoOfRandomElements = 25000; % [pieces]


%% Engine, doing the mapping, the program itself. (Modify at own risk)
faceAlphas = [0.03, 0.03, 0.03, 1, 0.1, 0.1, 0.1];
edgeAlphas = [0.01, 0.01, 0.01, 1, 0.075, 0.075, 0.075];
voxelColors = [1 0 0;
               0 0 1;
               0 1 0;
               1 1 0;
               1 0 0;
               0 0 1;
               0 1 0;];


GTPR_Robot = GTPR(a1,a2,a3,e1,e2,e3,L1,L2,L3,l1,l2,l3,alpha12,alpha13);

% Mapping the workspace points:
data_GTPR_WS = GTPR_Robot.mapWorkSpace(NoOfRandomElements);

% Discretizing the workspace
data_GTPR_WS_Discrete = GTPR_Robot.displayVoxels(data_GTPR_WS, edgeLength);
GTPR_figure = plotVoxelizedSpace(data_GTPR_WS_Discrete, 1, faceAlphas, edgeAlphas, voxelColors);
grid on;


