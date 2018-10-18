local players = game:GetService("Players")
local runService = game:GetService("RunService")

local t = require(script.Parent.t)

-- Checks if a value is in the given array
local function isInList(value, array)
    for _, other in pairs(array) do
        if value == other then
            return true
        end
    end
    return false
end

local Event = {}
Event.__index = Event

local newCheck = t.tuple(t.string, t.instance("RemoteEvent"))
function Event.new(eventName, remote)
    assert(newCheck(eventName, remote))

    local self = {}

    self.name = eventName
    self._remote = remote
    self._listeners = {}

    return setmetatable(self, Event)
end

local _handleListenersCheck = t.tuple(t.string, t.table)
function Event:_handleListeners(eventName, args)
    assert(_handleListenersCheck(eventName, args))

    if eventName == self.name then
        for callback in pairs(self._listeners) do
            callback(unpack(args))
        end
    end
end

function Event:init()
    if runService:IsServer() then
        self._remote.OnServerEvent:Connect(function(player, eventName, ...)
            self:_handleListeners(eventName, { player, ... })
        end)
    else
        self._remote.OnClientEvent:Connect(function(eventName, ...)
            self:_handleListeners(eventName, { ... })
        end)
    end
end

function Event:fire(...)
    if runService:IsServer() then
        self._remote:FireAllClients(self.name, ...)
    else
        self._remote:FireServer(self.name, ...)
    end
end

-- Ensures the given argument is either a single player or array of players.
local playerGroupCheck = t.union(
    t.instance("Player"),
    t.array(t.instance("Player"))
)

function Event:fireTo(playerOrPlayers, ...)
    assert(playerGroupCheck(playerOrPlayers))

    if type(playerOrPlayers) ~= "table" then
        playerOrPlayers = { playerOrPlayers }
    end

    for _, player in pairs(playerOrPlayers) do
        self._remote:FireClient(player, self.name, ...)
    end
end

function Event:fireExceptTo(playerOrPlayers, ...)
    assert(playerGroupCheck(playerOrPlayers))

    print(playerOrPlayers)

    if type(playerOrPlayers) ~= "table" then
        playerOrPlayers = { playerOrPlayers }
    end

    for _, player in pairs(players:GetPlayers()) do
        if not isInList(player, playerOrPlayers) then
            self._remote:FireClient(player, self.name, ...)
        end
    end
end

function Event:connect(callback)
    self._listeners[callback] = true
end

return Event
