local runService = game:GetService("RunService")

local constants = require(script.Parent.constants)

local name = constants.REMOTE_NAME
local storage = constants.REMOTE_STORAGE

local function getRemote()
    if runService:IsServer() then
        local remote = Instance.new("RemoteEvent")
        remote.Name = name
        remote.Parent = storage
        return remote
    else
        local remote = storage:WaitForChild(name, constants.WAIT_FOR_REMOTE_TIMEOUT)
        assert(remote, "Could not find the RemoteEvent in time. Was action-network not required on the server?")
        return remote
    end
end

return getRemote
