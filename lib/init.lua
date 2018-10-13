local repStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

local network = {
    STORAGE_LOCATION = repStorage,
    REMOTE_NAME = "ActionDispatcherEvent",
    _actions = {}
}

local CAN_ONLY_CALL_FROM_SERVER = "%s() can only be called from the server"
local CAN_ONLY_CALL_FROM_CLIENT = "%s() can only be called from a client"
local BAD_ARGUMENT = "bad argument #%i to '%s' (%s expected, got %s)"

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
    assert(runService:IsServer(), CAN_ONLY_CALL_FROM_SERVER:format("network.init"))

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
    assert(type(actionType) == "string", BAD_ARGUMENT:format(1, "network.on()", "string", type(actionType)))
    assert(type(callback) == "function", BAD_ARGUMENT:format(2, "network.on()", "function", type(callback)))

    network._actions[actionType] = callback
end

-- client only
function network.dispatch(action)
    assert(runService:IsClient(), CAN_ONLY_CALL_FROM_CLIENT:format("network.init"))
    assert(type(action) == "string", BAD_ARGUMENT:format(1, "network.dispatch()", "table", type(action)))

    local remote = clientGetRemote()
    remote:FireServer(action)
end

return network
