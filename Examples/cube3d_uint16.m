% 3d cube in uint16 map

clear; clc;

% grids:
gridx = -4:4;
gridy = -4:4;
gridz = -4:4;

map = uint16(zeros(9,9,9));

cube = uint16(ones(5,5,5));

for x = 2:size(map,1)-1
    for y = 2:size(map,2)-1
        for z = 2:size(map,3)-1
            
            map(x,y,z) = bitset(map(x,y,z),1);
            
        end
    end
end

map(2,2,2)=0;
map(3,3,3) = 0;
map(3,3,4) = 0;
map(3,4,4) = 0;
map(4,4,4) = 0;
% map(5,5,5) = 0;
% map(5,5,6) = 0;
% map(5,6,6) = 0;
% map(6,6,6) = 0;


WSProps = regionprops3(bitget(map,1)==1, 'all');

convAlpha = alphaShape(cell2mat(WSProps.ConvexHull));
convAlpha.plot
figure(2)
alpha = alphaShape(cell2mat(WSProps.VoxelList));
alpha.plot







