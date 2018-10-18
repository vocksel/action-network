local t = require(script.Parent.t)
local Event = require(script.Parent.Event)

local Network = {}
Network.__index = Network

function Network.new(remote)
    assert(t.instance("RemoteEvent")(remote))

    local self = {}

    self._remote = remote
    self._events = {}

    return setmetatable(self, Network)
end

function Network:event(eventName)
    assert(t.string(eventName))

    local event = self._events[eventName]

    if not event then
        event = Event.new(eventName, self._remote)
        event:init()
        self._events[eventName] = event
    end

    return event
end

return Network
