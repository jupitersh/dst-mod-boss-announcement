--[[
在此声明：
针对神乐的抄袭行为，创意工坊没有相关防抄袭的规定，鄙人无能为力
此人将开源堂而皇之地作为自己抄袭的借口，其脸皮之厚，令鄙人叹为观止
做人做事要有最基本的底线，尊重他人劳动成果
要借鉴甚至抄鄙人拙劣的代码，可以，请询问鄙人并在您的mod说明中写上致谢声明并附上链接
让我们维护一个更好的创意工坊！！！
]]

local TheNet = GLOBAL.TheNet
local lang = TheNet:GetDefaultServerLanguage()

local grave = "󰀊"
local diamond = "󰀒"
local chester = "󰀃"
local ghost ="󰀉"
local heart = "󰀍"
local battle = "󰀘"
local arm = "󰀙"
local lightbulb = "󰀏"
local redskull = "󰀀"
local skull = "󰀕"
local thumb = "󰀫"
local trophy = "󰀭"
local hand = "󰀮"

local annstring = {}
if lang == "zh" then
	annstring.reflash = "已刷新"
	annstring.dragonfly = "龙蝇"
	annstring.gotkilledby = "被此人击杀："
	annstring.gotkilled = "被击杀"
else
	annstring.reflash = "is Available Now"
	annstring.dragonfly = "Dragonfly"
	annstring.gotkilledby = "Got Killed By"
	annstring.gotkilled = "Got Killed"
end

--蜂蜜地块出现
AddPrefabPostInit("beequeenhive",function(inst)
    inst:ListenForEvent("timerdone", function()
        if inst:GetDisplayName() == "蜂蜜地块" or inst:GetDisplayName() == "Honey Patch" then
            TheNet:Announce(lightbulb.."〖 "..inst:GetDisplayName().." 〗"..annstring.reflash..lightbulb)
        end
    end)
end)

--蜻蜓出现
AddPrefabPostInit("dragonfly_spawner",function(inst)
    inst:ListenForEvent("timerdone", function()
        TheNet:Announce(lightbulb.."〖 "..annstring.dragonfly.." 〗"..annstring.reflash..lightbulb)
    end)
end)

--蟾蜍菇出现
AddPrefabPostInit("toadstool_cap",function(inst)
    inst:ListenForEvent("ms_spawntoadstool", function()
        TheNet:Announce(lightbulb.."〖 "..inst:GetDisplayName().." 〗"..annstring.reflash..lightbulb)
    end)
end)

--远古大门刷新
AddPrefabPostInit("atrium_gate",function(inst)
    inst:ListenForEvent("timerdone", function()
        if inst.components.trader.enabled == true then
            TheNet:Announce(lightbulb.."〖 "..inst:GetDisplayName().." 〗"..annstring.reflash..lightbulb)
        end
    end)
end)

--克劳斯刷新公告
--禁止抄袭，特别针对是某乐
AddPrefabPostInit("klaus_sack", function(inst)
    inst:DoTaskInTime(.5, function(inst)
        TheNet:Announce(lightbulb.."〖 "..inst:GetDisplayName().." 〗"..annstring.reflash..lightbulb)
    end)
end)

--克劳斯击杀公告
AddPrefabPostInit("klaus", function(inst)
    local function announcement(inst, data)
        local lastattacker = inst.components.combat and inst.components.combat.lastattacker
        if lastattacker ~= nil then
            TheNet:Announce(trophy.."〖 "..inst:GetDisplayName().." 〗"..annstring.gotkilledby..heart.."〖 "..lastattacker.name.." 〗"..battle)
        else
            TheNet:Announce(trophy.."〖 "..inst:GetDisplayName().." 〗"..annstring.gotkilled..battle)
        end
    end
    local function extinction(inst)
        if inst:IsUnchained() then
            inst:ListenForEvent("attacked", announcement)
        end
    end
    inst:ListenForEvent("death", extinction)
end)


--所有boss击杀公告
local death_announcement ={
    "beequeen",
    "dragonfly",
    "toadstool",
    "toadstool_dark",
    "moose",
    "antlion",
    "bearger",
    "deerclops",
    "stalker",
    "stalker_atrium",
    --"stalker_forest",
    "minotaur",
    "malbatross",
}

for k, v in pairs(death_announcement) do    
    AddPrefabPostInit(v, function(inst)
        inst:ListenForEvent("death", function()
            local lastattacker = inst.components.combat and inst.components.combat.lastattacker
            if lastattacker ~= nil then
                TheNet:Announce(trophy.."〖 "..inst:GetDisplayName().." 〗"..annstring.gotkilledby..heart.."〖 "..lastattacker.name.." 〗"..battle)
            else
                TheNet:Announce(trophy.."〖 "..inst:GetDisplayName().." 〗"..annstring.gotkilled..battle)
            end
        end)
    end)
end

--猎犬&猎狗

local DAYS_IN_ADVANCE = 5

local secADay = 8*60

local function second2Day(val) 
    return math.floor(val / secADay)
end

local function HoundAttackString(timeToAttack)
    if timeToAttack == 0 then
    	if lang == "zh" then
        	return "猎犬今日来袭"
        else
        	return "the Hounds Will Attack Today"
        end
    else
    	if lang == "zh" then
        	return '猎犬'..arm..'倒计时'..skull..timeToAttack..'天'
        else
        	return arm.."the Hounds Will Attack in "..skull..timeToAttack..' Days'
        end
    end
end

local function HoundAttack(inst)
    inst:ListenForEvent("cycleschanged",
        function(inst)
            if GLOBAL.TheWorld:HasTag("cave") then
                return
            end
            if not GLOBAL.TheWorld.components.hounded then
                return
            end
            local _timeToAttack = GLOBAL.TheWorld.components.hounded:GetTimeToAttack()
            local timeToAttack  = second2Day(_timeToAttack)
            if timeToAttack <= DAYS_IN_ADVANCE and GLOBAL.TheWorld.state.cycles ~= 0 then
                for i, v in ipairs(GLOBAL.AllPlayers) do v.components.talker:Say(redskull..HoundAttackString(timeToAttack)..grave,10,true,true,false) end
            end
            print("Hound attack in "..timeToAttack.."(".._timeToAttack..") days.")
        end,
    GLOBAL.TheWorld)
end

local function WormAttackString(timeToAttack)
    if timeToAttack == 0 then
    	if lang == "zh" then
        	return "蠕虫今日来袭"
        else
        	return "the Hounds Will Attack Today"
        end
    else
    	if lang == "zh" then
        	return '蠕虫'..arm..'倒计时'..skull..timeToAttack..'天'
        else
        	return arm.."the Hounds Will Attack in "..skull..timeToAttack..' Days'
        end
    end
end

local function WormAttack(inst)
    inst:ListenForEvent("cycleschanged",
        function(inst)
            if not GLOBAL.TheWorld:HasTag("cave") then
                return
            end
            if not GLOBAL.TheWorld.components.hounded then
                return
            end
            local _timeToAttack = GLOBAL.TheWorld.components.hounded:GetTimeToAttack()
            local timeToAttack  = second2Day(_timeToAttack)
            if timeToAttack <= DAYS_IN_ADVANCE and GLOBAL.TheWorld.state.cycles ~= 0 then
                for i, v in ipairs(GLOBAL.AllPlayers) do v.components.talker:Say(redskull..WormAttackString(timeToAttack)..grave,10,true,true,false) end
            end
            print("Hound attack in "..timeToAttack.."(".._timeToAttack..") days.")
        end,
    GLOBAL.TheWorld)
end

AddPrefabPostInit("world", HoundAttack)
AddPrefabPostInit("cave", WormAttack)