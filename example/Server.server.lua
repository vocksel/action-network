local repStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local network = require(repStorage.Network)

local sample = network:event("sample")

sample:connect(function(player, ...)
    print(player, "fired 'sample' with args:", ...)
    sample:fireTo(player, "pong")
end)

players.PlayerAdded:Connect(function(player)
    local message = network:event("message")
    message:fireTo(player, "Welcome to the game!")
    message:fireExceptTo(player, tostring(player) .. " joined the game!")
end)
