local network = require(game.ReplicatedStorage.Network)
local sampleAction = require(game.ReplicatedStorage.SampleAction)

network.dispatch(sampleAction(true, false))
