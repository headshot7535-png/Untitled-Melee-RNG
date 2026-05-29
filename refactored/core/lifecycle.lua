--[[ ════════════════════════════════════════════════════════
     MODULE: Lifecycle Management
     ════════════════════════════════════════════════════════
     Re-execution generation tracking and resource cleanup.
]]

local Lifecycle = {}

Lifecycle.GEN = (_G.MeleeRNG_Gen or 0) + 1
_G.MeleeRNG_Gen = Lifecycle.GEN

local _conns = {}
local _threads = {}
local _stopped = false

function Lifecycle.addConn(c)
    if not _stopped then
        _conns[#_conns + 1] = c
    end
end

function Lifecycle.addThread(t)
    if not _stopped then
        _threads[#_threads + 1] = t
    end
end

function Lifecycle.isActive()
    return Lifecycle.GEN == _G.MeleeRNG_Gen
end

function Lifecycle.cleanupAll()
    _stopped = true

    for _, c in ipairs(_conns) do
        pcall(function() c:Disconnect() end)
    end

    for _, t in ipairs(_threads) do
        pcall(function() task.cancel(t) end)
    end

    _conns = {}
    _threads = {}
end

function Lifecycle.getConnCount()
    return #_conns
end

function Lifecycle.getThreadCount()
    return #_threads
end

return Lifecycle
