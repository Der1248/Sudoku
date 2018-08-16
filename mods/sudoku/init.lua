local hud_levels = {}

minetest.register_on_joinplayer(function(player)
	
    local name = player:get_player_name()
    player:hud_add({
		hud_elem_type = "text",
		position = {x=0, y=0.85},
		offset = {x=0, y=10},
		alignment = {x=1, y=0},
		number = 0xFFFFFF ,
		text = "For Minetest 	  :  0.4.16",
	})
	player:hud_add({
		hud_elem_type = "text",
		position = {x=0, y=0.85},
		offset = {x=0, y=30},
		alignment = {x=1, y=0},
		number = 0xFFFFFF ,
		text = "Game Version	 :  1.7.1",
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
    end
    for i=12,25 do
        for j=0,25 do
            for k=75,89 do
                if minetest.get_node({x=i, y=j, z=(-1)*k}).name == "default:mossycobble" then
                    minetest.set_node({x=i, y=j, z=(-1)*k}, {name="sudoku:wall"})
                end
                if minetest.get_node({x=i, y=j, z=(-1)*k}).name == "default:obsidian_glass" then
                    minetest.set_node({x=i, y=j, z=(-1)*k}, {name="sudoku:glass"})
                end
            end
        end
    end
end)
minetest.register_on_joinplayer(function(player)
    local override_table = player:get_physics_override()
    override_table.new_move = false
    override_table.sneak_glitch = true
    player:set_physics_override(override_table)
    minetest.setting_set("time_speed", "0")
    minetest.set_timeofday(0.5)
    minetest.setting_set("node_highlighting", "box")
    player:hud_set_hotbar_itemcount(9)
    player:setpos({x=19, y=10, z=-87})
    for i=17,21 do
        for j=9,15 do
            minetest.set_node({x=i, y=j, z=-89}, {name="sudoku:wall"})
        end
    end
end)
minetest.register_on_newplayer(function(player)
    local player = minetest.get_player_by_name(player:get_player_name())
    local pri = minetest.get_player_privs(player:get_player_name())
    pri["fly"] = true
    minetest.set_player_privs(player:get_player_name(), pri)
	player:setpos({x=20, y=10, z=-91})
	
end)
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
minetest.register_node("sudoku:glass", {
	description = "Obsidian Glass",
	drawtype = "glasslike_framed_optional",
	tiles = {"default_obsidian_glass.png", "default_obsidian_glass_detail.png"},
	paramtype = "light",
	paramtype2 = "glasslikeliquidlevel",
	is_ground_content = false,
	sunlight_propagates = true,
})
minetest.register_node("sudoku:wall",{
	description = "Wall",
	tiles = {"default_mossycobble.png"},
    --groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
})
for i=1,9 do
    minetest.register_node("sudoku:"..i,{
	    description = ""..i,
	    tiles = {"sudoku_1_"..i..".png"},
        --groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
    })
end
for i=1,9 do
    minetest.register_node("sudoku:n_"..i,{
	    description = ""..i,
	    tiles = {"sudoku_2_"..i..".png"},
        groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
    })
end
function New(player,page)
    local player_inv = player:get_inventory()
    player_inv:set_list("main", nil)
    player_inv:set_size("main", 32)
    lv = io.open(minetest.get_worldpath().."/level1.txt", "r")
	local level = lv:read("*l")
    lv:close()
    local lv = io.open(minetest.get_modpath("sudoku").."/lv"..page..".txt", "r")
    local ar1 = {}
    local ar2 = {}
    for i=1,9 do
	    ar1[i] = lv:read("*l")
    end
    for i=14,24 do
        for k=9,19 do
            minetest.set_node({x=i, y=k, z=-76}, {name="air"})
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
                minetest.set_node({x=k+13, y=(12-l)+8, z=-76}, {name="air"})
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
    player_inv:add_item("main", "sudoku:n_1 "..(9-a1))
    player_inv:add_item("main", "sudoku:n_2 "..(9-a2))
    player_inv:add_item("main", "sudoku:n_3 "..(9-a3))
    player_inv:add_item("main", "sudoku:n_4 "..(9-a4))
    player_inv:add_item("main", "sudoku:n_5 "..(9-a5))
    player_inv:add_item("main", "sudoku:n_6 "..(9-a6))
    player_inv:add_item("main", "sudoku:n_7 "..(9-a7))
    player_inv:add_item("main", "sudoku:n_8 "..(9-a8))
    player_inv:add_item("main", "sudoku:n_9 "..(9-a9))
end
function Fi(i,k)
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
    else
        temp = "0"
    end
    return temp
end
function Finisch(player)
    local dd = 0
    local ar = {}
    for i=14,24 do
        local d = 0
        local temp = ""
        for k=9,19 do
            temp = temp..Fi(i,k)
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
            temp = temp..Fi(i,k)
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
            temp = temp..Fi(i,k)
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
            temp = temp..Fi(i,k)
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
            temp = temp..Fi(i,k)
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
            temp = temp..Fi(i,k)
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
            temp = temp..Fi(i,k)
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
            temp = temp..Fi(i,k)
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
            temp = temp..Fi(i,k)
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
            temp = temp..Fi(i,k)
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
            temp = temp..Fi(i,k)
        end
    end
    if string.find(temp, "1") and string.find(temp, "2") and string.find(temp, "3") and string.find(temp, "4") and string.find(temp, "5") and string.find(temp, "6") and string.find(temp, "7") and string.find(temp, "8") and string.find(temp, "9") then
    else
        dd = 1
    end
    if dd == 1 then
        minetest.chat_send_all("not correct")
    else
        local player_inv = player:get_inventory()
        local ll = player_inv:get_stack("ll", 1):get_count()
        local level2 = player_inv:get_stack("l", ll):get_count()
        lv = io.open(minetest.get_worldpath().."/level"..ll..".txt", "r")
	    local level = lv:read("*l")
        lv:close()
        minetest.chat_send_all("level completed")
        if tonumber(level) == tonumber(level2) then
            le = io.open(minetest.get_worldpath().."/level"..ll..".txt", "w")
		    le:write(level+1)
		    le:close()
        end
    end
end
local w11 = {}
w11.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level1.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/160]"
        .."button[0,1;1,1;;1]"
        if tonumber(level2) > 1 then
            formspec = formspec.."button[1,1;1,1;;2]"
        end
        if tonumber(level2) > 2 then
            formspec = formspec.."button[2,1;1,1;;3]"
        end
        if tonumber(level2) > 3 then
            formspec = formspec.."button[3,1;1,1;;4]"
        end
        if tonumber(level2) > 4 then
            formspec = formspec.."button[4,1;1,1;;5]"
        end
        if tonumber(level2) > 5 then
            formspec = formspec.."button[0,2;1,1;;6]"
        end
        if tonumber(level2) > 6 then
            formspec = formspec.."button[1,2;1,1;;7]"
        end
        if tonumber(level2) > 7 then
            formspec = formspec.."button[2,2;1,1;;8]"
        end
        if tonumber(level2) > 8 then
            formspec = formspec.."button[3,2;1,1;;9]"
        end
        if tonumber(level2) > 9 then
            formspec = formspec.."button[4,2;1,1;;10]"
        end
        if tonumber(level2) > 10 then
            formspec = formspec.."button[0,3;1,1;;11]"
        end
        if tonumber(level2) > 11 then
            formspec = formspec.."button[1,3;1,1;;12]"
        end
        if tonumber(level2) > 12 then
            formspec = formspec.."button[2,3;1,1;;13]"
        end
        if tonumber(level2) > 13 then
            formspec = formspec.."button[3,3;1,1;;14]"
        end
        if tonumber(level2) > 14 then
            formspec = formspec.."button[4,3;1,1;;15]"
        end
        if tonumber(level2) > 15 then
            formspec = formspec.."button[0,4;1,1;;16]"
        end
        if tonumber(level2) > 16 then
            formspec = formspec.."button[1,4;1,1;;17]"
        end
        if tonumber(level2) > 17 then
            formspec = formspec.."button[2,4;1,1;;18]"
        end
        if tonumber(level2) > 18 then
            formspec = formspec.."button[3,4;1,1;;19]"
        end
        if tonumber(level2) > 19 then
            formspec = formspec.."button[4,4;1,1;;20]"
        end
        if tonumber(level2) > 20 then
            formspec = formspec.."button[0,5;1,1;;21]"
        end
        if tonumber(level2) > 21 then
            formspec = formspec.."button[1,5;1,1;;22]"
        end
        if tonumber(level2) > 22 then
            formspec = formspec.."button[2,5;1,1;;23]"
        end
        if tonumber(level2) > 23 then
            formspec = formspec.."button[3,5;1,1;;24]"
        end
        if tonumber(level2) > 24 then
            formspec = formspec.."button[4,5;1,1;;25]"
        end
        if tonumber(level2) > 25 then
            formspec = formspec.."button[2.5,6;1,1;wab;>]"
        end
	return formspec		
end
local w12 = {}
w12.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level1.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/160]"
        .."button[0,1;1,1;;26]"
        .."button[1.5,6;1,1;waa;<]"
        if tonumber(level2) > 26 then
            formspec = formspec.."button[1,1;1,1;;27]"
        end
        if tonumber(level2) > 27 then
            formspec = formspec.."button[2,1;1,1;;28]"
        end
        if tonumber(level2) > 28 then
            formspec = formspec.."button[3,1;1,1;;29]"
        end
        if tonumber(level2) > 29 then
            formspec = formspec.."button[4,1;1,1;;30]"
        end
        if tonumber(level2) > 30 then
            formspec = formspec.."button[0,2;1,1;;31]"
        end
        if tonumber(level2) > 31 then
            formspec = formspec.."button[1,2;1,1;;32]"
        end
        if tonumber(level2) > 32 then
            formspec = formspec.."button[2,2;1,1;;33]"
        end
        if tonumber(level2) > 33 then
            formspec = formspec.."button[3,2;1,1;;34]"
        end
        if tonumber(level2) > 34 then
            formspec = formspec.."button[4,2;1,1;;35]"
        end
        if tonumber(level2) > 35 then
            formspec = formspec.."button[0,3;1,1;;36]"
        end
        if tonumber(level2) > 36 then
            formspec = formspec.."button[1,3;1,1;;37]"
        end
        if tonumber(level2) > 37 then
            formspec = formspec.."button[2,3;1,1;;38]"
        end
        if tonumber(level2) > 38 then
            formspec = formspec.."button[3,3;1,1;;39]"
        end
        if tonumber(level2) > 39 then
            formspec = formspec.."button[4,3;1,1;;40]"
        end
        if tonumber(level2) > 40 then
            formspec = formspec.."button[0,4;1,1;;41]"
        end
        if tonumber(level2) > 41 then
            formspec = formspec.."button[1,4;1,1;;42]"
        end
        if tonumber(level2) > 42 then
            formspec = formspec.."button[2,4;1,1;;43]"
        end
        if tonumber(level2) > 43 then
            formspec = formspec.."button[3,4;1,1;;44]"
        end
        if tonumber(level2) > 44 then
            formspec = formspec.."button[4,4;1,1;;45]"
        end
        if tonumber(level2) > 45 then
            formspec = formspec.."button[0,5;1,1;;46]"
        end
        if tonumber(level2) > 46 then
            formspec = formspec.."button[1,5;1,1;;47]"
        end
        if tonumber(level2) > 47 then
            formspec = formspec.."button[2,5;1,1;;48]"
        end
        if tonumber(level2) > 48 then
            formspec = formspec.."button[3,5;1,1;;49]"
        end
        if tonumber(level2) > 49 then
            formspec = formspec.."button[4,5;1,1;;50]"
        end
        if tonumber(level2) > 50 then
            formspec = formspec.."button[2.5,6;1,1;wac;>]"
        end
	return formspec		
end
local w13 = {}
w13.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level1.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/160]"
        .."button[0,1;1,1;;51]"
        .."button[1.5,6;1,1;wab;<]"
        if tonumber(level2) > 51 then
            formspec = formspec.."button[1,1;1,1;;52]"
        end
        if tonumber(level2) > 52 then
            formspec = formspec.."button[2,1;1,1;;53]"
        end
        if tonumber(level2) > 53 then
            formspec = formspec.."button[3,1;1,1;;54]"
        end
        if tonumber(level2) > 54 then
            formspec = formspec.."button[4,1;1,1;;55]"
        end
        if tonumber(level2) > 55 then
            formspec = formspec.."button[0,2;1,1;;56]"
        end
        if tonumber(level2) > 56 then
            formspec = formspec.."button[1,2;1,1;;57]"
        end
        if tonumber(level2) > 57 then
            formspec = formspec.."button[2,2;1,1;;58]"
        end
        if tonumber(level2) > 58 then
            formspec = formspec.."button[3,2;1,1;;59]"
        end
        if tonumber(level2) > 59 then
            formspec = formspec.."button[4,2;1,1;;60]"
        end
        if tonumber(level2) > 60 then
            formspec = formspec.."button[0,3;1,1;;61]"
        end
        if tonumber(level2) > 61 then
            formspec = formspec.."button[1,3;1,1;;62]"
        end
        if tonumber(level2) > 62 then
            formspec = formspec.."button[2,3;1,1;;63]"
        end
        if tonumber(level2) > 63 then
            formspec = formspec.."button[3,3;1,1;;64]"
        end
        if tonumber(level2) > 64 then
            formspec = formspec.."button[4,3;1,1;;65]"
        end
        if tonumber(level2) > 65 then
            formspec = formspec.."button[0,4;1,1;;66]"
        end
        if tonumber(level2) > 66 then
            formspec = formspec.."button[1,4;1,1;;67]"
        end
        if tonumber(level2) > 67 then
            formspec = formspec.."button[2,4;1,1;;68]"
        end
        if tonumber(level2) > 68 then
            formspec = formspec.."button[3,4;1,1;;69]"
        end
        if tonumber(level2) > 69 then
            formspec = formspec.."button[4,4;1,1;;70]"
        end
        if tonumber(level2) > 70 then
            formspec = formspec.."button[0,5;1,1;;71]"
        end
        if tonumber(level2) > 71 then
            formspec = formspec.."button[1,5;1,1;;72]"
        end
        if tonumber(level2) > 72 then
            formspec = formspec.."button[2,5;1,1;;73]"
        end
        if tonumber(level2) > 73 then
            formspec = formspec.."button[3,5;1,1;;74]"
        end
        if tonumber(level2) > 74 then
            formspec = formspec.."button[4,5;1,1;;75]"
        end
        if tonumber(level2) > 75 then
            formspec = formspec.."button[2.5,6;1,1;wad;>]"
        end
	return formspec		
end
local w14 = {}
w14.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level1.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/160]"
        .."button[0,1;1,1;;76]"
        formspec = formspec.."button[1.5,6;1,1;wac;<]"
        if tonumber(level2) > 76 then
            formspec = formspec.."button[1,1;1,1;;77]"
        end
        if tonumber(level2) > 77 then
            formspec = formspec.."button[2,1;1,1;;78]"
        end
        if tonumber(level2) > 78 then
            formspec = formspec.."button[3,1;1,1;;79]"
        end
        if tonumber(level2) > 79 then
            formspec = formspec.."button[4,1;1,1;;80]"
        end
        if tonumber(level2) > 80 then
            formspec = formspec.."button[0,2;1,1;;81]"
        end
        if tonumber(level2) > 81 then
            formspec = formspec.."button[1,2;1,1;;82]"
        end
        if tonumber(level2) > 82 then
            formspec = formspec.."button[2,2;1,1;;83]"
        end
        if tonumber(level2) > 83 then
            formspec = formspec.."button[3,2;1,1;;84]"
        end
        if tonumber(level2) > 84 then
            formspec = formspec.."button[4,2;1,1;;85]"
        end
        if tonumber(level2) > 85 then
            formspec = formspec.."button[0,3;1,1;;86]"
        end
        if tonumber(level2) > 86 then
            formspec = formspec.."button[1,3;1,1;;87]"
        end
        if tonumber(level2) > 87 then
            formspec = formspec.."button[2,3;1,1;;88]"
        end
        if tonumber(level2) > 88 then
            formspec = formspec.."button[3,3;1,1;;89]"
        end
        if tonumber(level2) > 89 then
            formspec = formspec.."button[4,3;1,1;;90]"
        end
        if tonumber(level2) > 90 then
            formspec = formspec.."button[0,4;1,1;;91]"
        end
        if tonumber(level2) > 91 then
            formspec = formspec.."button[1,4;1,1;;92]"
        end
        if tonumber(level2) > 92 then
            formspec = formspec.."button[2,4;1,1;;93]"
        end
        if tonumber(level2) > 93 then
            formspec = formspec.."button[3,4;1,1;;94]"
        end
        if tonumber(level2) > 94 then
            formspec = formspec.."button[4,4;1,1;;95]"
        end
        if tonumber(level2) > 95 then
            formspec = formspec.."button[0,5;1,1;;96]"
        end
        if tonumber(level2) > 96 then
            formspec = formspec.."button[1,5;1,1;;97]"
        end
        if tonumber(level2) > 97 then
            formspec = formspec.."button[2,5;1,1;;98]"
        end
        if tonumber(level2) > 98 then
            formspec = formspec.."button[3,5;1,1;;99]"
        end
        if tonumber(level2) > 99 then
            formspec = formspec.."button[4,5;1,1;;100]"
        end
        if tonumber(level2) > 100 then
            formspec = formspec.."button[2.5,6;1,1;wae;>]"
        end
	return formspec		
end
local w15 = {}
w15.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level1.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/160]"
        .."button[0,1;1,1;;101]"
        formspec = formspec.."button[1.5,6;1,1;wad;<]"
        if tonumber(level2) > 101 then
            formspec = formspec.."button[1,1;1,1;;102]"
        end
        if tonumber(level2) > 102 then
            formspec = formspec.."button[2,1;1,1;;103]"
        end
        if tonumber(level2) > 103 then
            formspec = formspec.."button[3,1;1,1;;104]"
        end
        if tonumber(level2) > 104 then
            formspec = formspec.."button[4,1;1,1;;105]"
        end
        if tonumber(level2) > 105 then
            formspec = formspec.."button[0,2;1,1;;106]"
        end
        if tonumber(level2) > 106 then
            formspec = formspec.."button[1,2;1,1;;107]"
        end
        if tonumber(level2) > 107 then
            formspec = formspec.."button[2,2;1,1;;108]"
        end
        if tonumber(level2) > 108 then
            formspec = formspec.."button[3,2;1,1;;109]"
        end
        if tonumber(level2) > 109 then
            formspec = formspec.."button[4,2;1,1;;110]"
        end
        if tonumber(level2) > 110 then
            formspec = formspec.."button[0,3;1,1;;111]"
        end
        if tonumber(level2) > 111 then
            formspec = formspec.."button[1,3;1,1;;112]"
        end
        if tonumber(level2) > 112 then
            formspec = formspec.."button[2,3;1,1;;113]"
        end
        if tonumber(level2) > 113 then
            formspec = formspec.."button[3,3;1,1;;114]"
        end
        if tonumber(level2) > 114 then
            formspec = formspec.."button[4,3;1,1;;115]"
        end
        if tonumber(level2) > 115 then
            formspec = formspec.."button[0,4;1,1;;116]"
        end
        if tonumber(level2) > 116 then
            formspec = formspec.."button[1,4;1,1;;117]"
        end
        if tonumber(level2) > 117 then
            formspec = formspec.."button[2,4;1,1;;118]"
        end
        if tonumber(level2) > 118 then
            formspec = formspec.."button[3,4;1,1;;119]"
        end
        if tonumber(level2) > 119 then
            formspec = formspec.."button[4,4;1,1;;120]"
        end
        if tonumber(level2) > 120 then
            formspec = formspec.."button[0,5;1,1;;121]"
        end
        if tonumber(level2) > 121 then
            formspec = formspec.."button[1,5;1,1;;122]"
        end
        if tonumber(level2) > 122 then
            formspec = formspec.."button[2,5;1,1;;123]"
        end
        if tonumber(level2) > 123 then
            formspec = formspec.."button[3,5;1,1;;124]"
        end
        if tonumber(level2) > 124 then
            formspec = formspec.."button[4,5;1,1;;125]"
        end
        if tonumber(level2) > 125 then
            formspec = formspec.."button[2.5,6;1,1;waf;>]"
        end
	return formspec		
end
local w16 = {}
w16.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level1.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/160]"
        .."button[0,1;1,1;;126]"
        formspec = formspec.."button[1.5,6;1,1;wae;<]"
        if tonumber(level2) > 126 then
            formspec = formspec.."button[1,1;1,1;;127]"
        end
        if tonumber(level2) > 127 then
            formspec = formspec.."button[2,1;1,1;;128]"
        end
        if tonumber(level2) > 128 then
            formspec = formspec.."button[3,1;1,1;;129]"
        end
        if tonumber(level2) > 129 then
            formspec = formspec.."button[4,1;1,1;;130]"
        end
        if tonumber(level2) > 130 then
            formspec = formspec.."button[0,2;1,1;;131]"
        end
        if tonumber(level2) > 131 then
            formspec = formspec.."button[1,2;1,1;;132]"
        end
        if tonumber(level2) > 132 then
            formspec = formspec.."button[2,2;1,1;;133]"
        end
        if tonumber(level2) > 133 then
            formspec = formspec.."button[3,2;1,1;;134]"
        end
        if tonumber(level2) > 134 then
            formspec = formspec.."button[4,2;1,1;;135]"
        end
        if tonumber(level2) > 135 then
            formspec = formspec.."button[0,3;1,1;;136]"
        end
        if tonumber(level2) > 136 then
            formspec = formspec.."button[1,3;1,1;;137]"
        end
        if tonumber(level2) > 137 then
            formspec = formspec.."button[2,3;1,1;;138]"
        end
        if tonumber(level2) > 138 then
            formspec = formspec.."button[3,3;1,1;;139]"
        end
        if tonumber(level2) > 139 then
            formspec = formspec.."button[4,3;1,1;;140]"
        end
        if tonumber(level2) > 140 then
            formspec = formspec.."button[0,4;1,1;;141]"
        end
        if tonumber(level2) > 141 then
            formspec = formspec.."button[1,4;1,1;;142]"
        end
        if tonumber(level2) > 142 then
            formspec = formspec.."button[2,4;1,1;;143]"
        end
        if tonumber(level2) > 143 then
            formspec = formspec.."button[3,4;1,1;;144]"
        end
        if tonumber(level2) > 144 then
            formspec = formspec.."button[4,4;1,1;;145]"
        end
        if tonumber(level2) > 145 then
            formspec = formspec.."button[0,5;1,1;;146]"
        end
        if tonumber(level2) > 146 then
            formspec = formspec.."button[1,5;1,1;;147]"
        end
        if tonumber(level2) > 147 then
            formspec = formspec.."button[2,5;1,1;;148]"
        end
        if tonumber(level2) > 148 then
            formspec = formspec.."button[3,5;1,1;;149]"
        end
        if tonumber(level2) > 149 then
            formspec = formspec.."button[4,5;1,1;;150]"
        end
        if tonumber(level2) > 150 then
            formspec = formspec.."button[2.5,6;1,1;wag;>]"
        end
	return formspec		
end
local w17 = {}
w17.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level1.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/160]"
        .."button[0,1;1,1;;151]"
        formspec = formspec.."button[1.5,6;1,1;waf;<]"
        if tonumber(level2) > 151 then
            formspec = formspec.."button[1,1;1,1;;152]"
        end
        if tonumber(level2) > 152 then
            formspec = formspec.."button[2,1;1,1;;153]"
        end
        if tonumber(level2) > 153 then
            formspec = formspec.."button[3,1;1,1;;154]"
        end
        if tonumber(level2) > 154 then
            formspec = formspec.."button[4,1;1,1;;155]"
        end
        if tonumber(level2) > 155 then
            formspec = formspec.."button[0,2;1,1;;156]"
        end
        if tonumber(level2) > 156 then
            formspec = formspec.."button[1,2;1,1;;157]"
        end
        if tonumber(level2) > 157 then
            formspec = formspec.."button[2,2;1,1;;158]"
        end
        if tonumber(level2) > 158 then
            formspec = formspec.."button[3,2;1,1;;159]"
        end
        if tonumber(level2) > 159 then
            formspec = formspec.."button[4,2;1,1;;160]"
        end
        if tonumber(level2) > 160 then
            formspec = formspec.."label[0,3;play world 2 and 3]"
        end
	return formspec		
end
local w21 = {}
w21.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level2.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/190]"
        .."button[0,1;1,1;;1]"
        if tonumber(level2) > 1 then
            formspec = formspec.."button[1,1;1,1;;2]"
        end
        if tonumber(level2) > 2 then
            formspec = formspec.."button[2,1;1,1;;3]"
        end
        if tonumber(level2) > 3 then
            formspec = formspec.."button[3,1;1,1;;4]"
        end
        if tonumber(level2) > 4 then
            formspec = formspec.."button[4,1;1,1;;5]"
        end
        if tonumber(level2) > 5 then
            formspec = formspec.."button[0,2;1,1;;6]"
        end
        if tonumber(level2) > 6 then
            formspec = formspec.."button[1,2;1,1;;7]"
        end
        if tonumber(level2) > 7 then
            formspec = formspec.."button[2,2;1,1;;8]"
        end
        if tonumber(level2) > 8 then
            formspec = formspec.."button[3,2;1,1;;9]"
        end
        if tonumber(level2) > 9 then
            formspec = formspec.."button[4,2;1,1;;10]"
        end
        if tonumber(level2) > 10 then
            formspec = formspec.."button[0,3;1,1;;11]"
        end
        if tonumber(level2) > 11 then
            formspec = formspec.."button[1,3;1,1;;12]"
        end
        if tonumber(level2) > 12 then
            formspec = formspec.."button[2,3;1,1;;13]"
        end
        if tonumber(level2) > 13 then
            formspec = formspec.."button[3,3;1,1;;14]"
        end
        if tonumber(level2) > 14 then
            formspec = formspec.."button[4,3;1,1;;15]"
        end
        if tonumber(level2) > 15 then
            formspec = formspec.."button[0,4;1,1;;16]"
        end
        if tonumber(level2) > 16 then
            formspec = formspec.."button[1,4;1,1;;17]"
        end
        if tonumber(level2) > 17 then
            formspec = formspec.."button[2,4;1,1;;18]"
        end
        if tonumber(level2) > 18 then
            formspec = formspec.."button[3,4;1,1;;19]"
        end
        if tonumber(level2) > 19 then
            formspec = formspec.."button[4,4;1,1;;20]"
        end
        if tonumber(level2) > 20 then
            formspec = formspec.."button[0,5;1,1;;21]"
        end
        if tonumber(level2) > 21 then
            formspec = formspec.."button[1,5;1,1;;22]"
        end
        if tonumber(level2) > 22 then
            formspec = formspec.."button[2,5;1,1;;23]"
        end
        if tonumber(level2) > 23 then
            formspec = formspec.."button[3,5;1,1;;24]"
        end
        if tonumber(level2) > 24 then
            formspec = formspec.."button[4,5;1,1;;25]"
        end
        if tonumber(level2) > 25 then
            formspec = formspec.."button[2.5,6;1,1;wab;>]"
        end
	return formspec		
end
local w22 = {}
w22.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level2.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/190]"
        .."button[0,1;1,1;;26]"
        .."button[1.5,6;1,1;waa;<]"
        if tonumber(level2) > 26 then
            formspec = formspec.."button[1,1;1,1;;27]"
        end
        if tonumber(level2) > 27 then
            formspec = formspec.."button[2,1;1,1;;28]"
        end
        if tonumber(level2) > 28 then
            formspec = formspec.."button[3,1;1,1;;29]"
        end
        if tonumber(level2) > 29 then
            formspec = formspec.."button[4,1;1,1;;30]"
        end
        if tonumber(level2) > 30 then
            formspec = formspec.."button[0,2;1,1;;31]"
        end
        if tonumber(level2) > 31 then
            formspec = formspec.."button[1,2;1,1;;32]"
        end
        if tonumber(level2) > 32 then
            formspec = formspec.."button[2,2;1,1;;33]"
        end
        if tonumber(level2) > 33 then
            formspec = formspec.."button[3,2;1,1;;34]"
        end
        if tonumber(level2) > 34 then
            formspec = formspec.."button[4,2;1,1;;35]"
        end
        if tonumber(level2) > 35 then
            formspec = formspec.."button[0,3;1,1;;36]"
        end
        if tonumber(level2) > 36 then
            formspec = formspec.."button[1,3;1,1;;37]"
        end
        if tonumber(level2) > 37 then
            formspec = formspec.."button[2,3;1,1;;38]"
        end
        if tonumber(level2) > 38 then
            formspec = formspec.."button[3,3;1,1;;39]"
        end
        if tonumber(level2) > 39 then
            formspec = formspec.."button[4,3;1,1;;40]"
        end
        if tonumber(level2) > 40 then
            formspec = formspec.."button[0,4;1,1;;41]"
        end
        if tonumber(level2) > 41 then
            formspec = formspec.."button[1,4;1,1;;42]"
        end
        if tonumber(level2) > 42 then
            formspec = formspec.."button[2,4;1,1;;43]"
        end
        if tonumber(level2) > 43 then
            formspec = formspec.."button[3,4;1,1;;44]"
        end
        if tonumber(level2) > 44 then
            formspec = formspec.."button[4,4;1,1;;45]"
        end
        if tonumber(level2) > 45 then
            formspec = formspec.."button[0,5;1,1;;46]"
        end
        if tonumber(level2) > 46 then
            formspec = formspec.."button[1,5;1,1;;47]"
        end
        if tonumber(level2) > 47 then
            formspec = formspec.."button[2,5;1,1;;48]"
        end
        if tonumber(level2) > 48 then
            formspec = formspec.."button[3,5;1,1;;49]"
        end
        if tonumber(level2) > 49 then
            formspec = formspec.."button[4,5;1,1;;50]"
        end
        if tonumber(level2) > 50 then
            formspec = formspec.."button[2.5,6;1,1;wac;>]"
        end
	return formspec		
end
local w23 = {}
w23.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level2.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/190]"
        .."button[0,1;1,1;;51]"
        .."button[1.5,6;1,1;wab;<]"
        if tonumber(level2) > 51 then
            formspec = formspec.."button[1,1;1,1;;52]"
        end
        if tonumber(level2) > 52 then
            formspec = formspec.."button[2,1;1,1;;53]"
        end
        if tonumber(level2) > 53 then
            formspec = formspec.."button[3,1;1,1;;54]"
        end
        if tonumber(level2) > 54 then
            formspec = formspec.."button[4,1;1,1;;55]"
        end
        if tonumber(level2) > 55 then
            formspec = formspec.."button[0,2;1,1;;56]"
        end
        if tonumber(level2) > 56 then
            formspec = formspec.."button[1,2;1,1;;57]"
        end
        if tonumber(level2) > 57 then
            formspec = formspec.."button[2,2;1,1;;58]"
        end
        if tonumber(level2) > 58 then
            formspec = formspec.."button[3,2;1,1;;59]"
        end
        if tonumber(level2) > 59 then
            formspec = formspec.."button[4,2;1,1;;60]"
        end
        if tonumber(level2) > 60 then
            formspec = formspec.."button[0,3;1,1;;61]"
        end
        if tonumber(level2) > 61 then
            formspec = formspec.."button[1,3;1,1;;62]"
        end
        if tonumber(level2) > 62 then
            formspec = formspec.."button[2,3;1,1;;63]"
        end
        if tonumber(level2) > 63 then
            formspec = formspec.."button[3,3;1,1;;64]"
        end
        if tonumber(level2) > 64 then
            formspec = formspec.."button[4,3;1,1;;65]"
        end
        if tonumber(level2) > 65 then
            formspec = formspec.."button[0,4;1,1;;66]"
        end
        if tonumber(level2) > 66 then
            formspec = formspec.."button[1,4;1,1;;67]"
        end
        if tonumber(level2) > 67 then
            formspec = formspec.."button[2,4;1,1;;68]"
        end
        if tonumber(level2) > 68 then
            formspec = formspec.."button[3,4;1,1;;69]"
        end
        if tonumber(level2) > 69 then
            formspec = formspec.."button[4,4;1,1;;70]"
        end
        if tonumber(level2) > 70 then
            formspec = formspec.."button[0,5;1,1;;71]"
        end
        if tonumber(level2) > 71 then
            formspec = formspec.."button[1,5;1,1;;72]"
        end
        if tonumber(level2) > 72 then
            formspec = formspec.."button[2,5;1,1;;73]"
        end
        if tonumber(level2) > 73 then
            formspec = formspec.."button[3,5;1,1;;74]"
        end
        if tonumber(level2) > 74 then
            formspec = formspec.."button[4,5;1,1;;75]"
        end
        if tonumber(level2) > 75 then
            formspec = formspec.."button[2.5,6;1,1;wad;>]"
        end
	return formspec		
end
local w24 = {}
w24.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level2.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/190]"
        .."button[0,1;1,1;;76]"
        .."button[1.5,6;1,1;wac;<]"
        if tonumber(level2) > 76 then
            formspec = formspec.."button[1,1;1,1;;77]"
        end
        if tonumber(level2) > 77 then
            formspec = formspec.."button[2,1;1,1;;78]"
        end
        if tonumber(level2) > 78 then
            formspec = formspec.."button[3,1;1,1;;79]"
        end
        if tonumber(level2) > 79 then
            formspec = formspec.."button[4,1;1,1;;80]"
        end
        if tonumber(level2) > 80 then
            formspec = formspec.."button[0,2;1,1;;81]"
        end
        if tonumber(level2) > 81 then
            formspec = formspec.."button[1,2;1,1;;82]"
        end
        if tonumber(level2) > 82 then
            formspec = formspec.."button[2,2;1,1;;83]"
        end
        if tonumber(level2) > 83 then
            formspec = formspec.."button[3,2;1,1;;84]"
        end
        if tonumber(level2) > 84 then
            formspec = formspec.."button[4,2;1,1;;85]"
        end
        if tonumber(level2) > 85 then
            formspec = formspec.."button[0,3;1,1;;86]"
        end
        if tonumber(level2) > 86 then
            formspec = formspec.."button[1,3;1,1;;87]"
        end
        if tonumber(level2) > 87 then
            formspec = formspec.."button[2,3;1,1;;88]"
        end
        if tonumber(level2) > 88 then
            formspec = formspec.."button[3,3;1,1;;89]"
        end
        if tonumber(level2) > 89 then
            formspec = formspec.."button[4,3;1,1;;90]"
        end
        if tonumber(level2) > 90 then
            formspec = formspec.."button[0,4;1,1;;91]"
        end
        if tonumber(level2) > 91 then
            formspec = formspec.."button[1,4;1,1;;92]"
        end
        if tonumber(level2) > 92 then
            formspec = formspec.."button[2,4;1,1;;93]"
        end
        if tonumber(level2) > 93 then
            formspec = formspec.."button[3,4;1,1;;94]"
        end
        if tonumber(level2) > 94 then
            formspec = formspec.."button[4,4;1,1;;95]"
        end
        if tonumber(level2) > 95 then
            formspec = formspec.."button[0,5;1,1;;96]"
        end
        if tonumber(level2) > 96 then
            formspec = formspec.."button[1,5;1,1;;97]"
        end
        if tonumber(level2) > 97 then
            formspec = formspec.."button[2,5;1,1;;98]"
        end
        if tonumber(level2) > 98 then
            formspec = formspec.."button[3,5;1,1;;99]"
        end
        if tonumber(level2) > 99 then
            formspec = formspec.."button[4,5;1,1;;100]"
        end
        if tonumber(level2) > 100 then
            formspec = formspec.."button[2.5,6;1,1;wae;>]"
        end
	return formspec		
end
local w25 = {}
w25.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level2.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/190]"
        .."button[0,1;1,1;;101]"
        .."button[1.5,6;1,1;wad;<]"
        if tonumber(level2) > 101 then
            formspec = formspec.."button[1,1;1,1;;102]"
        end
        if tonumber(level2) > 102 then
            formspec = formspec.."button[2,1;1,1;;103]"
        end
        if tonumber(level2) > 103 then
            formspec = formspec.."button[3,1;1,1;;104]"
        end
        if tonumber(level2) > 104 then
            formspec = formspec.."button[4,1;1,1;;105]"
        end
        if tonumber(level2) > 105 then
            formspec = formspec.."button[0,2;1,1;;106]"
        end
        if tonumber(level2) > 106 then
            formspec = formspec.."button[1,2;1,1;;107]"
        end
        if tonumber(level2) > 107 then
            formspec = formspec.."button[2,2;1,1;;108]"
        end
        if tonumber(level2) > 108 then
            formspec = formspec.."button[3,2;1,1;;109]"
        end
        if tonumber(level2) > 109 then
            formspec = formspec.."button[4,2;1,1;;110]"
        end
        if tonumber(level2) > 110 then
            formspec = formspec.."button[0,3;1,1;;111]"
        end
        if tonumber(level2) > 111 then
            formspec = formspec.."button[1,3;1,1;;112]"
        end
        if tonumber(level2) > 112 then
            formspec = formspec.."button[2,3;1,1;;113]"
        end
        if tonumber(level2) > 113 then
            formspec = formspec.."button[3,3;1,1;;114]"
        end
        if tonumber(level2) > 114 then
            formspec = formspec.."button[4,3;1,1;;115]"
        end
        if tonumber(level2) > 115 then
            formspec = formspec.."button[0,4;1,1;;116]"
        end
        if tonumber(level2) > 116 then
            formspec = formspec.."button[1,4;1,1;;117]"
        end
        if tonumber(level2) > 117 then
            formspec = formspec.."button[2,4;1,1;;118]"
        end
        if tonumber(level2) > 118 then
            formspec = formspec.."button[3,4;1,1;;119]"
        end
        if tonumber(level2) > 119 then
            formspec = formspec.."button[4,4;1,1;;120]"
        end
        if tonumber(level2) > 120 then
            formspec = formspec.."button[0,5;1,1;;121]"
        end
        if tonumber(level2) > 121 then
            formspec = formspec.."button[1,5;1,1;;122]"
        end
        if tonumber(level2) > 122 then
            formspec = formspec.."button[2,5;1,1;;123]"
        end
        if tonumber(level2) > 123 then
            formspec = formspec.."button[3,5;1,1;;124]"
        end
        if tonumber(level2) > 124 then
            formspec = formspec.."button[4,5;1,1;;125]"
        end
        if tonumber(level2) > 125 then
            formspec = formspec.."button[2.5,6;1,1;waf;>]"
        end
	return formspec		
end
local w26 = {}
w26.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level2.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/190]"
        .."button[0,1;1,1;;126]"
        .."button[1.5,6;1,1;wae;<]"
        if tonumber(level2) > 126 then
            formspec = formspec.."button[1,1;1,1;;127]"
        end
        if tonumber(level2) > 127 then
            formspec = formspec.."button[2,1;1,1;;128]"
        end
        if tonumber(level2) > 128 then
            formspec = formspec.."button[3,1;1,1;;129]"
        end
        if tonumber(level2) > 129 then
            formspec = formspec.."button[4,1;1,1;;130]"
        end
        if tonumber(level2) > 130 then
            formspec = formspec.."button[0,2;1,1;;131]"
        end
        if tonumber(level2) > 131 then
            formspec = formspec.."button[1,2;1,1;;132]"
        end
        if tonumber(level2) > 132 then
            formspec = formspec.."button[2,2;1,1;;133]"
        end
        if tonumber(level2) > 133 then
            formspec = formspec.."button[3,2;1,1;;134]"
        end
        if tonumber(level2) > 134 then
            formspec = formspec.."button[4,2;1,1;;135]"
        end
        if tonumber(level2) > 135 then
            formspec = formspec.."button[0,3;1,1;;136]"
        end
        if tonumber(level2) > 136 then
            formspec = formspec.."button[1,3;1,1;;137]"
        end
        if tonumber(level2) > 137 then
            formspec = formspec.."button[2,3;1,1;;138]"
        end
        if tonumber(level2) > 138 then
            formspec = formspec.."button[3,3;1,1;;139]"
        end
        if tonumber(level2) > 139 then
            formspec = formspec.."button[4,3;1,1;;140]"
        end
        if tonumber(level2) > 140 then
            formspec = formspec.."button[0,4;1,1;;141]"
        end
        if tonumber(level2) > 141 then
            formspec = formspec.."button[1,4;1,1;;142]"
        end
        if tonumber(level2) > 142 then
            formspec = formspec.."button[2,4;1,1;;143]"
        end
        if tonumber(level2) > 143 then
            formspec = formspec.."button[3,4;1,1;;144]"
        end
        if tonumber(level2) > 144 then
            formspec = formspec.."button[4,4;1,1;;145]"
        end
        if tonumber(level2) > 145 then
            formspec = formspec.."button[0,5;1,1;;146]"
        end
        if tonumber(level2) > 146 then
            formspec = formspec.."button[1,5;1,1;;147]"
        end
        if tonumber(level2) > 147 then
            formspec = formspec.."button[2,5;1,1;;148]"
        end
        if tonumber(level2) > 148 then
            formspec = formspec.."button[3,5;1,1;;149]"
        end
        if tonumber(level2) > 149 then
            formspec = formspec.."button[4,5;1,1;;150]"
        end
        if tonumber(level2) > 150 then
            formspec = formspec.."button[2.5,6;1,1;wag;>]"
        end
	return formspec		
end
local w27 = {}
w27.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level2.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/190]"
        .."button[0,1;1,1;;151]"
        .."button[1.5,6;1,1;waf;<]"
        if tonumber(level2) > 151 then
            formspec = formspec.."button[1,1;1,1;;152]"
        end
        if tonumber(level2) > 152 then
            formspec = formspec.."button[2,1;1,1;;153]"
        end
        if tonumber(level2) > 153 then
            formspec = formspec.."button[3,1;1,1;;154]"
        end
        if tonumber(level2) > 154 then
            formspec = formspec.."button[4,1;1,1;;155]"
        end
        if tonumber(level2) > 155 then
            formspec = formspec.."button[0,2;1,1;;156]"
        end
        if tonumber(level2) > 156 then
            formspec = formspec.."button[1,2;1,1;;157]"
        end
        if tonumber(level2) > 157 then
            formspec = formspec.."button[2,2;1,1;;158]"
        end
        if tonumber(level2) > 158 then
            formspec = formspec.."button[3,2;1,1;;159]"
        end
        if tonumber(level2) > 159 then
            formspec = formspec.."button[4,2;1,1;;160]"
        end
        if tonumber(level2) > 160 then
            formspec = formspec.."button[0,3;1,1;;161]"
        end
        if tonumber(level2) > 161 then
            formspec = formspec.."button[1,3;1,1;;162]"
        end
        if tonumber(level2) > 162 then
            formspec = formspec.."button[2,3;1,1;;163]"
        end
        if tonumber(level2) > 163 then
            formspec = formspec.."button[3,3;1,1;;164]"
        end
        if tonumber(level2) > 164 then
            formspec = formspec.."button[4,3;1,1;;165]"
        end
        if tonumber(level2) > 165 then
            formspec = formspec.."button[0,4;1,1;;166]"
        end
        if tonumber(level2) > 166 then
            formspec = formspec.."button[1,4;1,1;;167]"
        end
        if tonumber(level2) > 167 then
            formspec = formspec.."button[2,4;1,1;;168]"
        end
        if tonumber(level2) > 168 then
            formspec = formspec.."button[3,4;1,1;;169]"
        end
        if tonumber(level2) > 169 then
            formspec = formspec.."button[4,4;1,1;;170]"
        end
        if tonumber(level2) > 170 then
            formspec = formspec.."button[0,5;1,1;;171]"
        end
        if tonumber(level2) > 171 then
            formspec = formspec.."button[1,5;1,1;;172]"
        end
        if tonumber(level2) > 172 then
            formspec = formspec.."button[2,5;1,1;;173]"
        end
        if tonumber(level2) > 173 then
            formspec = formspec.."button[3,5;1,1;;174]"
        end
        if tonumber(level2) > 174 then
            formspec = formspec.."button[4,5;1,1;;175]"
        end
        if tonumber(level2) > 175 then
            formspec = formspec.."button[2.5,6;1,1;wah;>]"
        end
	return formspec		
end
local w28 = {}
w28.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level2.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/190]"
        .."button[0,1;1,1;;176]"
        .."button[1.5,6;1,1;wag;<]"
        if tonumber(level2) > 176 then
            formspec = formspec.."button[1,1;1,1;;177]"
        end
        if tonumber(level2) > 177 then
            formspec = formspec.."button[2,1;1,1;;178]"
        end
        if tonumber(level2) > 178 then
            formspec = formspec.."button[3,1;1,1;;179]"
        end
        if tonumber(level2) > 179 then
            formspec = formspec.."button[4,1;1,1;;180]"
        end
        if tonumber(level2) > 180 then
            formspec = formspec.."button[0,2;1,1;;181]"
        end
        if tonumber(level2) > 181 then
            formspec = formspec.."button[1,2;1,1;;182]"
        end
        if tonumber(level2) > 182 then
            formspec = formspec.."button[2,2;1,1;;183]"
        end
        if tonumber(level2) > 183 then
            formspec = formspec.."button[3,2;1,1;;184]"
        end
        if tonumber(level2) > 184 then
            formspec = formspec.."button[4,2;1,1;;185]"
        end
        if tonumber(level2) > 185 then
            formspec = formspec.."button[0,3;1,1;;186]"
        end
        if tonumber(level2) > 186 then
            formspec = formspec.."button[1,3;1,1;;187]"
        end
        if tonumber(level2) > 187 then
            formspec = formspec.."button[2,3;1,1;;188]"
        end
        if tonumber(level2) > 188 then
            formspec = formspec.."button[3,3;1,1;;189]"
        end
        if tonumber(level2) > 189 then
            formspec = formspec.."button[4,3;1,1;;190]"
        end
        if tonumber(level2) > 190 then
            formspec = formspec.."label[0,4;play world 1 and 3]"
        end
	return formspec		
end
local w31 = {}
w31.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level3.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/222]"
        .."button[0,1;1,1;;1]"
        if tonumber(level2) > 1 then
            formspec = formspec.."button[1,1;1,1;;2]"
        end
        if tonumber(level2) > 2 then
            formspec = formspec.."button[2,1;1,1;;3]"
        end
        if tonumber(level2) > 3 then
            formspec = formspec.."button[3,1;1,1;;4]"
        end
        if tonumber(level2) > 4 then
            formspec = formspec.."button[4,1;1,1;;5]"
        end
        if tonumber(level2) > 5 then
            formspec = formspec.."button[0,2;1,1;;6]"
        end
        if tonumber(level2) > 6 then
            formspec = formspec.."button[1,2;1,1;;7]"
        end
        if tonumber(level2) > 7 then
            formspec = formspec.."button[2,2;1,1;;8]"
        end
        if tonumber(level2) > 8 then
            formspec = formspec.."button[3,2;1,1;;9]"
        end
        if tonumber(level2) > 9 then
            formspec = formspec.."button[4,2;1,1;;10]"
        end
        if tonumber(level2) > 10 then
            formspec = formspec.."button[0,3;1,1;;11]"
        end
        if tonumber(level2) > 11 then
            formspec = formspec.."button[1,3;1,1;;12]"
        end
        if tonumber(level2) > 12 then
            formspec = formspec.."button[2,3;1,1;;13]"
        end
        if tonumber(level2) > 13 then
            formspec = formspec.."button[3,3;1,1;;14]"
        end
        if tonumber(level2) > 14 then
            formspec = formspec.."button[4,3;1,1;;15]"
        end
        if tonumber(level2) > 15 then
            formspec = formspec.."button[0,4;1,1;;16]"
        end
        if tonumber(level2) > 16 then
            formspec = formspec.."button[1,4;1,1;;17]"
        end
        if tonumber(level2) > 17 then
            formspec = formspec.."button[2,4;1,1;;18]"
        end
        if tonumber(level2) > 18 then
            formspec = formspec.."button[3,4;1,1;;19]"
        end
        if tonumber(level2) > 19 then
            formspec = formspec.."button[4,4;1,1;;20]"
        end
        if tonumber(level2) > 20 then
            formspec = formspec.."button[0,5;1,1;;21]"
        end
        if tonumber(level2) > 21 then
            formspec = formspec.."button[1,5;1,1;;22]"
        end
        if tonumber(level2) > 22 then
            formspec = formspec.."button[2,5;1,1;;23]"
        end
        if tonumber(level2) > 23 then
            formspec = formspec.."button[3,5;1,1;;24]"
        end
        if tonumber(level2) > 24 then
            formspec = formspec.."button[4,5;1,1;;25]"
        end
        if tonumber(level2) > 25 then
            formspec = formspec.."button[2.5,6;1,1;wab;>]"
        end
	return formspec		
end
local w32 = {}
w32.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level3.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/222]"
        .."button[0,1;1,1;;26]"
        .."button[1.5,6;1,1;waa;<]"
        if tonumber(level2) > 26 then
            formspec = formspec.."button[1,1;1,1;;27]"
        end
        if tonumber(level2) > 27 then
            formspec = formspec.."button[2,1;1,1;;28]"
        end
        if tonumber(level2) > 28 then
            formspec = formspec.."button[3,1;1,1;;29]"
        end
        if tonumber(level2) > 29 then
            formspec = formspec.."button[4,1;1,1;;30]"
        end
        if tonumber(level2) > 30 then
            formspec = formspec.."button[0,2;1,1;;31]"
        end
        if tonumber(level2) > 31 then
            formspec = formspec.."button[1,2;1,1;;32]"
        end
        if tonumber(level2) > 32 then
            formspec = formspec.."button[2,2;1,1;;33]"
        end
        if tonumber(level2) > 33 then
            formspec = formspec.."button[3,2;1,1;;34]"
        end
        if tonumber(level2) > 34 then
            formspec = formspec.."button[4,2;1,1;;35]"
        end
        if tonumber(level2) > 35 then
            formspec = formspec.."button[0,3;1,1;;36]"
        end
        if tonumber(level2) > 36 then
            formspec = formspec.."button[1,3;1,1;;37]"
        end
        if tonumber(level2) > 37 then
            formspec = formspec.."button[2,3;1,1;;38]"
        end
        if tonumber(level2) > 38 then
            formspec = formspec.."button[3,3;1,1;;39]"
        end
        if tonumber(level2) > 39 then
            formspec = formspec.."button[4,3;1,1;;40]"
        end
        if tonumber(level2) > 40 then
            formspec = formspec.."button[0,4;1,1;;41]"
        end
        if tonumber(level2) > 41 then
            formspec = formspec.."button[1,4;1,1;;42]"
        end
        if tonumber(level2) > 42 then
            formspec = formspec.."button[2,4;1,1;;43]"
        end
        if tonumber(level2) > 43 then
            formspec = formspec.."button[3,4;1,1;;44]"
        end
        if tonumber(level2) > 44 then
            formspec = formspec.."button[4,4;1,1;;45]"
        end
        if tonumber(level2) > 45 then
            formspec = formspec.."button[0,5;1,1;;46]"
        end
        if tonumber(level2) > 46 then
            formspec = formspec.."button[1,5;1,1;;47]"
        end
        if tonumber(level2) > 47 then
            formspec = formspec.."button[2,5;1,1;;48]"
        end
        if tonumber(level2) > 48 then
            formspec = formspec.."button[3,5;1,1;;49]"
        end
        if tonumber(level2) > 49 then
            formspec = formspec.."button[4,5;1,1;;50]"
        end
        if tonumber(level2) > 50 then
            formspec = formspec.."button[2.5,6;1,1;wac;>]"
        end
	return formspec		
end
local w33 = {}
w33.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level3.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/222]"
        .."button[0,1;1,1;;51]"
        .."button[1.5,6;1,1;wab;<]"
        if tonumber(level2) > 51 then
            formspec = formspec.."button[1,1;1,1;;52]"
        end
        if tonumber(level2) > 52 then
            formspec = formspec.."button[2,1;1,1;;53]"
        end
        if tonumber(level2) > 53 then
            formspec = formspec.."button[3,1;1,1;;54]"
        end
        if tonumber(level2) > 54 then
            formspec = formspec.."button[4,1;1,1;;55]"
        end
        if tonumber(level2) > 55 then
            formspec = formspec.."button[0,2;1,1;;56]"
        end
        if tonumber(level2) > 56 then
            formspec = formspec.."button[1,2;1,1;;57]"
        end
        if tonumber(level2) > 57 then
            formspec = formspec.."button[2,2;1,1;;58]"
        end
        if tonumber(level2) > 58 then
            formspec = formspec.."button[3,2;1,1;;59]"
        end
        if tonumber(level2) > 59 then
            formspec = formspec.."button[4,2;1,1;;60]"
        end
        if tonumber(level2) > 60 then
            formspec = formspec.."button[0,3;1,1;;61]"
        end
        if tonumber(level2) > 61 then
            formspec = formspec.."button[1,3;1,1;;62]"
        end
        if tonumber(level2) > 62 then
            formspec = formspec.."button[2,3;1,1;;63]"
        end
        if tonumber(level2) > 63 then
            formspec = formspec.."button[3,3;1,1;;64]"
        end
        if tonumber(level2) > 64 then
            formspec = formspec.."button[4,3;1,1;;65]"
        end
        if tonumber(level2) > 65 then
            formspec = formspec.."button[0,4;1,1;;66]"
        end
        if tonumber(level2) > 66 then
            formspec = formspec.."button[1,4;1,1;;67]"
        end
        if tonumber(level2) > 67 then
            formspec = formspec.."button[2,4;1,1;;68]"
        end
        if tonumber(level2) > 68 then
            formspec = formspec.."button[3,4;1,1;;69]"
        end
        if tonumber(level2) > 69 then
            formspec = formspec.."button[4,4;1,1;;70]"
        end
        if tonumber(level2) > 70 then
            formspec = formspec.."button[0,5;1,1;;71]"
        end
        if tonumber(level2) > 71 then
            formspec = formspec.."button[1,5;1,1;;72]"
        end
        if tonumber(level2) > 72 then
            formspec = formspec.."button[2,5;1,1;;73]"
        end
        if tonumber(level2) > 73 then
            formspec = formspec.."button[3,5;1,1;;74]"
        end
        if tonumber(level2) > 74 then
            formspec = formspec.."button[4,5;1,1;;75]"
        end
        if tonumber(level2) > 75 then
            formspec = formspec.."button[2.5,6;1,1;wad;>]"
        end
	return formspec		
end
local w34 = {}
w34.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level3.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/222]"
        .."button[0,1;1,1;;76]"
        .."button[1.5,6;1,1;wac;<]"
        if tonumber(level2) > 76 then
            formspec = formspec.."button[1,1;1,1;;77]"
        end
        if tonumber(level2) > 77 then
            formspec = formspec.."button[2,1;1,1;;78]"
        end
        if tonumber(level2) > 78 then
            formspec = formspec.."button[3,1;1,1;;79]"
        end
        if tonumber(level2) > 79 then
            formspec = formspec.."button[4,1;1,1;;80]"
        end
        if tonumber(level2) > 80 then
            formspec = formspec.."button[0,2;1,1;;81]"
        end
        if tonumber(level2) > 81 then
            formspec = formspec.."button[1,2;1,1;;82]"
        end
        if tonumber(level2) > 82 then
            formspec = formspec.."button[2,2;1,1;;83]"
        end
        if tonumber(level2) > 83 then
            formspec = formspec.."button[3,2;1,1;;84]"
        end
        if tonumber(level2) > 84 then
            formspec = formspec.."button[4,2;1,1;;85]"
        end
        if tonumber(level2) > 85 then
            formspec = formspec.."button[0,3;1,1;;86]"
        end
        if tonumber(level2) > 86 then
            formspec = formspec.."button[1,3;1,1;;87]"
        end
        if tonumber(level2) > 87 then
            formspec = formspec.."button[2,3;1,1;;88]"
        end
        if tonumber(level2) > 88 then
            formspec = formspec.."button[3,3;1,1;;89]"
        end
        if tonumber(level2) > 89 then
            formspec = formspec.."button[4,3;1,1;;90]"
        end
        if tonumber(level2) > 90 then
            formspec = formspec.."button[0,4;1,1;;91]"
        end
        if tonumber(level2) > 91 then
            formspec = formspec.."button[1,4;1,1;;92]"
        end
        if tonumber(level2) > 92 then
            formspec = formspec.."button[2,4;1,1;;93]"
        end
        if tonumber(level2) > 93 then
            formspec = formspec.."button[3,4;1,1;;94]"
        end
        if tonumber(level2) > 94 then
            formspec = formspec.."button[4,4;1,1;;95]"
        end
        if tonumber(level2) > 95 then
            formspec = formspec.."button[0,5;1,1;;96]"
        end
        if tonumber(level2) > 96 then
            formspec = formspec.."button[1,5;1,1;;97]"
        end
        if tonumber(level2) > 97 then
            formspec = formspec.."button[2,5;1,1;;98]"
        end
        if tonumber(level2) > 98 then
            formspec = formspec.."button[3,5;1,1;;99]"
        end
        if tonumber(level2) > 99 then
            formspec = formspec.."button[4,5;1,1;;100]"
        end
        if tonumber(level2) > 100 then
            formspec = formspec.."button[2.5,6;1,1;wae;>]"
        end
	return formspec		
end
local w35 = {}
w35.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level3.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/222]"
        .."button[0,1;1,1;;101]"
        .."button[1.5,6;1,1;wad;<]"
        if tonumber(level2) > 101 then
            formspec = formspec.."button[1,1;1,1;;102]"
        end
        if tonumber(level2) > 102 then
            formspec = formspec.."button[2,1;1,1;;103]"
        end
        if tonumber(level2) > 103 then
            formspec = formspec.."button[3,1;1,1;;104]"
        end
        if tonumber(level2) > 104 then
            formspec = formspec.."button[4,1;1,1;;105]"
        end
        if tonumber(level2) > 105 then
            formspec = formspec.."button[0,2;1,1;;106]"
        end
        if tonumber(level2) > 106 then
            formspec = formspec.."button[1,2;1,1;;107]"
        end
        if tonumber(level2) > 107 then
            formspec = formspec.."button[2,2;1,1;;108]"
        end
        if tonumber(level2) > 108 then
            formspec = formspec.."button[3,2;1,1;;109]"
        end
        if tonumber(level2) > 109 then
            formspec = formspec.."button[4,2;1,1;;110]"
        end
        if tonumber(level2) > 110 then
            formspec = formspec.."button[0,3;1,1;;111]"
        end
        if tonumber(level2) > 111 then
            formspec = formspec.."button[1,3;1,1;;112]"
        end
        if tonumber(level2) > 112 then
            formspec = formspec.."button[2,3;1,1;;113]"
        end
        if tonumber(level2) > 113 then
            formspec = formspec.."button[3,3;1,1;;114]"
        end
        if tonumber(level2) > 114 then
            formspec = formspec.."button[4,3;1,1;;115]"
        end
        if tonumber(level2) > 115 then
            formspec = formspec.."button[0,4;1,1;;116]"
        end
        if tonumber(level2) > 116 then
            formspec = formspec.."button[1,4;1,1;;117]"
        end
        if tonumber(level2) > 117 then
            formspec = formspec.."button[2,4;1,1;;118]"
        end
        if tonumber(level2) > 118 then
            formspec = formspec.."button[3,4;1,1;;119]"
        end
        if tonumber(level2) > 119 then
            formspec = formspec.."button[4,4;1,1;;120]"
        end
        if tonumber(level2) > 120 then
            formspec = formspec.."button[0,5;1,1;;121]"
        end
        if tonumber(level2) > 121 then
            formspec = formspec.."button[1,5;1,1;;122]"
        end
        if tonumber(level2) > 122 then
            formspec = formspec.."button[2,5;1,1;;123]"
        end
        if tonumber(level2) > 123 then
            formspec = formspec.."button[3,5;1,1;;124]"
        end
        if tonumber(level2) > 124 then
            formspec = formspec.."button[4,5;1,1;;125]"
        end
        if tonumber(level2) > 125 then
            formspec = formspec.."button[2.5,6;1,1;waf;>]"
        end
	return formspec		
end
local w36 = {}
w36.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level3.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/222]"
        .."button[0,1;1,1;;126]"
        .."button[1.5,6;1,1;wae;<]"
        if tonumber(level2) > 126 then
            formspec = formspec.."button[1,1;1,1;;127]"
        end
        if tonumber(level2) > 127 then
            formspec = formspec.."button[2,1;1,1;;128]"
        end
        if tonumber(level2) > 128 then
            formspec = formspec.."button[3,1;1,1;;129]"
        end
        if tonumber(level2) > 129 then
            formspec = formspec.."button[4,1;1,1;;130]"
        end
        if tonumber(level2) > 130 then
            formspec = formspec.."button[0,2;1,1;;131]"
        end
        if tonumber(level2) > 131 then
            formspec = formspec.."button[1,2;1,1;;132]"
        end
        if tonumber(level2) > 132 then
            formspec = formspec.."button[2,2;1,1;;133]"
        end
        if tonumber(level2) > 133 then
            formspec = formspec.."button[3,2;1,1;;134]"
        end
        if tonumber(level2) > 134 then
            formspec = formspec.."button[4,2;1,1;;135]"
        end
        if tonumber(level2) > 135 then
            formspec = formspec.."button[0,3;1,1;;136]"
        end
        if tonumber(level2) > 136 then
            formspec = formspec.."button[1,3;1,1;;137]"
        end
        if tonumber(level2) > 137 then
            formspec = formspec.."button[2,3;1,1;;138]"
        end
        if tonumber(level2) > 138 then
            formspec = formspec.."button[3,3;1,1;;139]"
        end
        if tonumber(level2) > 139 then
            formspec = formspec.."button[4,3;1,1;;140]"
        end
        if tonumber(level2) > 140 then
            formspec = formspec.."button[0,4;1,1;;141]"
        end
        if tonumber(level2) > 141 then
            formspec = formspec.."button[1,4;1,1;;142]"
        end
        if tonumber(level2) > 142 then
            formspec = formspec.."button[2,4;1,1;;143]"
        end
        if tonumber(level2) > 143 then
            formspec = formspec.."button[3,4;1,1;;144]"
        end
        if tonumber(level2) > 144 then
            formspec = formspec.."button[4,4;1,1;;145]"
        end
        if tonumber(level2) > 145 then
            formspec = formspec.."button[0,5;1,1;;146]"
        end
        if tonumber(level2) > 146 then
            formspec = formspec.."button[1,5;1,1;;147]"
        end
        if tonumber(level2) > 147 then
            formspec = formspec.."button[2,5;1,1;;148]"
        end
        if tonumber(level2) > 148 then
            formspec = formspec.."button[3,5;1,1;;149]"
        end
        if tonumber(level2) > 149 then
            formspec = formspec.."button[4,5;1,1;;150]"
        end
        if tonumber(level2) > 150 then
            formspec = formspec.."button[2.5,6;1,1;wag;>]"
        end
	return formspec		
end
local w37 = {}
w37.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level3.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/222]"
        .."button[0,1;1,1;;151]"
        .."button[1.5,6;1,1;waf;<]"
        if tonumber(level2) > 151 then
            formspec = formspec.."button[1,1;1,1;;152]"
        end
        if tonumber(level2) > 152 then
            formspec = formspec.."button[2,1;1,1;;153]"
        end
        if tonumber(level2) > 153 then
            formspec = formspec.."button[3,1;1,1;;154]"
        end
        if tonumber(level2) > 154 then
            formspec = formspec.."button[4,1;1,1;;155]"
        end
        if tonumber(level2) > 155 then
            formspec = formspec.."button[0,2;1,1;;156]"
        end
        if tonumber(level2) > 156 then
            formspec = formspec.."button[1,2;1,1;;157]"
        end
        if tonumber(level2) > 157 then
            formspec = formspec.."button[2,2;1,1;;158]"
        end
        if tonumber(level2) > 158 then
            formspec = formspec.."button[3,2;1,1;;159]"
        end
        if tonumber(level2) > 159 then
            formspec = formspec.."button[4,2;1,1;;160]"
        end
        if tonumber(level2) > 160 then
            formspec = formspec.."button[0,3;1,1;;161]"
        end
        if tonumber(level2) > 161 then
            formspec = formspec.."button[1,3;1,1;;162]"
        end
        if tonumber(level2) > 162 then
            formspec = formspec.."button[2,3;1,1;;163]"
        end
        if tonumber(level2) > 163 then
            formspec = formspec.."button[3,3;1,1;;164]"
        end
        if tonumber(level2) > 164 then
            formspec = formspec.."button[4,3;1,1;;165]"
        end
        if tonumber(level2) > 165 then
            formspec = formspec.."button[0,4;1,1;;166]"
        end
        if tonumber(level2) > 166 then
            formspec = formspec.."button[1,4;1,1;;167]"
        end
        if tonumber(level2) > 167 then
            formspec = formspec.."button[2,4;1,1;;168]"
        end
        if tonumber(level2) > 168 then
            formspec = formspec.."button[3,4;1,1;;169]"
        end
        if tonumber(level2) > 169 then
            formspec = formspec.."button[4,4;1,1;;170]"
        end
        if tonumber(level2) > 170 then
            formspec = formspec.."button[0,5;1,1;;171]"
        end
        if tonumber(level2) > 171 then
            formspec = formspec.."button[1,5;1,1;;172]"
        end
        if tonumber(level2) > 172 then
            formspec = formspec.."button[2,5;1,1;;173]"
        end
        if tonumber(level2) > 173 then
            formspec = formspec.."button[3,5;1,1;;174]"
        end
        if tonumber(level2) > 174 then
            formspec = formspec.."button[4,5;1,1;;175]"
        end
        if tonumber(level2) > 175 then
            formspec = formspec.."button[2.5,6;1,1;wah;>]"
        end
	return formspec		
end
local w38 = {}
w38.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level3.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/222]"
        .."button[0,1;1,1;;176]"
        .."button[1.5,6;1,1;wag;<]"
        if tonumber(level2) > 176 then
            formspec = formspec.."button[1,1;1,1;;177]"
        end
        if tonumber(level2) > 177 then
            formspec = formspec.."button[2,1;1,1;;178]"
        end
        if tonumber(level2) > 178 then
            formspec = formspec.."button[3,1;1,1;;179]"
        end
        if tonumber(level2) > 179 then
            formspec = formspec.."button[4,1;1,1;;180]"
        end
        if tonumber(level2) > 180 then
            formspec = formspec.."button[0,2;1,1;;181]"
        end
        if tonumber(level2) > 181 then
            formspec = formspec.."button[1,2;1,1;;182]"
        end
        if tonumber(level2) > 182 then
            formspec = formspec.."button[2,2;1,1;;183]"
        end
        if tonumber(level2) > 183 then
            formspec = formspec.."button[3,2;1,1;;184]"
        end
        if tonumber(level2) > 184 then
            formspec = formspec.."button[4,2;1,1;;185]"
        end
        if tonumber(level2) > 185 then
            formspec = formspec.."button[0,3;1,1;;186]"
        end
        if tonumber(level2) > 186 then
            formspec = formspec.."button[1,3;1,1;;187]"
        end
        if tonumber(level2) > 187 then
            formspec = formspec.."button[2,3;1,1;;188]"
        end
        if tonumber(level2) > 188 then
            formspec = formspec.."button[3,3;1,1;;189]"
        end
        if tonumber(level2) > 189 then
            formspec = formspec.."button[4,3;1,1;;190]"
        end
        if tonumber(level2) > 190 then
            formspec = formspec.."button[0,4;1,1;;191]"
        end
        if tonumber(level2) > 191 then
            formspec = formspec.."button[1,4;1,1;;192]"
        end
        if tonumber(level2) > 192 then
            formspec = formspec.."button[2,4;1,1;;193]"
        end
        if tonumber(level2) > 193 then
            formspec = formspec.."button[3,4;1,1;;194]"
        end
        if tonumber(level2) > 194 then
            formspec = formspec.."button[4,4;1,1;;195]"
        end
        if tonumber(level2) > 195 then
            formspec = formspec.."button[0,5;1,1;;196]"
        end
        if tonumber(level2) > 196 then
            formspec = formspec.."button[1,5;1,1;;197]"
        end
        if tonumber(level2) > 197 then
            formspec = formspec.."button[2,5;1,1;;198]"
        end
        if tonumber(level2) > 198 then
            formspec = formspec.."button[3,5;1,1;;199]"
        end
        if tonumber(level2) > 199 then
            formspec = formspec.."button[4,5;1,1;;200]"
        end
        if tonumber(level2) > 200 then
            formspec = formspec.."button[2.5,6;1,1;wai;>]"
        end
	return formspec		
end
local w39 = {}
w39.get_formspec = function(player, pos)
	if player == nil then
        return
    end
	local player_inv = player:get_inventory()
    lv = io.open(minetest.get_worldpath().."/level3.txt", "r")
	local level2 = lv:read("*l")
    lv:close()
	formspec = "size[5,6.5]"
        .."background[5,6.5;1,1;gui_formbg.png;true]"
        .."listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
        .."bgcolor[#080808BB;true]"
        .."image_button[4.5,-0.3;0.8,0.8;;esc;X]"
        .."label[0,0;World Level:     "..(tonumber(level2)-1).."/222]"
        .."button[0,1;1,1;;201]"
        .."button[1.5,6;1,1;wah;<]"
        if tonumber(level2) > 201 then
            formspec = formspec.."button[1,1;1,1;;202]"
        end
        if tonumber(level2) > 202 then
            formspec = formspec.."button[2,1;1,1;;203]"
        end
        if tonumber(level2) > 203 then
            formspec = formspec.."button[3,1;1,1;;204]"
        end
        if tonumber(level2) > 204 then
            formspec = formspec.."button[4,1;1,1;;205]"
        end
        if tonumber(level2) > 205 then
            formspec = formspec.."button[0,2;1,1;;206]"
        end
        if tonumber(level2) > 206 then
            formspec = formspec.."button[1,2;1,1;;207]"
        end
        if tonumber(level2) > 207 then
            formspec = formspec.."button[2,2;1,1;;208]"
        end
        if tonumber(level2) > 208 then
            formspec = formspec.."button[3,2;1,1;;209]"
        end
        if tonumber(level2) > 209 then
            formspec = formspec.."button[4,2;1,1;;210]"
        end
        if tonumber(level2) > 210 then
            formspec = formspec.."button[0,3;1,1;;211]"
        end
        if tonumber(level2) > 211 then
            formspec = formspec.."button[1,3;1,1;;212]"
        end
        if tonumber(level2) > 212 then
            formspec = formspec.."button[2,3;1,1;;213]"
        end
        if tonumber(level2) > 213 then
            formspec = formspec.."button[3,3;1,1;;214]"
        end
        if tonumber(level2) > 214 then
            formspec = formspec.."button[4,3;1,1;;215]"
        end
        if tonumber(level2) > 215 then
            formspec = formspec.."button[0,4;1,1;;216]"
        end
        if tonumber(level2) > 216 then
            formspec = formspec.."button[1,4;1,1;;217]"
        end
        if tonumber(level2) > 217 then
            formspec = formspec.."button[2,4;1,1;;218]"
        end
        if tonumber(level2) > 218 then
            formspec = formspec.."button[3,4;1,1;;219]"
        end
        if tonumber(level2) > 219 then
            formspec = formspec.."button[4,4;1,1;;220]"
        end
        if tonumber(level2) > 220 then
            formspec = formspec.."button[0,5;1,1;;221]"
        end
        if tonumber(level2) > 221 then
            formspec = formspec.."button[1,5;1,1;;222]"
        end
        if tonumber(level2) > 222 then
            formspec = formspec.."label[0,5.8;wait until the next update]"
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
            minetest.show_formspec(player:get_player_name(), "w11" , w11.get_formspec(player))
        elseif page == 2 then
            minetest.show_formspec(player:get_player_name(), "w12" , w12.get_formspec(player))
        elseif page == 3 then
            minetest.show_formspec(player:get_player_name(), "w13" , w13.get_formspec(player))
        elseif page == 4 then
            minetest.show_formspec(player:get_player_name(), "w14" , w14.get_formspec(player))
        elseif page == 5 then
            minetest.show_formspec(player:get_player_name(), "w15" , w15.get_formspec(player))
        elseif page == 6 then
            minetest.show_formspec(player:get_player_name(), "w16" , w16.get_formspec(player))
        elseif page == 7 then
            minetest.show_formspec(player:get_player_name(), "w17" , w17.get_formspec(player))
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
            minetest.show_formspec(player:get_player_name(), "w21" , w21.get_formspec(player))
        elseif page == 2 then
            minetest.show_formspec(player:get_player_name(), "w22" , w22.get_formspec(player))
        elseif page == 3 then
            minetest.show_formspec(player:get_player_name(), "w23" , w23.get_formspec(player))
        elseif page == 4 then
            minetest.show_formspec(player:get_player_name(), "w24" , w24.get_formspec(player))
        elseif page == 5 then
            minetest.show_formspec(player:get_player_name(), "w25" , w25.get_formspec(player))
        elseif page == 6 then
            minetest.show_formspec(player:get_player_name(), "w26" , w26.get_formspec(player))
        elseif page == 7 then
            minetest.show_formspec(player:get_player_name(), "w27" , w27.get_formspec(player))
        elseif page == 8 then
            minetest.show_formspec(player:get_player_name(), "w28" , w28.get_formspec(player))
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
            minetest.show_formspec(player:get_player_name(), "w31" , w31.get_formspec(player))
        elseif page == 2 then
            minetest.show_formspec(player:get_player_name(), "w32" , w32.get_formspec(player))
        elseif page == 3 then
            minetest.show_formspec(player:get_player_name(), "w33" , w33.get_formspec(player))
        elseif page == 4 then
            minetest.show_formspec(player:get_player_name(), "w34" , w34.get_formspec(player))
        elseif page == 5 then
            minetest.show_formspec(player:get_player_name(), "w35" , w35.get_formspec(player))
        elseif page == 6 then
            minetest.show_formspec(player:get_player_name(), "w36" , w36.get_formspec(player))
        elseif page == 7 then
            minetest.show_formspec(player:get_player_name(), "w37" , w37.get_formspec(player))
        elseif page == 8 then
            minetest.show_formspec(player:get_player_name(), "w38" , w38.get_formspec(player))
        elseif page == 9 then
            minetest.show_formspec(player:get_player_name(), "w39" , w39.get_formspec(player))
        end
    end,
})
minetest.register_node("sudoku:new_w4",{
	tiles  = {"default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png^sudoku_new_w4.png"},
	description = "New",
    --groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
    on_punch = function(pos, node, player, pointed_thing)
        minetest.show_formspec(player:get_player_name(), "w3" , w3.get_formspec(player))
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
minetest.register_node("sudoku:new_ws",{
	tiles  = {"default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png^sudoku_new_ws.png"},
	description = "New",
    --groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
    on_punch = function(pos, node, player, pointed_thing)
        minetest.show_formspec(player:get_player_name(), "w3" , w3.get_formspec(player))
    end,
})
minetest.register_node("sudoku:finisch",{
	tiles  = {"default_silver_sandstone_block.png^sudoku_finisch.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png","default_silver_sandstone_block.png"},
	description = "New",
    --groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
    on_punch = function(pos, node, player, pointed_thing)
        Finisch(player)
    end,
})
minetest.register_on_player_receive_fields(function(player, formname, fields)
    local player_inv = player:get_inventory()
    player_inv:set_size("ll", 1)
    player_inv:set_size("l", 6)
    player_inv:set_size("page1", 1)
    player_inv:set_size("page2", 1)
    player_inv:set_size("page3", 1)
    local d = 0
    if formname == "w11" then
        d = 1
        for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"1_"..v)
                player_inv:set_stack("l",  1, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 1")
            end
        end
        if fields.wab then
            player_inv:set_stack("page1",  1, "default:dirt")
            minetest.show_formspec(player:get_player_name(), "w12" , w12.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
	end
    if formname == "w12" and d == 0 then
        d = 1
		for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"1_"..v)
                player_inv:set_stack("l",  1, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 1")
            end
        end
        if fields.waa then
            player_inv:set_stack("page1",  1, nil)
            minetest.show_formspec(player:get_player_name(), "w11" , w11.get_formspec(player))
        elseif fields.wac then
            player_inv:set_stack("page1",  1, "default:dirt 2")
            minetest.show_formspec(player:get_player_name(), "w13" , w13.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
    end
    if formname == "w13" and d == 0 then
        d = 1
		for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"1_"..v)
                player_inv:set_stack("l",  1, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 1")
            end
        end
        if fields.wab then
            player_inv:set_stack("page1",  1, "default:dirt 1")
            minetest.show_formspec(player:get_player_name(), "w12" , w12.get_formspec(player))
        elseif fields.wad then
            player_inv:set_stack("page1",  1, "default:dirt 3")
            minetest.show_formspec(player:get_player_name(), "w14" , w14.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
	end
    if formname == "w14" and d == 0 then
        d = 1
		for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"1_"..v)
                player_inv:set_stack("l",  1, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 1")
            end
        end
        if fields.wac then
            player_inv:set_stack("page1",  1, "default:dirt 2")
            minetest.show_formspec(player:get_player_name(), "w13" , w13.get_formspec(player))
        elseif fields.wae then
            player_inv:set_stack("page1",  1, "default:dirt 4")
            minetest.show_formspec(player:get_player_name(), "w15" , w15.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
	end
    if formname == "w15" and d == 0 then
        d = 1
		for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"1_"..v)
                player_inv:set_stack("l",  1, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 1")
            end
        end
        if fields.wad then
            player_inv:set_stack("page1",  1, "default:dirt 3")
            minetest.show_formspec(player:get_player_name(), "w14" , w14.get_formspec(player))
        elseif fields.waf then
            player_inv:set_stack("page1",  1, "default:dirt 5")
            minetest.show_formspec(player:get_player_name(), "w16" , w16.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
	end
    if formname == "w16" and d == 0 then
        d = 1
		for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"1_"..v)
                player_inv:set_stack("l",  1, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 1")
            end
        end
        if fields.wae then
            player_inv:set_stack("page1",  1, "default:dirt 4")
            minetest.show_formspec(player:get_player_name(), "w15" , w15.get_formspec(player))
        elseif fields.wag then
            player_inv:set_stack("page1",  1, "default:dirt 6")
            minetest.show_formspec(player:get_player_name(), "w17" , w17.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
	end
    if formname == "w17" and d == 0 then
        d = 1
		for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"1_"..v)
                player_inv:set_stack("l",  1, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 1")
            end
        end
        if fields.waf then
            player_inv:set_stack("page1",  1, "default:dirt 5")
            minetest.show_formspec(player:get_player_name(), "w16" , w16.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
	end
    if formname == "w21" then
        d = 1
        for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"2_"..v)
                player_inv:set_stack("l",  2, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 2")
            end
        end
        if fields.wab then
            player_inv:set_stack("page2",  1, "default:dirt")
            minetest.show_formspec(player:get_player_name(), "w22" , w22.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
	end
    if formname == "w22" and d == 0 then
        d = 1
		for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"2_"..v)
                player_inv:set_stack("l",  2, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 2")
            end
        end
        if fields.waa then
            player_inv:set_stack("page2",  1, nil)
            minetest.show_formspec(player:get_player_name(), "w21" , w21.get_formspec(player))
        elseif fields.wac then
            player_inv:set_stack("page2",  1, "default:dirt 2")
            minetest.show_formspec(player:get_player_name(), "w23" , w23.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
    end
    if formname == "w23" and d == 0 then
        d = 1
		for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"2_"..v)
                player_inv:set_stack("l",  2, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 2")
            end
        end
        if fields.wab then
            player_inv:set_stack("page2",  1, nil)
            minetest.show_formspec(player:get_player_name(), "w22" , w22.get_formspec(player))
        elseif fields.wad then
            player_inv:set_stack("page2",  1, "default:dirt 3")
            minetest.show_formspec(player:get_player_name(), "w24" , w24.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
    end
    if formname == "w24" and d == 0 then
        d = 1
		for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"2_"..v)
                player_inv:set_stack("l",  2, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 2")
            end
        end
        if fields.wac then
            player_inv:set_stack("page2",  1, "default:dirt 2")
            minetest.show_formspec(player:get_player_name(), "w23" , w23.get_formspec(player))
        elseif fields.wae then
            player_inv:set_stack("page2",  1, "default:dirt 4")
            minetest.show_formspec(player:get_player_name(), "w25" , w25.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
    end
    if formname == "w25" and d == 0 then
        d = 1
		for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"2_"..v)
                player_inv:set_stack("l",  2, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 2")
            end
        end
        if fields.wad then
            player_inv:set_stack("page2",  1, "default:dirt 3")
            minetest.show_formspec(player:get_player_name(), "w24" , w24.get_formspec(player))
        elseif fields.waf then
            player_inv:set_stack("page2",  1, "default:dirt 5")
            minetest.show_formspec(player:get_player_name(), "w26" , w26.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
    end
    if formname == "w26" and d == 0 then
        d = 1
		for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"2_"..v)
                player_inv:set_stack("l",  2, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 2")
            end
        end
        if fields.wae then
            player_inv:set_stack("page2",  1, "default:dirt 4")
            minetest.show_formspec(player:get_player_name(), "w25" , w25.get_formspec(player))
        elseif fields.wag then
            player_inv:set_stack("page2",  1, "default:dirt 6")
            minetest.show_formspec(player:get_player_name(), "w27" , w27.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
    end
    if formname == "w27" and d == 0 then
        d = 1
		for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"2_"..v)
                player_inv:set_stack("l",  2, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 2")
            end
        end
        if fields.waf then
            player_inv:set_stack("page2",  1, "default:dirt 5")
            minetest.show_formspec(player:get_player_name(), "w26" , w26.get_formspec(player))
        elseif fields.wah then
            player_inv:set_stack("page2",  1, "default:dirt 7")
            minetest.show_formspec(player:get_player_name(), "w28" , w28.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
    end
    if formname == "w28" and d == 0 then
        d = 1
		for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"2_"..v)
                player_inv:set_stack("l",  2, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 2")
            end
        end
        if fields.wag then
            player_inv:set_stack("page2",  1, "default:dirt 6")
            minetest.show_formspec(player:get_player_name(), "w27" , w27.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
    end
    if formname == "w31" then
        d = 1
        for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"3_"..v)
                player_inv:set_stack("l",  3, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 3")
            end
        end
        if fields.wab then
            player_inv:set_stack("page3",  1, "default:dirt")
            minetest.show_formspec(player:get_player_name(), "w32" , w32.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
	end
    if formname == "w32" then
        d = 1
        for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"3_"..v)
                player_inv:set_stack("l",  3, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 3")
            end
        end
        if fields.waa then
            player_inv:set_stack("page3",  1,nil)
            minetest.show_formspec(player:get_player_name(), "w31" , w31.get_formspec(player))
        elseif fields.wac then
            player_inv:set_stack("page3",  1, "default:dirt 2")
            minetest.show_formspec(player:get_player_name(), "w33" , w33.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
	end
    if formname == "w33" then
        d = 1
        for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"3_"..v)
                player_inv:set_stack("l",  3, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 3")
            end
        end
        if fields.wab then
            player_inv:set_stack("page3",  1,"default:dirt")
            minetest.show_formspec(player:get_player_name(), "w32" , w32.get_formspec(player))
        elseif fields.wad then
            player_inv:set_stack("page3",  1, "default:dirt 3")
            minetest.show_formspec(player:get_player_name(), "w34" , w34.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
	end
    if formname == "w34" then
        d = 1
        for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"3_"..v)
                player_inv:set_stack("l",  3, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 3")
            end
        end
        if fields.wac then
            player_inv:set_stack("page3",  1,"default:dirt 2")
            minetest.show_formspec(player:get_player_name(), "w33" , w33.get_formspec(player))
        elseif fields.wae then
            player_inv:set_stack("page3",  1, "default:dirt 4")
            minetest.show_formspec(player:get_player_name(), "w35" , w35.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
	end
    if formname == "w35" then
        d = 1
        for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"3_"..v)
                player_inv:set_stack("l",  3, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 3")
            end
        end
        if fields.wad then
            player_inv:set_stack("page3",  1,"default:dirt 3")
            minetest.show_formspec(player:get_player_name(), "w34" , w34.get_formspec(player))
        elseif fields.waf then
            player_inv:set_stack("page3",  1, "default:dirt 5")
            minetest.show_formspec(player:get_player_name(), "w36" , w36.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
	end
    if formname == "w36" then
        d = 1
        for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"3_"..v)
                player_inv:set_stack("l",  3, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 3")
            end
        end
        if fields.wae then
            player_inv:set_stack("page3",  1,"default:dirt 4")
            minetest.show_formspec(player:get_player_name(), "w35" , w35.get_formspec(player))
        elseif fields.wag then
            player_inv:set_stack("page3",  1, "default:dirt 6")
            minetest.show_formspec(player:get_player_name(), "w37" , w37.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
	end
    if formname == "w37" then
        d = 1
        for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"3_"..v)
                player_inv:set_stack("l",  3, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 3")
            end
        end
        if fields.waf then
            player_inv:set_stack("page3",  1,"default:dirt 5")
            minetest.show_formspec(player:get_player_name(), "w36" , w36.get_formspec(player))
        elseif fields.wah then
            player_inv:set_stack("page3",  1, "default:dirt 7")
            minetest.show_formspec(player:get_player_name(), "w38" , w38.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
	end
    if formname == "w38" then
        d = 1
        for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"3_"..v)
                player_inv:set_stack("l",  3, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 3")
            end
        end
        if fields.wag then
            player_inv:set_stack("page3",  1,"default:dirt 6")
            minetest.show_formspec(player:get_player_name(), "w37" , w37.get_formspec(player))
        elseif fields.wai then
            player_inv:set_stack("page3",  1, "default:dirt 8")
            minetest.show_formspec(player:get_player_name(), "w39" , w39.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
	end
    if formname == "w39" then
        d = 1
        for k, v in pairs(fields) do
            if tonumber(v) ~= nil then
                New(player,"3_"..v)
                player_inv:set_stack("l",  3, "default:dirt "..v)
                player_inv:set_stack("ll", 1, "default:dirt 3")
            end
        end
        if fields.wah then
            player_inv:set_stack("page3",  1,"default:dirt 7")
            minetest.show_formspec(player:get_player_name(), "w38" , w38.get_formspec(player))
        else
            minetest.show_formspec(player:get_player_name(), "", "")
	    end
	end
end)