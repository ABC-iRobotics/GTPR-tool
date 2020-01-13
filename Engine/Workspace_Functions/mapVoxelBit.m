function voxelMapOut = mapVoxelBit(voxelMapIn, voxelSize, points, offsets, bit2Write, value2Write)
    % Maps a non-discrete point to a discretized voxel map
    voxelMapOut = voxelMapIn;
    pts = floor((points+offsets)/voxelSize) + 1;

    for i = 1:length(points)
           voxelMapOut(pts(i,1), pts(i,2), pts(i,3)) = bitset(voxelMapIn(pts(i,1), pts(i,2), pts(i,3)), bit2Write, value2Write);
    end

end
