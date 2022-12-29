# Zelt's UI Lib

I decided to release this since I am remaking it and I don't really like how it looks.
Have fun

Example like in the file above:
<br>
```lua
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/ZeltRblx/ZeltsUI/main/Library.lua'), true)()

local Window = Library:Init({
    Name = "<font color='rgb(125, 93, 255)'>Zelt's</font> UI" -- Rich Text can be used.
})

local Tab = Window:CreateTab({
    Name = "Home",
    Icon = "rbxassetid://11952806790"
})

local SecondTab = Window:CreateTab({
    Name = "Secondary",
    Icon = "rbxassetid://11961977932"
})

local Button = Tab:Button({
    Text = "I'm a button!",
    callback = function()
        print("I have been clicked.")
    end
})

local Label = Tab:Label({
    Text = "I'm a label!"  
})

local Toggle = Tab:Toggle({
    Text = "Toggle",
    callback = function(v)
        print("Toggle state changed to: "..tostring(v))
    end
})

local Slider = Tab:Slider({
    Text = "Slider",
    Default = 50,
    Min = 1,
    Max = 100,
    Rounding = 1, -- How many numbers after the comma. If the rounding is 0 the number will be a whole number (example: 10, 20). If the rounding is 1 the number will be 10.1, if the rounding is 2 the number will be 10.12 and so on.
    callback = function(v)
        print("Slider's value changed to: "..v)
    end
})

local Dropdown = Tab:Dropdown({
    Text = "Dropdown",
    Items = {"This", "is", "a", "dropdown"},
    callback = function(v)
        print("Dropdown's value changed to: "..v)
    end
})
```
