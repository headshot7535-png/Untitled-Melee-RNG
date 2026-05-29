--[[ ════════════════════════════════════════════════════════
     BOOTSTRAP: Main Entry Point
     ════════════════════════════════════════════════════════
     Orchestrates all modular components and initializes the script.
     This is the single file users should execute.
]]

-- ── Module Loader ─────────────────────────────────────────
local function loadModule(path)
    local ok, module = pcall(function()
        return require(script:FindFirstChild(path:match("([^/]+)$")))
    end)
    if not ok then
        error("Failed to load module: " .. path)
    end
    return module
end

-- ── Load Core Dependencies ────────────────────────────────
local CONSTANTS = require(script.Parent.constants)
local Logger = require(script.Parent.utils.logger)
local Lifecycle = require(script.Parent.core.lifecycle)
local Character = require(script.Parent.core.character)
local LeaderStats = require(script.Parent.core.leaderstats)
local Remote = require(script.Parent.core.remotes)
local Mob = require(script.Parent.core.mob)

-- ── Load Features ─────────────────────────────────────────
local StateManager = require(script.Parent.features["state-manager"])
local SettingsManager = require(script.Parent.features["settings-manager"])
local AscendManager = require(script.Parent.features["ascend-manager"])
local AuraManager = require(script.Parent.features["aura-manager"])
local GuildManager = require(script.Parent.features["guild-manager"])
local UpgradeManager = require(script.Parent.features["upgrade-manager"])
local SacrificeManager = require(script.Parent.features["sacrifice-manager"])
local TotemManager = require(script.Parent.features["totem-manager"])
local APUpgradeManager = require(script.Parent.features["ap-upgrade-manager"])
local FarmManager = require(script.Parent.features["farm-manager"])
local UIManager = require(script.Parent.features["ui-manager"])
local RaidManager = require(script.Parent.features["raid-manager"])
local TimeTrialManager = require(script.Parent.features["time-trial-manager"])
local PerfManager = require(script.Parent.features["perf-manager"])

-- ── Initialize Services ───────────────────────────────────
local function initializeServices()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local RS = game:GetService("ReplicatedStorage")
    
    Character.LP = Players.LocalPlayer
    LeaderStats.LP = Players.LocalPlayer
    Remote.RS = RS
    Mob.Character = Character
    
    return {
        Players = Players,
        RunService = RunService,
        RS = RS,
    }
end

-- ── Wait for LocalPlayer ───────────────────────────────────
local function waitForLocalPlayer()
    local Players = game:GetService("Players")
    task.wait(CONSTANTS.LOCALPLAYER_WAIT_TIME)
    
    local LP
    for _ = 1, CONSTANTS.LOCALPLAYER_WAIT_TIMEOUT do
        LP = Players.LocalPlayer
        if LP and LP:FindFirstChildOfClass("PlayerGui") then
            break
        end
        task.wait(CONSTANTS.LOCALPLAYER_WAIT_INTERVAL)
    end
    
    if not LP then
        error("[MeleeRNG] LocalPlayer not ready after timeout")
    end
    
    return LP
end

-- ── Initialize State ──────────────────────────────────────
local function initializeState()
    local defaults = {
        -- Feature Toggles
        autoEquipBest = false,
        autoAscend = false,
        autoCycleFarm = false,
        farmBoss = true,
        farmMegaBoss = false,
        skipRegular = false,
        
        -- Movement
        noclip = false,
        godMode = false,
        fly = false,
        infJump = false,
        antiAfk = false,
        
        -- Visuals
        fullBright = false,
        espMobs = false,
        
        -- UI
        uiHideHud = false,
        uiHideManaKills = false,
        uiHideMiniRoll = false,
        uiHideNotifications = false,
        
        -- Auto Systems
        autoUpgradeOn = false,
        autoManaToSP = false,
        autoGuildSpToGp = false,
        autoGuildBuffs = false,
        autoApUpgrades = false,
        autoSacrifice = false,
        autoTotem = false,
        autoTimeTrial = false,
        
        -- Ascend
        ascendAfterTpX = CONSTANTS.DEFAULT_ASCEND_TP_X,
        ascendAfterTpY = CONSTANTS.DEFAULT_ASCEND_TP_Y,
        ascendAfterTpZ = CONSTANTS.DEFAULT_ASCEND_TP_Z,
        ascendAuraKeepBeforeTp = true,
        
        -- Performance
        perfHideOtherWeapons = false,
        perfHideOwnWeapons = false,
        perfHideAllEffects = false,
        perfDisableShadows = false,
        perfHideLootDrops = false,
        perfHideMobManaOrbs = false,
        perfMuteWorldSounds = false,
        perfCompatLighting = false,
        perfLowGraphicsQuality = false,
        perfHideOtherCharacters = false,
        perfMobOptimize = false,
        perfPeriodicGc = false,
        
        -- Other
        autoSave = true,
        autoReExec = false,
        dpsTrackingEnabled = false,
    }
    
    StateManager.init(defaults)
    return defaults
end

-- ── Load Settings ────────────────────────────────────────
local function loadSettings()
    SettingsManager.load()
    -- Merge saved settings into state
    -- This would need custom merge logic per setting type
end

-- ── Setup Heartbeat Loop ──────────────────────────────────
local function setupHeartbeat(services)
    local function onHeartbeat()
        if not Lifecycle.isActive() then
            Lifecycle.cleanupAll()
            return
        end
        
        -- Apply UI hiding rules
        local state = StateManager.getAll()
        if state.uiHideHud or state.uiHideManaKills or state.uiHideMiniRoll or state.uiHideNotifications then
            UIManager.applyHidingRules(Character.LP, state)
        end
        
        -- Apply performance settings
        if state.perfDisableShadows then
            PerfManager.disableShadows(true)
        end
        if state.perfMuteWorldSounds then
            PerfManager.muteWorldSounds(true)
        end
        if state.perfCompatLighting then
            PerfManager.setLightingCompat(true)
        end
        
        -- Maintain aura selection
        if StateManager.get("auraMaintainSelection") then
            local preferredName = StateManager.get("auraPreferredName")
            if preferredName and preferredName ~= "" then
                AuraManager.maintainPreferredAuraSelection(Character.LP, preferredName)
            end
        end
    end
    
    local heartbeatConn = services.RunService.Heartbeat:Connect(onHeartbeat)
    Lifecycle.addConn(heartbeatConn)
    return heartbeatConn
end

-- ── Setup Re-exec Detection ───────────────────────────────
local function setupReexecDetection(services)
    local function onPlayerRemoving(player)
        if player == Character.LP then
            Lifecycle.cleanupAll()
        end
    end
    
    local removing = services.Players.PlayerRemoving:Connect(onPlayerRemoving)
    Lifecycle.addConn(removing)
end

-- ── Main Bootstrap ────────────────────────────────────────
local function bootstrap()
    Logger.print("Initializing MeleeRNG v" .. Lifecycle.GEN)
    
    -- Wait for LocalPlayer
    local LP = waitForLocalPlayer()
    Character.LP = LP
    LeaderStats.LP = LP
    Logger.print("LocalPlayer ready:", LP.Name)
    
    -- Initialize services
    local services = initializeServices()
    Logger.print("Services initialized")
    
    -- Initialize state
    local defaults = initializeState()
    Logger.print("State initialized with", #defaults, "defaults")
    
    -- Load persisted settings
    pcall(loadSettings)
    Logger.print("Settings loaded")
    
    -- Setup event loops
    setupHeartbeat(services)
    setupReexecDetection(services)
    Logger.print("Event loops established")
    
    -- Print ready status
    Logger.print("✅ Bootstrap complete. Generation:", Lifecycle.GEN)
    Logger.print("Connections:", Lifecycle.getConnCount(), "| Threads:", Lifecycle.getThreadCount())
    
    return {
        version = Lifecycle.GEN,
        character = Character,
        stats = LeaderStats,
        remotes = Remote,
        state = StateManager,
        settings = SettingsManager,
        modules = {
            ascend = AscendManager,
            aura = AuraManager,
            guild = GuildManager,
            upgrade = UpgradeManager,
            sacrifice = SacrificeManager,
            totem = TotemManager,
            ap = APUpgradeManager,
            farm = FarmManager,
            ui = UIManager,
            raid = RaidManager,
            timeTrial = TimeTrialManager,
            perf = PerfManager,
        }
    }
end

-- ── Execute Bootstrap ─────────────────────────────────────
local ok, result = pcall(bootstrap)
if not ok then
    Logger.error("BOOTSTRAP", result)
else
    _G.MeleeRNG = result
end

return result
