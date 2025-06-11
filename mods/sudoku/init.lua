local hud_levels = {}

minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    player:hud_add({
		hud_elem_type = "text",
		position = {x=0, y=0.85},
		offset = {x=0, y=10},
		alignment = {x=1, y=0},
		number = 0xFFFFFF ,
		text = "For Minetest 	  :  5.7.0",
	})
	player:hud_add({
		hud_elem_type = "text",
		position = {x=0, y=0.85},
		offset = {x=0, y=30},
		alignment = {x=1, y=0},
		number = 0xFFFFFF ,
		text = "Game Version	 :  1.11.0",
	})
    hud_levels[name] = player:hud_add({
		hud_elem_type = "text",
		position = {x=0, y=0.85},
		offset = {x=0, y=-450},
		alignment = {x=1, y=0},
		number = 0xFFFFFF ,
		text = "Level: /",
	})
end)

local map_version = 3

local caps = {times = {42, 42, 42}, uses = 0, maxlevel = 256}
minetest.register_alias("mapgen_stone", "sudoku:wall")
minetest.register_alias("mapgen_water_source", "sudoku:wall")
minetest.register_alias("mapgen_river_water_source", "sudoku:wall")

minetest.register_item(":", {
	type = "none",
	wield_image = "wieldhand.png",
	wield_scale = {x = 1, y = 1, z = 2.5},
	range = 15,
	tool_capabilities = {
		full_punch_interval = 0.5,
		max_drop_level = 3,
		groupcaps = {
			crumbly = caps,
			cracky  = caps,
			snappy  = caps,
			choppy  = caps,
			oddly_breakable_by_hand = caps,
		},
		damage_groups = {fleshy = 1},
	}
})

local main = {}
main.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local formspec = "size[9,10.3]"
        .."background[9,10.3;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."label[0,0;Here you can get some basic informations about my game: Sudoku]"
        .."label[0,0.6;Thanks to:]"
		.."label[0,0.9;jumali for testing and making some sudokus]"
		.."label[0,1.8;more informations comming soon]"
	return formspec		
end

minetest.register_on_joinplayer(function(player)
    player:set_inventory_formspec("")
	if not minetest.is_singleplayer() then
        minetest.kick_player(player:get_player_name(), "You can play Sudoku only in singleplayer")
    end
    local formspec = [[
			bgcolor[#080808BB;true]
			listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF] ]]
	local name = player:get_player_name()
	local info = minetest.get_player_information(name)
	if info.formspec_version > 1 then
		formspec = formspec .. "background9[5,5;1,1;gui_formbg.png;true;10]"
	else
		formspec = formspec .. "background[5,5;1,1;gui_formbg.png;true]"
	end
	player:set_formspec_prepend(formspec)
    player:set_inventory_formspec("")
end)

minetest.register_globalstep(function(dtime)
    local players = minetest.get_connected_players()
    for _,player in ipairs(players) do
        local player_inv = player:get_inventory()
        player_inv:set_size("ll", 1)
        player_inv:set_size("l", 4)
        local ll = player_inv:get_stack("ll", 1):get_count()
        local l = player_inv:get_stack("l", ll):get_count()
        if ll == 0 then
        else
            player:hud_change(hud_levels[player:get_player_name()], 'text', "Level: World "..ll.."."..l)
        end
		player:hud_set_hotbar_image("sudoku_gui_hotbar.png")
		player:hud_set_hotbar_selected_image("gui_hotbar_selected.png")
		player:set_inventory_formspec(main.get_formspec(player))
		SetItems(player)
    end
end)
local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= 1 then
		timer = 0
		minetest.set_timeofday(0.5)
    end
end)

function file_check(file_name)
	local file_found=io.open(file_name, "r")
	if file_found==nil then
		file_found=false
	else
		file_found=true
	end
	return file_found
end
minetest.register_on_joinplayer(function(player)
	local player_inv = player:get_inventory()
    player:hud_set_hotbar_itemcount(9)
	if file_check(minetest.get_worldpath().."/level1.txt") == true then
	else
		local file = io.open(minetest.get_worldpath().."/level1.txt", "w")
		file:write("1")
		file:close()
	end
    if file_check(minetest.get_worldpath().."/level2.txt") == true then
	else
		local file = io.open(minetest.get_worldpath().."/level2.txt", "w")
		file:write("1")
		file:close()
	end
    if file_check(minetest.get_worldpath().."/level3.txt") == true then
	else
		local file = io.open(minetest.get_worldpath().."/level3.txt", "w")
		file:write("1")
		file:close()
	end
    if file_check(minetest.get_worldpath().."/level4.txt") == true then
	else
		local file = io.open(minetest.get_worldpath().."/level4.txt", "w")
		file:write("1")
		file:close()
	end
	if file_check(minetest.get_worldpath().."/level5.txt") == true then
	else
		local file = io.open(minetest.get_worldpath().."/level5.txt", "w")
		file:write("1")
		file:close()
	end
	if file_check(minetest.get_worldpath().."/Map_Version.txt") ~= true  then
		minetest.place_schematic({ x = 9, y = 7, z = -93 }, minetest.get_modpath("sudoku").."/schematics/sector1.mts","0")
		player:set_pos({x=19, y=8, z=-88})
		for j=1,9 do
			local ll = player_inv:get_stack("ll", 1):get_count()
			player_inv:set_stack("main", j, "")
		end
		local file = io.open(minetest.get_worldpath().."/Map_Version.txt", "w")
		file:write(map_version)
		file:close()
	end
	local file = io.open(minetest.get_worldpath().."/Map_Version.txt", "r")
	local map_ver = file:read("*l")
    file:close()
	if tonumber(map_ver) < map_version then
		minetest.place_schematic({ x = 9, y = 7, z = -93 }, minetest.get_modpath("sudoku").."/schematics/sector1.mts","0")
		player:set_pos({x=19, y=8, z=-88})
		local player_inv = player:get_inventory()
		for j=1,9 do
			local ll = player_inv:get_stack("ll", 1):get_count()
			player_inv:set_stack("main", j, "")
		end
		player_inv:set_stack("ll", 1, "")
		local file = io.open(minetest.get_worldpath().."/Map_Version.txt", "w")
		file:write(map_version)
		file:close()
	end
end)
minetest.register_on_newplayer(function(player)
    local player = minetest.get_player_by_name(player:get_player_name())
    local pri = minetest.get_player_privs(player:get_player_name())
    pri["fly"] = true
	pri["fast"] = true
    minetest.set_player_privs(player:get_player_name(), pri)
end)

minetest.register_on_player_hpchange(function(player, hp_change)
	hp_change = 0
	return hp_change
end, true)

minetest.register_node("sudoku:desert",{
	description = "Desert",
	tiles = {"default_desert_sand.png"},
    --groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
})
minetest.register_node("sudoku:black",{
	description = "Black",
	tiles = {"wool_black.png"},
    --groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
})
minetest.register_node("sudoku:gray",{
	description = "Gray",
	tiles = {"default_sand.png"},
    --groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
})
minetest.register_node("sudoku:wall",{
	description = "Wall",
	tiles = {"default_mossycobble.png"},
    --groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
})
minetest.register_node("sudoku:meselamp", {
	description = "Mese Lamp",
	drawtype = "glasslike",
	tiles = {"sudoku_meselamp.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	--groups = {cracky = 3, oddly_breakable_by_hand = 3},
	light_source = 14,
})
for i=0,9 do
    minetest.register_node("sudoku:"..i,{
	    description = ""..i,
	    tiles = {"sudoku_1_"..i..".png^sudoku_outline.png"},
        --groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
    })
	
end
for i=1,9 do
	minetest.register_node("sudoku:n_"..i,{
	    description = ""..i,
	    tiles = {"sudoku_2_"..i..".png^sudoku_outline.png"},
        groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
		on_dig = function(pos, node, digger)
			minetest.add_node(pos, {name="sudoku:0"})
		end,
    })
	minetest.register_craftitem("sudoku:i_"..i, {
		description = ""..i,
		inventory_image = "sudoku_2_"..i..".png",
		on_place = function(itemstack, placer, pointed_thing) 
			local nodes = minetest.get_node(pointed_thing.under)
			local name = nodes.name
			if name == "sudoku:0" and Place(placer,i,pointed_thing.under) then
				minetest.add_node(pointed_thing.under, {name="sudoku:n_"..i})
			end
			
			Finisch(placer,0,pointed_thing.under)
		end,
	})
end


function New(player,page)
    local player_inv = player:get_inventory()
    player_inv:set_list("main", nil)
    player_inv:set_size("main", 32)
    local lv = io.open(minetest.get_worldpath().."/level1.txt", "r")
	local level = lv:read("*l")
    lv:close()
    local lv = io.open(minetest.get_modpath("sudoku").."/lv"..page..".txt", "r")
    local ar1 = {}
    local ar2 = {}
    minetest.set_node({x=20, y=7, z=-85}, {name="sudoku:desert"})
    for i=1,9 do
	    ar1[i] = lv:read("*l")
    end
    for i=10,28 do
        for k=9,27 do
            minetest.set_node({x=i, y=k, z=-76}, {name="air"})
        end
    end
	for i=10,13 do
        for k=9,27 do
            minetest.set_node({x=i, y=k, z=-76}, {name="sudoku:wall"})
        end
    end
	for i=25,28 do
        for k=9,27 do
            minetest.set_node({x=i, y=k, z=-76}, {name="sudoku:wall"})
        end
    end
	for i=10,28 do
        for k=18,27 do
            minetest.set_node({x=i, y=k, z=-76}, {name="sudoku:wall"})
        end
    end
    local a1 = 0
    local a2 = 0
    local a3 = 0
    local a4 = 0
    local a5 = 0
    local a6 = 0
    local a7 = 0
    local a8 = 0
    local a9 = 0
    for j = 1, 9 do
        for i = 1, string.len(ar1[j]) do
            local k = 0
            if i < 4 then
                k = i
            elseif i < 7 then
                k = i+1
            else
                k = i+2
            end
            local l = 0
            if j < 4 then
                l = j
            elseif j < 7 then
                l = j+1
            else
                l = j+2
            end
            if string.sub(ar1[j], i, i) == "0" then
                minetest.set_node({x=k+13, y=(12-l)+8, z=-76}, {name="sudoku:0"})
            elseif string.sub(ar1[j], i, i) == "1" then
                minetest.set_node({x=k+13, y=(12-l)+8, z=-76}, {name="sudoku:1"})
                a1 = a1+1
            elseif string.sub(ar1[j], i, i) == "2" then
                minetest.set_node({x=k+13, y=(12-l)+8, z=-76}, {name="sudoku:2"})
                a2 = a2+1
            elseif string.sub(ar1[j], i, i) == "3" then
                minetest.set_node({x=k+13, y=(12-l)+8, z=-76}, {name="sudoku:3"})
                a3 = a3+1
            elseif string.sub(ar1[j], i, i) == "4" then
                minetest.set_node({x=k+13, y=(12-l)+8, z=-76}, {name="sudoku:4"})
                a4 = a4+1
            elseif string.sub(ar1[j], i, i) == "5" then
                minetest.set_node({x=k+13, y=(12-l)+8, z=-76}, {name="sudoku:5"})
                a5 = a5+1
            elseif string.sub(ar1[j], i, i) == "6" then
                minetest.set_node({x=k+13, y=(12-l)+8, z=-76}, {name="sudoku:6"})
                a6 = a6+1
            elseif string.sub(ar1[j], i, i) == "7" then
                minetest.set_node({x=k+13, y=(12-l)+8, z=-76}, {name="sudoku:7"})
                a7 = a7+1
            elseif string.sub(ar1[j], i, i) == "8" then
                minetest.set_node({x=k+13, y=(12-l)+8, z=-76}, {name="sudoku:8"})
                a8 = a8+1
            elseif string.sub(ar1[j], i, i) == "9" then
                minetest.set_node({x=k+13, y=(12-l)+8, z=-76}, {name="sudoku:9"})
                a9 = a9+1
            end
        end
    end
    for i = 1,11 do
        minetest.set_node({x=17, y=i+8, z=-76}, {name="sudoku:black"})
        minetest.set_node({x=21, y=i+8, z=-76}, {name="sudoku:black"})
        minetest.set_node({x=13+i, y=12, z=-76}, {name="sudoku:black"})
        minetest.set_node({x=13+i, y=16, z=-76}, {name="sudoku:black"})
    end
    SetItems(player)
end
function Fi(i,k,number,pos)
    local temp = ""
    if minetest.get_node({x=i, y=k, z=-76}).name == "sudoku:1" or minetest.get_node({x=i, y=k, z=-76}).name == "sudoku:n_1" then
        temp = "1"
    elseif minetest.get_node({x=i, y=k, z=-76}).name == "sudoku:2" or minetest.get_node({x=i, y=k, z=-76}).name == "sudoku:n_2" then
        temp = "2"
    elseif minetest.get_node({x=i, y=k, z=-76}).name == "sudoku:3" or minetest.get_node({x=i, y=k, z=-76}).name == "sudoku:n_3" then
        temp = "3"
    elseif minetest.get_node({x=i, y=k, z=-76}).name == "sudoku:4" or minetest.get_node({x=i, y=k, z=-76}).name == "sudoku:n_4" then
        temp = "4"
    elseif minetest.get_node({x=i, y=k, z=-76}).name == "sudoku:5" or minetest.get_node({x=i, y=k, z=-76}).name == "sudoku:n_5" then
        temp = "5"
    elseif minetest.get_node({x=i, y=k, z=-76}).name == "sudoku:6" or minetest.get_node({x=i, y=k, z=-76}).name == "sudoku:n_6" then
        temp = "6"
    elseif minetest.get_node({x=i, y=k, z=-76}).name == "sudoku:7" or minetest.get_node({x=i, y=k, z=-76}).name == "sudoku:n_7" then
        temp = "7"
    elseif minetest.get_node({x=i, y=k, z=-76}).name == "sudoku:8" or minetest.get_node({x=i, y=k, z=-76}).name == "sudoku:n_8" then
        temp = "8"
    elseif minetest.get_node({x=i, y=k, z=-76}).name == "sudoku:9" or minetest.get_node({x=i, y=k, z=-76}).name == "sudoku:n_9" then
        temp = "9"
	elseif pos.x == i and pos.y == k then
        temp = number
    else
        temp = "0"
    end
    return temp
end
function SetItems(player)
	local n = {0,0,0,0,0,0,0,0,0}
    for i=10,28 do
        for k=9,27 do
			for j=1,9 do
				if minetest.get_node({x=i, y=k, z=-76}).name == "sudoku:"..j or minetest.get_node({x=i, y=k, z=-76}).name == "sudoku:n_"..j then
					n[j] = n[j]+1
				end
			end
        end
    end
	local player_inv = player:get_inventory()
	for j=1,9 do
		local ll = player_inv:get_stack("ll", 1):get_count()
		if ll ~= 0 then
			player_inv:set_stack("main", j, "sudoku:i_"..j.." "..(9-n[j]))
		end
	end
end
function repeats(s,c)
    local _,n = s:gsub(c,"")
    return n
end
function Place(player,number,pos)
	local dd = 0
    local ar = {}
    for i=14,24 do
        local d = 0
        local temp = ""
        for k=9,19 do
			temp = temp..Fi(i,k,number,pos)
        end
        ar[i-13] = temp
    end
    for i=1,3 do
        if repeats(ar[i],"1") < 2 and repeats(ar[i],"2") < 2 and repeats(ar[i],"3") < 2 and repeats(ar[i],"4") < 2 and repeats(ar[i],"5") < 2 and repeats(ar[i],"6") < 2 and repeats(ar[i],"7") < 2 and repeats(ar[i],"8") < 2 and repeats(ar[i],"9") < 2 then
        else
            dd = 1
        end
    end
    for i=5,7 do
        if repeats(ar[i],"1") < 2 and repeats(ar[i],"2") < 2 and repeats(ar[i],"3") < 2 and repeats(ar[i],"4") < 2 and repeats(ar[i],"5") < 2 and repeats(ar[i],"6") < 2 and repeats(ar[i],"7") < 2 and repeats(ar[i],"8") < 2 and repeats(ar[i],"9") < 2 then
        else
            dd = 1
        end
    end
    for i=9,11 do
        if repeats(ar[i],"1") < 2 and repeats(ar[i],"2") < 2 and repeats(ar[i],"3") < 2 and repeats(ar[i],"4") < 2 and repeats(ar[i],"5") < 2 and repeats(ar[i],"6") < 2 and repeats(ar[i],"7") < 2 and repeats(ar[i],"8") < 2 and repeats(ar[i],"9") < 2 then
        else
            dd = 1
        end
    end
    local ar = {}
    for k=9,19 do
        local d = 0
        local temp = ""
        for i=14,24 do
            temp = temp..Fi(i,k,number,pos)
        end
        ar[k-8] = temp
    end
    for i=1,3 do
        if repeats(ar[i],"1") < 2 and repeats(ar[i],"2") < 2 and repeats(ar[i],"3") < 2 and repeats(ar[i],"4") < 2 and repeats(ar[i],"5") < 2 and repeats(ar[i],"6") < 2 and repeats(ar[i],"7") < 2 and repeats(ar[i],"8") < 2 and repeats(ar[i],"9") < 2 then
        else
            dd = 1
        end
    end
    for i=5,7 do
        if repeats(ar[i],"1") < 2 and repeats(ar[i],"2") < 2 and repeats(ar[i],"3") < 2 and repeats(ar[i],"4") < 2 and repeats(ar[i],"5") < 2 and repeats(ar[i],"6") < 2 and repeats(ar[i],"7") < 2 and repeats(ar[i],"8") < 2 and repeats(ar[i],"9") < 2 then
        else
            dd = 1
        end
    end
    for i=9,11 do
        if repeats(ar[i],"1") < 2 and repeats(ar[i],"2") < 2 and repeats(ar[i],"3") < 2 and repeats(ar[i],"4") < 2 and repeats(ar[i],"5") < 2 and repeats(ar[i],"6") < 2 and repeats(ar[i],"7") < 2 and repeats(ar[i],"8") < 2 and repeats(ar[i],"9") < 2 then
        else
            dd = 1
        end
    end
	
    local ar = {}
    local temp = ""
    for k=9,11 do
        local d = 0
        for i=14,16 do
            temp = temp..Fi(i,k,number,pos)
        end
    end
    if repeats(temp,"1") < 2 and repeats(temp,"2") < 2 and repeats(temp,"3") < 2 and repeats(temp,"4") < 2 and repeats(temp,"5") < 2 and repeats(temp,"6") < 2 and repeats(temp,"7") < 2 and repeats(temp,"8") < 2 and repeats(temp,"9") < 2 then
    else
        dd = 1
    end
    local ar = {}
    local temp = ""
    for k=9,11 do
        local d = 0
        for i=18,20 do
            temp = temp..Fi(i,k,number,pos)
        end
    end
    if repeats(temp,"1") < 2 and repeats(temp,"2") < 2 and repeats(temp,"3") < 2 and repeats(temp,"4") < 2 and repeats(temp,"5") < 2 and repeats(temp,"6") < 2 and repeats(temp,"7") < 2 and repeats(temp,"8") < 2 and repeats(temp,"9") < 2 then
    else
        dd = 1
    end
    local ar = {}
    local temp = ""
    for k=9,11 do
        local d = 0
        for i=22,24 do
            temp = temp..Fi(i,k,number,pos)
        end
    end
    if repeats(temp,"1") < 2 and repeats(temp,"2") < 2 and repeats(temp,"3") < 2 and repeats(temp,"4") < 2 and repeats(temp,"5") < 2 and repeats(temp,"6") < 2 and repeats(temp,"7") < 2 and repeats(temp,"8") < 2 and repeats(temp,"9") < 2 then
    else
        dd = 1
    end

    local ar = {}
    local temp = ""
    for k=13,15 do
        local d = 0
        for i=14,16 do
            temp = temp..Fi(i,k,number,pos)
        end
    end
    if repeats(temp,"1") < 2 and repeats(temp,"2") < 2 and repeats(temp,"3") < 2 and repeats(temp,"4") < 2 and repeats(temp,"5") < 2 and repeats(temp,"6") < 2 and repeats(temp,"7") < 2 and repeats(temp,"8") < 2 and repeats(temp,"9") < 2 then
    else
        dd = 1
    end
    local ar = {}
    local temp = ""
    for k=13,15 do
        local d = 0
        for i=18,20 do
            temp = temp..Fi(i,k,number,pos)
        end
    end
    if repeats(temp,"1") < 2 and repeats(temp,"2") < 2 and repeats(temp,"3") < 2 and repeats(temp,"4") < 2 and repeats(temp,"5") < 2 and repeats(temp,"6") < 2 and repeats(temp,"7") < 2 and repeats(temp,"8") < 2 and repeats(temp,"9") < 2 then
    else
        dd = 1
    end
    local ar = {}
    local temp = ""
    for k=13,15 do
        local d = 0
        for i=22,24 do
            temp = temp..Fi(i,k,number,pos)
        end
    end
    if repeats(temp,"1") < 2 and repeats(temp,"2") < 2 and repeats(temp,"3") < 2 and repeats(temp,"4") < 2 and repeats(temp,"5") < 2 and repeats(temp,"6") < 2 and repeats(temp,"7") < 2 and repeats(temp,"8") < 2 and repeats(temp,"9") < 2 then
    else
        dd = 1
    end
    local ar = {}
    local temp = ""
    for k=17,29 do
        local d = 0
        for i=14,16 do
            temp = temp..Fi(i,k,number,pos)
        end
    end
    if repeats(temp,"1") < 2 and repeats(temp,"2") < 2 and repeats(temp,"3") < 2 and repeats(temp,"4") < 2 and repeats(temp,"5") < 2 and repeats(temp,"6") < 2 and repeats(temp,"7") < 2 and repeats(temp,"8") < 2 and repeats(temp,"9") < 2 then
    else
        dd = 1
    end
    local ar = {}
    local temp = ""
    for k=17,19 do
        local d = 0
        for i=18,20 do
            temp = temp..Fi(i,k,number,pos)
        end
    end
    if repeats(temp,"1") < 2 and repeats(temp,"2") < 2 and repeats(temp,"3") < 2 and repeats(temp,"4") < 2 and repeats(temp,"5") < 2 and repeats(temp,"6") < 2 and repeats(temp,"7") < 2 and repeats(temp,"8") < 2 and repeats(temp,"9") < 2 then
    else
        dd = 1
    end

    local ar = {}
    local temp = ""
    for k=17,19 do
        local d = 0
        for i=22,24 do
            temp = temp..Fi(i,k,number,pos)
        end
    end
    if repeats(temp,"1") < 2 and repeats(temp,"2") < 2 and repeats(temp,"3") < 2 and repeats(temp,"4") < 2 and repeats(temp,"5") < 2 and repeats(temp,"6") < 2 and repeats(temp,"7") < 2 and repeats(temp,"8") < 2 and repeats(temp,"9") < 2 then
    else
        dd = 1
    end
	if dd == 1 then
		minetest.chat_send_all("number already exists")
		return false
	else
		return true
	end
end
function Finisch(player,number,pos)
    local dd = 0
    local ar = {}
    for i=14,24 do
        local d = 0
        local temp = ""
        for k=9,19 do
            temp = temp..Fi(i,k,number,pos)
        end
        ar[i-13] = temp
    end
    for i=1,3 do
        if string.find(ar[i], "1") and string.find(ar[i], "2") and string.find(ar[i], "3") and string.find(ar[i], "4") and string.find(ar[i], "5") and string.find(ar[i], "6") and string.find(ar[i], "7") and string.find(ar[i], "8") and string.find(ar[i], "9") then
        else
            dd = 1
        end
    end
    for i=5,7 do
        if string.find(ar[i], "1") and string.find(ar[i], "2") and string.find(ar[i], "3") and string.find(ar[i], "4") and string.find(ar[i], "5") and string.find(ar[i], "6") and string.find(ar[i], "7") and string.find(ar[i], "8") and string.find(ar[i], "9") then
        else
            dd = 1
        end
    end
    for i=9,11 do
        if string.find(ar[i], "1") and string.find(ar[i], "2") and string.find(ar[i], "3") and string.find(ar[i], "4") and string.find(ar[i], "5") and string.find(ar[i], "6") and string.find(ar[i], "7") and string.find(ar[i], "8") and string.find(ar[i], "9") then
        else
            dd = 1
        end
    end
    local ar = {}
    for k=9,19 do
        local d = 0
        local temp = ""
        for i=14,24 do
            temp = temp..Fi(i,k,number,pos)
        end
        ar[k-8] = temp
    end
    for i=1,3 do
        if string.find(ar[i], "1") and string.find(ar[i], "2") and string.find(ar[i], "3") and string.find(ar[i], "4") and string.find(ar[i], "5") and string.find(ar[i], "6") and string.find(ar[i], "7") and string.find(ar[i], "8") and string.find(ar[i], "9") then
        else
            dd = 1
        end
    end
    for i=5,7 do
        if string.find(ar[i], "1") and string.find(ar[i], "2") and string.find(ar[i], "3") and string.find(ar[i], "4") and string.find(ar[i], "5") and string.find(ar[i], "6") and string.find(ar[i], "7") and string.find(ar[i], "8") and string.find(ar[i], "9") then
        else
            dd = 1
        end
    end
    for i=9,11 do
        if string.find(ar[i], "1") and string.find(ar[i], "2") and string.find(ar[i], "3") and string.find(ar[i], "4") and string.find(ar[i], "5") and string.find(ar[i], "6") and string.find(ar[i], "7") and string.find(ar[i], "8") and string.find(ar[i], "9") then
        else
            dd = 1
        end
    end

    local ar = {}
    local temp = ""
    for k=9,11 do
        local d = 0
        for i=14,16 do
            temp = temp..Fi(i,k,number,pos)
        end
    end
    if string.find(temp, "1") and string.find(temp, "2") and string.find(temp, "3") and string.find(temp, "4") and string.find(temp, "5") and string.find(temp, "6") and string.find(temp, "7") and string.find(temp, "8") and string.find(temp, "9") then
    else
        dd = 1
    end
    local ar = {}
    local temp = ""
    for k=9,11 do
        local d = 0
        for i=18,20 do
            temp = temp..Fi(i,k,number,pos)
        end
    end
    if string.find(temp, "1") and string.find(temp, "2") and string.find(temp, "3") and string.find(temp, "4") and string.find(temp, "5") and string.find(temp, "6") and string.find(temp, "7") and string.find(temp, "8") and string.find(temp, "9") then
    else
        dd = 1
    end
    local ar = {}
    local temp = ""
    for k=9,11 do
        local d = 0
        for i=22,24 do
            temp = temp..Fi(i,k,number,pos)
        end
    end
    if string.find(temp, "1") and string.find(temp, "2") and string.find(temp, "3") and string.find(temp, "4") and string.find(temp, "5") and string.find(temp, "6") and string.find(temp, "7") and string.find(temp, "8") and string.find(temp, "9") then
    else
        dd = 1
    end

    local ar = {}
    local temp = ""
    for k=13,15 do
        local d = 0
        for i=14,16 do
            temp = temp..Fi(i,k,number,pos)
        end
    end
    if string.find(temp, "1") and string.find(temp, "2") and string.find(temp, "3") and string.find(temp, "4") and string.find(temp, "5") and string.find(temp, "6") and string.find(temp, "7") and string.find(temp, "8") and string.find(temp, "9") then
    else
        dd = 1
    end
    local ar = {}
    local temp = ""
    for k=13,15 do
        local d = 0
        for i=18,20 do
            temp = temp..Fi(i,k,number,pos)
        end
    end
    if string.find(temp, "1") and string.find(temp, "2") and string.find(temp, "3") and string.find(temp, "4") and string.find(temp, "5") and string.find(temp, "6") and string.find(temp, "7") and string.find(temp, "8") and string.find(temp, "9") then
    else
        dd = 1
    end
    local ar = {}
    local temp = ""
    for k=13,15 do
        local d = 0
        for i=22,24 do
            temp = temp..Fi(i,k,number,pos)
        end
    end
    if string.find(temp, "1") and string.find(temp, "2") and string.find(temp, "3") and string.find(temp, "4") and string.find(temp, "5") and string.find(temp, "6") and string.find(temp, "7") and string.find(temp, "8") and string.find(temp, "9") then
    else
        dd = 1
    end
    local ar = {}
    local temp = ""
    for k=17,29 do
        local d = 0
        for i=14,16 do
            temp = temp..Fi(i,k,number,pos)
        end
    end
    if string.find(temp, "1") and string.find(temp, "2") and string.find(temp, "3") and string.find(temp, "4") and string.find(temp, "5") and string.find(temp, "6") and string.find(temp, "7") and string.find(temp, "8") and string.find(temp, "9") then
    else
        dd = 1
    end
    local ar = {}
    local temp = ""
    for k=17,19 do
        local d = 0
        for i=18,20 do
            temp = temp..Fi(i,k,number,pos)
        end
    end
    if string.find(temp, "1") and string.find(temp, "2") and string.find(temp, "3") and string.find(temp, "4") and string.find(temp, "5") and string.find(temp, "6") and string.find(temp, "7") and string.find(temp, "8") and string.find(temp, "9") then
    else
        dd = 1
    end
    local ar = {}
    local temp = ""
    for k=17,19 do
        local d = 0
        for i=22,24 do
            temp = temp..Fi(i,k,number,pos)
        end
    end
    if string.find(temp, "1") and string.find(temp, "2") and string.find(temp, "3") and string.find(temp, "4") and string.find(temp, "5") and string.find(temp, "6") and string.find(temp, "7") and string.find(temp, "8") and string.find(temp, "9") then
    else
        dd = 1
    end
    if dd == 1 then
    else
        local player_inv = player:get_inventory()
        local ll = player_inv:get_stack("ll", 1):get_count()
        local level2 = player_inv:get_stack("l", ll):get_count()
        local lv = io.open(minetest.get_worldpath().."/level"..ll..".txt", "r")
	    local level = lv:read("*l")
        lv:close()
        minetest.chat_send_all("level completed")
        if tonumber(level) == tonumber(level2) then
            local le = io.open(minetest.get_worldpath().."/level"..ll..".txt", "w")
		    le:write(level+1)
		    le:close()
        end
    end
end

function lvbut(from,num,level2)
    local formspec = ""
    .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
    .."background[5,6.5;1,1;gui_formbg.png;true]"
    .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
    .."bgcolor[#080808BB;true]"
    if tonumber(level2) > from and num > 0 then
        formspec = formspec.."button[0,1;1,1;a;"..(from+1).."]"
    end
    if tonumber(level2) > (from+1) and num > 1 then
        formspec = formspec.."button[1,1;1,1;b;"..(from+2).."]"
    end
    if tonumber(level2) > (from+2) and num > 2 then
        formspec = formspec.."button[2,1;1,1;c;"..(from+3).."]"
    end
    if tonumber(level2) > (from+3) and num > 3 then
        formspec = formspec.."button[3,1;1,1;d;"..(from+4).."]"
    end
    if tonumber(level2) > (from+4) and num > 4 then
        formspec = formspec.."button[4,1;1,1;e;"..(from+5).."]"
    end
    if tonumber(level2) > (from+5) and num > 5 then
        formspec = formspec.."button[0,2;1,1;f;"..(from+6).."]"
    end
    if tonumber(level2) > (from+6) and num > 6 then
        formspec = formspec.."button[1,2;1,1;g;"..(from+7).."]"
    end
    if tonumber(level2) > (from+7) and num > 7 then
        formspec = formspec.."button[2,2;1,1;h;"..(from+8).."]"
    end
    if tonumber(level2) > (from+8) and num > 8 then
        formspec = formspec.."button[3,2;1,1;i;"..(from+9).."]"
    end
    if tonumber(level2) > (from+9) and num > 9 then
        formspec = formspec.."button[4,2;1,1;j;"..(from+10).."]"
    end
    if tonumber(level2) > (from+10) and num > 10 then
        formspec = formspec.."button[0,3;1,1;k;"..(from+11).."]"
    end
    if tonumber(level2) > (from+11) and num > 11 then
        formspec = formspec.."button[1,3;1,1;l;"..(from+12).."]"
    end
    if tonumber(level2) > (from+12) and num > 12 then
        formspec = formspec.."button[2,3;1,1;m;"..(from+13).."]"
    end
    if tonumber(level2) > (from+13) and num > 13 then
        formspec = formspec.."button[3,3;1,1;n;"..(from+14).."]"
    end
    if tonumber(level2) > (from+14) and num > 14 then
        formspec = formspec.."button[4,3;1,1;o;"..(from+15).."]"
    end
    if tonumber(level2) > (from+15) and num > 15 then
        formspec = formspec.."button[0,4;1,1;p;"..(from+16).."]"
    end
    if tonumber(level2) > (from+16) and num > 16 then
        formspec = formspec.."button[1,4;1,1;q;"..(from+17).."]"
    end
    if tonumber(level2) > (from+17) and num > 17 then
        formspec = formspec.."button[2,4;1,1;r;"..(from+18).."]"
    end
    if tonumber(level2) > (from+18) and num > 18 then
        formspec = formspec.."button[3,4;1,1;s;"..(from+19).."]"
    end
    if tonumber(level2) > (from+19) and num > 19 then
        formspec = formspec.."button[4,4;1,1;t;"..(from+20).."]"
    end
    if tonumber(level2) > (from+20) and num > 20 then
        formspec = formspec.."button[0,5;1,1;u;"..(from+21).."]"
    end
    if tonumber(level2) > (from+21) and num > 21 then
        formspec = formspec.."button[1,5;1,1;v;"..(from+22).."]"
    end
    if tonumber(level2) > (from+22) and num > 22 then
        formspec = formspec.."button[2,5;1,1;w;"..(from+23).."]"
    end
    if tonumber(level2) > (from+23) and num > 23 then
        formspec = formspec.."button[3,5;1,1;x;"..(from+24).."]"
    end
    if tonumber(level2) > (from+24) and num > 24 then
        formspec = formspec.."button[4,5;1,1;y;"..(from+25).."]"
    end
    return formspec
end
function level_formspec(player,file,max_level,level_count,previous_levels,previous_page,previous_page_name,next_page,next_name,pos)
	local player_inv = player:get_inventory()
	lv = io.open(minetest.get_worldpath().."/"..file..".txt", "r")
	local level2 = lv:read("*l")
    lv:close()
    local player_inv = player:get_inventory()
	formspec = "size[5,6.5]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/"..max_level.."]"
		if previous_page then
			formspec = formspec.."button[1.5,6;1,1;"..previous_page_name..";<]"
		end
		formspec = formspec..lvbut(previous_levels,level_count,level2)
		if tonumber(level2) > (previous_levels+level_count) then
			if next_page then
				formspec = formspec.."button[2.5,6;1,1;"..next_name..";>]"
			else
				formspec = formspec.."label[0,"..pos..";"..next_name.."]"
			end
		end
	return formspec
end

local w3 = {}
w3.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
	formspec = "size[8,8.3]"
        .."background[9,10.3;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."label[0,0;Comming soon]"
	return formspec		
end

minetest.register_node("sudoku:new_w1",{
	tiles  = {"default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png^sudoku_new_w1.png"},
	description = "New",
    --groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
    on_punch = function(pos, node, player, pointed_thing)
        local player_inv = player:get_inventory()
        local page = player_inv:get_stack("page1", 1):get_count()+1
        if page == 1 then
            minetest.show_formspec(player:get_player_name(), "w11" , level_formspec(player,"level1",160,25,0,false,"",true,"wab",""))
        elseif page == 2 then
            minetest.show_formspec(player:get_player_name(), "w12" , level_formspec(player,"level1",160,25,25,true,"waa",true,"wac",""))
        elseif page == 3 then
            minetest.show_formspec(player:get_player_name(), "w13" , level_formspec(player,"level1",160,25,50,true,"wab",true,"wad",""))
        elseif page == 4 then
            minetest.show_formspec(player:get_player_name(), "w14" , level_formspec(player,"level1",160,25,75,true,"wac",true,"wae",""))
        elseif page == 5 then
            minetest.show_formspec(player:get_player_name(), "w15" , level_formspec(player,"level1",160,25,100,true,"wad",true,"waf",""))
        elseif page == 6 then
            minetest.show_formspec(player:get_player_name(), "w16" , level_formspec(player,"level1",160,25,125,true,"wae",true,"wag",""))
        elseif page == 7 then
            minetest.show_formspec(player:get_player_name(), "w17" , level_formspec(player,"level1",160,10,150,true,"waf",false,"You have finished world 1!","2.7"))
        end
    end,
})

minetest.register_node("sudoku:new_w2",{
	tiles  = {"default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png^sudoku_new_w2.png"},
	description = "New",
    --groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
    on_punch = function(pos, node, player, pointed_thing)
        local player_inv = player:get_inventory()
        local page = player_inv:get_stack("page2", 1):get_count()+1
        if page == 1 then
            minetest.show_formspec(player:get_player_name(), "w21" , level_formspec(player,"level2",190,25,0,false,"",true,"wbb",""))
        elseif page == 2 then
            minetest.show_formspec(player:get_player_name(), "w22" , level_formspec(player,"level2",190,25,25,true,"wba",true,"wbc",""))
        elseif page == 3 then
            minetest.show_formspec(player:get_player_name(), "w23" , level_formspec(player,"level2",190,25,50,true,"wbb",true,"wbd",""))
        elseif page == 4 then
            minetest.show_formspec(player:get_player_name(), "w24" , level_formspec(player,"level2",190,25,75,true,"wbc",true,"wbe",""))
        elseif page == 5 then
            minetest.show_formspec(player:get_player_name(), "w25" , level_formspec(player,"level2",190,25,100,true,"wbd",true,"wbf",""))
        elseif page == 6 then
            minetest.show_formspec(player:get_player_name(), "w26" , level_formspec(player,"level2",190,25,125,true,"wbe",true,"wbg",""))
        elseif page == 7 then
            minetest.show_formspec(player:get_player_name(), "w27" , level_formspec(player,"level2",190,25,150,true,"wbf",true,"wbh",""))
        elseif page == 8 then
            minetest.show_formspec(player:get_player_name(), "w28" , level_formspec(player,"level2",190,15,175,true,"wbg",false,"You have finished world 2!","3.7"))
        end
    end,
})

minetest.register_node("sudoku:new_w3",{
	tiles  = {"default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png^sudoku_new_w3.png"},
	description = "New",
    --groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
    on_punch = function(pos, node, player, pointed_thing)
        local player_inv = player:get_inventory()
        local page = player_inv:get_stack("page3", 1):get_count()+1
        if page == 1 then
            minetest.show_formspec(player:get_player_name(), "w31" , level_formspec(player,"level3",333,25,0,false,"",true,"wcb",""))
        elseif page == 2 then
            minetest.show_formspec(player:get_player_name(), "w32" , level_formspec(player,"level3",333,25,25,true,"wca",true,"wcc",""))
        elseif page == 3 then
            minetest.show_formspec(player:get_player_name(), "w33" , level_formspec(player,"level3",333,25,50,true,"wcb",true,"wcd",""))
        elseif page == 4 then
            minetest.show_formspec(player:get_player_name(), "w34" , level_formspec(player,"level3",333,25,75,true,"wcc",true,"wce",""))
        elseif page == 5 then
            minetest.show_formspec(player:get_player_name(), "w35" , level_formspec(player,"level3",333,25,100,true,"wcd",true,"wcf",""))
        elseif page == 6 then
            minetest.show_formspec(player:get_player_name(), "w36" , level_formspec(player,"level3",333,25,125,true,"wce",true,"wcg",""))
        elseif page == 7 then
            minetest.show_formspec(player:get_player_name(), "w37" , level_formspec(player,"level3",333,25,150,true,"wcf",true,"wch",""))
        elseif page == 8 then
            minetest.show_formspec(player:get_player_name(), "w38" , level_formspec(player,"level3",333,25,175,true,"wcg",true,"wci",""))
        elseif page == 9 then
            minetest.show_formspec(player:get_player_name(), "w39" , level_formspec(player,"level3",333,25,200,true,"wch",true,"wcj",""))
        elseif page == 10 then
            minetest.show_formspec(player:get_player_name(), "w310" , level_formspec(player,"level3",333,25,225,true,"wci",true,"wck",""))
        elseif page == 11 then
            minetest.show_formspec(player:get_player_name(), "w311" , level_formspec(player,"level3",333,25,250,true,"wcj",true,"wcl",""))
        elseif page == 12 then
            minetest.show_formspec(player:get_player_name(), "w312" , level_formspec(player,"level3",333,25,275,true,"wck",true,"wcm",""))
        elseif page == 13 then
            minetest.show_formspec(player:get_player_name(), "w313" , level_formspec(player,"level3",333,25,300,true,"wcl",true,"wcn",""))
        elseif page == 14 then
            minetest.show_formspec(player:get_player_name(), "w314" , level_formspec(player,"level3",333,8,325,true,"wcm",false,"You have finished world 3!","2.7"))
        end
    end,
})

minetest.register_node("sudoku:new_w4",{
	tiles  = {"default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png^sudoku_new_w4.png"},
	description = "New",
    --groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
    on_punch = function(pos, node, player, pointed_thing)
		local player_inv = player:get_inventory()
        local page = player_inv:get_stack("page4", 1):get_count()+1
        if page == 1 then
            minetest.show_formspec(player:get_player_name(), "w41" , level_formspec(player,"level4",300,25,0,false,"",true,"wdb",""))
        elseif page == 2 then
            minetest.show_formspec(player:get_player_name(), "w42" , level_formspec(player,"level4",300,25,25,true,"wda",true,"wdc",""))
        elseif page == 3 then
            minetest.show_formspec(player:get_player_name(), "w43" , level_formspec(player,"level4",300,25,50,true,"wdb",true,"wdd",""))
        elseif page == 4 then
            minetest.show_formspec(player:get_player_name(), "w44" , level_formspec(player,"level4",300,25,75,true,"wdc",true,"wde",""))
        elseif page == 5 then
            minetest.show_formspec(player:get_player_name(), "w45" , level_formspec(player,"level4",300,25,100,true,"wdd",true,"wdf",""))
        elseif page == 6 then
            minetest.show_formspec(player:get_player_name(), "w46" , level_formspec(player,"level4",300,25,125,true,"wde",true,"wdg",""))
        elseif page == 7 then
            minetest.show_formspec(player:get_player_name(), "w47" , level_formspec(player,"level4",300,25,150,true,"wdf",true,"wdh",""))
        elseif page == 8 then
            minetest.show_formspec(player:get_player_name(), "w48" , level_formspec(player,"level4",300,25,175,true,"wdg",true,"wdi",""))
        elseif page == 9 then
            minetest.show_formspec(player:get_player_name(), "w49" , level_formspec(player,"level4",300,25,200,true,"wdh",true,"wdj",""))
        elseif page == 10 then
            minetest.show_formspec(player:get_player_name(), "w410" , level_formspec(player,"level4",300,25,225,true,"wdi",true,"wdk",""))
        elseif page == 11 then
            minetest.show_formspec(player:get_player_name(), "w411" , level_formspec(player,"level4",300,25,250,true,"wdj",true,"wdl",""))
        elseif page == 12 then
            minetest.show_formspec(player:get_player_name(), "w412" , level_formspec(player,"level4",300,25,275,true,"wdk",false,"You have finished world 4!","5.7"))
		end
    end,
})

minetest.register_node("sudoku:new_w5",{
	tiles  = {"default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png^sudoku_new_w5.png"},
	description = "New",
    --groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
    on_punch = function(pos, node, player, pointed_thing)
        minetest.show_formspec(player:get_player_name(), "w3" , w3.get_formspec(player))
    end,
})
minetest.register_node("sudoku:new_w6",{
	tiles  = {"default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png^sudoku_new_w6.png"},
	description = "New",
    --groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
    on_punch = function(pos, node, player, pointed_thing)
        minetest.show_formspec(player:get_player_name(), "w3" , w3.get_formspec(player))
    end,
})
minetest.register_node("sudoku:new_w7",{
	tiles  = {"default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png^sudoku_new_w7.png"},
	description = "New",
    --groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
    on_punch = function(pos, node, player, pointed_thing)
        minetest.show_formspec(player:get_player_name(), "w3" , w3.get_formspec(player))
    end,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
    local player_inv = player:get_inventory()
    player_inv:set_size("ll", 1)
    player_inv:set_size("l", 6)
    player_inv:set_size("page1", 1)
    player_inv:set_size("page2", 1)
    player_inv:set_size("page3", 1)
	player_inv:set_size("page4", 1)
	if formname == "w11" or formname == "w12" or formname == "w13" or formname == "w14" or formname == "w15" or formname == "w16" or formname == "w17" then
        for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"1_"..v)
                player_inv:set_stack("l",  1, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 1")
            end
        end
	end
	if formname == "w21" or formname == "w22" or formname == "w23" or formname == "w24" or formname == "w25" or formname == "w26" or formname == "w27" or formname == "w28" then
        for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"2_"..v)
                player_inv:set_stack("l",  2, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 2")
            end
        end
	end
	if formname == "w31" or formname == "w32" or formname == "w33" or formname == "w34" or formname == "w35" or formname == "w36" or formname == "w37" or formname == "w38" or formname == "w39" or formname == "w310" or formname == "w311" or formname == "w312" or formname == "w313" or formname == "w314" then
        for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"3_"..v)
                player_inv:set_stack("l",  3, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 3")
            end
        end
	end
	if formname == "w41" or formname == "w42" or formname == "w43" or formname == "w44" or formname == "w45" or formname == "w46" or formname == "w47" or formname == "w48" or formname == "w49" or formname == "w410" or formname == "w411" or formname == "w412" then
        for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"4_"..v)
                player_inv:set_stack("l",  4, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 4")
            end
        end
	end
	if fields.waa then
        player_inv:set_stack("page1",  1, nil)
        minetest.show_formspec(player:get_player_name(), "w11" , level_formspec(player,"level1",160,25,0,false,"",true,"wab",""))
    elseif fields.wab then
        player_inv:set_stack("page1",  1, "default:dirt")
        minetest.show_formspec(player:get_player_name(), "w12" , level_formspec(player,"level1",160,25,25,true,"waa",true,"wac",""))
    elseif fields.wac then
        player_inv:set_stack("page1",  1, "default:dirt 2")
        minetest.show_formspec(player:get_player_name(), "w13" , level_formspec(player,"level1",160,25,50,true,"wab",true,"wad",""))
    elseif fields.wad then
        player_inv:set_stack("page1",  1, "default:dirt 3")
        minetest.show_formspec(player:get_player_name(), "w14" , level_formspec(player,"level1",160,25,75,true,"wac",true,"wae",""))
    elseif fields.wae then
        player_inv:set_stack("page1",  1, "default:dirt 4")
        minetest.show_formspec(player:get_player_name(), "w15" , level_formspec(player,"level1",160,25,100,true,"wad",true,"waf",""))
    elseif fields.waf then
        player_inv:set_stack("page1",  1, "default:dirt 5")
        minetest.show_formspec(player:get_player_name(), "w16" , level_formspec(player,"level1",160,25,125,true,"wae",true,"wag",""))
    elseif fields.wag then
        player_inv:set_stack("page1",  1, "default:dirt 6")
        minetest.show_formspec(player:get_player_name(), "w17" , level_formspec(player,"level1",160,10,150,true,"waf",false,"You have finished world 1!","2.7"))
    elseif fields.wba then
        player_inv:set_stack("page2",  1, nil)
        minetest.show_formspec(player:get_player_name(), "w21" , level_formspec(player,"level2",190,25,0,false,"",true,"wbb",""))
    elseif fields.wbb then
        player_inv:set_stack("page2",  1, "default:dirt")
        minetest.show_formspec(player:get_player_name(), "w22" , level_formspec(player,"level2",190,25,25,true,"wba",true,"wbc",""))
    elseif fields.wbc then
        player_inv:set_stack("page2",  1, "default:dirt 2")
        minetest.show_formspec(player:get_player_name(), "w23" , level_formspec(player,"level2",190,25,50,true,"wbb",true,"wbd",""))
    elseif fields.wbd then
        player_inv:set_stack("page2",  1, "default:dirt 3")
        minetest.show_formspec(player:get_player_name(), "w24" , level_formspec(player,"level2",190,25,75,true,"wbc",true,"wbe",""))
    elseif fields.wbe then
        player_inv:set_stack("page2",  1, "default:dirt 4")
        minetest.show_formspec(player:get_player_name(), "w25" , level_formspec(player,"level2",190,25,100,true,"wbd",true,"wbf",""))
    elseif fields.wbf then
        player_inv:set_stack("page2",  1, "default:dirt 5")
        minetest.show_formspec(player:get_player_name(), "w26" , level_formspec(player,"level2",190,25,125,true,"wbe",true,"wbg",""))
    elseif fields.wbg then
        player_inv:set_stack("page2",  1, "default:dirt 6")
        minetest.show_formspec(player:get_player_name(), "w27" , level_formspec(player,"level2",190,25,150,true,"wbf",true,"wbh",""))
	elseif fields.wbh then
        player_inv:set_stack("page2",  1, "default:dirt 7")
        minetest.show_formspec(player:get_player_name(), "w28" , level_formspec(player,"level2",190,15,175,true,"wbg",false,"You have finished world 2!","3.7"))
    elseif fields.wca then
        player_inv:set_stack("page3",  1, nil)
        minetest.show_formspec(player:get_player_name(), "w31" , level_formspec(player,"level3",333,25,0,false,"",true,"wcb",""))
    elseif fields.wcb then
        player_inv:set_stack("page3",  1, "default:dirt")
        minetest.show_formspec(player:get_player_name(), "w32" , level_formspec(player,"level3",333,25,25,true,"wca",true,"wcc",""))
    elseif fields.wcc then
        player_inv:set_stack("page3",  1, "default:dirt 2")
        minetest.show_formspec(player:get_player_name(), "w33" , level_formspec(player,"level3",333,25,50,true,"wcb",true,"wcd",""))
    elseif fields.wcd then
        player_inv:set_stack("page3",  1, "default:dirt 3")
        minetest.show_formspec(player:get_player_name(), "w34" , level_formspec(player,"level3",333,25,75,true,"wcc",true,"wce",""))
	elseif fields.wce then
        player_inv:set_stack("page3",  1, "default:dirt 4")
        minetest.show_formspec(player:get_player_name(), "w35" , level_formspec(player,"level3",333,25,100,true,"wcd",true,"wcf",""))
	elseif fields.wcf then
        player_inv:set_stack("page3",  1, "default:dirt 5")
        minetest.show_formspec(player:get_player_name(), "w36" , level_formspec(player,"level3",333,25,125,true,"wce",true,"wcg",""))	
	elseif fields.wcg then
        player_inv:set_stack("page3",  1, "default:dirt 6")
        minetest.show_formspec(player:get_player_name(), "w37" , level_formspec(player,"level3",333,25,150,true,"wcf",true,"wch",""))
	elseif fields.wch then
        player_inv:set_stack("page3",  1, "default:dirt 7")
        minetest.show_formspec(player:get_player_name(), "w38" , level_formspec(player,"level3",333,25,175,true,"wcg",true,"wci",""))
	elseif fields.wci then
        player_inv:set_stack("page3",  1, "default:dirt 8")
        minetest.show_formspec(player:get_player_name(), "w39" , level_formspec(player,"level3",333,25,200,true,"wch",true,"wcj",""))	
	elseif fields.wcj then
        player_inv:set_stack("page3",  1, "default:dirt 9")
        minetest.show_formspec(player:get_player_name(), "w310" , level_formspec(player,"level3",333,25,225,true,"wci",true,"wck",""))
	elseif fields.wck then
        player_inv:set_stack("page3",  1, "default:dirt 10")
        minetest.show_formspec(player:get_player_name(), "w311" , level_formspec(player,"level3",333,25,250,true,"wcj",true,"wcl",""))
	elseif fields.wcl then
        player_inv:set_stack("page3",  1, "default:dirt 11")
        minetest.show_formspec(player:get_player_name(), "w312" , level_formspec(player,"level3",333,25,275,true,"wck",true,"wcm",""))
	elseif fields.wcm then
        player_inv:set_stack("page3",  1, "default:dirt 12")
        minetest.show_formspec(player:get_player_name(), "w313" , level_formspec(player,"level3",333,25,300,true,"wcl",true,"wcn",""))
	elseif fields.wcn then
        player_inv:set_stack("page3",  1, "default:dirt 13")
        minetest.show_formspec(player:get_player_name(), "w314" , level_formspec(player,"level3",333,8,325,true,"wcm",false,"You have finished world 3!","2.7"))
    elseif fields.wda then
        player_inv:set_stack("page4",  1, "")
        minetest.show_formspec(player:get_player_name(), "w41" , level_formspec(player,"level4",300,25,0,false,"",true,"wdb",""))
	elseif fields.wdb then
        player_inv:set_stack("page4",  1, "default:dirt")
        minetest.show_formspec(player:get_player_name(), "w42" , level_formspec(player,"level4",300,25,25,true,"wda",true,"wdc",""))
	elseif fields.wdc then
        player_inv:set_stack("page4",  1, "default:dirt 2")
        minetest.show_formspec(player:get_player_name(), "w43" , level_formspec(player,"level4",300,25,50,true,"wdb",true,"wdd",""))
	elseif fields.wdd then
        player_inv:set_stack("page4",  1, "default:dirt 3")
        minetest.show_formspec(player:get_player_name(), "w44" , level_formspec(player,"level4",300,25,75,true,"wdc",true,"wde",""))
	elseif fields.wde then
        player_inv:set_stack("page4",  1, "default:dirt 4")
        minetest.show_formspec(player:get_player_name(), "w45" , level_formspec(player,"level4",300,25,100,true,"wdd",true,"wdf",""))
	elseif fields.wdf then
        player_inv:set_stack("page4",  1, "default:dirt 5")
        minetest.show_formspec(player:get_player_name(), "w46" , level_formspec(player,"level4",300,25,125,true,"wde",true,"wdg",""))
	elseif fields.wdg then
        player_inv:set_stack("page4",  1, "default:dirt 6")
        minetest.show_formspec(player:get_player_name(), "w47" , level_formspec(player,"level4",300,25,150,true,"wdf",true,"wdh",""))
	elseif fields.wdh then
        player_inv:set_stack("page4",  1, "default:dirt 7")
        minetest.show_formspec(player:get_player_name(), "w48" , level_formspec(player,"level4",300,25,175,true,"wdg",true,"wdi",""))
	elseif fields.wdi then
        player_inv:set_stack("page4",  1, "default:dirt 8")
        minetest.show_formspec(player:get_player_name(), "w49" , level_formspec(player,"level4",300,25,200,true,"wdh",true,"wdj",""))
	elseif fields.wdj then
        player_inv:set_stack("page4",  1, "default:dirt 9")
        minetest.show_formspec(player:get_player_name(), "w410" , level_formspec(player,"level4",300,25,225,true,"wdi",true,"wdk",""))
	elseif fields.wdk then
        player_inv:set_stack("page4",  1, "default:dirt 10")
        minetest.show_formspec(player:get_player_name(), "w411" , level_formspec(player,"level4",300,25,250,true,"wdj",true,"wdl",""))
    elseif fields.wdl then
        player_inv:set_stack("page4",  1, "default:dirt 11")
        minetest.show_formspec(player:get_player_name(), "w412" , level_formspec(player,"level4",300,25,275,true,"wdk",false,"You have finished world 4!","5.7"))
    else
        minetest.show_formspec(player:get_player_name(), "", "")
	end
end)