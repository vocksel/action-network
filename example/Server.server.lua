local repStorage = game:GetService("ReplicatedStorage")
local network = require(repStorage.Network)
local sampleAction = require(repStorage.SampleAction)

network:init()

network:on("sampleAction", function(player, action)
    print(player, "dispatched", action.type, "with arg:", action.arg)
    network:dispatch(sampleAction("pong"))
end)
