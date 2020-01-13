classdef GTPR_Volume_Functions < GTPR_Geometry
    %GTPR_Volume_Functions Summary
    % This class defines the basic functions which are used most widely,
    % for the static workspace mapping.
    
    properties
        GTPR_model;
    end
    
    methods
        
        function outData = Voxelize(obj, inData, edgeLength)
        % This function will voxelize the workspace which allows us to 
        % see the arms movement in the workspace with a specific resolution
        % Inputs:
        %   - inData:              containts the characteristic points of the workspace previously calculated
        %
        %   - edgeLength:           the distance between each points of the workspace by which it should
        %                           be investigated
        %
        %   - outdata:         a struct which contains all the necessary output data.
        %                   'dataValues', WS_boolFull, 'AxisValues_X', WS_x, 'AxisValues_Y', WS_y, 'AxisValues_Z', WS_z
        %                   For the "bool" cloud workspace
        %                   0     -> empty space
        %                   1     -> robot ws (TCP)
        %                   -1    -> deadWS (arm1)
        %                   -2    -> deadWS (arm2)
        %                   -3    -> deadWS (arm3)
        
        
        
        arm1_pts = extractfield(inData, 'D');
        arm2_pts = extractfield(inData, 'E');
        arm3_pts = extractfield(inData, 'F');
        
        WS_pts = extractfield(inData, 'TCP');

        % find the max min of the workspace, and round it to the closest
        % 100th mm.
        
        
        
        WS_minmax = [   min(WS_pts(:,1)), min(WS_pts(:,2)), min(WS_pts(:,3));...
                        max(WS_pts(:,1)), max(WS_pts(:,2)), max(WS_pts(:,3));];
         
        discrete_rounding = 300;
                    
        % The discrete ws:
        if (WS_minmax(1,:) < 0) %min
            WS_minmax(1,:) = floor(WS_minmax(1,:)/discrete_rounding)*discrete_rounding-discrete_rounding;
        else
            WS_minmax(1,:) = ceil(WS_minmax(1,:)/discrete_rounding)*discrete_rounding;
        end
        
        WS_disc_min = floor(min(WS_minmax(:,1:2),[],'all')/discrete_rounding)*discrete_rounding;
        WS_disc_max = ceil(max(WS_minmax(:,1:2),[],'all')/discrete_rounding)*discrete_rounding;
        
        WS_disc_max = max(abs(WS_disc_max), abs(WS_disc_min));
        
        WS_minmax(1,1:2) = -WS_disc_max;
        WS_minmax(2,1:2) = WS_disc_max;
        WS_minmax_disc = ceil(WS_minmax/discrete_rounding)*discrete_rounding;
        
        WS_x = [WS_minmax_disc(1,1):edgeLength:WS_minmax_disc(2,1)];
        WS_y = [WS_minmax_disc(1,2):edgeLength:WS_minmax_disc(2,2)];
        WS_z = [WS_minmax_disc(2,3)+discrete_rounding:-edgeLength:WS_minmax_disc(1,3)];
        
        % For the "bool" cloud workspace
        % 0     -> empty space
        % 1     -> robot ws (TCP)
        % -1    -> deadWS (arm1)
        % -2    -> deadWS (arm2)
        % -3    -> deadWS (arm3)
        % -4    -> arm1 rotational point
        % -5    -> arm2 rotational point
        % -6    -> arm3 rotational point

        WS_VoxelFull = int8(zeros(length(WS_x), length(WS_y), length(WS_z)));

        [WS_VoxelFull, WS_idx] = mapVoxelValue(WS_VoxelFull, WS_data, roundingPrecisionN, 1, WS_x, WS_y, WS_z);
        
        [WS_arms, arm1_idx] = mapVoxelValue(WS_VoxelFull, arm1_pts, roundingPrecisionN, -1, WS_x, WS_y, WS_z);
        [WS_arms, arm2_idx] = mapVoxelValue(WS_arms, arm2_pts, roundingPrecisionN, -2, WS_x, WS_y, WS_z);
        [WS_arms, arm3_idx] = mapVoxelValue(WS_arms, arm3_pts, roundingPrecisionN, -3, WS_x, WS_y, WS_z);
        
        [A, B, C, A1, B1, C1, A1v, B1v, C1v] = obj.UpperArmsPoints2(0,0,0);
        
        %armij_idx stands for the location of the rotational joint index
        %within the voxelmap
        [WS_arms, arm1j_idx] = mapVoxelValue(WS_arms, A', roundingPrecisionN, -7, WS_x, WS_y, WS_z);
        [WS_arms, arm2j_idx] = mapVoxelValue(WS_arms, B', roundingPrecisionN, -8, WS_x, WS_y, WS_z);
        [WS_arms, arm3j_idx] = mapVoxelValue(WS_arms, C', roundingPrecisionN, -9, WS_x, WS_y, WS_z);
        
        arm1_idx = unique(arm1_idx, 'rows');
        arm2_idx = unique(arm2_idx, 'rows');
        arm3_idx = unique(arm3_idx, 'rows');
       
        outData = struct('WS_VoxelMap', WS_VoxelFull, 'WS_indeces', WS_idx, 'WS_arms', WS_arms, ...
        'arm1u_indeces', arm1_idx, 'arm2u_indeces', arm2_idx, 'arm3u_indeces', arm3_idx, ...
        'AxisValues_X', WS_x, 'AxisValues_Y', WS_y, 'AxisValues_Z', WS_z, ...
        'arm1joint_idx', arm1j_idx, 'arm2joint_idx', arm2j_idx, 'arm3joint_idx', arm3j_idx);
        
    %'arm1l_indeces', arm1l_idx, 'arm2l_indeces', arm2l_idx, 'arm3l_indeces', arm3l_idx, ...
        
        end
        
        function data = Voxelize_bits(obj, WS_data, deadWS_data, edgeLength, roundingPrecisionN)
        % This function will booleanize the workspace which allows us to 
        % see the arms movement in the workspace with a specific resolution
        % Inputs:
        %   - WS_data:              should be a 3*n matrix, where the columns correspond to the
        %                           x,y,z coordinates of the workspace.
        %
        %   - deadWS_data:          should be a 9*n matrix, where the columns (grouped
        %                           by 3) are the (xyz) coordinates of the upper arm endpoints
        %
        %   - edgeLength:           the distance between each points of the workspace by which it should
        %                           be investigated
        %
        %   - roundingPrecisionN:   For the rounding of the arm coordinates, till the precision specified.
        %                           Same input as for round() function. 
        %
        % Output:
        %   - data:         a struct which contains all the necessary output data.
        %                   'dataValues', WS_boolFull, 'AxisValues_X', WS_x, 'AxisValues_Y', WS_y, 'AxisValues_Z', WS_z
        %                   For the "bit" cloud workspace
        %                   0     -> empty space
        %                   1     -> robot ws (TCP)
        %                   2    -> deadWS (arm1)
        %                   3    -> deadWS (arm2)
        %                   4    -> deadWS (arm3)
        
        arm1_pts = unique(deadWS_data(:,1:3), 'rows');
        arm2_pts = unique(deadWS_data(:,4:6), 'rows');
        arm3_pts = unique(deadWS_data(:,7:9), 'rows');
        
        WS_pts = unique(WS_data, 'rows');

        % find the max min of the workspace, and round it to the closest
        % 100th mm.
        
        WS_minmax = [   min(WS_pts(:,1)), min(WS_pts(:,2)), min(WS_pts(:,3));...
                        max(WS_pts(:,1)), max(WS_pts(:,2)), max(WS_pts(:,3));];
         
        discrete_rounding = 300;
                    
        % The discrete ws:
        if (WS_minmax(1,:) < 0) %min
            WS_minmax(1,:) = floor(WS_minmax(1,:)/discrete_rounding)*discrete_rounding-discrete_rounding;
        else
            WS_minmax(1,:) = ceil(WS_minmax(1,:)/discrete_rounding)*discrete_rounding;
        end
        
        WS_disc_min = floor(min(WS_minmax(:,1:2),[],'all')/discrete_rounding)*discrete_rounding;
        WS_disc_max = ceil(max(WS_minmax(:,1:2),[],'all')/discrete_rounding)*discrete_rounding;
        
        WS_disc_max = max(abs(WS_disc_max), abs(WS_disc_min));
        
        WS_minmax(1,1:2) = -WS_disc_max;
        WS_minmax(2,1:2) = WS_disc_max;
        WS_minmax_disc = ceil(WS_minmax/discrete_rounding)*discrete_rounding;
        
        WS_x = [WS_minmax_disc(1,1):edgeLength:WS_minmax_disc(2,1)];
        WS_y = [WS_minmax_disc(1,2):edgeLength:WS_minmax_disc(2,2)];
        WS_z = [WS_minmax_disc(2,3)+discrete_rounding:-edgeLength:WS_minmax_disc(1,3)];
        
        WS_VoxelFull = (uint16(zeros(length(WS_x), length(WS_y), length(WS_z))));

        [WS_VoxelFull, WS_idx] = mapVoxelValue_bits(WS_VoxelFull, WS_data, roundingPrecisionN, 1, WS_x, WS_y, WS_z);
        
        [WS_arms, arm1_idx] = mapVoxelValue_bits(WS_VoxelFull, arm1_pts, roundingPrecisionN, 2, WS_x, WS_y, WS_z);
        [WS_arms, arm2_idx] = mapVoxelValue_bits(WS_arms, arm2_pts, roundingPrecisionN, 3, WS_x, WS_y, WS_z);
        [WS_arms, arm3_idx] = mapVoxelValue_bits(WS_arms, arm3_pts, roundingPrecisionN, 4, WS_x, WS_y, WS_z);
        
        [A, B, C, A1, B1, C1, A1v, B1v, C1v] = obj.UpperArmsPoints2(0,0,0);
        
        %armij_idx stands for the location of the rotational joint index
        %within the voxelmap
        [WS_arms, arm1j_idx] = mapVoxelValue(WS_arms, A', roundingPrecisionN, 7, WS_x, WS_y, WS_z);
        [WS_arms, arm2j_idx] = mapVoxelValue(WS_arms, B', roundingPrecisionN, 8, WS_x, WS_y, WS_z);
        [WS_arms, arm3j_idx] = mapVoxelValue(WS_arms, C', roundingPrecisionN, 9, WS_x, WS_y, WS_z);
        
        arm1_idx = unique(arm1_idx, 'rows');
        arm2_idx = unique(arm2_idx, 'rows');
        arm3_idx = unique(arm3_idx, 'rows');
       
        data = struct('WS_VoxelMap', WS_VoxelFull, 'WS_indeces', WS_idx, 'WS_arms', WS_arms, ...
        'arm1u_indeces', arm1_idx, 'arm2u_indeces', arm2_idx, 'arm3u_indeces', arm3_idx, ...
        'AxisValues_X', WS_x, 'AxisValues_Y', WS_y, 'AxisValues_Z', WS_z, ...
        'arm1joint_idx', arm1j_idx, 'arm2joint_idx', arm2j_idx, 'arm3joint_idx', arm3j_idx);
        
    %'arm1l_indeces', arm1l_idx, 'arm2l_indeces', arm2l_idx, 'arm3l_indeces', arm3l_idx, ...
        
        end
        
%         function elements = findElementsWithinTolerance(A,B, tolerance)
%            abs(u-v) <= tol*max(abs([A(:);B(:)])) 
%         end
        
        function [Boundary, Volume] = getBoundary(obj, dataPts)
        % Input:
        %   - dataPts: The datapoints to be plotted, should be a n*3
        %   matrix, where the columns correspond to the X, Y, Z coordinates
            [Boundary, Volume] = boundary(dataPts(:,1), dataPts(:,2), dataPts(:,3));
        end
            
            
        function [Boundary, Volume] = plotSurface(obj, dataPts, color, opacity)
        % Plot the data points in 3D, as a surface:
        % Input:
        %   - dataPts: The datapoints to be plotted, should be a n*3
        %   matrix, where the columns correspond to the X, Y, Z coordinates
        % Output:
        %   - Boundary: The boundary points of the input
        %   - Volume: Volume of the bounded points
            [Boundary, Volume] = boundary(dataPts(:,1), dataPts(:,2), dataPts(:,3));
            trisurf(Boundary, dataPts(:,1), dataPts(:,2), dataPts(:,3), 'Facecolor', color , 'FaceAlpha', opacity);
        end
        
        function plotSurfaceWDeadWS(obj, data_WS, data_DeadWS, surfaceColor, opacity, arm1Color, arm2Color, arm3Color)
            plot3(data_DeadWS(:,1), data_DeadWS(:,2), data_DeadWS(:,3), arm1Color);
            
            hold on;
            
            plot3(data_DeadWS(:,4), data_DeadWS(:,5), data_DeadWS(:,6), arm2Color);
            plot3(data_DeadWS(:,7), data_DeadWS(:,8), data_DeadWS(:,9), arm3Color);
            
            [Boundary, Volume] = boundary(data_WS(:,1), data_WS(:,2), data_WS(:,3));
            
            trisurf(Boundary, data_WS(:,1), data_WS(:,2), data_WS(:,3), 'FaceColor', surfaceColor, 'FaceAlpha', opacity);
            
        end
        
        function [tol_under, tol_over] = makeTolerance(obj, mat, tolerance)
           % Makes a simple tolerance about the numbers in the matrix 
           % specified, for over and under 
           tol_under = mat - tolerance;
           tol_over = mat + tolerance;
        end
        

    end
end

