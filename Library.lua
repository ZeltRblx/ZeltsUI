-- Services

local players = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")

-- Vars

local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jxereas/UI-Libraries/main/notification_gui_library.lua", true))()
local mouse = players.LocalPlayer:GetMouse()
local viewport = workspace.CurrentCamera.ViewportSize
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

local ProtectGui = protectgui or (syn and syn.protect_gui) or (function() end);

local LibName = tostring(math.random(10000, 100000)..math.random(10000, 100000))



local Library = {}

function Library:Validate(defaults, options)
	for i,v in pairs(defaults) do
		if options[i] == nil then
			options[i] = v
		end
	end
	return options
end

function Library:tween(object, goal, callback)
	local tween = tweenService:Create(object, tweenInfo, goal)
	tween.Completed:Connect(callback or function() end)
	tween:Play()
end

function Library:MakeDraggable(Instance, Cutoff)
	Instance.Active = true;

	Instance.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			local ObjPos = Vector2.new(
				mouse.X - Instance.AbsolutePosition.X,
				mouse.Y - Instance.AbsolutePosition.Y
			);

			if ObjPos.Y > (Cutoff or 40) then
				return;
			end;

			while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
				Instance.Position = UDim2.new(
					0,
					mouse.X - ObjPos.X + (Instance.Size.X.Offset * Instance.AnchorPoint.X),
					0,
					mouse.Y - ObjPos.Y + (Instance.Size.Y.Offset * Instance.AnchorPoint.Y)
				);

				runService.RenderStepped:Wait();
			end;
		end;
	end);
end

function Library:ToggleUI()
	if game.CoreGui:FindFirstChild(LibName) ~= nil then
		if game.CoreGui[LibName].Enabled == false then
			game.CoreGui[LibName].Enabled = true
		else
			game.CoreGui[LibName].Enabled = false
		end
	end
end

function Library:Unload()
	if game.CoreGui:FindFirstChild(LibName) ~= nil then
		game.CoreGui[LibName]:Destroy()
	end
end

function Library:DraggingEnabled(frame, parent)

	parent = parent or frame

	-- stolen from wally or kiriot, kek
	local dragging = false
	local dragInput, mousePos, framePos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			mousePos = input.Position
			framePos = parent.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	uis.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			parent.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
		end
	end)
	
end


function Library:Init(options)
	options = Library:Validate({
		Name = "Zelt's UI"
	}, options or {})
	
	local GUI = {
		CurrentTab = nil,
		Hover = false,
		MouseDown = false
	}
	
	-- Main Frame
	do
		GUI["1"] = Instance.new("ScreenGui", runService:IsStudio() and players.LocalPlayer:WaitForChild("PlayerGui") or coreGui);
		GUI["1"]["Name"] = LibName;
		GUI["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Global;
		GUI["1"]["IgnoreGuiInset"] = true;
		
		ProtectGui(GUI["1"])
		

		GUI["2"] = Instance.new("Frame", GUI["1"]);
		GUI["2"]["BackgroundColor3"] = Color3.fromRGB(45, 45, 45);
		GUI["2"]["AnchorPoint"] = Vector2.new(0, 0);
		GUI["2"]["Size"] = UDim2.new(0, 500, 0, 355);
		GUI["2"]["Position"] = UDim2.fromOffset((viewport.X / 2) - (GUI["2"].Size.X.Offset / 2), (viewport.Y / 2) - (GUI["2"].Size.Y.Offset / 2))
		GUI["2"]["Name"] = [[Main]];

		GUI["3"] = Instance.new("UICorner", GUI["2"]);
		GUI["3"]["CornerRadius"] = UDim.new(0, 6);

		GUI["4"] = Instance.new("Frame", GUI["2"]);
		GUI["4"]["ZIndex"] = 0;
		GUI["4"]["BorderSizePixel"] = 0;
		GUI["4"]["BackgroundTransparency"] = 1;
		GUI["4"]["Size"] = UDim2.new(1, 0, 1, 0);
		GUI["4"]["Name"] = [[DropShadowHolder]];

		GUI["5"] = Instance.new("ImageLabel", GUI["4"]);
		GUI["5"]["ZIndex"] = 0;
		GUI["5"]["BorderSizePixel"] = 0;
		GUI["5"]["SliceCenter"] = Rect.new(49, 49, 450, 450);
		GUI["5"]["ScaleType"] = Enum.ScaleType.Slice;
		GUI["5"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["5"]["ImageTransparency"] = 0.5;
		GUI["5"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
		GUI["5"]["Image"] = [[rbxassetid://6014261993]];
		GUI["5"]["Size"] = UDim2.new(1, 47, 1, 47);
		GUI["5"]["Name"] = [[DropShadow]];
		GUI["5"]["BackgroundTransparency"] = 1;
		GUI["5"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

		-- StarterGui.UI Lib.Main.TopBar
		GUI["6"] = Instance.new("Frame", GUI["2"]);
		GUI["6"]["BackgroundColor3"] = Color3.fromRGB(53, 53, 53);
		GUI["6"]["Size"] = UDim2.new(1, 0, 0, 35);
		GUI["6"]["Name"] = [[TopBar]];
		
		Library:DraggingEnabled(GUI["6"], GUI["2"])
		

		-- StarterGui.UI Lib.Main.TopBar.UICorner
		GUI["7"] = Instance.new("UICorner", GUI["6"]);
		GUI["7"]["CornerRadius"] = UDim.new(0, 6);

		-- StarterGui.UI Lib.Main.TopBar.Extension
		GUI["8"] = Instance.new("Frame", GUI["6"]);
		GUI["8"]["BorderSizePixel"] = 0;
		GUI["8"]["BackgroundColor3"] = Color3.fromRGB(53, 53, 53);
		GUI["8"]["AnchorPoint"] = Vector2.new(0, 1);
		GUI["8"]["Size"] = UDim2.new(1, 0, 0.5, 0);
		GUI["8"]["Position"] = UDim2.new(0, 0, 1, 0);
		GUI["8"]["Name"] = [[Extension]];

		-- StarterGui.UI Lib.Main.TopBar.Title
		GUI["9"] = Instance.new("TextLabel", GUI["6"]);
		GUI["9"]["RichText"] = true;
		GUI["9"]["TextXAlignment"] = Enum.TextXAlignment.Left;
		GUI["9"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["9"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["9"]["TextSize"] = 14;
		GUI["9"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["9"]["Size"] = UDim2.new(0.5, 0, 1, 0);
		GUI["9"]["Text"] = options["Name"];
		GUI["9"]["Name"] = "Title"
		GUI["9"]["Font"] = Enum.Font.Gotham;
		GUI["9"]["BackgroundTransparency"] = 1;

		-- StarterGui.UI Lib.Main.TopBar.Title.UIPadding
		GUI["a"] = Instance.new("UIPadding", GUI["9"]);
		GUI["a"]["PaddingTop"] = UDim.new(0, 1);
		GUI["a"]["PaddingLeft"] = UDim.new(0, 8);

		-- StarterGui.UI Lib.Main.TopBar.ExitButton
		GUI["b"] = Instance.new("ImageLabel", GUI["6"]);
		GUI["b"]["BackgroundColor3"] = Color3.fromRGB(255, 85, 85);
		GUI["b"]["AnchorPoint"] = Vector2.new(1, 0);
		GUI["b"]["Image"] = [[rbxassetid://11952585022]];
		GUI["b"]["Size"] = UDim2.new(0, 20, 0, 20);
		GUI["b"]["Name"] = [[ExitButton]];
		GUI["b"]["BackgroundTransparency"] = 1;
		GUI["b"]["Position"] = UDim2.new(1, -8, 0, 8);

		-- StarterGui.UI Lib.Main.TopBar.Line
		GUI["c"] = Instance.new("Frame", GUI["6"]);
		GUI["c"]["BorderSizePixel"] = 0;
		GUI["c"]["BackgroundColor3"] = Color3.fromRGB(126, 94, 255);
		GUI["c"]["AnchorPoint"] = Vector2.new(0, 1);
		GUI["c"]["Size"] = UDim2.new(1, 0, 0, 2);
		GUI["c"]["Position"] = UDim2.new(0, 0, 1, 0);
		GUI["c"]["Name"] = [[Line]];
		
		-- StarterGui.UI Lib.Main.ContentContainer
		GUI["1b"] = Instance.new("Frame", GUI["2"]);
		GUI["1b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["1b"]["AnchorPoint"] = Vector2.new(1, 0);
		GUI["1b"]["BackgroundTransparency"] = 1;
		GUI["1b"]["Size"] = UDim2.new(1, -147, 1, -46);
		GUI["1b"]["Position"] = UDim2.new(1, -6, 0, 41);
		GUI["1b"]["Name"] = [[ContentContainer]];
	end
	
	-- Logic
	do
		GUI["b"].MouseEnter:Connect(function()
			GUI.Hover = true

			if not GUI.Active then
				Library:tween(GUI["b"], {BackgroundTransparency = 0})
			end
		end)

		GUI["b"].MouseLeave:Connect(function()
			GUI.Hover = false
			if not GUI.Active then
				Library:tween(GUI["b"], {BackgroundTransparency = 1})
			end
		end)

		uis.InputBegan:Connect(function(input, gpe)
			if gpe then return end

			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if GUI.Hover then
					Library:Unload()
				end
			end
		end)
		
		
		uis.InputBegan:Connect(function(input, gpe)
			if gpe then return end
			if input.KeyCode == Enum.KeyCode.RightShift then
				Library:ToggleUI()
			end
		end)
		
	end
	
	-- Navigation
	do
		-- StarterGui.UI Lib.Main.Navigation
		GUI["d"] = Instance.new("Frame", GUI["2"]);
		GUI["d"]["BorderSizePixel"] = 0;
		GUI["d"]["BackgroundColor3"] = Color3.fromRGB(53, 53, 53);
		GUI["d"]["Size"] = UDim2.new(0, 136, 1, -35);
		GUI["d"]["Position"] = UDim2.new(0, 0, 0, 35);
		GUI["d"]["Name"] = [[Navigation]];

		-- StarterGui.UI Lib.Main.Navigation.UICorner
		GUI["e"] = Instance.new("UICorner", GUI["d"]);
		GUI["e"]["CornerRadius"] = UDim.new(0, 6);

		-- StarterGui.UI Lib.Main.Navigation.Hide
		GUI["f"] = Instance.new("Frame", GUI["d"]);
		GUI["f"]["BorderSizePixel"] = 0;
		GUI["f"]["BackgroundColor3"] = Color3.fromRGB(53, 53, 53);
		GUI["f"]["Size"] = UDim2.new(1, 0, 0, 20);
		GUI["f"]["Name"] = [[Hide]];

		-- StarterGui.UI Lib.Main.Navigation.Hide2
		GUI["10"] = Instance.new("Frame", GUI["d"]);
		GUI["10"]["BorderSizePixel"] = 0;
		GUI["10"]["BackgroundColor3"] = Color3.fromRGB(53, 53, 53);
		GUI["10"]["AnchorPoint"] = Vector2.new(1, 0);
		GUI["10"]["Size"] = UDim2.new(0, 20, 1, 0);
		GUI["10"]["Position"] = UDim2.new(1, 0, 0, 0);
		GUI["10"]["Name"] = [[Hide2]];

		-- StarterGui.UI Lib.Main.Navigation.ButtonHolder
		GUI["11"] = Instance.new("Frame", GUI["d"]);
		GUI["11"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["11"]["BackgroundTransparency"] = 1;
		GUI["11"]["Size"] = UDim2.new(1, 0, 1, 0);
		GUI["11"]["Name"] = [[ButtonHolder]];

		-- StarterGui.UI Lib.Main.Navigation.ButtonHolder.UIPadding
		GUI["12"] = Instance.new("UIPadding", GUI["11"]);
		GUI["12"]["PaddingTop"] = UDim.new(0, 8);
		GUI["12"]["PaddingBottom"] = UDim.new(0, 8);

		-- StarterGui.UI Lib.Main.Navigation.ButtonHolder.UIListLayout
		GUI["13"] = Instance.new("UIListLayout", GUI["11"]);
		GUI["13"]["Padding"] = UDim.new(0, 1);
		GUI["13"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
		
		
		-- StarterGui.UI Lib.Main.Navigation.Line
		GUI["1a"] = Instance.new("Frame", GUI["d"]);
		GUI["1a"]["BorderSizePixel"] = 0;
		GUI["1a"]["BackgroundColor3"] = Color3.fromRGB(126, 94, 255);
		GUI["1a"]["AnchorPoint"] = Vector2.new(1, 0);
		GUI["1a"]["Size"] = UDim2.new(0, 2, 1, 0);
		GUI["1a"]["Position"] = UDim2.new(1, 2, 0, 0);
		GUI["1a"]["Name"] = [[Line]];
		
	end
	
	function GUI:CreateTab(options)
		options = Library:Validate({
			Name = "New Tab",
			Icon = "rbxassetid://11952806790"
		}, options or {})
		
		local Tab = {
			Hover = false,
			Active = false
		}
		
		
		-- Render
		do
			
			-- StarterGui.UI Lib.Main.Navigation.ButtonHolder.Inactive
			Tab["17"] = Instance.new("TextLabel", GUI["11"]);
			Tab["17"]["BorderSizePixel"] = 0;
			Tab["17"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Tab["17"]["BackgroundColor3"] = Color3.fromRGB(53, 53, 53);
			Tab["17"]["TextSize"] = 14;
			Tab["17"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
			Tab["17"]["Size"] = UDim2.new(1, 0, 0, 27);
			Tab["17"]["Text"] = options.Name;
			Tab["17"]["Name"] = [[Inactive]];
			Tab["17"]["Font"] = Enum.Font.Ubuntu;

			-- StarterTab.UI Lib.Main.Navigation.ButtonHolder.Inactive.UIPadding
			Tab["18"] = Instance.new("UIPadding", Tab["17"]);
			Tab["18"]["PaddingLeft"] = UDim.new(0, 28);
			
			-- StarterGui.UI Lib.Main.Navigation.ButtonHolder.Inactive.Icon
			Tab["19"] = Instance.new("ImageLabel", Tab["17"]);
			Tab["19"]["BorderSizePixel"] = 0;
			Tab["19"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Tab["19"]["ImageColor3"] = Color3.fromRGB(200, 200, 200);
			Tab["19"]["AnchorPoint"] = Vector2.new(0, 0.5);
			Tab["19"]["Image"] = options.Icon
			Tab["19"]["Size"] = UDim2.new(0, 20, 0, 20);
			Tab["19"]["Name"] = [[Icon]];
			Tab["19"]["BackgroundTransparency"] = 1;
			Tab["19"]["Position"] = UDim2.new(0, -24, 0.5, 0);
			
			-- StarterGui.UI Lib.Main.ContentContainer.HomeTab
			Tab["1c"] = Instance.new("ScrollingFrame", GUI["1b"]);
			Tab["1c"]["BorderSizePixel"] = 0;
			Tab["1c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Tab["1c"]["BackgroundTransparency"] = 1;
			Tab["1c"]["Size"] = UDim2.new(1, 0, 1, 0);
			Tab["1c"]["Selectable"] = false;
			Tab["1c"]["ScrollBarThickness"] = 0;
			Tab["1c"]["Name"] = [[HomeTab]];
			Tab["1c"]["SelectionGroup"] = false;
			Tab["1c"]["Visible"] = false;
			
			-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.UIPadding
			Tab["23"] = Instance.new("UIPadding", Tab["1c"]);
			Tab["23"]["PaddingTop"] = UDim.new(0, 1);
			Tab["23"]["PaddingRight"] = UDim.new(0, 1);
			Tab["23"]["PaddingBottom"] = UDim.new(0, 1);
			Tab["23"]["PaddingLeft"] = UDim.new(0, 3);

			-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.UIListLayout
			Tab["24"] = Instance.new("UIListLayout", Tab["1c"]);
			Tab["24"]["Padding"] = UDim.new(0, 6);
			Tab["24"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
		end
		
		-- Methods
		function Tab:Activate()
			if not Tab.Active then
				if GUI.CurrentTab ~= nil then
					GUI.CurrentTab:Deactivate()
				end
				
				Tab.Active = true
				
				Library:tween(Tab["17"], {BackgroundColor3 = Color3.fromRGB(125, 93, 255)})
				Library:tween(Tab["17"], {TextColor3 = Color3.fromRGB(255,255,255)})
				Library:tween(Tab["19"], {ImageColor3 = Color3.fromRGB(255,255,255)})
				Tab["1c"].Visible = true
				
				GUI.CurrentTab = Tab
			end
		end
		
		function Tab:Deactivate()
			if Tab.Active then
				Tab.Active = false
				Tab.Hover = false
				Library:tween(Tab["17"], {TextColor3 = Color3.fromRGB(200,200,200)})
				Library:tween(Tab["17"], {BackgroundColor3 = Color3.fromRGB(52, 52, 52)})
				Library:tween(Tab["19"], {ImageColor3 = Color3.fromRGB(200,200,200)})
				Tab["1c"].Visible = false
			end
		end
		
		-- Logic
		do
			Tab["17"].MouseEnter:Connect(function()
				Tab.Hover = true

				if not Tab.Active then
					Library:tween(Tab["17"], {TextColor3 = Color3.fromRGB(255,255,255)})
					Library:tween(Tab["19"], {ImageColor3 = Color3.fromRGB(255,255,255)})
				end
			end)

			Tab["17"].MouseLeave:Connect(function()
				Tab.Hover = false
				if not Tab.Active then
					Library:tween(Tab["17"], {TextColor3 = Color3.fromRGB(200,200,200)})
					Library:tween(Tab["19"], {ImageColor3 = Color3.fromRGB(200,200,200)})
				end
			end)

			uis.InputBegan:Connect(function(input, gpe)
				if gpe then return end

				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if Tab.Hover then
						Tab:Activate()
					end
				end
			end)

			if GUI.CurrentTab == nil then
				Tab:Activate()
			end
		end
		
		function Tab:Button(options)
			options = Library:Validate({
				Text = "Button",
				callback = function() end
			}, options or {})
			
			local Button = {
				Hover = false,
				MouseDown = false
			}
			
			-- Render
			do
				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Button
				Button["1d"] = Instance.new("Frame", Tab["1c"]);
				Button["1d"]["BackgroundColor3"] = Color3.fromRGB(55, 55, 55);
				Button["1d"]["Size"] = UDim2.new(1, 0, 0, 31);
				Button["1d"]["Name"] = [[Button]];

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Button.UICorner
				Button["1e"] = Instance.new("UICorner", Button["1d"]);
				Button["1e"]["CornerRadius"] = UDim.new(0, 4);

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Button.UIStroke
				Button["1f"] = Instance.new("UIStroke", Button["1d"]);
				Button["1f"]["Color"] = Color3.fromRGB(125, 93, 255);
				Button["1f"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Button.Title
				Button["20"] = Instance.new("TextLabel", Button["1d"]);
				Button["20"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Button["20"]["TextSize"] = 15;
				Button["20"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Button["20"]["Size"] = UDim2.new(1, 0, 1, 0);
				Button["20"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				Button["20"]["Text"] = options.Text;
				Button["20"]["Name"] = [[Title]];
				Button["20"]["Font"] = Enum.Font.Ubuntu;
				Button["20"]["BackgroundTransparency"] = 1;

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Button.UIPadding
				Button["21"] = Instance.new("UIPadding", Button["1d"]);
				Button["21"]["PaddingTop"] = UDim.new(0, 6);
				Button["21"]["PaddingRight"] = UDim.new(0, 6);
				Button["21"]["PaddingBottom"] = UDim.new(0, 6);
				Button["21"]["PaddingLeft"] = UDim.new(0, 6);

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Button.Icon
				Button["22"] = Instance.new("ImageLabel", Button["1d"]);
				Button["22"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Button["22"]["AnchorPoint"] = Vector2.new(1, 0);
				Button["22"]["Image"] = [[rbxassetid://11952962844]];
				Button["22"]["Size"] = UDim2.new(0, 20, 0, 20);
				Button["22"]["Name"] = [[Icon]];
				Button["22"]["BackgroundTransparency"] = 1;
				Button["22"]["Position"] = UDim2.new(1, 0, 0, 0);
			end
			
			-- Methods
			function Button:SetText(text)
				Button["20"].Text = text
				options.Text = text
			end
			
			function Button:SetCallback(fn)
				options.callback = fn
			end
			
			-- Logic
			do
				Button["1d"].MouseEnter:Connect(function()
					Button.Hover = true
					
					Library:tween(Button["1f"], {Color = Color3.fromRGB(175, 135, 255)})
				end)
				
				Button["1d"].MouseLeave:Connect(function()
					Button.Hover = false
					
					if not Button.MouseDown then
						Library:tween(Button["1f"], {Color = Color3.fromRGB(125, 93, 255)})
					end
				end)
				
				uis.InputBegan:Connect(function(input, gpe)
					if gpe then return end
					
					if input.UserInputType == Enum.UserInputType.MouseButton1 and Button.Hover then
						Button.MouseDown = true
						Library:tween(Button["1d"], {BackgroundColor3 = Color3.fromRGB(125, 93, 255)})
						Library:tween(Button["1f"], {Color = Color3.fromRGB(175, 135, 255)})
						options.callback()
					end
				end)
				
				uis.InputEnded:Connect(function(input, gpe)
					if gpe then return end

					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Button.MouseDown = false
						
						if Button.Hover then
							Library:tween(Button["1d"], {BackgroundColor3 = Color3.fromRGB(55, 55, 55)})
							Library:tween(Button["1f"], {Color = Color3.fromRGB(175, 135, 255)})
						else
							Library:tween(Button["1d"], {BackgroundColor3 = Color3.fromRGB(55, 55, 55)})
							Library:tween(Button["1f"], {Color = Color3.fromRGB(125, 93, 255)})
						end
					end
				end)
			end
			
			return Button
		end
		
		function Tab:Label(options)
			options = Library:Validate({
				Text = "Label"
			}, options or {})
			
			local Label = {}
			
			-- Render
			do
				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Label
				Label["25"] = Instance.new("Frame", Tab["1c"]);
				Label["25"]["BackgroundColor3"] = Color3.fromRGB(55, 55, 55);
				Label["25"]["Size"] = UDim2.new(1, 0, 0, 27);
				Label["25"]["Name"] = [[Label]];

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Label.UICorner
				Label["26"] = Instance.new("UICorner", Label["25"]);
				Label["26"]["CornerRadius"] = UDim.new(0, 4);

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Label.UIStroke
				Label["27"] = Instance.new("UIStroke", Label["25"]);
				Label["27"]["Color"] = Color3.fromRGB(126, 94, 255);
				Label["27"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Label.Title
				Label["28"] = Instance.new("TextLabel", Label["25"]);
				Label["28"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Label["28"]["TextSize"] = 15;
				Label["28"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Label["28"]["Size"] = UDim2.new(1, 0, 1, 0);
				Label["28"]["Text"] = options.Text
				Label["28"]["TextXAlignment"] = Enum.TextXAlignment.Left
				Label["28"]["Name"] = [[Title]];
				Label["28"]["Font"] = Enum.Font.Ubuntu;
				Label["28"]["BackgroundTransparency"] = 1;
				Label["28"]["TextWrapped"] = true
				Label["28"]["TextYAlignment"] = Enum.TextYAlignment.Top

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Label.UIPadding
				Label["29"] = Instance.new("UIPadding", Label["25"]);
				Label["29"]["PaddingTop"] = UDim.new(0, 6);
				Label["29"]["PaddingRight"] = UDim.new(0, 6);
				Label["29"]["PaddingBottom"] = UDim.new(0, 6);
				Label["29"]["PaddingLeft"] = UDim.new(0, 6);
			end
			
			-- Methods
			function Label:SetText(text)
				options.Text = text
				Label:_update()
			end
			
			function Label:_update()
				Label["28"]["Text"] = options.Text
				
				Label["28"].Size = UDim2.new(Label["28"].Size.X.Scale, Label["28"].Size.X.Offset, 0, math.huge)
				Label["28"].Size = UDim2.new(Label["28"].Size.X.Scale, Label["28"].Size.X.Offset, 0, Label["28"].TextBounds.Y)
				Library:tween(Label["25"], {Size = UDim2.new(Label["25"].Size.X.Scale, Label["25"].Size.X.Offset, 0, Label["28"].TextBounds.Y + 12)})
			end
			
			Label:_update()
			
			
			
			return Label
			
		end
		
		function Tab:Toggle(options)
			options = Library:Validate({
				Text = "Toggle",
				callback = function() end
			}, options or {})
			
			local Toggle = {
				Hover = false,
				MouseDown = false,
				State = false
			}
			
			-- Render
			do
				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.ToggleInactive
				Toggle["46"] = Instance.new("Frame", Tab["1c"]);
				Toggle["46"]["BackgroundColor3"] = Color3.fromRGB(55, 55, 55);
				Toggle["46"]["Size"] = UDim2.new(1, 0, 0, 31);
				Toggle["46"]["Name"] = [[ToggleInactive]];

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.ToggleInactive.UICorner
				Toggle["47"] = Instance.new("UICorner", Toggle["46"]);
				Toggle["47"]["CornerRadius"] = UDim.new(0, 4);

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.ToggleInactive.UIStroke
				Toggle["48"] = Instance.new("UIStroke", Toggle["46"]);
				Toggle["48"]["Color"] = Color3.fromRGB(126, 94, 255);
				Toggle["48"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.ToggleInactive.Title
				Toggle["49"] = Instance.new("TextLabel", Toggle["46"]);
				Toggle["49"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Toggle["49"]["TextSize"] = 15;
				Toggle["49"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Toggle["49"]["Size"] = UDim2.new(1, -26, 1, 0);
				Toggle["49"]["Text"] = options.Text;
				Toggle["49"]["TextXAlignment"] = Enum.TextXAlignment.Left
				Toggle["49"]["Name"] = [[Title]];
				Toggle["49"]["Font"] = Enum.Font.Ubuntu;
				Toggle["49"]["BackgroundTransparency"] = 1;

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.ToggleInactive.UIPadding
				Toggle["4a"] = Instance.new("UIPadding", Toggle["46"]);
				Toggle["4a"]["PaddingTop"] = UDim.new(0, 6);
				Toggle["4a"]["PaddingRight"] = UDim.new(0, 6);
				Toggle["4a"]["PaddingBottom"] = UDim.new(0, 6);
				Toggle["4a"]["PaddingLeft"] = UDim.new(0, 6);

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.ToggleInactive.CheckmarkHolder
				Toggle["4b"] = Instance.new("Frame", Toggle["46"]);
				Toggle["4b"]["BackgroundColor3"] = Color3.fromRGB(50, 50, 50);
				Toggle["4b"]["AnchorPoint"] = Vector2.new(1, 0);
				Toggle["4b"]["Size"] = UDim2.new(0, 20, 0, 20);
				Toggle["4b"]["Position"] = UDim2.new(1, 0, 0, 0);
				Toggle["4b"]["Name"] = [[CheckmarkHolder]];

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.ToggleInactive.CheckmarkHolder.UICorner
				Toggle["4c"] = Instance.new("UICorner", Toggle["4b"]);
				Toggle["4c"]["CornerRadius"] = UDim.new(0, 4);

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.ToggleInactive.CheckmarkHolder.UIStroke
				Toggle["4d"] = Instance.new("UIStroke", Toggle["4b"]);
				Toggle["4d"]["Color"] = Color3.fromRGB(126, 94, 255);
				Toggle["4d"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.ToggleInactive.CheckmarkHolder.Checkmark
				Toggle["4e"] = Instance.new("ImageLabel", Toggle["4b"]);
				Toggle["4e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Toggle["4e"]["ImageTransparency"] = 1;
				Toggle["4e"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
				Toggle["4e"]["Image"] = [[rbxassetid://11953862481]];
				Toggle["4e"]["Size"] = UDim2.new(1, -2, 1, -2);
				Toggle["4e"]["Name"] = [[Checkmark]];
				Toggle["4e"]["BackgroundTransparency"] = 1;
				Toggle["4e"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
			end
			
			-- Logic
			do
				Toggle["4b"].MouseEnter:Connect(function()
					Toggle.Hover = true

					Library:tween(Toggle["48"], {Color = Color3.fromRGB(175, 135, 255)})
				end)

				Toggle["4b"].MouseLeave:Connect(function()
					Toggle.Hover = false

					if not Toggle.MouseDown then
						Library:tween(Toggle["48"], {Color = Color3.fromRGB(125, 93, 255)})
					end
				end)

				uis.InputBegan:Connect(function(input, gpe)
					if gpe then return end

					if input.UserInputType == Enum.UserInputType.MouseButton1 and Toggle.Hover then
						Toggle.MouseDown = true
						Library:tween(Toggle["48"], {Color = Color3.fromRGB(175, 135, 255)})
						Toggle:SetValue()
					end
				end)

				uis.InputEnded:Connect(function(input, gpe)
					if gpe then return end

					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Toggle.MouseDown = false

						if Toggle.Hover then
							Library:tween(Toggle["46"], {BackgroundColor3 = Color3.fromRGB(55, 55, 55)})
							Library:tween(Toggle["48"], {Color = Color3.fromRGB(175, 135, 255)})
						else
							Library:tween(Toggle["46"], {BackgroundColor3 = Color3.fromRGB(55,55,55)})
							Library:tween(Toggle["48"], {Color = Color3.fromRGB(125, 93, 255)})
						end
					end
				end)
			end
			
			-- Methods
			function Toggle:SetValue(b)
				if b == nil then
					Toggle.State = not Toggle.State
				else
					Toggle.State = b
				end
				
				if Toggle.State then
					Library:tween(Toggle["4b"], {BackgroundColor3 = Color3.fromRGB(125, 93, 255)})
					Library:tween(Toggle["4e"], {ImageTransparency = 0})
				else
					Library:tween(Toggle["4b"], {BackgroundColor3 = Color3.fromRGB(50,50,50)})
					Library:tween(Toggle["4e"], {ImageTransparency = 1})
				end
				
				options.callback(Toggle.State)
			end
			
			return Toggle
		end
		
		function Tab:Slider(options)
			options = Library:Validate({
				Text = "Slider",
				Default = 50,
				Min = 0,
				Max = 100,
				Rounding = 0,
				callback = function(v) 
					print(v) 
				end
			}, options or {})
			
			local Slider = {
				MouseDown = false,
				Hover = false,
				Connection = nil
			}
			
			-- Render
			do
				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Slider
				Slider["2a"] = Instance.new("Frame", Tab["1c"]);
				Slider["2a"]["BackgroundColor3"] = Color3.fromRGB(55, 55, 55);
				Slider["2a"]["Size"] = UDim2.new(1, 0, 0, 38);
				Slider["2a"]["Name"] = [[Slider]];

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Slider.UICorner
				Slider["2b"] = Instance.new("UICorner", Slider["2a"]);
				Slider["2b"]["CornerRadius"] = UDim.new(0, 4);

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Slider.UIStroke
				Slider["2c"] = Instance.new("UIStroke", Slider["2a"]);
				Slider["2c"]["Color"] = Color3.fromRGB(126, 94, 255);
				Slider["2c"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Slider.Title
				Slider["2d"] = Instance.new("TextLabel", Slider["2a"]);
				Slider["2d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Slider["2d"]["TextSize"] = 15;
				Slider["2d"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Slider["2d"]["Size"] = UDim2.new(1, -24, 1, -10);
				Slider["2d"]["Text"] = options.Text;
				Slider["2d"]["TextXAlignment"] = Enum.TextXAlignment.Left
				Slider["2d"]["Name"] = [[Title]];
				Slider["2d"]["Font"] = Enum.Font.Ubuntu;
				Slider["2d"]["BackgroundTransparency"] = 1;

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Slider.UIPadding
				Slider["2e"] = Instance.new("UIPadding", Slider["2a"]);
				Slider["2e"]["PaddingTop"] = UDim.new(0, 6);
				Slider["2e"]["PaddingRight"] = UDim.new(0, 6);
				Slider["2e"]["PaddingBottom"] = UDim.new(0, 6);
				Slider["2e"]["PaddingLeft"] = UDim.new(0, 6);

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Slider.Value
				Slider["2f"] = Instance.new("TextLabel", Slider["2a"]);
				Slider["2f"]["TextXAlignment"] = Enum.TextXAlignment.Right;
				Slider["2f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Slider["2f"]["TextSize"] = 15;
				Slider["2f"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Slider["2f"]["AnchorPoint"] = Vector2.new(1, 0);
				Slider["2f"]["Size"] = UDim2.new(0, 24, 1, -10);
				Slider["2f"]["Text"] = tostring(options.Default);
				Slider["2f"]["Name"] = [[Value]];
				Slider["2f"]["Font"] = Enum.Font.Ubuntu;
				Slider["2f"]["BackgroundTransparency"] = 1;
				Slider["2f"]["Position"] = UDim2.new(1, 0, 0, 0);

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Slider.SliderBack
				Slider["30"] = Instance.new("Frame", Slider["2a"]);
				Slider["30"]["BackgroundColor3"] = Color3.fromRGB(52, 52, 52);
				Slider["30"]["BorderColor3"] = Color3.fromRGB(52,52,52)
				Slider["30"]["AnchorPoint"] = Vector2.new(0, 1);
				Slider["30"]["Size"] = UDim2.new(1, 0, 0, 5);
				Slider["30"]["Position"] = UDim2.new(0, 0, 1, 0);
				Slider["30"]["Name"] = [[SliderBack]];

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Slider.SliderBack.UICorner
				Slider["31"] = Instance.new("UICorner", Slider["30"]);


				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Slider.SliderBack.UIStroke
				Slider["32"] = Instance.new("UIStroke", Slider["30"]);
				Slider["32"]["Color"] = Color3.fromRGB(48, 48, 48);
				Slider["32"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Slider.SliderBack.Draggable
				Slider["33"] = Instance.new("Frame", Slider["30"]);
				Slider["33"]["BackgroundColor3"] = Color3.fromRGB(126, 94, 255);
				Slider["33"]["BorderColor3"] = Color3.fromRGB(125, 93, 255)
				Slider["33"]["Size"] = UDim2.new(0.5, 0, 1, 0);
				Slider["33"]["Name"] = [[Draggable]];

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Slider.SliderBack.Draggable.UICorner
				Slider["34"] = Instance.new("UICorner", Slider["33"]);
			end
			
			-- Methods
			
			local function Round(Value)
				if options.Rounding == 0 then
					return math.floor(Value);
				end;
				
				local Str = Value.. '';
				local Dot = Str:find('%.');
				
				return Dot and tonumber(Str:sub(1, Dot + options.Rounding)) or Value;
			end
			
			function Slider:SetValue(v)
				if v == nil then
					local percentage = math.clamp((mouse.X - Slider["30"].AbsolutePosition.X) / (Slider["30"].AbsoluteSize.X), 0, 1)
					local value = (((options.Max - options.Min) * percentage) + options.Min)
					local rounded = Round(value)
					value = rounded

					Slider["2f"].Text = tostring(value)
					Slider["33"].Size = UDim2.fromScale(percentage, 1)
				else
					Slider["2f"].Text = tostring(v)
					Slider["33"].Size = UDim2.fromScale(((v - options.Min) / (options.Max - options.Min)), 1)
				end
				options.callback(Slider:GetValue())
			end
			
			function Slider:GetValue(v)
				return tonumber(Slider["2f"].Text)
			end
			
			-- Logic
			do
				Slider["2a"].MouseEnter:Connect(function()
					Slider.Hover = true

					Library:tween(Slider["2c"], {Color = Color3.fromRGB(213, 178, 255)})
				end)

				Slider["2a"].MouseLeave:Connect(function()
					Slider.Hover = false

					if not Slider.MouseDown then
						Library:tween(Slider["2c"], {Color = Color3.fromRGB(125, 93, 255)})
					end
				end)

				uis.InputBegan:Connect(function(input, gpe)
					if gpe then return end

					if input.UserInputType == Enum.UserInputType.MouseButton1 and Slider.Hover then
						Slider.MouseDown = true
						Library:tween(Slider["2c"], {Color = Color3.fromRGB(213, 178, 255)})
						
						if not Slider.Connection then
							Slider.Connection = runService.RenderStepped:Connect(function()
								Slider:SetValue()
							end)
						end
					end
				end)

				uis.InputEnded:Connect(function(input, gpe)
					if gpe then return end

					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Slider.MouseDown = false

						if Slider.Hover then
							Library:tween(Slider["2a"], {BackgroundColor3 = Color3.fromRGB(55, 55, 55)})
							Library:tween(Slider["2c"], {Color = Color3.fromRGB(175, 135, 255)})
						else
							Library:tween(Slider["2a"], {BackgroundColor3 = Color3.fromRGB(55, 55, 55)})
							Library:tween(Slider["2c"], {Color = Color3.fromRGB(125, 93, 255)})
						end
						
						if Slider.Connection then
							Slider.Connection:Disconnect()
						end
						Slider.Connection = nil
					end
				end)
			end
			
			return Slider
		end
		
		function Tab:Dropdown(options)
			options = Library:Validate({
				Text = "Dropdown",
				Items = {},
				callback = function(v) print(v) end
			}, options or {})
			
			local Dropdown = {
				Items = {
					["id"] = {
						"value"
					}
				},
				Open = false,
				MouseDown = false,
				Hover = false
			}
			
			-- Render
			do
				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Dropdown
				Dropdown["35"] = Instance.new("Frame", Tab["1c"]);
				Dropdown["35"]["BackgroundColor3"] = Color3.fromRGB(55, 55, 55);
				Dropdown["35"]["Size"] = UDim2.new(1, 0, 0, 31);
				Dropdown["35"]["ClipsDescendants"] = true;
				Dropdown["35"]["Name"] = options.Text;

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Dropdown.UICorner
				Dropdown["36"] = Instance.new("UICorner", Dropdown["35"]);
				Dropdown["36"]["CornerRadius"] = UDim.new(0, 4);

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Dropdown.UIStroke
				Dropdown["37"] = Instance.new("UIStroke", Dropdown["35"]);
				Dropdown["37"]["Color"] = Color3.fromRGB(126, 94, 255);
				Dropdown["37"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Dropdown.Title
				Dropdown["38"] = Instance.new("TextLabel", Dropdown["35"]);
				Dropdown["38"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Dropdown["38"]["TextSize"] = 15;
				Dropdown["38"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Dropdown["38"]["Size"] = UDim2.new(1, 0, 0, 20);
				Dropdown["38"]["TextXAlignment"] = Enum.TextXAlignment.Left
				Dropdown["38"]["Text"] = options.Text;
				Dropdown["38"]["Name"] = [[Title]];
				Dropdown["38"]["Font"] = Enum.Font.Ubuntu;
				Dropdown["38"]["BackgroundTransparency"] = 1;

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Dropdown.UIPadding
				Dropdown["39"] = Instance.new("UIPadding", Dropdown["35"]);
				Dropdown["39"]["PaddingTop"] = UDim.new(0, 6);
				Dropdown["39"]["PaddingRight"] = UDim.new(0, 6);
				Dropdown["39"]["PaddingBottom"] = UDim.new(0, 6);
				Dropdown["39"]["PaddingLeft"] = UDim.new(0, 6);

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Dropdown.Icon
				Dropdown["3a"] = Instance.new("ImageLabel", Dropdown["35"]);
				Dropdown["3a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Dropdown["3a"]["AnchorPoint"] = Vector2.new(1,0);
				Dropdown["3a"]["Image"] = [[rbxassetid://11953657495]];
				Dropdown["3a"]["Size"] = UDim2.new(0, 20, 0, 20);
				Dropdown["3a"]["Name"] = [[Icon]];
				Dropdown["3a"]["BackgroundTransparency"] = 1;
				Dropdown["3a"]["Position"] = UDim2.new(1, 0, 0, 0);

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Dropdown.OptionHolder
				Dropdown["3b"] = Instance.new("Frame", Dropdown["35"]);
				Dropdown["3b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Dropdown["3b"]["BackgroundTransparency"] = 1;
				Dropdown["3b"]["Size"] = UDim2.new(1, 0, 1, -24);
				Dropdown["3b"]["Position"] = UDim2.new(0, 0, 0, 26);
				Dropdown["3b"]["Visible"] = false;
				Dropdown["3b"]["Name"] = [[OptionHolder]];

				-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Dropdown.OptionHolder.UIListLayout
				Dropdown["3c"] = Instance.new("UIListLayout", Dropdown["3b"]);
				Dropdown["3c"]["Padding"] = UDim.new(0, 6);
				Dropdown["3c"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
			end
			
			-- Methods
			do
				function Dropdown:Add(id, value)
					local Item = {
						Hover = false,
						MouseDown = false
					}
					if Dropdown.Items[id] ~= nil then
						return
					end
					Dropdown.Items[id] = {
						instance = {},
						value = value
					}
					-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Dropdown.OptionHolder.Inactive Option
					Dropdown.Items[id].instance["3d"] = Instance.new("TextLabel", Dropdown["3b"]);
					Dropdown.Items[id].instance["3d"]["BorderSizePixel"] = 0;
					Dropdown.Items[id].instance["3d"]["BackgroundColor3"] = Color3.fromRGB(60,60,60);
					Dropdown.Items[id].instance["3d"]["TextSize"] = 14;
					Dropdown.Items[id].instance["3d"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
					Dropdown.Items[id].instance["3d"]["Size"] = UDim2.new(1, 0, 0, 20);
					Dropdown.Items[id].instance["3d"]["Text"] = id;
					Dropdown.Items[id].instance["3d"]["Name"] = [[Inactive Option]];
					Dropdown.Items[id].instance["3d"]["Font"] = Enum.Font.Ubuntu;

					-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Dropdown.OptionHolder.Inactive Option.UIStroke
					Dropdown.Items[id].instance["3e"] = Instance.new("UIStroke", Dropdown.Items[id].instance["3d"]);
					Dropdown.Items[id].instance["3e"]["Color"] = Color3.fromRGB(65,65,65);
					Dropdown.Items[id].instance["3e"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;

					-- StarterGui.UI Lib.Main.ContentContainer.HomeTab.Dropdown.OptionHolder.Inactive Option.UICorner
					Dropdown.Items[id].instance["3f"] = Instance.new("UICorner", Dropdown.Items[id].instance["3d"]);
					Dropdown.Items[id].instance["3f"]["CornerRadius"] = UDim.new(0, 2);
					
					Dropdown.Items[id].instance["3d"].MouseEnter:Connect(function()
						Item.Hover = true

						Library:tween(Dropdown.Items[id].instance["3e"], {Color = Color3.fromRGB(175, 135, 255)})
					end)

					Dropdown.Items[id].instance["3d"].MouseLeave:Connect(function()
						Item.Hover = false

						if not Item.MouseDown then
							Library:tween(Dropdown.Items[id].instance["3e"], {Color = Color3.fromRGB(125, 93, 255)})
						end
					end)

					uis.InputBegan:Connect(function(input, gpe)
						if gpe then return end
						
						if Dropdown.Items[id] == nil then
							return
						end
						
						if Dropdown.Items[id].instance == nil then
							return
						end

						if input.UserInputType == Enum.UserInputType.MouseButton1 and Item.Hover then
							Dropdown.MouseDown = true
							Library:tween(Dropdown.Items[id].instance["3e"], {Color = Color3.fromRGB(175, 135, 255)})
							options.callback(id)
							Dropdown:Toggle()
							Dropdown["38"].Text = tostring(id)
						end
					end)

					uis.InputEnded:Connect(function(input, gpe)
						if gpe then return end
						
						if Dropdown.Items[id] == nil then
							return
						end
						
						if Dropdown.Items[id].instance == nil then
							return
						end

						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							Item.MouseDown = false

							if Item.Hover then
								Library:tween(Dropdown.Items[id].instance["3e"], {Color = Color3.fromRGB(175, 135, 255)})
							else
								Library:tween(Dropdown.Items[id].instance["3e"], {Color = Color3.fromRGB(125, 93, 255)})
							end
						end
					end)
				end

				function Dropdown:Remove(id)
					if Dropdown.Items[id] ~= nil then
						if Dropdown.Items[id].instance then
							for i,v in pairs(Dropdown.Items[id].instance) do
								v:Destroy()
							end
						end
						Dropdown.Items[id] = nil
					end
				end

				function Dropdown:Clear()
					for i,v in pairs(Dropdown.Items) do
						Dropdown:Remove(i)
					end
				end

				function Dropdown:Toggle()
					if Dropdown.Open then
						Library:tween(Dropdown["35"], {Size = UDim2.new(1, 0, 0, 30)}, function()
							Dropdown["3b"].Visible = false
						end)
					else
						local count = 0
						for i,v in pairs(Dropdown.Items) do
							if v ~= nil then
								count += 1
							end
						end
						
						Dropdown["3b"].Visible = true
						Library:tween(Dropdown["35"], {Size = UDim2.new(1, 0, 0, 31 + (count * 20) + 1)})
					end
					Dropdown.Open = not Dropdown.Open
				end
			end
			
			-- Logic
			do
				
				for i,v in pairs(options.Items) do
					if v then
						Dropdown:Add(v, 1)
					end
				end
				
				Dropdown["3a"].MouseEnter:Connect(function()
					Dropdown.Hover = true

					Library:tween(Dropdown["37"], {Color = Color3.fromRGB(175, 135, 255)})
				end)

				Dropdown["3a"].MouseLeave:Connect(function()
					Dropdown.Hover = false

					if not Dropdown.MouseDown then
						Library:tween(Dropdown["37"], {Color = Color3.fromRGB(125, 93, 255)})
					end
				end)

				uis.InputBegan:Connect(function(input, gpe)
					if gpe then return end

					if input.UserInputType == Enum.UserInputType.MouseButton1 and Dropdown.Hover then
						Dropdown.MouseDown = true
						Library:tween(Dropdown["37"], {Color = Color3.fromRGB(175, 135, 255)})
						Dropdown:Toggle()
					end
				end)

				uis.InputEnded:Connect(function(input, gpe)
					if gpe then return end

					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Dropdown.MouseDown = false

						if Dropdown.Hover then
							Library:tween(Dropdown["37"], {Color = Color3.fromRGB(175, 135, 255)})
						else
							Library:tween(Dropdown["37"], {Color = Color3.fromRGB(125, 93, 255)})
						end
					end
				end)
				
			end
			
			return Dropdown
		end
		
		return Tab
	end
	
	return GUI
end

print("Zelt was here")
return Library
