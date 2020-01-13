function outData = DisplayVoxelizedGTPR(GTPR, q, edgeLength, faceAlphas, edgeAlphas, voxelColors, plotRobot)
% Displays the Voxelized workspace of a GTPR.
% Inputs:
%   - GTPR: an object of the GTPR class, which was already preconstructed
%   - q: angles of the arms (in radians) in the format of nx3 or the number 
%        of random points to investigate
%   - edgeLength: the size of the voxel edges length
%   - precision: The rounding precision of the work-space, should correlate
%                to edgeLength
%   - faceAlphas: (Optional) the opacity of the voxel sides (array of 7, 
%                 limited between 0 and 1)
%   - edgeAlphas: (Optional) the opacity of the voxel edges (array of 7, 
%                  limited between 0 and 1)
%   - voxelColors: (Optional) the colors of each voxel (array of 7x3,
%                  values between 0 and 1)
%       The orders for the previous three arguments:
%       1) Arm1
%       2) arm2
%       3) arm3
%       4) TCP 
%       5) Arm1 Common Points with TCP
%       6) Arm2 Common Points with TCP
%       7) Arm3 Common Points with TCP
%   - plotRobot: (Optional) to plot the robots base triangle with the upper
%   arms

    qVec = [];

    if length(q) <= 1
        qVec = deg2rad(rand(q, 3) * 90);
        qVec = unique(qVec, 'rows');
        
        while (length(qVec) < q )
            
            q2 = deg2rad(rand(q-length(qVec),3) * 90);
            
            q2 = unique(q2,'rows');
            
            qVec = [qVec;q2];
        end
        
        
    else
        % Do nothing
        qVec = q;
    end
    
    
    
    GTPRNotablePoints = GTPR.DirectGeometry(qVec);
    VoxelMap = GTPR.voxelizeWS(GTPRNotablePoints, edgeLength);
    
    % if the optional arguments are given:
    if nargin <= 4 
        if ~exist('plotRobot', 'var')
            plotRobot = 1;
        end
        
        if ~exist('faceAlphas', 'var')
            faceAlphas = [0.1, 0.1, 0.1, 1, 0.3, 0.3, 0.3];
        end
        
        if ~exist('edgeAlphas', 'var')
           edgeAlphas = [0.1, 0.1, 0.1, 1, 0.3, 0.3, 0.3];
        end
        
        if ~exist('voxelColors', 'var')
           voxelColors = [ 1 0 0;
                           0 0 1;
                           0 1 0;
                           1 1 0;
                           1 0 0;
                           0 0 1;
                           0 1 0;]; 
        end
    else
        % do nothing
    end

    % Start the plotting:
    GTPR.plotVoxelizedSpace(VoxelMap, faceAlphas, edgeAlphas, voxelColors);
    
    if plotRobot == 1
        GTPR.plotGTPR([0 0 0], 'nice');
    end
    
    hold off;
    
	outData = struct('GTPRNotablePoints', GTPRNotablePoints, 'VoxelMap', VoxelMap);
end

