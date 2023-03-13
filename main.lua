CurrentTheme = {
	ColorThemes = {
		Dark = Color3.fromRGB(77, 77, 77),
		Light = Color3.fromRGB(230, 230, 230)
	},
	TextColors = {
		Dark = Color3.fromRGB(192, 192, 192),
		Light = Color3.fromRGB(0, 0, 0)
	},
	TitlebarThemes = {
		Dark = Color3.fromRGB(94, 94, 94),
		Light = Color3.fromRGB(176, 176, 176)
	},
	TransparencyEnabled = true,
	Theme = "Dark"
}

local LuaReflection = {}

function LuaReflection.CreateAssembly(Source: string)
	local LoadFunc = loadstring -- Will probably replace with vLua.
	
	return LoadFunc(Source)
end

local HttpService = game:GetService("HttpService")

function LoadLibrary(FileName)
	local BaseUrl = "https://raw.githubusercontent.com/arm8086/hydrogen/main/utils/%s.lua"
	
	local Source = HttpService:GetAsync( string.format( BaseUrl, FileName ), false )
	
	if Source == "404: Not Found" then
		return {}, warn("The module you requested either does not exist or did not load correctly.")
	end
	
	local Function = LuaReflection.CreateAssembly( Source )
	
	return Function()
end


--local Fusion = LoadLibrary("Fusion")

--local Fusion = LuaReflection.CreateAssembly( HttpService:GetAsync("https://glot.io/snippets/givo4t927q/raw/main.lua") )()

local Fusion = {
	Children = "_CHILDREN",
	AddClickDetection = "_CLICK",
	Inputtable = "_ALLOWINPUT"
}

local boxes = {}

function Fusion.New(Class)
	local Object = Instance.new(Class)
	return function(Properties)
		for Name, Value in Properties do 
			if Name:sub(1,1) == "_" then
				continue
			end
			
			Object[Name] = Value
		end
		
		local Children = Properties[Fusion.Children]
		if Children then
			for _, Child in Children do 
				Child.Parent = Object
			end
		end
		
		if Class == "TextBox" then
			local id = HttpService:GenerateGUID(false)
			boxes[id] = Object
			Object.ClearTextOnFocus = false
			Object.TextEditable = false
			if Properties[Fusion.Inputtable] then
				Object:SetAttribute("CanEdit", true)
			end
			Object:SetAttribute("Identifier", id)
		end
		
		local Click = Properties[Fusion.AddClickDetection]
		if Click then
			local Clicker = Fusion.New "TextButton" {
				Name = "Clicker",
				Text = "",
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromOffset(0, 0)
			}
			Clicker.Parent = Object
			local CClicker = Fusion.New "BindableEvent" {
				Name = "CClicker"
			}
			CClicker.Parent = Object
		end
		
		return Object
	end
end

Children = Fusion.Children
new = Fusion.New
AddClickDetection = Fusion.AddClickDetection
Inputtable = Fusion.Inputtable


function base_CreateRoundedWidget(size, position, parent, z)
	return new "Frame" {
		Name = "taskbar",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = CurrentTheme.Theme == "Dark" and CurrentTheme.ColorThemes.Dark or CurrentTheme.ColorThemes.Light,
		BackgroundTransparency = CurrentTheme.TransparencyEnabled == true and 0.4 or 0,
		BorderSizePixel = 0,
		Position = position,
		Size = size,
		ZIndex = z,

		[Children] = {
			new "UICorner" {
				Name = "UICorner",
			},
		}
	}
end

function base_CreateCircularFrame(size, position, clickable, z)
	return new "Frame" {
		Name = "start",
		BackgroundColor3 = CurrentTheme.Theme == "Dark" and CurrentTheme.TitlebarThemes.Dark or CurrentTheme.TitlebarThemes.Light,
		Position = position,
		Size = size,
		ZIndex = z,
		
		[AddClickDetection] = clickable,
		[Children] = {
			new "UICorner" {
				Name = "UICorner",
				CornerRadius = UDim.new(1, 0),
			},
		}
	}
end

local proc = {}

function ClickerFunctionsForWindow(window)
	local docked = false
	local windowSize = window.Parent.Size
	local windowPos = window.Parent.Position
	window.close.CClicker.Event:Connect(function(g)
		if g == "Click" then
			window.Parent:Destroy()
		end
	end)
	window.min.CClicker.Event:Connect(function(g)
		if g == "Click" then
			-- ill add this when i add taskbar functionality
		end
	end)
	window.dock.CClicker.Event:Connect(function(g)
		if g == "Click" then
			docked = not docked
			if docked == true then
				windowSize = window.Parent.Size
				windowPos = window.Parent.Position
				window.Parent.Position = UDim2.new()
				window.Parent.Size = UDim2.new(1, 0, 1, -168)
			else
				window.Parent.Position = windowPos
				window.Parent.Size = windowSize
			end
		end
	end)
end

function LocalCreateResetGui() -- so the body mover and control script wont get yeeted when u die
	return new "ScreenGui" {
		Name = math.random(),
		ResetOnSpawn = false
	}
end

local ControlContainer = LocalCreateResetGui()

ControlContainer.Parent = owner:FindFirstChildOfClass("PlayerGui")

local Control = Instance.new("RemoteFunction")

Control.Parent = ControlContainer

function base_CreateWindow(size, position, name)
	local obj = new "CanvasGroup" {
		Name = "Window",
		BackgroundColor3 = Color3.fromRGB(77, 77, 77),
		LayoutOrder = -1,
		Position = position,
		Size = size,
		ZIndex = 2,

		[Children] = {
			new "Frame" {
				Name = "TitleBar",
				BackgroundColor3 = Color3.fromRGB(88, 88, 88),
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 24),

				[Children] = {
					new "Frame" {
						Name = "close",
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						Position = UDim2.fromOffset(464, 0),
						Size = UDim2.fromOffset(48, 24),

						[AddClickDetection] = true,
						[Children] = {
							new "ImageLabel" {
								Name = "ImageLabel",
								Image = "rbxassetid://12223525050",
								ScaleType = Enum.ScaleType.Fit,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1,
								Position = UDim2.fromScale(0.5, 0.5),
								Size = UDim2.fromOffset(12, 12),
							},
						}
					},

					new "Frame" {
						Name = "dock",
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						Position = UDim2.fromOffset(416, 0),
						Size = UDim2.fromOffset(48, 24),
						[AddClickDetection] = true,

						[Children] = {
							new "ImageLabel" {
								Name = "ImageLabel",
								Image = "rbxassetid://12223524847",
								ResampleMode = Enum.ResamplerMode.Pixelated,
								ScaleType = Enum.ScaleType.Fit,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1,
								Position = UDim2.fromScale(0.5, 0.5),
								Size = UDim2.fromOffset(12, 12),
							},
						}
					},

					new "Frame" {
						Name = "min",
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						Position = UDim2.fromOffset(368, 0),
						Size = UDim2.fromOffset(48, 24),
						[AddClickDetection] = true,

						[Children] = {
							new "ImageLabel" {
								Name = "ImageLabel",
								Image = "rbxassetid://12223524685",
								ResampleMode = Enum.ResamplerMode.Pixelated,
								ScaleType = Enum.ScaleType.Fit,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1,
								Position = UDim2.fromScale(0.5, 0.5),
								Size = UDim2.fromOffset(12, 12),
							},
						}
					},

					new "TextBox" {
						Name = "title",
						ClearTextOnFocus = false,
						Active = false,
						FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
						Text = name,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextEditable = false,
						TextSize = 20,
						TextXAlignment = Enum.TextXAlignment.Left,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						Position = UDim2.fromOffset(24, 0),
						Size = UDim2.fromOffset(344, 24),
					},
				}
			},

			new "Frame" {
				Name = "Contents",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(0, 24),
				Size = UDim2.new(1, 0, 1, -24),
			},

			new "UICorner" {
				Name = "UICorner",
				CornerRadius = UDim.new(0, 4),
			},
		}
	}
	task.spawn(ClickerFunctionsForWindow, obj.TitleBar)
	obj:GetPropertyChangedSignal("Parent"):Connect(function()
		if obj.Parent ~= nil then
			Control:InvokeClient(owner, "WindowCreated", obj)
		end
	end)
	return obj
end

function base_makeWallpaper(imageId)
	return new "ImageLabel" {
		Name = "wallpaper",
		Image = imageId,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Size = UDim2.fromScale(1, 1),
	}
end

function createCursor()
	return new "ImageLabel" {
		Name = "cursor",
		Image = "rbxassetid://12697485794",
		Active = true,
		BackgroundTransparency = 1,
		Selectable = true,
		Size = UDim2.fromOffset(32, 32),
		ZIndex = 500
	}
end

function makeScreen()
	return new "Part" {
		Name = "screen",
		Parent = script,
		BottomSurface = Enum.SurfaceType.Smooth,
		BrickColor = BrickColor.new("Really black"),
		Anchored = true,
		Color = Color3.fromRGB(17, 17, 17),
		Size = Vector3.new(19.2, 10.8, 0.001),
		TopSurface = Enum.SurfaceType.Smooth,

		[Children] = {
			new "SurfaceGui" {
				Name = "gui",
				CanvasSize = Vector2.new(1920, 1080),
				Face = Enum.NormalId.Back,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			},
		}
	}
end

local screen = makeScreen()

gui = screen.gui

local cursor = createCursor()
cursor.Parent = gui

NLS([[
	local mouse = game:GetService("Players").LocalPlayer:GetMouse()
	local remote = script.Parent

	local gui = remote:InvokeServer("GetUI")
	
	local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
	local Down = false
	Mouse.Button1Down:Connect(function()
		Down = true
	end)
	Mouse.Button1Up:Connect(function()
		Down = false
	end)
	function dragify(f)
		local nf = Instance.new("Frame")
		nf.Size = UDim2.new(1, -168, 1, 0)
		nf.ZIndex = f.TitleBar.ZIndex+1 -- this is important
		nf.BackgroundTransparency = 1
		nf.Parent = f.TitleBar
		local lastPos = Vector2.new(Mouse.X, Mouse.Y)
		nf.MouseMoved:Connect(function()
			local mPos = Vector2.new(Mouse.X, Mouse.Y)
			local delta = mPos - lastPos
			lastPos = mPos
			if Down == true then
				remote:InvokeServer("DragFrame", f, f.Position + UDim2.fromOffset(delta.X*5, delta.Y*5))
			end
		end)
	end
	
	local mfr = Instance.new("Frame")
	mfr.Active = false
	mfr.BackgroundTransparency = 1
	mfr.Size = UDim2.fromScale(1, 1)
	mfr.ZIndex = 499
	mfr.Parent = gui
	
	function shitHere(v)
		if v.Name == "Clicker" and v:IsA("TextButton") then
			v.MouseButton1Click:Connect(function()
				remote:InvokeServer("OnClick", v.Parent)
			end)
			v.MouseEnter:Connect(function()
				remote:InvokeServer("OnHover", v.Parent)
			end)
			v.MouseLeave:Connect(function()
				remote:InvokeServer("OnHoverLeave", v.Parent)
			end)
		elseif v:IsA("TextBox") and v:GetAttribute("CanEdit") == true then
			local str = v:GetAttribute("Identifier")
			local nv = v:Clone()
			nv.Parent = v.Parent
			nv.TextEditable = true
			nv:GetPropertyChangedSignal("Text"):Connect(function()
				remote:InvokeServer("TextObjectSet", str, nv.Text)
			end)
			task.wait()
			v:Destroy()
		end
	end

	for i, v in next, gui:GetDescendants() do
		shitHere(v)
	end
	
	gui.DescendantAdded:Connect(shitHere)
	
	remote.OnClientInvoke = function(s, ...)
		local args = {...}
		if s == "WindowCreated" then
			dragify(args[1])
		end
	end
	
	mfr.MouseMoved:Connect(function(x, y)
		remote:InvokeServer("SetCursorPosition", UDim2.fromOffset(x, y))
	end)
]], Control)

Control.OnServerInvoke = function(Player, Source, ...)
	local args = {...}
	if Source == "GetUI" then
		return gui
	elseif Source == "SetCursorPosition" then
		cursor.Position = args[1]
	elseif Source == "OnClick" then
		args[1].CClicker:Fire("Click")
	elseif Source == "TextObjectSet" then	
		boxes[args[1]].Text = args[2]
		print(boxes[args[1]].Text, args[2])
	elseif Source == "OnHover" then
		args[1].CClicker:Fire("Hover")
	elseif Source == "OnHoverLeave" then
		args[1].CClicker:Fire("Unhover")
	elseif Source == "DragFrame" then
		args[1].Position = args[2]
	end
end

local helper = LoadLibrary("BodyMoverHelper")

helper:HookPart(screen, CFrame.new(0, 4, -4))

local wallpaper = base_makeWallpaper("rbxassetid://12186974523")

wallpaper.Parent = gui

local taskbar = base_CreateRoundedWidget(UDim2.fromOffset(1824, 72), UDim2.fromOffset(960, 998), 2)

taskbar.Name = "Taskbar"

taskbar.Parent = gui

local startButton = base_CreateCircularFrame(UDim2.fromOffset(52, 52), UDim2.fromOffset(10, 10), true, 1)

startButton.Name = "StartButton"

local startImage = new "ImageLabel" {
	BackgroundTransparency = 1,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(0.5, 0.5),
	Image = "rbxassetid://12290216485"
}

startImage.Parent = startButton

startButton.Parent = taskbar

function _startMenu()
	return new "Frame" {
		Name = "startmenu",
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = Color3.fromRGB(77, 77, 77),
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.fromOffset(48, 952),
		Size = UDim2.fromOffset(512, 0),
		ZIndex = 2,

		[Children] = {
			new "UICorner" {
				Name = "UICorner",
			},

			new "CanvasGroup" {
				Name = "scroller",
				BackgroundColor3 = Color3.fromRGB(77, 77, 77),
				BackgroundTransparency = 0.6,
				LayoutOrder = 1,
				Position = UDim2.fromOffset(15, 15),
				Size = UDim2.fromOffset(344, 430),

				[Children] = {
					new "ScrollingFrame" {
						Name = "ScrollingFrame",
						ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
						ScrollBarThickness = 0,
						Active = true,
						BackgroundColor3 = Color3.fromRGB(77, 77, 77),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.fromScale(1, 1),

						[Children] = {
							new "UIListLayout" {
								Name = "UIListLayout",
								Padding = UDim.new(0, 4),
								SortOrder = Enum.SortOrder.LayoutOrder,
							},
						}
					},

					new "UICorner" {
						Name = "UICorner",
					},
				}
			},
		}
	}
end

function programFrame(n, i)
	return new "Frame" {
		Name = "Frame",
		BackgroundColor3 = Color3.fromRGB(80, 80, 80),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(27, 42, 53),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 64),
		
		[AddClickDetection] = true,

		[Children] = {
			new "TextLabel" {
				Name = "TextLabel",
				FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
				Text = n,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 25,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(68, 0),
				Size = UDim2.new(1, -68, 1, 0),
			},

			new "ImageLabel" {
				Name = "ImageLabel",
				Image = i,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(8, 8),
				Size = UDim2.fromOffset(48, 48),
			},
		}
	}
end

local sm = _startMenu()

sm.Parent = gui

local smopen = false

startButton.CClicker.Event:Connect(function(St)
	if St == "Click" then
		smopen = not smopen
		if smopen then
			sm:TweenSize(UDim2.fromOffset(512, 512), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 1, true)
		else
			sm:TweenSize(UDim2.fromOffset(512, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 1, true)
		end
	end
end)

local programList = new "Frame" {
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(80, 0),
	Size = UDim2.new(1, -80, 0, 72)
}

local pll = new "UIListLayout" {
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	VerticalAlignment = Enum.VerticalAlignment.Center
}
pll.Parent = programList

programList.Parent = taskbar

local builtInPrograms = {
	notepad = {source = [[
		local stuff = ({...})[1]
		local wnd = stuff.base_CreateWindow(UDim2.fromOffset(512, 384), UDim2.fromOffset(100, 100), "Notepad--")
		wnd.Parent = stuff.gui
		local box = stuff.new "TextBox" {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextColor3 = stuff.CurrentTheme.TextColors[stuff.CurrentTheme.Theme],
			MultiLine = true,
			[stuff.Inputtable] = true
		}
		box.Parent = wnd.Contents
	]], name = "Notepad", icon = "rbxassetid://12767086744"}
	
}

shared.launch = function(w) LuaReflection.CreateAssembly(builtInPrograms[w].source)(getfenv()) end

for i, v in next, builtInPrograms do
	local thing = programFrame(v.name, v.icon)
	thing.Parent = sm.scroller.ScrollingFrame
	thing.CClicker.Event:Connect(function(x)
		if x == "Click" then
			smopen = false
			LuaReflection.CreateAssembly(v.source)(getfenv())
		end
	end)
end
