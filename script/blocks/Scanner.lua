--公共变量存储位置：19200,5,19200
--以+X为正方向
IgnoreId = {0,212};
Lights = {};
LightColumns = {};
LightColumnHeight = 3;

function main(entity)
	local globalData = blocks.getscript(19200,5,19200,true);
	bx,by,bz = entity:GetBlockPos();
	if(BlockEngine:GetBlockData(bx, by + 1, bz) == 5) then
	--如果拉杆是关闭状态
	cmd("/tip -notice -color #cccc00 音乐已暂停");
	ClearLights();
	return
	end
	--删去上一帧的
	ClearLastLights();
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
	entity:SetFrameMoveInterval(1/globalData.fps);
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
		--谱子上的音符亮灯
		--AddLightColumn(beginX,beginY + 1,Z + beginZ - 1);	
		end

		--进度条亮灯
		AddLight(beginX,beginY + 1,beginZ);
	end
	return 0;
end

--添加新的灯
function AddLight(x,y,z)
	table.insert(Lights,1,{x,y,z});
end	
--添加新的下落灯柱
function AddLightColumn(x,y,z)
	table.insert(LightColumns,1,{x,y,z});
end
--应用所有的灯
function ApplyLights()
	for k, position in ipairs(Lights) do
		BlockEngine:SetBlock(position[1],position[2],position[3],6,1,1);
	end
	for k, position in ipairs(LightColumns) do
		for k2, position2 in ipairs(GetBlockPositions(position[1], position[2], position[3], 0, LightColumnHeight - 1, 0)) do
			BlockEngine:SetBlock(position2[1], position2[2], position2[3], 6, 1, 0);
		end
	end	
end
--删去所有的灯
function ClearLights()
	for k,position in ipairs(Lights) do
		BlockEngine:SetBlock(position[1],position[2],position[3],0,1,1);
	end
	Lights = {};
	for k,position in ipairs(LightColumns) do
		for k2, position in ipairs(GetBlockPositions(position[1], position[2], position[3], 0, LightColumnHeight - 1, 0)) do
			BlockEngine:SetBlock(position[1], position[2], position[3], 0, 1, 0);
		end
	end
	LightColumns = {};
end

--删去上一帧的灯
function ClearLastLights()
	--删去普通的灯
	for k,position in ipairs(Lights) do
		BlockEngine:SetBlock(position[1], position[2], position[3], 0, 1, 0);
	end
	Lights = {};
	for k,cposition in ipairs(LightColumns) do
		--删掉底部的
		BlockEngine:SetBlock(cposition[1], cposition[2], cposition[3], 0, 1, 0);
		--位移一格
		cmd("/translate "..cposition[1].." "..(cposition[2] + 1).." "..cposition[3]..
		"(0 "..(LightColumnHeight - 2).." 0) to 0 -1 0");
		echo("/translate "..cposition[1].." "..(cposition[2] + 1).." "..cposition[3]..
		"(0 "..(LightColumnHeight - 2).." 0) to 0 -1 0");
	end
	local i = 1;
	--移除空灯柱
	while i <= table.maxn(LightColumns) do
		if BlockEngine:GetBlockId(LightColumns[i][1], LightColumns[i][2], LightColumns[i][3]) == 0 then
			--如果是空气
			--移除一个元素
			table.remove(LightColumns,i);
			i = i - 1;
		end
		i = i + 1;
	end
end

--在琴键上亮灯
--note：音高
function PianoLight(note)
	local x,y,z = NoteToPianoLightPosition(note);
	--AddLightColumn(x,y,z);
	AddLight(x,y,z);
end
--[硬编码]根据音符获取相应的灯的位置
function NoteToPianoLightPosition(note)
	local beginX = 19198;
	local beginY = 6;
	local beginZ = 19200;
	return beginX, beginY, beginZ - note + 128
end

function GetBlockPositions(x,y,z,rx,ry,rz)
	result = {};
	for i = x, x + rx do
		for j = y, y + ry do
			for k = z, z + rz do 
				table.insert(result,1,{i,j,k});
			end	
		end
	end
	return result;
end