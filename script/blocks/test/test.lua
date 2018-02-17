function main(entity)
	local ParaLib = blocks.getscript(19200,1,19200).ParaLib;
	--ParaLib:CreateSBlock(entity:GetBlockPos()):SimpleMoveRelative(0,1,0);
	x, y, z = entity:GetBlockPos();
	ParaLib:Translate(x, y + 1, z,
					0, 1, 0,
					0, 1, 0);
end


