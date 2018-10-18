# network

Easy communication between the server and clients with a familiar API.

## Quick Start

```lua
-- client
local network = require(game.ReplicatedStorage.Network)

local event = network:event("message")

event:fireServer("foo")
```

```lua
-- server
local network = require(game.ReplicatedStorage.Network)

local event = network:event("message")

event:connect(function(player, message)
    print(message) -- "foo"
end)
```

## API

**`network:event(string eventName)`**

Returns an `Event` instance. Either a new one, or one that already exists by the given name.

**`Event:connect(function callback)`**

Sets `callback` as a listener, which will be called when the event is fired by the server or client (whichever one the event was not connected on).

The callback is passed in the player that fired the event on the server, followed by any arguments. The client just gets arguments passed in.

```lua
-- client
event:connect(function(...) end)

-- server
event:connect(function(player, ...) end)
```

**`Event:fireServer(Tuple arguments)`**

Fires this event to the server. Client only.

**`Event:fireAllClients(Tuple arguments)`**

Fires this event to all clients. Server only.

**`Event:fireTo(Player player, Tuple arguments)`**

Fires this event to the given client. Server only.

**`Event:fireExceptTo(Player excludedPlayer, Tuple arguments)`**

Fires this event to all clients _except_ the one given.

This is useful for replicating a client's local change. Typically the user will update something locally so it happens instantly. The server then verifies the change and will use this method to let all other clients know about the change.

```lua
-- server
network:event("shoot"):connect(function(player, pos)
    validate(pos)
    -- after validating, let all other clients know about the change
    network:event("replicateShot"):fireExceptTo(player, pos)
end)
```

**`Event:fireToGroup(Array<Player> group, Tuple arguments)`**

Fires this event to all the clients specified. Server only.

**`Event:fireExceptToGroup(Array<Player> excludedGroup, Tuple arguments)`**

Fires this event to all clients _except_ the ones specified. Server only.
