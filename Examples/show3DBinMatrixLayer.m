function fighandle = show3DBinMatrixLayer(binMatrix3d, layerNo, useGrid, faceAlpha, edgeAlpha, color)

	voxelData = binMatrix3d.VoxelData;
	
	if useGrid = 1
		gridx = binMatrix3d.grid.x;
		gridy = binMatrix3d.grid.y;
		gridz = binMatrix3d.grid.z;
	
		PATCH_3Darray(faceAlpha, edgeAlpha, voxelData(:,:,layerNo), gridx, gridy, gridz, color);
	
	else
	
		PATCH_3Darray(faceAlpha, edgeAlpha, voxelData(:,:,layerNo), color);
		
	end
	

end