--公共变量存储位置：19200,5,19200
IgnoreId = {0,212};
Lights = {};
function main(entity)
	local globalData = blocks.getscript(19200,5,19200,true);
	bx,by,bz = entity:GetBlockPos();
	if(BlockEngine:GetBlockData(bx, by + 1, bz) == 5) then
	--如果拉杆是关闭状态
	cmd("/tip -notice -color #cccc00 音乐已暂停");
	return
	end
	--关灯
	ClearLights();
	--获取开始位置
	local beginX;
	if(globalData.lineIndex > 1) then
		beginX = globalData.lineIndex + globalData.beginPositionX;
	else
		globalData.lineIndex = 1;
		beginX = globalData.lineIndex + globalData.beginPositionX - 1;
	end

	--扫描
	ScanLine(beginX,globalData.beginPositionY,globalData.beginPositionZ,globalData.mapWidth);
	ApplyLights();
	cmd("/tip -debug It is working at "..globalData.lineIndex..".");
	globalData.lineIndex  = globalData.lineIndex + 1;
	--创建自循环
	entity:SetFrameMoveInterval(1/15);
	cmd("/t 0.01/activate",nil,entity);
end

function ScanLine(beginX,beginY,beginZ,mapWidth)
	for Z = mapWidth, 1, -1 do
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
		PianoLight(129 - Z);
		end
		AddLight(beginX,beginY + 1,beginZ);
	end
	return 0;
end

--添加新的灯
function AddLight(x,y,z)
	table.insert(Lights,1,{x,y,z});
end	
--应用所有的灯
function ApplyLights()
	for k,position in ipairs(Lights) do
		BlockEngine:SetBlock(position[1],position[2],position[3],6,1,0);
	end
end
--删去所有的灯
function ClearLights()
	for k,position in ipairs(Lights) do
		BlockEngine:SetBlock(position[1],position[2],position[3],0,1,0);
	end
	Lights = {};
end

--在琴键上亮灯
--note：音高
function PianoLight(note)
	local x,y,z = NoteToLightPosition(note);
	AddLight(x,y,z);
end
--[硬编码]根据音符获取相应的灯的位置
function NoteToPianoLightPosition(note)
	local beginX = 19198;
	local beginY = 6;
	local beginZ = 19200;
	return beginX, beginY, beginZ - note + 128
end