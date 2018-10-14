local repStorage = game:GetService("ReplicatedStorage")
local network = require(repStorage.Network)
local sampleAction = require(repStorage.SampleAction)

network:init()

network:on("sampleAction", function(action)
    print("server responded with:", action.arg)
end)

network:dispatch(sampleAction("ping"))
