local BindableEvent = { }
BindableEvent.__index = BindableEvent
BindableEvent.ClassName = "BindableEvent"

local setmetatable = setmetatable

function BindableEvent.new()
	return setmetatable({ }, BindableEvent)
end

function BindableEvent:Fire(...)
	for Index in ipairs(self) do
		local Thread = coroutine.create(self[Index])
		coroutine.resume(Thread, ...)
	end
end

function BindableEvent:Connect(Function)
	self[#self + 1] = Function
end

function BindableEvent:Disconnect(Function)
	local Size = #self

	for Index in ipairs(self) do
		if Function == self[Index] then
			self[Index] = self[Size]
			self[Size] = nil
			break
		end
	end
end

function BindableEvent:Destroy()
	for Index in ipairs(self) do self[Index] = nil end
	setmetatable(self, nil)
end

return BindableEvent
