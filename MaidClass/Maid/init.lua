local RunService = game:GetService("RunService")
local FastSpawn = require(script.FastSpawn).UNSAFE

local typeof = typeof
local pcall = pcall
local tostring = tostring
local setmetatable = setmetatable
local next = next

local function TaskDestructor(Task)
	local TaskType = typeof(Task)
	if TaskType == "function" then
		FastSpawn(Task)
	elseif TaskType == "RBXScriptConnection" then
		Task:Disconnect()
	elseif TaskType == "string" then
		pcall(function()
			RunService:UnbindFromRenderStep(Task)
		end)
	elseif TaskType == "Instance" or (TaskType == "table" and Task.Destroy) then
		Task:Destroy()
	else
		warn("Unhandled maid task \"" .. tostring(Task) .. "\" of type \"" .. TaskType .. "\"", debug.traceback())
	end
end

local Maid = { }
Maid.__index = Maid

function Maid.new()
	return setmetatable({
		Tasks = { };
	}, Maid)
end

function Maid:GiveTask(...)
	local TasksToAdd = {...}
	for Index in ipairs(TasksToAdd) do
		self.Tasks[#self.Tasks + 1] = TasksToAdd[Index]
	end
	return ...
end

function Maid:CleanupAllTasks()
	local Tasks = self.Tasks
	
	for Index, Task in ipairs(Tasks) do
		if typeof(Task) == "RBXScriptConnection" then
			Tasks[Index] = nil
			Task:Disconnect()
		end
	end
	
	local Index, Task = next(Tasks)
	while Task ~= nil do
		Tasks[Index] = nil
		TaskDestructor(Task)
		Index, Task = next(Tasks)
	end
end

function Maid:Cleanup(Task)
	self:RemoveTask(Task)
	TaskDestructor(Task)
end

function Maid:RemoveTask(Task)
	local Tasks = self.Tasks
	for Index, OtherTask in ipairs(Tasks) do
		if OtherTask == Task then
			Tasks[Index] = nil
			break
		end
	end
end

function Maid:Destroy()
	self:CleanupAllTasks()
	setmetatable(self, nil)
end

return Maid
