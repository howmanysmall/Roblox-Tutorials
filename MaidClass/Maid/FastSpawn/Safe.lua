local unpack = unpack

local SpawnEvent = Instance.new("BindableEvent")
SpawnEvent.Event:Connect(function(Function, Pointer) Function(Pointer()) end)

local function FastSpawn(Function, ...)
	local Arguments = {...}
	SpawnEvent:Fire(Function, function() return unpack(Arguments) end)
end

return FastSpawn
