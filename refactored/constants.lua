--[[ ════════════════════════════════════════════════════════
     MODULE: Constants & Configuration
     ════════════════════════════════════════════════════════
     Central location for all magic numbers and configuration values.
]]

local CONSTANTS = {
    -- Network URLs
    NEXUSLIB_URL = "https://raw.githubusercontent.com/headshot7535-png/Nexuslib/main/Nexuslib",
    SCRIPT_URL = "https://raw.githubusercontent.com/headshot7535-png/Untitled-Melee-RNG/main/Untitled%20Melee%20RNG",

    -- File & Persistence
    SETTINGS_FILE = "meleernq_settings.json",
    SETTINGS_BACKUP_SUFFIX = ".bak",
    SETTINGS_SCHEMA_VERSION = 1,

    -- Bootstrap & Lifecycle
    LOCALPLAYER_WAIT_TIMEOUT = 60,
    LOCALPLAYER_WAIT_INTERVAL = 0.3,
    LOCALPLAYER_WAIT_TIME = 2,

    -- Ascend: Teleportation
    ASCEND_TP_NEAR_STUDS = 20,
    ASCEND_TP_RETRY_SEC = 0.12,
    ASCEND_TP_MAX_CHASE = 90,
    ASCEND_STAT_WAIT_ITER = 60,
    DEFAULT_ASCEND_TP_X = 496.9,
    DEFAULT_ASCEND_TP_Y = 222.1,
    DEFAULT_ASCEND_TP_Z = -7380.4,

    -- Ascend: Aura Roll UI
    AURA_KEEP_POLL_SEC = 0.2,
    AURA_KEEP_MAX_WAIT_SEC = 90,
    AURA_NO_ROLL_SKIP_SEC = 22,
    AURA_MAINTAIN_COOLDOWN = 2.5,

    -- Ascend: Kill Requirements
    ASCEND_KILL_GATE_MULTIPLIER = 1000000,

    -- Guild: Buff System
    GUILD_BUFF_ORDER = {
        "Roll Speed", "Kill Multiplier", "Mana Multiplier", "Damage Multiplier", "Max Guild Members",
    },

    GUILD_BUFF_COST_FALLBACK = {
        ["Roll Speed"] = function(l) return 5 + l * 20 end,
        ["Kill Multiplier"] = function(l) return 20 + l * 10 end,
        ["Mana Multiplier"] = function(l) return 7 + l * 15 end,
        ["Damage Multiplier"] = function(l) return 10 + l * 10 end,
        ["Max Guild Members"] = function(l) return 10 + l * 20 end,
    },

    -- Ascend: AP Upgrades
    ASCEND_AP_MAX_LEVEL = 10,

    ASCEND_AP_ORDER = {
        "Boss Raid SP Multiplier", "Faster Rolls", "Zombie with weapon chance", "Double weapon chance",
        "Ascend points upgrade", "Chance to keep upgrade when ascend", "Totem Of Fortune Sacrifices",
    },

    ASCEND_AP_COST_FALLBACK = {
        ["Boss Raid SP Multiplier"] = function(nextL) return 2 * nextL end,
        ["Faster Rolls"] = function(nextL) return 2 * nextL end,
        ["Zombie with weapon chance"] = function(nextL) return 3 * nextL end,
        ["Double weapon chance"] = function(nextL) return 3 * nextL end,
        ["Ascend points upgrade"] = function(nextL) return 4 * nextL end,
        ["Chance to keep upgrade when ascend"] = function(nextL) return 4 * nextL end,
        ["Totem Of Fortune Sacrifices"] = function(nextL) return 2 * nextL end,
    },

    -- Upgrades
    UPGRADE_ORDER = {
        "Weapons Equipped", "Damage Multiplier", "Enemy Spawn Rate", "Enemy Limit",
        "Mana Multiplier", "Spin Speed", "RNG Luck", "Kill Multiplier",
        "Skill Point Multiplier", "Boss Spawn Chance",
    },

    -- Performance & Rendering
    HITBOX_SIZE_DEFAULT = 500,
    HITBOX_SIZE_MIN = 10,
    HITBOX_SIZE_MAX = 100000,
    HITBOX_DUTY_CYCLE_DEFAULT = 2,
    GC_INTERVAL_SEC = 60,

    -- Default Walk Speed
    WALK_SPEED_DEFAULT = 16,

    -- Sacrifice (Fountain)
    SACRIFICE_RARITY_TIERS_MAX = 9,
    SACRIFICE_DEFAULT_KEEP_QTY = 0,

    -- Totem of Fortune
    TOTEM_CYCLE_SEC = 3600,
    TOTEM_MAX_PER_CYCLE = 25,
    TOTEM_DEFAULT_RARITY_CAP_IDX = 7,
    TOTEM_DEFAULT_KEEP_QTY = 0,
    TOTEM_RARITY_TIERS_MAX = 9,

    -- Time Trial
    TIME_TRIAL_DEFAULT_LEAVE_STAGE = 0,

    -- Logging & Debug
    VERBOSE_CONSOLE = false,
}

return CONSTANTS
