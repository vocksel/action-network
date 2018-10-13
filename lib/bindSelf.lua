--[[
  bindSelf()
  ------

  Used for binding `self` to a method so it can be called without colon notation.

  Typically this is used in Roact components, as this makes it easy to attach
  methods as callbacks to sub-components.

  Usage with Roact:

    local Stateful = Roact.Component:extend("Stateful")

    function Stateful:doSomething()
      print("Foo")
    end

    function Stateful:render()
      return Roact.createElement("TextButton", {
        -- This will print "Foo" each time the TextButton is clicked
        [Roact.Event.MouseButton1Down] = bindSelf(self, self.doSomething)
      })
    end
--]]

local function bindSelf(self, func)
    return function(...)
        return func(self, ...)
    end
end

return bindSelf
