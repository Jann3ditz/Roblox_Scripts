RunService.RenderStepped:Connect(function()
	if not aimbotEnabled then return end

	local closest = nil
	local shortestDistance = math.huge

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
			local head = plr.Character.Head
			local distance = (head.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
			
			if distance <= 15 then -- ✅ 15-stud range aimbot
				local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
				if onScreen then
					local mouseDist = (Vector2.new(screenPos.X, screenPos.Y) - UIS:GetMouseLocation()).Magnitude
					if mouseDist < shortestDistance then
						shortestDistance = mouseDist
						closest = head
					end
				end
			end
		end
	end

	if closest then
		Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
	end
end)
