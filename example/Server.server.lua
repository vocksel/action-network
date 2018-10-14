local repStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local network = require(repStorage.Network)
local sampleAction = require(repStorage.SampleAction)
local message = require(repStorage.Message)

network:on("sampleAction", function(player, action)
    print(player, "dispatched", action.type, "with arg:", action.arg)

    -- Note that when the server calls dispatch(), this fires to every client.
    -- Use dispatchTo if you want to fire to one client.
    network:dispatch(sampleAction("pong"))
end)

players.PlayerAdded:Connect(function(player)
    network:dispatchTo(player, message("Welcome to the game!"))
    network:dispatchExcept(player, message(tostring(player) .. " joined the game!"))
end)
