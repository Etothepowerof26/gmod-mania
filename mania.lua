--beatmap
surface.CreateFont( "BudgetLabel30", {
	font = "BudgetLabel",
	size = 30
} )
mania = mania or {}
k1,k2,k3,k4 = {},{},{},{}
curroffset = 0
mania.add = 100/6
mania.scoreperkey = 0
mania.currentstats = {
	score = 0,
	good = 0,
	meh = 0,
	bad = 0,
	miss = 0
}
mania.bmkeys = {
	64, --K1  [] - - -
	192, --K2 - [] - -
	320, --K3 - - [] -
	448 --K4  - - - []
}
mania.mappedkeys = {
	"D",
	"F",
	"J",
	"K"
}
mania.ingame = false
mania.parsemap = function(map)
	local beatmap = file.Read(map, "DATA") --yea
	local metadata = {}
	beatmap = string.Explode("\r\n", beatmap)
	
	for i,v in pairs(beatmap) do
		if v == "[HitObjects]" then
			for k = 1, i do
				table.remove(beatmap, 1)	
			end
			table.remove(beatmap, #beatmap)
			
			for k,z in pairs(beatmap) do
				table.insert(metadata, string.Explode(",", z))	
			end
			
			break
		end
	end --'nother pairs loop
	
	for i,Data in pairs(metadata) do --now editing metadata
		local stats = Data --do this before overwriting metadata
		local newmeta = {}
		for KeyNum,Key in pairs(mania.bmkeys) do
			if tonumber(stats[1]) == Key then
				newmeta["Key"] = KeyNum
			end
		end
		newmeta["Offset"] = tonumber(stats[3])
		
		metadata[i] = newmeta
	end
	return metadata
end
mania.autoplay = function()
	hook.Add("Think", "key1auto", function()
		if #k1 == 0 then
			hook.Remove("Think", "key1auto")	
		elseif -k1[1].Offset + curroffset >= 720 then
			hook.Run("ManiaKeyPress", {What = 1})
		end
	end)
	hook.Add("Think", "key2auto", function()
		if #k2 == 0 then
			hook.Remove("Think", "key2auto")	
		elseif -k2[1].Offset + curroffset >= 720 then
			hook.Run("ManiaKeyPress", {What = 2})
		end
	end)
	hook.Add("Think", "key3auto", function()
		if #k3 == 0 then
			hook.Remove("Think", "key3auto")	
		elseif -k3[1].Offset + curroffset >= 720 then
			hook.Run("ManiaKeyPress", {What = 3})
		end
	end)
	hook.Add("Think", "key4auto", function()
		if #k4 == 0 then
			hook.Remove("Think", "key4auto")	
		elseif -k4[1].Offset + curroffset >= 720 then
			hook.Run("ManiaKeyPress", {What = 4})
		end
	end)
end
mania.openframe = function()
	LocalPlayer():AllowFlashlight(false)
	mania.ingame = true
	mania.autoplay()
	gui.EnableScreenClicker(true)
	local debounce = {one, two, three, four}
	local frame = vgui.Create("DFrame")
	frame:SetSize(400, ScrH())
	frame:Center()
	frame:SetTitle''
	
	local sizex, sizey = frame:GetSize()--frame size
	frame.Paint = function()
		draw.RoundedBox(8, 0, 0, sizex, sizey, Color(23, 23, 23, 255))--background
		--//Outsides
		draw.RoundedBox(8, 0, 0, 95, sizey, Color(0, 127, 255, 255))
		draw.RoundedBox(8, 305, 0, 95, sizey, Color(0, 127, 255, 255))
		--//Insides
		draw.RoundedBox(8, 102, 0, 95, sizey, Color(255, 0, 127, 255))
		draw.RoundedBox(8, 205, 0, 95, sizey, Color(255, 0, 127, 255))
		--//Keys
		draw.RoundedBox(8, 0, sizey - 200, 95, 200, Color(127, 127, 127, 255)) --1
		draw.RoundedBox(8, 102, sizey - 200, 95, 200, Color(127, 127, 127, 255)) --2
		draw.RoundedBox(8, 205, sizey - 200, 95, 200, Color(127, 127, 127, 255)) --3
		draw.RoundedBox(8, 305, sizey - 200, 95, 200, Color(127, 127, 127, 255)) --4
		--//Key presses
		if debounce.one == true then
			draw.RoundedBox(8, 0, sizey - 200, 95, 200, Color(0, 255, 255, 255)) end
		if debounce.two == true then
			draw.RoundedBox(8, 102, sizey - 200, 95, 200, Color(0, 255, 255, 255)) end
		if debounce.three == true then
			draw.RoundedBox(8, 205, sizey - 200, 95, 200, Color(0, 255, 255, 255)) end
		if debounce.four == true then
			draw.RoundedBox(8, 305, sizey - 200, 95, 200, Color(0, 255, 255, 255)) end
		--//Notes
		for i,v in pairs(k1) do
			if -v.Offset + curroffset <= 800 then
				draw.RoundedBox(8, 0, -v.Offset + curroffset, 95, 50, Color(255, 255, 255, 255))
			else
				table.remove(k1, 1)
				mania.currentstats.miss = mania.currentstats.miss + 1 end end
		for i,v in pairs(k2) do
			if -v.Offset + curroffset <= 800 then
				draw.RoundedBox(8, 102, -v.Offset + curroffset, 95, 50, Color(255, 255, 255, 255))
			else
				table.remove(k2, 1)
				mania.currentstats.miss = mania.currentstats.miss + 1 end end
		for i,v in pairs(k3) do
			if -v.Offset + curroffset <= 800 then
				draw.RoundedBox(8, 205, -v.Offset + curroffset, 95, 50, Color(255, 255, 255, 255))
			else
				table.remove(k3, 1)
				mania.currentstats.miss = mania.currentstats.miss + 1 end end
		for i,v in pairs(k4) do
			if -v.Offset + curroffset <= 800 then
				draw.RoundedBox(8, 305, -v.Offset + curroffset, 95, 50, Color(255, 255, 255, 255))
			else
				table.remove(k4, 1)
				mania.currentstats.miss = mania.currentstats.miss + 1 end end
	end
	frame.Close = function()
		gui.EnableScreenClicker(false)
		hook.Remove("Think", "K")
		hook.Remove("ManiaKeyPress", "K")
		LocalPlayer():AllowFlashlight(true)
		timer.Remove("offs")
		curroffset = 0
		k1,k2,k3,k4 = {},{},{},{}
		mania.currentstats = {score = 0,good = 0,meh = 0,bad = 0,miss = 0}
		frame:Hide()
	end
	
	hook.Add("ManiaKeyPress", "K", function(What)
		
		if What.What == 1 and debounce.one == false then
			debounce.one = true
			surface.PlaySound("garrysmod/balloon_pop_cute.wav")
			if -k1[1].Offset + curroffset >= 720 then
				mania.currentstats.score = mania.currentstats.score + mania.scoreperkey;
				mania.currentstats.good = mania.currentstats.good + 1
				table.remove(k1, 1)
			elseif -k1[1].Offset + curroffset >= 710 then
				mania.currentstats.score = mania.currentstats.score + (mania.scoreperkey * .75);
				mania.currentstats.meh = mania.currentstats.meh + 1
				table.remove(k1, 1)
			elseif -k1[1].Offset + curroffset >= 705 then
				mania.currentstats.score = mania.currentstats.score + (mania.scoreperkey / 2);
				mania.currentstats.bad = mania.currentstats.bad + 1
				table.remove(k1, 1)
			elseif -k1[1].Offset + curroffset >= 700 then
				mania.currentstats.miss = mania.currentstats.miss + 1
				table.remove(k1, 1)
			end
		elseif What.What == 2 and debounce.two == false then
			debounce.two = true
			surface.PlaySound("garrysmod/balloon_pop_cute.wav")
			if -k2[1].Offset + curroffset >= 720 then
				mania.currentstats.score = mania.currentstats.score + mania.scoreperkey;
				mania.currentstats.good = mania.currentstats.good + 1
				table.remove(k2, 1)
			elseif -k2[1].Offset + curroffset >= 710 then
				mania.currentstats.score = mania.currentstats.score + (mania.scoreperkey * .75);
				mania.currentstats.meh = mania.currentstats.meh + 1
				table.remove(k2, 1)
			elseif -k2[1].Offset + curroffset >= 705 then
				mania.currentstats.score = mania.currentstats.score + (mania.scoreperkey / 2);
				mania.currentstats.bad = mania.currentstats.bad + 1
				table.remove(k2, 1)
			elseif -k2[1].Offset + curroffset >= 700 then
				mania.currentstats.miss = mania.currentstats.miss + 1
				table.remove(k2, 1)
			end
		elseif What.What == 3 and debounce.three == false then
			debounce.three = true
			surface.PlaySound("garrysmod/balloon_pop_cute.wav")
			if -k3[1].Offset + curroffset >= 720 then
				mania.currentstats.score = mania.currentstats.score + mania.scoreperkey;
				mania.currentstats.good = mania.currentstats.good + 1
				table.remove(k3, 1)
			elseif -k3[1].Offset + curroffset >= 710 then
				mania.currentstats.score = mania.currentstats.score + (mania.scoreperkey * .75);
				mania.currentstats.meh = mania.currentstats.meh + 1
				table.remove(k3, 1)
			elseif -k3[1].Offset + curroffset >= 705 then
				mania.currentstats.score = mania.currentstats.score + (mania.scoreperkey / 2);
				mania.currentstats.bad = mania.currentstats.bad + 1
				table.remove(k3, 1)
			elseif -k3[1].Offset + curroffset >= 700 then
				mania.currentstats.miss = mania.currentstats.miss + 1
				table.remove(k3, 1)
			end
		elseif What.What == 4 and debounce.four == false then
			debounce.four = true
			surface.PlaySound("garrysmod/balloon_pop_cute.wav")
			if -k4[1].Offset + curroffset >= 720 then
				mania.currentstats.score = mania.currentstats.score + mania.scoreperkey;
				mania.currentstats.good = mania.currentstats.good + 1
				table.remove(k4, 1)
			elseif -k4[1].Offset + curroffset >= 710 then
				mania.currentstats.score = mania.currentstats.score + (mania.scoreperkey * .75);
				mania.currentstats.meh = mania.currentstats.meh + 1
				table.remove(k4, 1)
			elseif -k4[1].Offset + curroffset >= 705 then
				mania.currentstats.score = mania.currentstats.score + (mania.scoreperkey / 2);
				mania.currentstats.bad = mania.currentstats.bad + 1
				table.remove(k4, 1)
			elseif -k4[1].Offset + curroffset >= 700 then
				mania.currentstats.miss = mania.currentstats.miss + 1
				table.remove(k4, 1)
			end
		end
	end)
	
	hook.Add("Think", "K", function()
		if input.IsKeyDown(KEY_D) then hook.Run("ManiaKeyPress", {What = 1}) debounce.one = true
		else debounce.one = false end
		if input.IsKeyDown(KEY_F) then hook.Run("ManiaKeyPress", {What = 2}) debounce.two = true
		else debounce.two = false end
		if input.IsKeyDown(KEY_J) then hook.Run("ManiaKeyPress", {What = 3}) debounce.three = true
		else debounce.three = false end
		if input.IsKeyDown(KEY_K) then hook.Run("ManiaKeyPress", {What = 4}) debounce.four = true
		else debounce.four = false end
	end)
end
mania.startmap = function(map)
	if mania.ingame == true then
		--parse map into 4 tables
		local play = mania.parsemap(map)
		mania.scoreperkey = 1000000/#play
		
		for i,v in pairs(play) do
			if v.Key == 1 then
				table.insert(k1, v)
			elseif v.Key == 2 then
				table.insert(k2, v)
			elseif v.Key == 3 then
				table.insert(k3, v)
			elseif v.Key ==4 then
				table.insert(k4, v)
			end
		end
	
		timer.Create("offs", 0, 0, function()
			curroffset = curroffset + mania.add
			if curroffset >= play[#play].Offset then
				timer.Remove("offs")	
			end
		end)
	else
		return "You arent in a game!"
	end
end
