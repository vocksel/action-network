local runService = game:GetService("RunService")

local CAN_ONLY_CALL_FROM_SERVER = "%s() can only be called from the server"
local CAN_ONLY_CALL_FROM_CLIENT = "%s() can only be called from a client"
local BAD_ARGUMENT = "bad argument #%i to '%s' (%s expected, got %s)"

local Network = {}
Network.__index = Network

function Network.new(remote)
    local self = {}

    self._remote = remote
    self._actions = {}

    return setmetatable(self, Network)
end

-- server only
function Network:init()
    assert(runService:IsServer(), CAN_ONLY_CALL_FROM_SERVER:format("init"))

    self._remote.OnServerEvent:Connect(function(player, action)
        assert(type(action) == "table")

        for actionType, callback in pairs(self._actions) do
            if action.type == actionType then
                callback(player, action)
            end
        end
    end)
end

-- server only
function Network:on(actionType, callback)
    assert(runService:IsServer(), CAN_ONLY_CALL_FROM_SERVER:format("on"))
    assert(type(actionType) == "string", BAD_ARGUMENT:format(1, "network.on()", "string", type(actionType)))
    assert(type(callback) == "function", BAD_ARGUMENT:format(2, "network.on()", "function", type(callback)))

    self._actions[actionType] = callback
end

-- client only
function Network:dispatch(action)
    assert(runService:IsClient(), CAN_ONLY_CALL_FROM_CLIENT:format("dispatch"))
    assert(type(action) == "table", BAD_ARGUMENT:format(1, "network.dispatch()", "table", type(action)))

    self._remote:FireServer(action)
end

return Network
