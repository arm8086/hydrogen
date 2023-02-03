local CurrentTheme = {
	ColorThemes = {
		Dark = Color3.fromRGB(77, 77, 77),
		Light = Color3.fromRGB(230, 230, 230)
	},
	TextColors = {
		Dark = Color3.fromRGB(192, 192, 192),
		Light = Color3.fromRGB(0, 0, 0)
	},
	TitlebarThemes = {
		Dark = Color3.fromRGB(97, 97, 97),
		Light = Color3.fromRGB(176, 176, 176)
	},
	TransparencyEnabled = true,
	Theme = "Dark"
}

function framework_New(instance, properties, descendants, callbacks)
	local Instance2 = Instance.new(instance)
	for i, v in ipairs(properties) do
		Instance2[i] = v
	end
	if descendants then
		for i, v in ipairs(descendants) do
			v.Parent = Instance2
		end
	end
	if callbacks then
		for i, v in ipairs(callbacks) do
			if Instance2[i] and Instance2[i].Connect then
				Instance2[i]:Connect(v)
			else
				warn("Event", i, "is not recognised.")
			end
		end
	end
	if instance == "TextBox" then
		Instance2.ClearTextOnFocus = false
		Instance2.TextEditable = false
	end
	return Instance2
end

function base_CreateRoundedWidget(size, position, parent)
	return framework_New("Frame", {
		Name = "Widget",
		Parent = parent,
		Size = size,
		Position = position,
		BackgroundTransparency = (CurrentTheme.TransparencyEnabled == true and 0.4) or 0,
		BackgroundColor3 = CurrentTheme.ColorThemes[CurrentTheme.Theme]
	}, {
		framework_New("UICorner", {
			CornerRadius = UDim.new(0, 8)
		})
	})
end

function base_CreateCircularFrame(size, position, parent)
	return framework_New("CanvasGroup", {
		Name = "Circle",
		Parent = parent,
		Size = size,
		Position = position,
		BackgroundColor3 = CurrentTheme.ColorThemes[CurrentTheme.Theme]
	}, {
		framework_New("UICorner", {
			CornerRadius = UDim.new(1, 0)
		})
	})
end

function base_CreateTextButton(size, position, parent, callback, text)
	return framework_New("TextButton", {
		Name = "Button",
		Parent = parent,
		Size = size,
		Position = position,
		Text = text,
		BackgroundTransparency = (CurrentTheme.TransparencyEnabled == true and 0.4) or 0,
		BackgroundColor3 = CurrentTheme.ColorThemes[CurrentTheme.Theme]
	}, {
		framework_New("UICorner", {
			CornerRadius = UDim.new(0, 6)
		})
	}, {
		MouseButton1Click = callback,
	})
end

function base_CreateImageButton(size, position, parent, image, callback)
	return framework_New("ImageButton", {
		Name = "Button",
		Parent = parent,
		Size = size,
		Position = position,
		Image = image,
		BackgroundTransparency = (CurrentTheme.TransparencyEnabled == true and 0.4) or 0,
		BackgroundColor3 = CurrentTheme.ColorThemes[CurrentTheme.Theme]
	}, {
		framework_New("UICorner", {
			CornerRadius = UDim.new(0, 6)
		})
	}, {
		MouseButton1Click = callback,
	})
end

local proc = {}

function base_CreateWindow(size, position, parent, name)
	local pid = #proc + 1
	return framework_New("CanvasGroup", {
		Name = name,
		Parent = parent,
		Size = size,
		Position = position,
		BackgroundTransparency = (CurrentTheme.TransparencyEnabled == true and 0.4) or 0,
		BackgroundColor3 = CurrentTheme.ColorThemes[CurrentTheme.Theme]
	}, {
		framework_New("UICorner", {
			CornerRadius = UDim.new(0, 4)
		}),
		framework_New("Frame", {
			Name = "TitleBar",
			Size = UDim2.new(1, 0, 0, 24),
			BackgroundTransparency = (CurrentTheme.TransparencyEnabled == true and 0.4) or 0,
			BackgroundColor3 = CurrentTheme.TitlebarThemes[CurrentTheme.Theme]
		}, {
			framework_New("Frame", {
				Name = "close",
				Position = UDim2.new(1, -48, 0, 0),
				Size = UDim2.fromOffset(48, 24),
				BackgroundTransparency = 1,
			}, {
				framework_New("ImageLabel", {
					Image = "rbxassetid://12223525050",
					AnchorPoint = Vector2.one / 2,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(12, 12),
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Fit
				})
			}),
			framework_New("Frame", {
				Name = "dock",
				Position = UDim2.new(1, -96, 0, 0),
				Size = UDim2.fromOffset(48, 24),
				BackgroundTransparency = 1,
			}, {
				framework_New("ImageLabel", {
					Image = "rbxassetid://12223524847",
					AnchorPoint = Vector2.one / 2,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(12, 12),
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Fit
				})
			}),
			framework_New("Frame", {
				Name = "min",
				Position = UDim2.new(1, -144, 0, 0),
				Size = UDim2.fromOffset(48, 24),
				BackgroundTransparency = 1,
			}, {
				framework_New("ImageLabel", {
					Image = "rbxassetid://12223524685",
					AnchorPoint = Vector2.one / 2,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(12, 12),
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Fit
				})
			}),
			framework_New("TextBox", {
				Name = "title",
				Size = UDim2.new(1, -168, 0, 24),
				Text = name,
				BackgroundTransparency = 1,
				TextColor3 = Color3.new(1, 1, 1),
				TextXAlignment = Enum.TextXAlignment.Left
			})
		})
	})
end

function base_makeWallpaper(imageId, parent)
	return framework_New("ImageLabel", {
		Image = imageId,
		Size = UDim2.fromScale(1, 1),
		Parent = parent
	})
end

local screen = Instance.new("Part")
screen.Name = "screen"
screen.BottomSurface = Enum.SurfaceType.Smooth
screen.TopSurface = Enum.SurfaceType.Smooth
screen.Color = Color3.fromRGB(17, 17, 17)
screen.Size = Vector3.new(19.2, 10.8, 0)
screen.CastShadow = false
screen.CanCollide = false
screen.Anchored = true

local gui = Instance.new("SurfaceGui")
gui.Name = "gui"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Face = Enum.NormalId.Back
gui.ClipsDescendants = true
gui.CanvasSize = Vector2.new(1920, 1080)
gui.Parent = screen

task.defer(function()
	while true do 
		local dt = task.wait()
		screen.CFrame = screen.CFrame:Lerp(owner.Character.HumanoidRootPart.CFrame * CFrame.new(0,screen.Size.Y/3, -6) * CFrame.Angles(0,math.pi,0), 0.2 + (1 - (0.2 ^ dt)))
	end
end)

local wallpaper = base_makeWallpaper("rbxassetid://12186974523", gui)

local taskbar = base_CreateRoundedWidget(UDim2.fromOffset(1824, 72), UDim2.fromOffset(960, 998), gui)
