local network = require(game.ReplicatedStorage.Network)

network:init()

network:on("sampleAction", function(player, action)
    print(player, "dispatched", action.type, "with args:", action.a, action.b)
end)
