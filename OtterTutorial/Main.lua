local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Otter = require(ReplicatedStorage:WaitForChild("Otter"))

local Gui = script.Parent
local TextButton = Gui:WaitForChild("TextButton")

math.randomseed(tick() % 1 * 1E7)

local State = {
	XOffset = 200;
	YOffset = 50;
	Rotation = 0;
}

local ClickSpring = Otter.createGroupMotor
{
	XOffset = 200;
	YOffset = 50;
	Rotation = 0;
}

ClickSpring:onStep(function(Values)
	State.XOffset = Values.XOffset
	State.YOffset = Values.YOffset
	State.Rotation = Values.Rotation
end)

RunService:BindToRenderStep("SpringUpdate", Enum.RenderPriority.First.Value, function()
	TextButton.Size = UDim2.new(0, State.XOffset, 0, State.YOffset)
	TextButton.Rotation = State.Rotation
end)

TextButton.MouseButton1Click:Connect(function() -- lazy
	ClickSpring:stop()
	ClickSpring.__states.XOffset.velocity = math.random(100, 300)
	ClickSpring.__states.YOffset.velocity = math.random(25, 100)
	ClickSpring.__states.Rotation.velocity = math.random(-100, 100)
	
	ClickSpring:setGoal
	{
		XOffset = Otter.spring(200, { dampingRatio = 0.1, frequency = 4 });
		YOffset = Otter.spring(50, { dampingRatio = 0.1, frequency = 4 });
		Rotation = Otter.spring(0, { dampingRatio = 0.1, frequency = 4 });
	}
	
	ClickSpring:start()
end)
