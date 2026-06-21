local RunService = game:GetService("RunService")
local Animation = {}
local connections = {}

local function ClearAllAnimations()
	for _, c in ipairs(connections) do
		pcall(function() c:Disconnect() end)
	end
	table.clear(connections)
end

function Animation.Apply(theme, root)
	ClearAllAnimations()

	if not theme or not root or not getgenv().ShineEnabled or not theme.ShineEnabled or not theme.Shine then
		return
	end

	local ShineConfig = theme.Shine
	local Speed = ShineConfig.Speed or 0.5
	local RotationSpeed = ShineConfig.RotationSpeed or 25
	local ColorSequence = ShineConfig.ColorSequence
	
	for _, obj in ipairs(root:GetDescendants()) do
		if obj:IsA("UIGradient") then
			local t = 0
			local conn
			conn = RunService.RenderStepped:Connect(function(dt)
				local t = obj:GetAttribute("old_t") or 0
				t += dt * Speed
                obj:SetAttribute("old_t", t)
				
				obj.Rotation = (t * RotationSpeed) % 360
				if ColorSequence then
					obj.Color = ColorSequence
				end
			end)
			table.insert(connections, conn)
		end

		if obj:IsA("UIStroke") and theme.StrokeShine then
			local from = theme.StrokeDark or theme.AcrylicBorder
			local shine = theme.Accent
			local t = 0
			local conn
			conn = RunService.RenderStepped:Connect(function(dt)
				local t = obj:GetAttribute("old_t") or 0
				t += dt * Speed
				obj.Thickness = 2
				obj:SetAttribute("old_t", t)
			
				obj.Color = from:Lerp(shine, (math.sin(t) + 1) / 2)
			end)
			table.insert(connections, conn)
		end
	end
end

return Animation
