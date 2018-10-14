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
    self._actions[actionType] = callback
end

-- client only
function Network:dispatch(action)
    self._remote:FireServer(action)
end

return Network
