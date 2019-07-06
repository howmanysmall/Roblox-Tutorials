local RunService = game:GetService("RunService")
local Maid = require(script.Maid).new()

local Connection = Maid:GiveTask(RunService.Heartbeat:Connect(function(DeltaTime)
	print(DeltaTime)
end))

wait(5)

if Connection.Connected then
	Maid:CleanupAllTasks()
end
