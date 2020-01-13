function [outVoxelMap, pts] = mapLine3D_bits(vecPts, VoxelMap, setBit)

    outVoxelMap = 0;
    pts = 0;

    if size(vecPts,1) > 1
        for i = size(vecPts,1)-1:-1:1
            line(i) = struct('x', [], 'y', [], 'z', []);
            [line(i).x, line(i).y, line(i).z] = bresenham_line3d(vecPts(i,:), vecPts(i+1, :));
        end

        x = extractfield(line, 'x');
        y = extractfield(line, 'y');
        z = extractfield(line, 'z');
        pts = unique([x; y; z]', 'rows');
        
        pts(pts(:,3) == [0 0 0]) = [];
        
        outVoxelMap = VoxelMap;

        for i = 1:size(pts,1)
            outVoxelMap(pts(i,1), pts(i,2), pts(i,3)) = bitset(outVoxelMap(pts(i,1), pts(i,2), pts(i,3)), setBit);
        end
    
    end
end