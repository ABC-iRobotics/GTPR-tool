function outdata = invert3DBinMatrix(binMatrix3D)

	idx_1 = find(bitget(binMatrix3D,1)==1);

	outdata = zeros(size(binMatrix3D));
	
	outdata(idx_1) = bitset(outdata(idx_1),1,1);

end