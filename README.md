# action-network

A simple networking module that works off of Rodux-style actions.

## Usage

To start off you just need to create a basic action for the server and client to use:

```lua
local function fooAction(a, b)
    return {
        type = "fooAction",
        a = a,
        b = b
    }
end

return fooAction
```

You can then setup listeners on the server or client using `on` to listen for
the action's type, and then a handler for it.

```lua
local network = require(game.ReplicatedStorage.Network)

network:on("fooAction", function(player, action)
    print(player, "dispatched", action.type, "with args:", action.a, action.b)
end)
```

And on the client you dispatch the action to the server:

```lua
local network = require(game.ReplicatedStorage.Network)
local fooAction = require(game.ReplicatedStorage.FooAction)

network:dispatch(fooAction(true, false))
```

This will print "Player1 disaptched fooAction with args: true false" on the server. And that's all there is to it.

## API

**`network:on(string actionType, function callback)`**

Sets up a listener for an action with a `type` of `actionType`. `callback` is run when that action is dispatched, and the action object is passed in as an argument.

**`network:dispatch(table action)`**

When called from the client, dispatches `action` to the server. When called from the server, dispatches `action` to _all_ clients.

Assuming you called `network:on()` for the action type, the associated callback will be run.
