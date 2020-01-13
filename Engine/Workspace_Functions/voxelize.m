function outData = voxelize(inData, edgeLength)
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

        arm1_pts = reshape(extractfield(inData, 'D'),3,[])';
        arm2_pts = reshape(extractfield(inData, 'E'),3,[])';
        arm3_pts = reshape(extractfield(inData, 'F'),3,[])';
        
        A = reshape(extractfield(inData, 'A'),3,[])';
        B = reshape(extractfield(inData, 'B'),3,[])';
        C = reshape(extractfield(inData, 'C'),3,[])';
        
        D = reshape(extractfield(inData, 'D'),3,[])';
        E = reshape(extractfield(inData, 'E'),3,[])';
        F = reshape(extractfield(inData, 'F'),3,[])';
        
        G = reshape(extractfield(inData, 'G'),3,[])';
        H = reshape(extractfield(inData, 'H'),3,[])';
        I = reshape(extractfield(inData, 'I'),3,[])';
        
        TCP = reshape(extractfield(inData, 'TCP'),3,[])';
        
        A = unique(A,'rows');
        B = unique(B,'rows');
        C = unique(C,'rows');
        
        TCP = unique(TCP,'rows');
        
        % find the max min of the workspace, and round it to the closest
        % 5th mm.
        
        % Minimum values:
        x_min = min([arm1_pts(:,1); arm2_pts(:,1); arm3_pts(:,1); TCP(:,1); G(:,1); H(:,1); I(:,1)]);
        
        y_min = min([arm1_pts(:,2); arm2_pts(:,2); arm3_pts(:,2); TCP(:,2); G(:,2); H(:,2); I(:,2)]);
                 
        z_min = min([arm1_pts(:,3); arm2_pts(:,3); arm3_pts(:,3); TCP(:,3); G(:,3); H(:,3); I(:,3)]);
                 
        % Maximum values:
        x_max = max([arm1_pts(:,1); arm2_pts(:,1); arm3_pts(:,1); TCP(:,1); G(:,1); H(:,1); I(:,1)]);
        
        y_max = max([arm1_pts(:,2); arm2_pts(:,2); arm3_pts(:,2); TCP(:,2); G(:,2); H(:,2); I(:,2)]);
                 
        z_max = max([arm1_pts(:,3); arm2_pts(:,3); arm3_pts(:,3); TCP(:,3); G(:,3); H(:,3); I(:,3)]);
        
        % Round to the boudary:
        discreteRounding = edgeLength;
        x_min = floor(x_min/discreteRounding)*discreteRounding-discreteRounding;
        y_min = floor(y_min/discreteRounding)*discreteRounding-discreteRounding;
        z_min = floor(z_min/discreteRounding)*discreteRounding-discreteRounding;
        
        x_max = ceil(x_max/discreteRounding)*discreteRounding;
        y_max = ceil(y_max/discreteRounding)*discreteRounding;
        z_max = ceil(z_max/discreteRounding)*discreteRounding;
        
        WS_x = x_min:edgeLength:x_max;
        WS_y = y_min:edgeLength:y_max;
        WS_z = z_min:edgeLength:z_max;
        
        dx = floor((x_max-x_min)/edgeLength)+1;
        dy = floor((y_max-y_min)/edgeLength)+1;
        dz = floor((z_max-z_min)/edgeLength)+1;
        
        x_offset = abs(x_min);
        y_offset = abs(y_min);
        z_offset = abs(z_min);
        
        offset = [x_offset y_offset z_offset];
        
        voxelMap = uint16(zeros(dx, dy, dz));
        
        % TCP
        voxelMap = mapVoxelBit(voxelMap, edgeLength, TCP, offset, 1, 1);

        % D
        voxelMap = mapVoxelBit(voxelMap, edgeLength, D, offset, 2, 1);
        
        % E
        voxelMap = mapVoxelBit(voxelMap, edgeLength, E, offset, 3, 1);
        
        % F
        voxelMap = mapVoxelBit(voxelMap, edgeLength, F, offset, 4, 1);
        
        % G
        voxelMap = mapVoxelBit(voxelMap, edgeLength, G, offset, 5, 1);
        
        % H
        voxelMap = mapVoxelBit(voxelMap, edgeLength, H, offset, 6, 1);
        
        % I
        voxelMap = mapVoxelBit(voxelMap, edgeLength, I, offset, 7, 1);
        
        % Discretizing, getting the indeces
        A = floor((A+offset)/edgeLength) + 1;
        B = floor((B+offset)/edgeLength) + 1;
        C = floor((C+offset)/edgeLength) + 1;
        
        D = floor((D+offset)/edgeLength) + 1;
        E = floor((E+offset)/edgeLength) + 1;
        F = floor((F+offset)/edgeLength) + 1;
        
        G = floor((G+offset)/edgeLength) + 1;
        H = floor((H+offset)/edgeLength) + 1;
        I = floor((I+offset)/edgeLength) + 1;
        
        D = unique(D,'rows');
        E = unique(E,'rows');
        F = unique(F,'rows');
        
        G = unique(G,'rows');
        H = unique(H,'rows');
        I = unique(I,'rows');
        
        [voxelMap, ~] = mapLine3D_pt1Stationary_bits([A; D], 0, voxelMap, 8);        
        [voxelMap, ~] = mapLine3D_pt1Stationary_bits([B; E], 0, voxelMap, 9);        
        [voxelMap, ~] = mapLine3D_pt1Stationary_bits([C; F], 0, voxelMap, 10);
        [voxelMap, ~] = mapLine3D_2Lines_bits(D, G, voxelMap, 11); 
        [voxelMap, ~] = mapLine3D_2Lines_bits(E, H, voxelMap, 12);
        [voxelMap, ~] = mapLine3D_2Lines_bits(F, I, voxelMap, 13);
        
        voxelMap(A(1), A(2), A(3)) = bitset(voxelMap(A(1), A(2), A(3)), 14);
        voxelMap(B(1), B(2), B(3)) = bitset(voxelMap(B(1), B(2), B(3)), 15);
        voxelMap(C(1), C(2), C(3)) = bitset(voxelMap(C(1), C(2), C(3)), 16);
   
        outData = struct('Voxels', voxelMap, 'grid', struct('x', WS_x, 'y', WS_y, 'z', WS_z));
        
end

