local getRemote = require(script.getRemote)
local Network = require(script.Network)

local remote = getRemote()
local network = Network.new(remote)

return network
