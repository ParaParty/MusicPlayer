function main(msg)
	local globalData = blocks.getscript(19200,5,19200,true);
	globalData.beginPositionX = 19200;
	globalData.beginPositionY = 5;
	globalData.beginPositionZ = 19200;
	globalData.mapWidth = 128;
	globalData.lineIndex = 1;
	cmd("/tip -notice");
	cmd("/tip -debug");
	cmd("/tip -notice -color #0000ff 初始化完毕！");
end





