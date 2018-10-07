# action-network

A simple networking module that works off of Rodux actions.

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

You then initialize the module and listen for dispatched actions on the server:

```lua
local network = require(game.ReplicatedStorage.Network)

-- Important! The client will have nothing to dispatch to if you don't call this
network.init()

network.on("fooAction", function(player, action)
    print(player, "dispatched", action.type, "with args:", action.a, action.b)
end)
```

And on the client you dispatch the action to the server:

```lua
local network = require(game.ReplicatedStorage.Network)
local fooAction = require(game.ReplicatedStorage.FooAction)

network.dispatch(fooAction(true, false))
```

This will print "Player1 disaptched fooAction with args: true false" on the server. And that's all there is to it.

## API

**`network.init()`**

Server only. Handles creating the RemoteEvent needed for communicating between server/client, and listening for any dispatched actions.

This must be called before any dispatch calls.

**`network.on(string actionType, function callback)`**

Server only. Sets up a listener for an action with a `type` of `actionType`. `callback` is run when that action is dispatched.

**`network.dispatch(table action)`**

Client only. Dispatches `action` to the server. Assuming you called `network.on()` for the action type, the associated callback will be run.
