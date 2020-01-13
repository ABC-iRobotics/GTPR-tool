function [outVoxelMap, pts] = mapLine3D_2Lines_bits(vecPts1, vecPts2, VoxelMap, setBit)

    outVoxelMap = 0;
    pts = 0;
    ctr = 1;
    
    if size(vecPts1,1) > 1 && size(vecPts2,1) > 1
        for i = size(vecPts1,1)-1:-1:1
            for j = size(vecPts2,1)-1:-1:1
                line(ctr) = struct('x', [], 'y', [], 'z', []);
                [line(ctr).x, line(ctr).y, line(ctr).z] = bresenham_line3d(vecPts1(i,:), vecPts2(j, :));
                ctr = ctr + 1;
            end
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