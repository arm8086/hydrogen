-- Taken from my "idolua" repository.
-- Cleaned it up a little since the first draft from the original repo looked.. weird.

return {
	HookPart = function(self, Target: Instance, OffsetCFrame: CFrame)
		local Remote = Instance.new("RemoteFunction", owner.PlayerGui)
		Remote.Name = game:GetService("HttpService"):GenerateGUID(false)

		Remote.OnServerInvoke = function(Player, MethodCall)
			if MethodCall == "GetPart" then
				Target.Anchored = false
				Target:SetNetworkOwner(owner)
				Target.CanCollide = false
				return Target
			elseif MethodCall == "GetOffset" then
				return OffsetCFrame
			end
		end

		NLS([[
			  local RunService = game:GetService("RunService")
			  local Players = game:GetService("Players")
			  
			  local Remote = script.Parent
			  local Target = Remote:InvokeServer("GetPart")
			  
			  local BodyPos = Instance.new("BodyPosition", Target)
			  BodyPos.D = 350
			  BodyPos.MaxForce = Vector3.new(1, 1, 1) * math.huge
			  BodyPos.P = 4500
			  
			  local BodyGyro = Instance.new("BodyGyro", Target)
			  BodyGyro.P = 4500
			  BodyGyro.MaxTorque = Vector3.new(1, 1, 1) * math.huge
			  BodyGyro.D = 350
			  
			  local LocalPlayer = Players.LocalPlayer
			  
			  local Character = LocalPlayer.Character
			  LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
			    Character = NewCharacter
			  end)
			  
			  local OffsetCFrame = Remote:InvokeServer("GetOffset")
			  
			  RunService.RenderStepped:Connect(function()
			    local AbsoluteOffset = Character.HumanoidRootPart.CFrame * OffsetCFrame
			    BodyPos.Position = AbsoluteOffset.Position
			    BodyGyro.CFrame = AbsoluteOffset
			  end)
		]], Remote)
	end,
}
