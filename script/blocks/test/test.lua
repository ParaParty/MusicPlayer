function main(entity)
	--[[x,y,z = entity:GetBlockPos();
	echo("ID:"..BlockEngine:GetBlockId(x,y + 1,z));
	tb = BlockEngine:GetBlockEntityData(x,y + 1,z);
	BlockEngine:SetBlock(x,y+2,z,BlockEngine:GetBlockId(x,y+1,z));
	BlockEngine:SetBlockData(x,y+2,z,tb);
	--[[for k,value in ipairs(tb) do
		echo("   "..k..": "..value);
	end]]
	--[[for k = 1, table.maxn(tb) do
		echo("  "..k..": "..tb[k][1]);
	end]]
	--echo("inventory: "..tb.inventory);
	
end





