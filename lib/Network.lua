local runService = game:GetService("RunService")

local t = require(script.Parent.t)

local Network = {}
Network.__index = Network

function Network.new(remote)
    assert(t.instance("RemoteEvent")(remote))

    local self = {}

    self._remote = remote
    self._actions = {}

    return setmetatable(self, Network)
end

function Network:_serverInit()
    self._remote.OnServerEvent:Connect(function(player, action)
        assert(t.table(action))

        local callback = self._actions[action.type]
        if callback then
            callback(player, action)
        end
    end)
end

function Network:_clientInit()
    self._remote.OnClientEvent:Connect(function(action)
        assert(t.table(action))

        local callback = self._actions[action.type]
        if callback then
            callback(action)
        end
    end)
end

function Network:init()
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

return Network
