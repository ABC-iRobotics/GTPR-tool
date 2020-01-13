function figureHandle = plotVoxelizedSpace(voxelized3DSpace, figureNo, faceAlphas, edgeAlphas, colors)
    % Plot the 3D Voxel map, with appropriate colors and alphas
    % The orders for the last 3 arguments:
    %   1) Arm1
    %   2) arm2
    %   3) arm3
    %   4) TCP 
    %   5) Arm1 Common Points with TCP
    %   6) Arm2 Common Points with TCP
    %   7) Arm3 Common Points with TCP

    % Bit fields:
    % 1  - TCP
    % 2  - arm1 end pts (D)
    % 3  - arm2 end pts (E)
    % 4  - arm3 end pts (F)
    % 5  - G pts 
    % 6  - H pts
    % 7  - I pts
    % 8  - A-D pts
    % 9  - B-E pts
    % 10 - C-F pts
    % 11 - D-G pts
    % 12 - E-H pts
    % 13 - F-I pts
    % 14  - A rotational pt
    % 15  - B rotational pt
    % 16 - C rotational pt

    A = bitget(voxelized3DSpace.VoxelData, 14) == 1;
    B = bitget(voxelized3DSpace.VoxelData, 15) == 1;
    C = bitget(voxelized3DSpace.VoxelData, 16) == 1;

    AD = bitget(voxelized3DSpace.VoxelData, 8) == 1;
    BE = bitget(voxelized3DSpace.VoxelData, 9) == 1;
    CF = bitget(voxelized3DSpace.VoxelData, 10) == 1;

    DG = bitget(voxelized3DSpace.VoxelData, 11) == 1;
    EH = bitget(voxelized3DSpace.VoxelData, 12) == 1;
    FI = bitget(voxelized3DSpace.VoxelData, 13) == 1;

    TCP = bitget(voxelized3DSpace.VoxelData, 1) == 1;

    arm1Common = bitget(voxelized3DSpace.VoxelData, 8) == 1 & bitget(voxelized3DSpace.VoxelData, 11) == 1 & bitget(voxelized3DSpace.VoxelData, 1) == 1;
    arm2Common = bitget(voxelized3DSpace.VoxelData, 9) == 1 & bitget(voxelized3DSpace.VoxelData, 12) == 1 & bitget(voxelized3DSpace.VoxelData, 1) == 1;
    arm3Common = bitget(voxelized3DSpace.VoxelData, 10) == 1 & bitget(voxelized3DSpace.VoxelData, 13) == 1 & bitget(voxelized3DSpace.VoxelData, 1) == 1;

    % plot it:
    figureHandle = figure(figureNo);
    hold on;

    PATCH_3Darray(faceAlphas(1), edgeAlphas(1), A, voxelized3DSpace.grid.x, voxelized3DSpace.grid.y, voxelized3DSpace.grid.z, colors(1,:));
    PATCH_3Darray(faceAlphas(2), edgeAlphas(2), B, voxelized3DSpace.grid.x, voxelized3DSpace.grid.y, voxelized3DSpace.grid.z, colors(2,:));
    PATCH_3Darray(faceAlphas(3), edgeAlphas(3), C, voxelized3DSpace.grid.x, voxelized3DSpace.grid.y, voxelized3DSpace.grid.z, colors(3,:));

    PATCH_3Darray(faceAlphas(1), edgeAlphas(1), AD, voxelized3DSpace.grid.x, voxelized3DSpace.grid.y, voxelized3DSpace.grid.z, colors(1,:));
    PATCH_3Darray(faceAlphas(2), edgeAlphas(2), BE, voxelized3DSpace.grid.x, voxelized3DSpace.grid.y, voxelized3DSpace.grid.z, colors(2,:));
    PATCH_3Darray(faceAlphas(3), edgeAlphas(3), CF, voxelized3DSpace.grid.x, voxelized3DSpace.grid.y, voxelized3DSpace.grid.z, colors(3,:));

    PATCH_3Darray(faceAlphas(1), edgeAlphas(1), DG, voxelized3DSpace.grid.x, voxelized3DSpace.grid.y, voxelized3DSpace.grid.z, colors(1,:));
    PATCH_3Darray(faceAlphas(2), edgeAlphas(2), EH, voxelized3DSpace.grid.x, voxelized3DSpace.grid.y, voxelized3DSpace.grid.z, colors(2,:));
    PATCH_3Darray(faceAlphas(3), edgeAlphas(3), FI, voxelized3DSpace.grid.x, voxelized3DSpace.grid.y, voxelized3DSpace.grid.z, colors(3,:));

    PATCH_3Darray(faceAlphas(4), edgeAlphas(4), TCP, voxelized3DSpace.grid.x, voxelized3DSpace.grid.y, voxelized3DSpace.grid.z, colors(4,:));

    if  sum(arm1Common(:) > 0)
        PATCH_3Darray(faceAlphas(5), edgeAlphas(5), arm1Common, voxelized3DSpace.grid.x, voxelized3DSpace.grid.y, voxelized3DSpace.grid.z, colors(5,:));
    end

    if sum(arm2Common(:) > 0)
        PATCH_3Darray(faceAlphas(6), edgeAlphas(6), arm2Common, voxelized3DSpace.grid.x, voxelized3DSpace.grid.y, voxelized3DSpace.grid.z, colors(6,:));
    end

    if sum(arm3Common(:) > 0)
        PATCH_3Darray(faceAlphas(7), edgeAlphas(7), arm3Common, voxelized3DSpace.grid.x, voxelized3DSpace.grid.y, voxelized3DSpace.grid.z, colors(7,:));
    end


end