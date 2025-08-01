local mod	= DBM:NewMod("Sartharion", "DBM-Raids-WoTLK", 7)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,normal25"

mod:SetRevision("@file-date-integer@")
mod:SetCreatureID(28860)
mod:SetEncounterID(1090)
mod:SetModelID(27035)
mod:SetZone(615)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 57579 59127",
	"RAID_BOSS_EMOTE"
)

local warnShadowFissure	    = mod:NewSpellAnnounce(59127, 4, nil, nil, nil, nil, nil, 2)
local warnTenebron          = mod:NewAnnounce("WarningTenebron", 2, 61248)
local warnShadron           = mod:NewAnnounce("WarningShadron", 2, 58105)
local warnVesperon          = mod:NewAnnounce("WarningVesperon", 2, 61251)

local warnFireWall			= mod:NewSpecialWarning("WarningFireWall", nil, nil, nil, 2, 2)
local warnVesperonPortal	= mod:NewSpecialWarning("WarningVesperonPortal", false, nil, nil, 1, 7)
local warnTenebronPortal	= mod:NewSpecialWarning("WarningTenebronPortal", false, nil, nil, 1, 7)
local warnShadronPortal		= mod:NewSpecialWarning("WarningShadronPortal", false, nil, nil, 1, 7)

local timerShadowFissure    = mod:NewCastTimer(5, 59128, nil, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON)--Cast timer until Void Blast. it's what happens when shadow fissure explodes.
local timerWall             = mod:NewCDTimer(30, 43113, nil, nil, nil, 2)
local timerTenebron         = mod:NewTimer(30, "TimerTenebron", 61248, nil, nil, 1)
local timerShadron          = mod:NewTimer(80, "TimerShadron", 58105, nil, nil, 1)
local timerVesperon         = mod:NewTimer(120, "TimerVesperon", 61251, nil, nil, 1)

mod:GroupSpells(59127, 59128)--Shadow fissure with void blast

local lastvoids = {}
local lastfire = {}
local tsort, tinsert, twipe = table.sort, table.insert, table.wipe

local function CheckDrakes(delay)
	if DBM:RaidUnitDebuff(DBM:GetSpellName(61248)) then	-- Power of Tenebron
		timerTenebron:Start(30 - delay)
		warnTenebron:Schedule(25 - delay)
	end
	if DBM:RaidUnitDebuff(DBM:GetSpellName(58105)) then	-- Power of Shadron
		timerShadron:Start(75 - delay)
		warnShadron:Schedule(70 - delay)
	end
	if DBM:RaidUnitDebuff(DBM:GetSpellName(61251)) then	-- Power of Vesperon
		timerVesperon:Start(120 - delay)
		warnVesperon:Schedule(115 - delay)
	end
end

local sortedFails = {}
local function sortFails1(e1, e2)
	return (lastvoids[e1] or 0) > (lastvoids[e2] or 0)
end
local function sortFails2(e1, e2)
	return (lastfire[e1] or 0) > (lastfire[e2] or 0)
end

function mod:OnCombatStart(delay)
	--Cache spellnames so a solo player check doesn't fail in CheckDrakes in 8.0+
	self:Schedule(5, CheckDrakes, delay)
	timerWall:Start(-delay)

	twipe(lastvoids)
	twipe(lastfire)
end

function mod:SPELL_CAST_SUCCESS(args)
    if args:IsSpellID(57579, 59127) and self:AntiSpam(3, 1) then
        warnShadowFissure:Show()
        warnShadowFissure:Play("watchstep")
        timerShadowFissure:Start()
    end
end

function mod:RAID_BOSS_EMOTE(msg, mob)
	if msg == L.Wall or msg:find(L.Wall) then
		self:SendSync("FireWall")
	elseif msg == L.Portal or msg:find(L.Portal) then
		if mob == L.NameVesperon then
			self:SendSync("VesperonPortal")
		elseif mob == L.NameTenebron then
			self:SendSync("TenebronPortal")
		elseif mob == L.NameShadron then
			self:SendSync("ShadronPortal")
		end
	end
end

function mod:OnSync(event)
	if event == "FireWall" then
		timerWall:Start()
		warnFireWall:Show()
		warnFireWall:Play("watchwave")
	elseif event == "VesperonPortal" then
		warnVesperonPortal:Show()
		warnVesperonPortal:Play("newportal")
	elseif event == "TenebronPortal" then
		warnTenebronPortal:Show()
		warnTenebronPortal:Play("newportal")
	elseif event == "ShadronPortal" then
		warnShadronPortal:Show()
		warnShadronPortal:Play("newportal")
	end
end
