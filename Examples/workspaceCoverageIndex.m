function wci = workspaceCoverageIndex(Data)
% Returns the workspace coverage index in [%]
% The TCP is assumed to be in bit position 1
% Get the TCP Positions

    VoxelData = Data.VoxelData;
    
    % Current volume of workspace
%     WSProps = regionprops3(bitget(VoxelData,1), 'all');

    % Full volume of workspace
    
%     WSProps = regionprops3((bitget(VoxelData,1)==1), 'Volume', 'ConvexVolume');

    id = find(bitget(VoxelData,1)==1);
    
    vol = length(id);
    
    [idx, idy, idz] = ind2sub(size(VoxelData), id);
        
    pts_alpha = alphaShape(idx,idy, idz);

    [~, vFull] = boundary(pts_alpha.Points);
    
    wci = vol/vFull;
    
    if wci > 1
        wci = 1;
    elseif wci < 0
        wci = 0;
    end
    
%     vol = sum(WSProps.Volume);
%     fvol = sum(WSProps.ConvexVolume);
%     
%     if 1
%         WSProps = regionprops3(VoxelData(bitget(VoxelData,1)==1), 'all');
%         idx = ~isnan(WSProps.Solidity);
%         a = WSProps(idx,:);
%         
%         tcpWS = bitget(VoxelData,1)==1;
%         
%         tcpWS_id = find(tcpWS==1);
%         
%         [tcpWS_idx, tcpWS_idy, tcpWS_idz] = ind2sub(size(tcpWS), tcpWS_id);
%         
%         pts_alpha = alphaShape(tcpWS_idx,tcpWS_idy, tcpWS_idz);
%         
%         [k, v] = boundary(pts_alpha.Points);
%         
%         
%         
%         volumeViewer(invert3DBinMatrix(VoxelData))
%         
%         a = isosurface(bitget(VoxelData,1)==1,0);
%         b = alphaShape(a.vertices);
%         vb = b.volume
%         
%     end
    
%     wci = (vol/fvol);
    
end