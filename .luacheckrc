files[".luacheckrc"].global = false

stds.testez = {
    read_globals = {
        "describe", "it", "expect", "itFOCUS", "itSKIP", "FOCUS", "SKIP"
    }
}

stds.roblox = {
    globals = {
        "script", "workspace", "plugin",
    },

    read_globals = {
        -- Roblox globals (http://wiki.roblox.com/index.php?title=Global_namespace/Roblox_namespace)

        -- variables
        "game", "Enum", math = { fields = { "clamp", "noise", "sign" } },
        -- functions
        "delay", "elapsedTime", "settings", "spawn", "tick", "time", "typeof",
        "UserSettings", "version", "wait", "warn",
        -- classes
        "CFrame", "Color3", "Instance", "PhysicalProperties", "Ray", "Rect",
        "Region3", "TweenInfo", "UDim", "UDim2", "Vector2", "Vector3", "Random",
        "NumberRange", "NumberSequence", "ColorSequence"
    }
}

ignore = {
    "self",
}

max_line_length = false

std = "lua51+roblox+testez"
