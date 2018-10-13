local bindSelf = require(script.bindSelf)
local getRemote = require(script.getRemote)
local constants = require(script.constants)
local Network = require(script.Network)

local remote = getRemote()
local network = Network.new(remote)

local api = {}

for _, methodName in pairs(constants.EXPORTED_METHODS) do
    api[methodName] = bindSelf(network, network[methodName])
end

return api
