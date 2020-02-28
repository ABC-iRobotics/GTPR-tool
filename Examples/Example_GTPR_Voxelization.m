% % Voxelization example for GTPR Workspace.

% [fList,pList] = matlab.codetools.requiredFilesAndProducts('Example_GTPR_Voxelization.m');

clear; clc;
close all;
% profile on

%%
% Turn off warnings since, for the three-spheres intersection it will give
% warnings in bad configurations
w = warning ('off','all');

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
           
formatOut = 'yyyymmdd_HHMMSS';
dateNow = datestr(datetime('now'), formatOut);
           
%%
% % Classic Robot Parameters:
a = 100; % [mm]
e = 80;  % [mm]
L = 100; % [mm]
l = 190; % [mm]

alpha12 = 120; % [deg]
alpha13 = 240; % [deg]

%%
% % % GTPR Parameters:
% % GTPR1_alpha12 = 15; % [deg]
% % GTPR1_alpha13 = 345; % [deg]
% % 
% % GTPR1_a1 = 30; % [mm]
% % GTPR1_a2 = 30;  % [mm]
% % GTPR1_a3 = 30;  % [mm]
% % % Since the base and work triangles have to be similar triangles:
% % GTPR1_e1 = 140;  % [mm]
% % GTPR1_e2 = 70; % [mm]
% % GTPR1_e3 = 70; % [mm]
% % 
% % % GTPR 1 Parameters:
% % GTPR1_L1 = 100; % [mm]
% % GTPR1_L2 = 290; % [mm]
% % GTPR1_L3 = 290; % [mm]
% % 
% % GTPR1_l1 = 350; % [mm]
% % GTPR1_l2 = 120; % [mm]
% % GTPR1_l3 = 120; % [mm]


%%
% GTPR 1 Parameters:
% GTPR1_alpha12 = 90; % [deg]
% GTPR1_alpha13 = 180; % [deg]
% 
% GTPR1_a1 = 30; % [mm]
% GTPR1_a2 = 130;  % [mm]
% GTPR1_a3 = 130;  % [mm]
% % Since the base and work triangles have to be similar triangles:
% GTPR1_e1 = 70;  % [mm]
% GTPR1_e2 = 170; % [mm]
% GTPR1_e3 = 30; % [mm]
% 
% % GTPR 1 Parameters:
% GTPR1_L1 = 290; % [mm]
% GTPR1_L2 = 100; % [mm]
% GTPR1_L3 = 100; % [mm]
% 
% GTPR1_l1 = 220; % [mm]
% GTPR1_l2 = 120; % [mm]
% GTPR1_l3 = 220; % [mm]


%%
% GTPR 1 Parameters:
GTPR1_alpha12 = 20; % [deg]
GTPR1_alpha13 = -20; % [deg]

GTPR1_a1 = 50; % [mm]
GTPR1_a2 = 80;  % [mm]
GTPR1_a3 = 80;  % [mm]
% Since the base and work triangles have to be similar triangles:
GTPR1_e1 = 50;  % [mm]
GTPR1_e2 = 70; % [mm]
GTPR1_e3 = 70; % [mm]

% GTPR 1 Parameters:
GTPR1_L1 = 100; % [mm]
GTPR1_L2 = 200; % [mm]
GTPR1_L3 = 200; % [mm]

GTPR1_l1 = 200; % [mm]
GTPR1_l2 = 100; % [mm]
GTPR1_l3 = 100; % [mm]

% Voxel function parameters
edgeLength1 = 5; % [mm]
edgeLength2 = 10;
edgeLength3 = 20;
NoOfRandomElements1 = 3000; % [pieces]
NoOfRandomElements2 = 15000; % [pieces]
NoOfRandomElements3 = 40000; % [pieces]


% View properties:
azimuth = -120;
elevation = 20;


%
% Declare GTPR objects:
% Classic = GTPR(a,a,a,e,e,e,L,L,L,l,l,l,alpha12,alpha13);
GTPR1 = GTPR(GTPR1_a1,GTPR1_a2,GTPR1_a3,GTPR1_e1,GTPR1_e2,GTPR1_e3,GTPR1_L1,GTPR1_L2,GTPR1_L3,GTPR1_l1,GTPR1_l2,GTPR1_l3,GTPR1_alpha12, GTPR1_alpha13);

% SaveNames:
% String_ClassicData_raw1 = sprintf("ClassicData_%s_raw.mat", num2str(NoOfRandomElements1));
% String_ClassicData_raw2 = sprintf("ClassicData_%s_raw.mat", num2str(NoOfRandomElements2));
% String_ClassicData_raw3 = sprintf("ClassicData_%s_raw.mat", num2str(NoOfRandomElements3));
% 
% 
% String_ClassicVoxelized11 = sprintf("Classic%s_%s_VoxelizedData.mat", num2str(NoOfRandomElements1), num2str(edgeLength1));
% String_ClassicVoxelized12 = sprintf("Classic%s_%s_VoxelizedData.mat", num2str(NoOfRandomElements1), num2str(edgeLength2));
% String_ClassicVoxelized13 = sprintf("Classic%s_%s_VoxelizedData.mat", num2str(NoOfRandomElements1), num2str(edgeLength3));
% 
% String_ClassicVoxelized21 = sprintf("Classic%s_%s_VoxelizedData.mat", num2str(NoOfRandomElements2), num2str(edgeLength1));
% String_ClassicVoxelized22 = sprintf("Classic%s_%s_VoxelizedData.mat", num2str(NoOfRandomElements2), num2str(edgeLength2));
% String_ClassicVoxelized23 = sprintf("Classic%s_%s_VoxelizedData.mat", num2str(NoOfRandomElements2), num2str(edgeLength3));
% 
% String_ClassicVoxelized31 = sprintf("Classic%s_%s_VoxelizedData.mat", num2str(NoOfRandomElements3), num2str(edgeLength1));
% String_ClassicVoxelized32 = sprintf("Classic%s_%s_VoxelizedData.mat", num2str(NoOfRandomElements3), num2str(edgeLength2));
% String_ClassicVoxelized33 = sprintf("Classic%s_%s_VoxelizedData.mat", num2str(NoOfRandomElements3), num2str(edgeLength3));





String_GTPRData_raw1 = sprintf("GTPRData_%s_raw.mat", num2str(NoOfRandomElements1));
String_GTPRData_raw2 = sprintf("GTPRData_%s_raw.mat", num2str(NoOfRandomElements2));
String_GTPRData_raw3 = sprintf("GTPRData_%s_raw.mat", num2str(NoOfRandomElements3));


String_GTPRVoxelized11 = sprintf("GTPR%s_%s_VoxelizedData.mat", num2str(NoOfRandomElements1), num2str(edgeLength1));
String_GTPRVoxelized12 = sprintf("GTPR%s_%s_VoxelizedData.mat", num2str(NoOfRandomElements1), num2str(edgeLength2));
String_GTPRVoxelized13 = sprintf("GTPR%s_%s_VoxelizedData.mat", num2str(NoOfRandomElements1), num2str(edgeLength3));
												   
String_GTPRVoxelized21 = sprintf("GTPR%s_%s_VoxelizedData.mat", num2str(NoOfRandomElements2), num2str(edgeLength1));
String_GTPRVoxelized22 = sprintf("GTPR%s_%s_VoxelizedData.mat", num2str(NoOfRandomElements2), num2str(edgeLength2));
String_GTPRVoxelized23 = sprintf("GTPR%s_%s_VoxelizedData.mat", num2str(NoOfRandomElements2), num2str(edgeLength3));
												   
String_GTPRVoxelized31 = sprintf("GTPR%s_%s_VoxelizedData.mat", num2str(NoOfRandomElements3), num2str(edgeLength1));
String_GTPRVoxelized32 = sprintf("GTPR%s_%s_VoxelizedData.mat", num2str(NoOfRandomElements3), num2str(edgeLength2));
String_GTPRVoxelized33 = sprintf("GTPR%s_%s_VoxelizedData.mat", num2str(NoOfRandomElements3), num2str(edgeLength3));

String_fig_GTPR11 = sprintf("GTPR_NoofElements%s_edgeLength%s.png", num2str(NoOfRandomElements1), num2str(edgeLength1), dateNow);
String_fig_GTPR12 = sprintf("GTPR_NoofElements%s_edgeLength%s.png", num2str(NoOfRandomElements1), num2str(edgeLength2), dateNow);
String_fig_GTPR13 = sprintf("GTPR_NoofElements%s_edgeLength%s.png", num2str(NoOfRandomElements1), num2str(edgeLength3), dateNow);

String_fig_GTPR21 = sprintf("GTPR_NoofElements%s_edgeLength%s.png", num2str(NoOfRandomElements2), num2str(edgeLength1), dateNow);
String_fig_GTPR22 = sprintf("GTPR_NoofElements%s_edgeLength%s.png", num2str(NoOfRandomElements2), num2str(edgeLength2), dateNow);
String_fig_GTPR23 = sprintf("GTPR_NoofElements%s_edgeLength%s.png", num2str(NoOfRandomElements2), num2str(edgeLength3), dateNow);

String_fig_GTPR31 = sprintf("GTPR_NoofElements%s_edgeLength%s.png", num2str(NoOfRandomElements3), num2str(edgeLength1), dateNow);
String_fig_GTPR32 = sprintf("GTPR_NoofElements%s_edgeLength%s.png", num2str(NoOfRandomElements3), num2str(edgeLength2), dateNow);
String_fig_GTPR33 = sprintf("GTPR_NoofElements%s_edgeLength%s.png", num2str(NoOfRandomElements3), num2str(edgeLength3), dateNow);

% String_fig_Classic11 = sprintf("Classic_NoofElements%s_edgeLength%s.png", num2str(NoOfRandomElements1), num2str(edgeLength1), dateNow);
% String_fig_Classic12 = sprintf("Classic_NoofElements%s_edgeLength%s.png", num2str(NoOfRandomElements1), num2str(edgeLength2), dateNow);
% String_fig_Classic13 = sprintf("Classic_NoofElements%s_edgeLength%s.png", num2str(NoOfRandomElements1), num2str(edgeLength3), dateNow);
% 											 
% String_fig_Classic21 = sprintf("Classic_NoofElements%s_edgeLength%s.png", num2str(NoOfRandomElements2), num2str(edgeLength1), dateNow);
% String_fig_Classic22 = sprintf("Classic_NoofElements%s_edgeLength%s.png", num2str(NoOfRandomElements2), num2str(edgeLength2), dateNow);
% String_fig_Classic23 = sprintf("Classic_NoofElements%s_edgeLength%s.png", num2str(NoOfRandomElements2), num2str(edgeLength3), dateNow);
% 											 
% String_fig_Classic31 = sprintf("Classic_NoofElements%s_edgeLength%s.png", num2str(NoOfRandomElements3), num2str(edgeLength1), dateNow);
% String_fig_Classic32 = sprintf("Classic_NoofElements%s_edgeLength%s.png", num2str(NoOfRandomElements3), num2str(edgeLength2), dateNow);
% String_fig_Classic33 = sprintf("Classic_NoofElements%s_edgeLength%s.png", num2str(NoOfRandomElements3), num2str(edgeLength3), dateNow);

save("baseParameters.mat");



%% Classic
% if ~exist(String_ClassicData_raw1, 'file')
%     tic;
%     data_Classic1 = Classic.mapWorkSpace(NoOfRandomElements1);
%     Time_data_Classic1 = toc;
% end
% 
% save(String_ClassicData_raw1);
% clear; clc;
% 
% 
% load("baseParameters.mat");
% %
% if ~exist(String_ClassicData_raw2, 'file')
%     tic;
%     data_Classic2 = Classic.mapWorkSpace(NoOfRandomElements2);
%     Time_data_Classic2 = toc;
% 
%     save(String_ClassicData_raw2);
% clear; clc;
% end
% 
% 
% load("baseParameters.mat");
% %
% 
% if ~exist(String_ClassicData_raw3, 'file')
%     tic;
%     data_Classic3 = Classic.mapWorkSpace(NoOfRandomElements3);
%     Time_data_Classic3 = toc;
% 
%     save(String_ClassicData_raw3);
%     clear; clc;
% end
% 
% 
% 
% load("baseParameters.mat");
% 
% if ~exist(String_ClassicVoxelized11, 'file')
%     load(String_ClassicData_raw1);
%     tic
%     data_Classic1_1_Voxelized = Classic.displayVoxels(data_Classic1, edgeLength1);
%     Classic1_1_fig = plotVoxelizedSpace(data_Classic1_1_Voxelized, 1, faceAlphas, edgeAlphas, voxelColors);
%     grid on;
%     set(gcf, 'Position', get(0, 'Screensize'));
%     view(azimuth,elevation);
%     set(gcf, 'Color', 'w'); xlabel("X"); ylabel("Y"); zlabel("Z");
%     export_fig(String_fig_Classic11,2.5);
%     Time_voxelization_Classic1_1 = toc;
% 
%     save(String_ClassicVoxelized11);
%     clear; clc;
% end
% 
% load("baseParameters.mat");
% 
% if ~exist(String_ClassicVoxelized12, 'file')
%     load(String_ClassicData_raw1);
%     %
%     tic
%     data_Classic1_2_Voxelized = Classic.displayVoxels(data_Classic1, edgeLength2);
%     Classic1_2_fig = plotVoxelizedSpace(data_Classic1_2_Voxelized, 2, faceAlphas, edgeAlphas, voxelColors);
%     grid on;
%     set(gcf, 'Position', get(0, 'Screensize'));
%     view(azimuth,elevation);
%     set(gcf, 'Color', 'w'); xlabel("X"); ylabel("Y"); zlabel("Z");
%     export_fig(String_fig_Classic12,2.5);
%     Time_voxelization_Classic1_2 = toc;
%     save(String_ClassicVoxelized12);
%     clear; clc;
% end
% 
% 
% 
% load("baseParameters.mat");
% 
% if ~exist(String_ClassicVoxelized13, 'file')
%     load(String_ClassicData_raw1);
%     %
%     tic
%     data_Classic1_3_Voxelized = Classic.displayVoxels(data_Classic1, edgeLength3);
%     Classic1_3_fig = plotVoxelizedSpace(data_Classic1_3_Voxelized, 3, faceAlphas, edgeAlphas, voxelColors);
%     grid on;
%     set(gcf, 'Position', get(0, 'Screensize'));
%     view(azimuth,elevation);
%     set(gcf, 'Color', 'w'); xlabel("X"); ylabel("Y"); zlabel("Z");
%     export_fig(String_fig_Classic13,2.5);
%     Time_voxelization_Classic1_3 = toc;
%     save(String_ClassicVoxelized13);
%     clear; clc;
% end
% 
% 
% 
% load("baseParameters.mat");
% 
% if ~exist(String_ClassicVoxelized21, 'file')
%     load(String_ClassicData_raw2);
%     tic
%     data_Classic2_1_Voxelized = Classic.displayVoxels(data_Classic2, edgeLength1);
%     Classic2_1_fig = plotVoxelizedSpace(data_Classic2_1_Voxelized, 4, faceAlphas, edgeAlphas, voxelColors);
%     grid on;
%     set(gcf, 'Position', get(0, 'Screensize'));
%     view(azimuth,elevation);
%     set(gcf, 'Color', 'w'); xlabel("X"); ylabel("Y"); zlabel("Z");
%     export_fig(String_fig_Classic21,2.5);
%     Time_voxelization_Classic2_1 = toc;
%     save(String_ClassicVoxelized21);
%     clear; clc;
% end
% 
% 
% 
% load("baseParameters.mat");
% if ~exist(String_ClassicVoxelized22, 'file')
%     load(String_ClassicData_raw2);
%     %
%     tic
%     data_Classic2_2_Voxelized = Classic.displayVoxels(data_Classic2, edgeLength2);
%     Classic2_2_fig = plotVoxelizedSpace(data_Classic2_2_Voxelized, 5, faceAlphas, edgeAlphas, voxelColors);
%     grid on;
%     set(gcf, 'Position', get(0, 'Screensize'));
%     view(azimuth,elevation);
%     set(gcf, 'Color', 'w'); xlabel("X"); ylabel("Y"); zlabel("Z");
%     export_fig(String_fig_Classic22,2.5);
%     Time_voxelization_Classic2_2 = toc;
%     save(String_ClassicVoxelized22);
%     clear; clc;
% end
% 
% load("baseParameters.mat");
% 
% if ~exist(String_ClassicVoxelized23, 'file')
%     load(String_ClassicData_raw2);
%     %
%     tic
%     data_Classic2_3_Voxelized = Classic.displayVoxels(data_Classic2, edgeLength3);
%     Classic2_3_fig = plotVoxelizedSpace(data_Classic2_3_Voxelized, 6, faceAlphas, edgeAlphas, voxelColors);
%     grid on;
%     set(gcf, 'Position', get(0, 'Screensize'));
%     view(azimuth,elevation);
%     set(gcf, 'Color', 'w'); xlabel("X"); ylabel("Y"); zlabel("Z");
%     export_fig(String_fig_Classic23,2.5);
%     Time_voxelization_Classic2_3 = toc;
%     save(String_ClassicVoxelized23);
%     clear; clc;
% end
% 
% 
% 
% load("baseParameters.mat");
% 
% if ~exist(String_ClassicVoxelized31, 'file')
%     load(String_ClassicData_raw3);
%     tic
%     data_Classic3_1_Voxelized = Classic.displayVoxels(data_Classic3, edgeLength1);
%     Classic3_1_fig = plotVoxelizedSpace(data_Classic3_1_Voxelized, 7, faceAlphas, edgeAlphas, voxelColors);
%     grid on;
%     hold off;
%     set(gcf, 'Position', get(0, 'Screensize'));
%     view(azimuth,elevation);
%     set(gcf, 'Color', 'w'); xlabel("X"); ylabel("Y"); zlabel("Z");
%     export_fig(String_fig_Classic31,2.5);
%     Time_voxelization_Classic3_1 = toc;
%     save(String_ClassicVoxelized31);
%     clear; clc;
% end
% 
% 
% 
% 
% load("baseParameters.mat");
% if ~exist(String_ClassicVoxelized32, 'file')
%     load(String_ClassicData_raw3);
%     %
%     tic
%     data_Classic3_2_Voxelized = Classic.displayVoxels(data_Classic3, edgeLength2);
%     Classic3_2_fig = plotVoxelizedSpace(data_Classic3_2_Voxelized, 8, faceAlphas, edgeAlphas, voxelColors);
%     grid on;
%     set(gcf, 'Position', get(0, 'Screensize'));
%     view(azimuth,elevation);
%     set(gcf, 'Color', 'w'); xlabel("X"); ylabel("Y"); zlabel("Z");
%     export_fig(String_fig_Classic32,2.5);
%     Time_voxelization_Classic3_2 = toc;
%     save(String_ClassicVoxelized32);
%     clear; clc;
% end
% 
% load("baseParameters.mat");
% 
% if ~exist(String_ClassicVoxelized33, 'file')
%     load(String_ClassicData_raw3);
%     %
%     tic
%     data_Classic3_3_Voxelized = Classic.displayVoxels(data_Classic3, edgeLength3);
%     Classic3_3_fig = plotVoxelizedSpace(data_Classic3_3_Voxelized, 9, faceAlphas, edgeAlphas, voxelColors);
%     grid on;
%     set(gcf, 'Position', get(0, 'Screensize'));
%     view(azimuth,elevation);
%     set(gcf, 'Color', 'w'); xlabel("X"); ylabel("Y"); zlabel("Z");
%     export_fig(String_fig_Classic33,2.5);
%     Time_voxelization_Classic3_3 = toc;
%     save(String_ClassicVoxelized33);
%     clear; clc;
% end

























load("baseParameters.mat")
% GTPR1
if ~exist(String_GTPRData_raw1, 'file')
    tic;
    data_GTPR1 = GTPR1.mapWorkSpace(NoOfRandomElements1);
    Time_data_GTPR1 = toc;
    save(String_GTPRData_raw1);
   clear; clc;
end

load("baseParameters.mat")

if ~exist(String_GTPRData_raw2, 'file')
    tic;
    data_GTPR2 = GTPR1.mapWorkSpace(NoOfRandomElements2);
    Time_data_GTPR2 = toc;
    save(String_GTPRData_raw2);
    clear; clc;
end


load("baseParameters.mat")
if ~exist(String_GTPRData_raw3, 'file')
    tic;
    data_GTPR3 = GTPR1.mapWorkSpace(NoOfRandomElements3);
    Time_data_GTPR3 = toc;
    save(String_GTPRData_raw3);
    clear; clc;
end




load("baseParameters.mat");
if ~exist(String_GTPRVoxelized11, 'file')
    load(String_GTPRData_raw1);
    tic;
    data_GTPR1_1_Voxelized = GTPR1.displayVoxels(data_GTPR1, edgeLength1);
    GTPR1_1_fig = plotVoxelizedSpace(data_GTPR1_1_Voxelized, 10, faceAlphas, edgeAlphas, voxelColors);
    grid on;
    set(gcf, 'Position', get(0, 'Screensize'));
    view(azimuth,elevation);
    set(gcf, 'Color', 'w'); xlabel("X"); ylabel("Y"); zlabel("Z");
    export_fig(String_fig_GTPR11,2.5);
    Time_voxelization_GTPR1_1 = toc;
    save(String_GTPRVoxelized11);
    clear; clc;
end



%
load("baseParameters.mat");
if ~exist(String_GTPRVoxelized12, 'file')
    load(String_GTPRData_raw1);
    tic
    data_GTPR1_2_Voxelized = GTPR1.displayVoxels(data_GTPR1, edgeLength2);
    GTPR1_2_fig = plotVoxelizedSpace(data_GTPR1_2_Voxelized, 11, faceAlphas, edgeAlphas, voxelColors);
    grid on;
    set(gcf, 'Position', get(0, 'Screensize'));
    view(azimuth,elevation);
    set(gcf, 'Color', 'w'); xlabel("X"); ylabel("Y"); zlabel("Z");
    export_fig(String_fig_GTPR12,2.5);
    Time_voxelization_GTPR1_2 = toc;
    save(String_GTPRVoxelized12);
    clear; clc;
end



%
load("baseParameters.mat");
if ~exist(String_GTPRVoxelized13, 'file')
    load(String_GTPRData_raw1);
    %
    tic
    data_GTPR1_3_Voxelized = GTPR1.displayVoxels(data_GTPR1, edgeLength3);
    GTPR1_3_fig = plotVoxelizedSpace(data_GTPR1_3_Voxelized, 12, faceAlphas, edgeAlphas, voxelColors);
    grid on;
    set(gcf, 'Position', get(0, 'Screensize'));
    view(azimuth,elevation);
    set(gcf, 'Color', 'w'); xlabel("X"); ylabel("Y"); zlabel("Z");
    export_fig(String_fig_GTPR13,2.5);
    Time_voxelization_GTPR1_3 = toc;
    save(String_GTPRVoxelized13);
    clear; clc;
end



load("baseParameters.mat");
if ~exist(String_GTPRVoxelized21, 'file')
    load(String_GTPRData_raw2);

    tic
    data_GTPR2_1_Voxelized = GTPR1.displayVoxels(data_GTPR2, edgeLength1);
    GTPR2_1_fig = plotVoxelizedSpace(data_GTPR2_1_Voxelized, 13, faceAlphas, edgeAlphas, voxelColors);
    grid on;
    set(gcf, 'Position', get(0, 'Screensize'));
    view(azimuth,elevation);
    set(gcf, 'Color', 'w'); xlabel("X"); ylabel("Y"); zlabel("Z");
    export_fig(String_fig_GTPR21,2.5);
    Time_voxelization_GTPR2_1 = toc;
    save(String_GTPRVoxelized21);
    clear; clc;
end



load("baseParameters.mat");
if ~exist(String_GTPRVoxelized22, 'file')
    load(String_GTPRData_raw2);

    tic
    data_GTPR2_2_Voxelized = GTPR1.displayVoxels(data_GTPR2, edgeLength2);
    GTPR2_2_fig = plotVoxelizedSpace(data_GTPR2_2_Voxelized, 14, faceAlphas, edgeAlphas, voxelColors);
    grid on;
    set(gcf, 'Position', get(0, 'Screensize'));
    view(azimuth,elevation);
    set(gcf, 'Color', 'w'); xlabel("X"); ylabel("Y"); zlabel("Z");
    export_fig(String_fig_GTPR22,2.5);
    Time_voxelization_GTPR2_2 = toc;
    save(String_GTPRVoxelized22);
    clear; clc;
end



load("baseParameters.mat");
if ~exist(String_GTPRVoxelized23, 'file')
    load(String_GTPRData_raw2);

    tic
    data_GTPR2_3_Voxelized = GTPR1.displayVoxels(data_GTPR2, edgeLength3);
    GTPR2_3_fig = plotVoxelizedSpace(data_GTPR2_3_Voxelized, 15, faceAlphas, edgeAlphas, voxelColors);
    grid on;
    set(gcf, 'Position', get(0, 'Screensize'));
    view(azimuth,elevation);
    set(gcf, 'Color', 'w'); xlabel("X"); ylabel("Y"); zlabel("Z");
    export_fig(String_fig_GTPR23,2.5);
    Time_voxelization_GTPR2_3 = toc;
    save(String_GTPRVoxelized23);
    clear; clc;
end



load("baseParameters.mat");
if ~exist(String_GTPRVoxelized31, 'file')
    load(String_GTPRData_raw3);

    tic
    data_GTPR3_1_Voxelized = GTPR1.displayVoxels(data_GTPR3, edgeLength1);
    GTPR3_1_fig = plotVoxelizedSpace(data_GTPR3_1_Voxelized, 16, faceAlphas, edgeAlphas, voxelColors);
    grid on;
    set(gcf, 'Position', get(0, 'Screensize'));
    view(azimuth,elevation);
    set(gcf, 'Color', 'w'); xlabel("X"); ylabel("Y"); zlabel("Z");
    export_fig(String_fig_GTPR31,2.5);
    Time_voxelization_GTPR3_1 = toc;
    save(String_GTPRVoxelized31);
    clear; clc;
end



load("baseParameters.mat");
if ~exist(String_GTPRVoxelized32, 'file')
    load(String_GTPRData_raw3);

    tic
    data_GTPR3_2_Voxelized = GTPR1.displayVoxels(data_GTPR3, edgeLength2);
    GTPR3_2_fig = plotVoxelizedSpace(data_GTPR3_2_Voxelized, 17, faceAlphas, edgeAlphas, voxelColors);
    grid on;
    set(gcf, 'Position', get(0, 'Screensize'));
    view(azimuth,elevation);
    set(gcf, 'Color', 'w'); xlabel("X"); ylabel("Y"); zlabel("Z");
    export_fig(String_fig_GTPR32,2.5);
    Time_voxelization_GTPR3_2 = toc;
    save(String_GTPRVoxelized32);
    clear; clc;
end



load("baseParameters.mat");
if ~exist(String_GTPRVoxelized33, 'file')
    load(String_GTPRData_raw3);
    tic;
    data_GTPR3_3_Voxelized = GTPR1.displayVoxels(data_GTPR3, edgeLength3);
    GTPR3_3_fig = plotVoxelizedSpace(data_GTPR3_3_Voxelized, 18, faceAlphas, edgeAlphas, voxelColors);
    grid on;
    set(gcf, 'Position', get(0, 'Screensize'));
    view(azimuth,elevation);
    set(gcf, 'Color', 'w'); xlabel("X"); ylabel("Y"); zlabel("Z");
    export_fig(String_fig_GTPR33,2.5);
    Time_voxelization_GTPR3_3 = toc;
    save(String_GTPRVoxelized33);
    clear; clc;
end




load("baseParameters.mat");
load(String_GTPRVoxelized11);
WCI_GTPR_1_1 = workspaceCoverageIndex(data_GTPR1_1_Voxelized);
save(String_GTPRVoxelized11);
clear; clc;

load("baseParameters.mat");
load(String_GTPRVoxelized12);
WCI_GTPR_1_2 = workspaceCoverageIndex(data_GTPR1_2_Voxelized);
save(String_GTPRVoxelized12);
clear; clc;

load("baseParameters.mat");
load(String_GTPRVoxelized13);
WCI_GTPR_1_3 = workspaceCoverageIndex(data_GTPR1_3_Voxelized);
save(String_GTPRVoxelized13);
clear; clc;



load("baseParameters.mat");
load(String_GTPRVoxelized21);
WCI_GTPR_2_1 = workspaceCoverageIndex(data_GTPR2_1_Voxelized);
save(String_GTPRVoxelized21);
clear; clc;

load("baseParameters.mat");
load(String_GTPRVoxelized22);
WCI_GTPR_2_2 = workspaceCoverageIndex(data_GTPR2_2_Voxelized);
save(String_GTPRVoxelized22);
clear; clc;

load("baseParameters.mat");
load(String_GTPRVoxelized23);
WCI_GTPR_2_3 = workspaceCoverageIndex(data_GTPR2_3_Voxelized);
save(String_GTPRVoxelized23);
clear; clc;



load("baseParameters.mat");
load(String_GTPRVoxelized31);
WCI_GTPR_3_1 = workspaceCoverageIndex(data_GTPR3_1_Voxelized);
save(String_GTPRVoxelized31);
clear; clc;

load("baseParameters.mat");
load(String_GTPRVoxelized32);
WCI_GTPR_3_2 = workspaceCoverageIndex(data_GTPR3_2_Voxelized);
save(String_GTPRVoxelized32);
clear; clc;

load("baseParameters.mat");
load(String_GTPRVoxelized33);
WCI_GTPR_3_3 = workspaceCoverageIndex(data_GTPR3_3_Voxelized);
save(String_GTPRVoxelized33);
clear; clc;
























% load("baseParameters.mat");
% load(String_ClassicVoxelized11);
% WCI_Classic_1_1 = workspaceCoverageIndex(data_Classic1_1_Voxelized);
% save(String_ClassicVoxelized11);
% clear; clc;
% 
% load("baseParameters.mat");
% load(String_ClassicVoxelized12);
% WCI_Classic_1_2 = workspaceCoverageIndex(data_Classic1_2_Voxelized);
% save(String_ClassicVoxelized12);
% clear; clc;
% 
% load("baseParameters.mat");
% load(String_ClassicVoxelized13);
% WCI_Classic_1_3 = workspaceCoverageIndex(data_Classic1_3_Voxelized);
% save(String_ClassicVoxelized13);
% clear; clc;
% 
% 
% 
% 
% load("baseParameters.mat");
% load(String_ClassicVoxelized21);
% WCI_Classic_2_1 = workspaceCoverageIndex(data_Classic2_1_Voxelized);
% save(String_ClassicVoxelized21);
% clear; clc;
% 
% load("baseParameters.mat");
% load(String_ClassicVoxelized22);
% WCI_Classic_2_2 = workspaceCoverageIndex(data_Classic2_2_Voxelized);
% save(String_ClassicVoxelized22);
% clear; clc;
% 
% load("baseParameters.mat");
% load(String_ClassicVoxelized23);
% WCI_Classic_2_3 = workspaceCoverageIndex(data_Classic2_3_Voxelized);
% save(String_ClassicVoxelized23);
% clear; clc;
% 
% 
% 
% 
% load("baseParameters.mat");
% load(String_ClassicVoxelized31);
% WCI_Classic_3_1 = workspaceCoverageIndex(data_Classic3_1_Voxelized);
% save(String_ClassicVoxelized31);
% clear; clc;
% 
% load("baseParameters.mat");
% load(String_ClassicVoxelized32);
% WCI_Classic_3_2 = workspaceCoverageIndex(data_Classic3_2_Voxelized);
% save(String_ClassicVoxelized32);
% clear; clc;
% 
% load("baseParameters.mat");
% load(String_ClassicVoxelized33);
% WCI_Classic_3_3 = workspaceCoverageIndex(data_Classic3_3_Voxelized);
% save(String_ClassicVoxelized33);
% clear; clc;
























































































load("baseParameters.mat");
% load(String_ClassicVoxelized11, "WCI_Classic_1_1", "Time_voxelization_Classic1_1");
% load(String_ClassicVoxelized12, "WCI_Classic_1_2", "Time_voxelization_Classic1_2");
% load(String_ClassicVoxelized13, "WCI_Classic_1_3", "Time_voxelization_Classic1_3");
% 	   
% load(String_ClassicVoxelized21, "WCI_Classic_2_1", "Time_voxelization_Classic2_1");
% load(String_ClassicVoxelized22, "WCI_Classic_2_2", "Time_voxelization_Classic2_2");
% load(String_ClassicVoxelized23, "WCI_Classic_2_3", "Time_voxelization_Classic2_3");
% 	   
% load(String_ClassicVoxelized31, "WCI_Classic_3_1", "Time_voxelization_Classic3_1");
% load(String_ClassicVoxelized32, "WCI_Classic_3_2", "Time_voxelization_Classic3_2");
% load(String_ClassicVoxelized33, "WCI_Classic_3_3", "Time_voxelization_Classic3_3");
	   
load(String_GTPRVoxelized11, "WCI_GTPR_1_1", "Time_voxelization_GTPR1_1");
load(String_GTPRVoxelized12, "WCI_GTPR_1_2", "Time_voxelization_GTPR1_2");
load(String_GTPRVoxelized13, "WCI_GTPR_1_3", "Time_voxelization_GTPR1_3");

load(String_GTPRVoxelized21, "WCI_GTPR_2_1", "Time_voxelization_GTPR2_1");
load(String_GTPRVoxelized22, "WCI_GTPR_2_2", "Time_voxelization_GTPR2_2");
load(String_GTPRVoxelized23, "WCI_GTPR_2_3", "Time_voxelization_GTPR2_3");
				  
load(String_GTPRVoxelized31, "WCI_GTPR_3_1", "Time_voxelization_GTPR3_1");
load(String_GTPRVoxelized32, "WCI_GTPR_3_2", "Time_voxelization_GTPR3_2");
load(String_GTPRVoxelized33, "WCI_GTPR_3_3", "Time_voxelization_GTPR3_3");








% load(String_ClassicVoxelized11, "data_Classic1_1_Voxelized");
% load(String_ClassicVoxelized12, "data_Classic1_2_Voxelized");
% load(String_ClassicVoxelized13, "data_Classic1_3_Voxelized");
% 
% load(String_ClassicVoxelized21, "data_Classic2_1_Voxelized");
% load(String_ClassicVoxelized22, "data_Classic2_2_Voxelized");
% load(String_ClassicVoxelized23, "data_Classic2_3_Voxelized");
% 																  
% load(String_ClassicVoxelized31, "data_Classic3_1_Voxelized");
% load(String_ClassicVoxelized32, "data_Classic3_2_Voxelized");
% load(String_ClassicVoxelized33, "data_Classic3_3_Voxelized");


% WCI_Classic_1_1 = workspaceCoverageIndex(data_Classic1_1_Voxelized);
% WCI_Classic_1_2 = workspaceCoverageIndex(data_Classic1_2_Voxelized);
% WCI_Classic_1_3 = workspaceCoverageIndex(data_Classic1_3_Voxelized);
% 
% WCI_Classic_2_1 = workspaceCoverageIndex(data_Classic2_1_Voxelized);
% WCI_Classic_2_2 = workspaceCoverageIndex(data_Classic2_2_Voxelized);
% WCI_Classic_2_3 = workspaceCoverageIndex(data_Classic2_3_Voxelized);
% 
% WCI_Classic_3_1 = workspaceCoverageIndex(data_Classic3_1_Voxelized);
% WCI_Classic_3_2 = workspaceCoverageIndex(data_Classic3_2_Voxelized);
% WCI_Classic_3_3 = workspaceCoverageIndex(data_Classic3_3_Voxelized);























load(String_GTPRVoxelized11, "data_GTPR1_1_Voxelized");
load(String_GTPRVoxelized12, "data_GTPR1_2_Voxelized");
load(String_GTPRVoxelized13, "data_GTPR1_3_Voxelized");
				
load(String_GTPRVoxelized21, "data_GTPR2_1_Voxelized");
load(String_GTPRVoxelized22, "data_GTPR2_2_Voxelized");
load(String_GTPRVoxelized23, "data_GTPR2_3_Voxelized");
									  
load(String_GTPRVoxelized31, "data_GTPR3_1_Voxelized");
load(String_GTPRVoxelized32, "data_GTPR3_2_Voxelized");
load(String_GTPRVoxelized33, "data_GTPR3_3_Voxelized");


WCI_GTPR_1_1 = workspaceCoverageIndex(data_GTPR1_1_Voxelized);
WCI_GTPR_1_2 = workspaceCoverageIndex(data_GTPR1_2_Voxelized);
WCI_GTPR_1_3 = workspaceCoverageIndex(data_GTPR1_3_Voxelized);
																		  
WCI_GTPR_2_1 = workspaceCoverageIndex(data_GTPR2_1_Voxelized);
WCI_GTPR_2_2 = workspaceCoverageIndex(data_GTPR2_2_Voxelized);
WCI_GTPR_2_3 = workspaceCoverageIndex(data_GTPR2_3_Voxelized);
																		  
WCI_GTPR_3_1 = workspaceCoverageIndex(data_GTPR3_1_Voxelized);
WCI_GTPR_3_2 = workspaceCoverageIndex(data_GTPR3_2_Voxelized);
WCI_GTPR_3_3 = workspaceCoverageIndex(data_GTPR3_3_Voxelized);




columnNames = {num2str(NoOfRandomElements1),num2str(NoOfRandomElements2),num2str(NoOfRandomElements3)};

GTPR_wci = 100*[WCI_GTPR_1_1, WCI_GTPR_1_2, WCI_GTPR_1_3;...
            WCI_GTPR_2_1, WCI_GTPR_2_2, WCI_GTPR_2_3;...
            WCI_GTPR_3_1, WCI_GTPR_3_2, WCI_GTPR_3_3;];
        
rows = {num2str(edgeLength1),num2str(edgeLength2),num2str(edgeLength3)};

GTPR_WCI_Table = table(GTPR_wci, columnNames', 'RowNames', rows);







% Classic_wci = 100*[WCI_Classic_1_1, WCI_Classic_1_2, WCI_Classic_1_3;...
%             WCI_Classic_2_1, WCI_Classic_2_2, WCI_Classic_2_3;...
%             WCI_Classic_3_1, WCI_Classic_3_2, WCI_Classic_3_3;]';
%         
% 
% Classic_WCI_Table = table(Classic_wci, columnNames', 'RowNames', rows);

% save(sprintf("WCIs_%s_%s_%s_%s.mat", num2str(NoOfRandomElements1), num2str(NoOfRandomElements2), num2str(NoOfRandomElements3), dateNow), "Classic_WCI_Table", "GTPR_WCI_Table");
save(sprintf("WCIs_%s_%s_%s_%s.mat", num2str(NoOfRandomElements1), num2str(NoOfRandomElements2), num2str(NoOfRandomElements3), dateNow), "GTPR_WCI_Table");
close all




% Classic_Time = [Time_voxelization_Classic1_1, Time_voxelization_Classic1_2, Time_voxelization_Classic1_3;...
%                 Time_voxelization_Classic2_1, Time_voxelization_Classic2_2, Time_voxelization_Classic2_3;...
%                 Time_voxelization_Classic3_1, Time_voxelization_Classic3_2, Time_voxelization_Classic3_3]';
%             
% ClassicTime_table = table(Classic_Time, columnNames', 'RowNames', rows);


GTPR_Time = [Time_voxelization_GTPR1_1, Time_voxelization_GTPR1_2, Time_voxelization_GTPR1_3;...
                Time_voxelization_GTPR2_1, Time_voxelization_GTPR2_2, Time_voxelization_GTPR2_3;...
                Time_voxelization_GTPR3_1, Time_voxelization_GTPR3_2, Time_voxelization_GTPR3_3]';
            
GTPRTime_table = table(GTPR_Time, columnNames', 'RowNames', rows);

% save(sprintf("Times_%s_%s_%s_%s.mat", num2str(NoOfRandomElements1), num2str(NoOfRandomElements2), num2str(NoOfRandomElements3), dateNow), "ClassicTime_table", "GTPRTime_table");

save(sprintf("Times_%s_%s_%s_%s.mat", num2str(NoOfRandomElements1), num2str(NoOfRandomElements2), num2str(NoOfRandomElements3), dateNow), "GTPRTime_table");

% delete(String_ClassicData_raw1, String_ClassicData_raw2, String_ClassicData_raw3, ...
%        String_ClassicVoxelized11, String_ClassicVoxelized12, String_ClassicVoxelized13,...
%        String_ClassicVoxelized21, String_ClassicVoxelized22, String_ClassicVoxelized23,...
%        String_ClassicVoxelized31, String_ClassicVoxelized32, String_ClassicVoxelized33,...
%        String_GTPRData_raw1, String_GTPRData_raw2, String_GTPRData_raw3, ...
%        String_GTPRVoxelized11, String_GTPRVoxelized12, String_GTPRVoxelized13, ...
%        String_GTPRVoxelized21, String_GTPRVoxelized22, String_GTPRVoxelized23, ...
%        String_GTPRVoxelized31, String_GTPRVoxelized32, String_GTPRVoxelized33, ...
%        "baseParameters.mat")
   
delete(String_GTPRData_raw1, String_GTPRData_raw2, String_GTPRData_raw3, ...
       String_GTPRVoxelized11, String_GTPRVoxelized12, String_GTPRVoxelized13, ...
       String_GTPRVoxelized21, String_GTPRVoxelized22, String_GTPRVoxelized23, ...
       String_GTPRVoxelized31, String_GTPRVoxelized32, String_GTPRVoxelized33, ...
       "baseParameters.mat")


save(sprintf("Example_GTPR_Voxelization_%s_%s_%s_%s.mat", num2str(NoOfRandomElements1), num2str(NoOfRandomElements2), num2str(NoOfRandomElements3), dateNow));

GTPR1_1_Xmax = max(data_GTPR1_1_Voxelized.grid.x);
GTPR1_1_Xmin = min(data_GTPR1_1_Voxelized.grid.x);
GTPR1_1_Ymax = max(data_GTPR1_1_Voxelized.grid.y);
GTPR1_1_Ymin = min(data_GTPR1_1_Voxelized.grid.y);
GTPR1_1_Zmax = max(data_GTPR1_1_Voxelized.grid.z);
GTPR1_1_Zmin = min(data_GTPR1_1_Voxelized.grid.z);

GTPR2_1_Xmax = max(data_GTPR2_1_Voxelized.grid.x);
GTPR2_1_Xmin = min(data_GTPR2_1_Voxelized.grid.x);
GTPR2_1_Ymax = max(data_GTPR2_1_Voxelized.grid.y);
GTPR2_1_Ymin = min(data_GTPR2_1_Voxelized.grid.y);
GTPR2_1_Zmax = max(data_GTPR2_1_Voxelized.grid.z);
GTPR2_1_Zmin = min(data_GTPR2_1_Voxelized.grid.z);

GTPR3_1_Xmax = max(data_GTPR3_1_Voxelized.grid.x);
GTPR3_1_Xmin = min(data_GTPR3_1_Voxelized.grid.x);
GTPR3_1_Ymax = max(data_GTPR3_1_Voxelized.grid.y);
GTPR3_1_Ymin = min(data_GTPR3_1_Voxelized.grid.y);
GTPR3_1_Zmax = max(data_GTPR3_1_Voxelized.grid.z);
GTPR3_1_Zmin = min(data_GTPR3_1_Voxelized.grid.z);