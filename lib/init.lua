local repStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

local network = {
    STORAGE_LOCATION = repStorage,
    REMOTE_NAME = "ActionDispatcherEvent",
    _actions = {}
}

local function createRemote()
    local remote = Instance.new("RemoteEvent")
    remote.Name = network.REMOTE_NAME
    remote.Parent = network.STORAGE_LOCATION

    return remote
end

local function clientGetRemote()
    local remote = network.STORAGE_LOCATION:WaitForChild(network.REMOTE_NAME, 2)
    assert(remote, "Could not find RemoteEvent for dispatching. Did you forget to call network.init()?")
    return remote
end

-- server only
function network.init()
    assert(runService:IsServer(), "network.init() can only be called from the server")

    local remote = createRemote()

    remote.OnServerEvent:Connect(function(player, action)
        assert(type(action) == "table")

        for actionType, callback in pairs(network._actions) do
            if action.type == actionType then
                callback(player, action)
            end
        end
    end)
end

-- server only
function network.on(actionType, callback)
    assert(runService:IsServer(), "'network.on()' can only be called from the server")
    assert(type(actionType) == "string", ("bad argument #1 to 'network.on()' (string expected, got %s)"):format(type(actionType)))
    assert(type(callback) == "function", ("bad argument #2 to 'network.on()' (function expected, got %s"):format(type(callback)))

    network._actions[actionType] = callback
end

-- client only
function network.dispatch(action)
    assert(runService:IsClient(), "'network.dispatch()' can only be called from a client")
    assert(type(action) == "table", ("bad argument #1 to 'network.dispatch() '(table expected, got %s)"):format(type(action)))

    local remote = clientGetRemote()
    remote:FireServer(action)
end

return network
