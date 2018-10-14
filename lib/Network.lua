local players = game:GetService("Players")
local runService = game:GetService("RunService")

local t = require(script.Parent.t)

local Network = {}
Network.__index = Network

function Network.new(remote)
    assert(t.instance("RemoteEvent")(remote))

    local self = {}

    self._remote = remote
    self._actions = {}
    self._connection = nil

    return setmetatable(self, Network)
end

function Network:_serverInit()
    self._connection = self._remote.OnServerEvent:Connect(function(player, action)
        assert(t.table(action))

        local callback = self._actions[action.type]
        if callback then
            callback(player, action)
        end
    end)
end

function Network:_clientInit()
    self._connection = self._remote.OnClientEvent:Connect(function(action)
        assert(t.table(action))

        local callback = self._actions[action.type]
        if callback then
            callback(action)
        end
    end)
end

function Network:init()
    assert(not self._connection, "The RemoteEvent has already been connected. Was init() called twice?")

    if runService:IsServer() then
        self:_serverInit()
    else
        self:_clientInit()
    end
end

local onCheck = t.tuple(t.string, t.callback)
function Network:on(actionType, callback)
    assert(onCheck(actionType, callback))

    self._actions[actionType] = callback
end

function Network:dispatch(action)
    assert(t.table(action))

    if runService:IsServer() then
        self._remote:FireAllClients(action)
    else
        self._remote:FireServer(action)
    end
end

local dispatchToCheck = t.tuple(t.instance("Player"), t.table)
function Network:dispatchTo(player, action)
    assert(dispatchToCheck(player, action))

    self._remote:FireClient(player, action)
end

local dispatchExcludingCheck = t.tuple(t.instance("Player"), t.table)
function Network:dispatchExcept(player, action)
    assert(dispatchExcludingCheck(player, action))

    for _, otherPlayer in pairs(players:GetPlayers()) do
        if player ~= otherPlayer then
            self._remote:FireClient(otherPlayer, action)
        end
    end
end

return Network
