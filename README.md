# t-util
t-util is table utility for Lua and Luau (or Roblox Lua) that is created by Loominatrx.

I created this module because I feel like Lua's table library is lack of something. I added around 20 methods that you can use for your projects.

## Examples
Notes:
1. If you're using Roblox Studio, you need to define t-util as `table`, as Roblox don't let me wrap built-in objects using metatable.
   ```lua
   -- You may replace the require path to where your t-util is located.
   local table = require(game.ReplicatedStorage['t-util'])
   -- ...
   ```
2. If you're not using Roblox Studio, you can `require` it without defining it.
   ```lua
   require('./t-util')
   -- ...
   ```

## Installation
### For Roblox Studio
Paste this code in your command bar to get t-util, and then press Enter.
```lua
local HttpService = game:GetService('HttpService'); HttpService.HttpEnabled = true; local source = HttpService:GetAsync(''); local script = Instance.new('ModuleScript'); script.Name = 't-util'; script.Source = source; script.Parent = game:GetService('ReplicatedStorage');
```
It will create ModuleScript called `t-util` in `ReplicatedStorage`.
### For Lua projects
You can download the source and put `t-util.lua` in your Lua projects, simple as that.

## Examples
Coming soon.
