local repStorage = game:GetService("ReplicatedStorage")

local network = require(repStorage.Network)

local sample = network:event("sample")

sample:connect(function(response)
    print("server responded with:", response)
end)

sample:fire("ping")

network:event("message"):connect(function(message)
    print(message)
end)
