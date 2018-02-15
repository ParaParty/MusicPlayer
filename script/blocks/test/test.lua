function main(entity)
	local ParaLib = blocks.getscript(19200,1,19200).ParaLib;
	ParaLib:CreateSBlock(entity:GetBlockPos()):SimpleMoveRelative(0,1,0);
end


