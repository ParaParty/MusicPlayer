--公共变量存储位置：19200,5,19200
IgnoreId = {0,212};
function main(entity)
	local globalData = blocks.getscript(19200,5,19200,true);
	bx,by,bz = entity:GetBlockPos();
	if(BlockEngine:GetBlockData(bx, by + 1, bz) == 5) then
	--如果拉杆是关闭状态
	cmd("/tip -notice -color #cccc00 音乐已暂停");
	return
	end
	--获取开始位置
	local beginX;
	if(globalData.lineIndex > 1) then
		beginX = globalData.lineIndex + globalData.beginPositionX;
	else
		globalData.lineIndex = 1;
		beginX = globalData.lineIndex + globalData.beginPositionX - 1;
	end
	local beginY = globalData.beginPositionY;
	local beginZ = globalData.beginPositionZ;

	--扫描
	for Z = globalData.mapWidth, 1, -1 do
		--检查是否在忽略列表内
		local Id = BlockEngine:GetBlockId(beginX,beginY,Z + beginZ - 1);
		local ignore = false;
		for k,value in ipairs(IgnoreId) do
			if Id == value then ignore = true; end
		end
		if not ignore then
		--没有忽略掉的话，放音乐
		--midi偏移量：67
		--因为是从右往左扫描，所以应该是(129-z)+67=196-z
		cmd("/midi "..(196 - Z));
		Light(129 - Z);
		end
		cmd(string.format("/setblock %i %i %i 6", beginX, beginY + 1, beginZ));
		cmd(string.format("/t 0.01/setblock %i %i %i 0", beginX, beginY + 1, beginZ));
	end
	cmd("/tip -debug It is working at "..globalData.lineIndex..".");
	globalData.lineIndex  = globalData.lineIndex + 1;
	--创建自循环
	entity:SetFrameMoveInterval(1/15);
	cmd("/t 0.01/activate",nil,entity);
end

--亮灯
--note：音高
function Light(note)
	local x,y,z = NoteToLightPosition(note);
	cmd("/setblock "..x.." "..y.." "..z.." 6");
	cmd("/t 0.1/setblock "..x.." "..y.." "..z.." 0");
	echo("x:"..x.."y:"..y.."z:"..z);
end

--[硬编码]根据音符获取相应的灯的位置
function NoteToLightPosition(note)
	local beginX = 19198;
	local beginY = 6;
	local beginZ = 19200;
	return beginX, beginY, beginZ - note + 128
end