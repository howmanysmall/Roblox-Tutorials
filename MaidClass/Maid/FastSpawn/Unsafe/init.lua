local unpack, require = unpack, require

local SpawnEvent = require(script.BindableEvent).new()
SpawnEvent:Connect(function(Function, Pointer) Function(Pointer()) end)

local function FastSpawn(Function, ...)
	local Arguments = {...}
	SpawnEvent:Fire(Function, function() return unpack(Arguments) end)
end

return FastSpawn
