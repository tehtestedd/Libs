-- // variables
local library = {}
local pages = {}
local sections = {}
local toggles = {}
local sliders = {}
local buttons = {}
local labels = {}
local dropdowns = {}
local multidropdowns = {}
local keybinds = {}
local textboxs = {}
local colorpickers = {}
--
local utility = {}
--
local plrs = game:GetService("Players")
local cre = game:GetService("CoreGui")
local ts = game:GetService("TweenService") 
local uis = game:GetService("UserInputService") 
local plr = plrs.LocalPlayer
-- // indexes
library.__index = library
pages.__index = pages
sections.__index = sections
toggles.__index = toggles
sliders.__index = sliders
buttons.__index = buttons
labels.__index = labels
dropdowns.__index = dropdowns
multidropdowns.__index = multidropdowns
keybinds.__index = keybinds
textboxs.__index = textboxs
colorpickers.__index = colorpickers
-- // functions
utility.new = function(instance,properties) 
	-- // instance
	local ins = Instance.new(instance)
	-- // properties setting
	for property,value in pairs(properties) do
		ins[property] = value
	end
	-- // return
	return ins
end
--
utility.round = function(n,d)
	return tonumber(string.format("%."..(d or 0).."f",n))
end
-- // main
function library:new(props)
	-- // properties
	local name = props.name or props.Name or props.UiName or props.Uiname or props.uiName or props.username or props.Username or props.UserName or props.userName or "new ui"
	local color = props.color or props.Color or props.mainColor or props.maincolor or props.MainColor or props.Maincolor or props.Accent or props.accent or Color3.fromRGB(0,167,255)
	local key = props.key or props.Key or props.toggle or props.Toggle or props.turn or props.Turn or "RightShift"
	local textsize = props.textsize or props.Textsize or props.TextSize or props.textSize or {14,13,10}
	-- // variables
	local window = {}
	-- // main
	local screen = utility.new(
		"ScreenGui",
		{
			Name = tostring(math.random(0,999999))..tostring(math.random(0,999999)),
			ZIndexBehavior = "Sibling"
		}
	)
	--
	syn.protect_gui(screen)
	--
	screen.Parent = cre
	-- 1
	local mainframe = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(0,525,0,400),
			Position = UDim2.new(0.092,0,0.21,0),
			Parent = screen
		}
	)
	-- 2
	local main = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = Color3.fromRGB(3,3,3),
			BorderColor3 = Color3.fromRGB(0,0,0),
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,0.96,0),
			Position = UDim2.new(0,0,1,0),
			Parent = mainframe
		}
	)
	--
	local top = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(3,3,3),
			BorderColor3 = Color3.fromRGB(0,0,0),
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,0.04,0),
			Position = UDim2.new(0,0,0,0),
			Parent = mainframe
		}
	)
	-- 3
	local holder = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundColor3 = Color3.fromRGB(13,13,13),
			BorderColor3 = Color3.fromRGB(0,0,0),
			BorderSizePixel = 0,
			Size = UDim2.new(1,-10,1,-10),
			Position = UDim2.new(0.5,0,0.5,0),
			Parent = main
		}
	)
	--
	local title = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0.7,0),
			Position = UDim2.new(0,0,0.2,0),
			Font = "RobotoMono",
			Text = name,
			TextColor3 = color,
			TextSize = textsize[1],
			TextStrokeTransparency = 0.5,
			Parent = top
		}
	)
	-- 4
	local tabs = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,1),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-10,1,-40),
			Position = UDim2.new(0.5,0,1,-5),
			Parent = holder
		}
	)
	--
	local buttons = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,25),
			Position = UDim2.new(0,0,0,0),
			Parent = holder
		}
	)
	-- 5
	utility.new(
		"UIListLayout",
		{
			FillDirection = "Horizontal",
			Parent = buttons
		}
	)
	--
	local drag = false
	local x,y = 0,0
	--
	top.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			drag = true
			x,y = plr:GetMouse().X-top.AbsolutePosition.X,plr:GetMouse().Y-top.AbsolutePosition.Y
			mainframe:TweenPosition(UDim2.new(0,plr:GetMouse().X-x,0,plr:GetMouse().Y-y),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true)
		end
	end)
	--
	top.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			drag = false
		end
	end)
	--
	uis.InputChanged:Connect(function()
		if drag then
			mainframe:TweenPosition(UDim2.new(0,plr:GetMouse().X-x,0,plr:GetMouse().Y-y),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true)
		end
	end)
	-- // window tbl
	window = {
		["screen"] = screen,
		["mainframe"] = mainframe,
		["top"] = top,
		["title"] = title,
		["holder"] = holder,
		["tabs"] = tabs,
		["buttons"] = buttons,
		["color"] = color,
		["key"] = key,
		["textsize"] = textsize
	}
	--
	local lastpos = nil
	local cooldown = false
	--
	uis.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode[window.key] then
				if screen.Enabled then
					if cooldown == false then
						cooldown = true
						lastpos = mainframe.Position
						mainframe:TweenPosition(UDim2.new(-1.25,0,lastpos.Y.Scale,lastpos.Y.Offset),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.2,true)
						wait(0.25)
						screen.Enabled = false
						wait(0.1)
						cooldown = false
					end
				else
					if cooldown == false then
						cooldown = true
						screen.Enabled = true
						mainframe:TweenPosition(lastpos,Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.2,true)
						wait(0.35)
						cooldown = false
					end
				end
			end
		end
	end)
	-- // metatable indexing + return
	setmetatable(window, library)
	return window
end
--
function library:key(str)
	self.key = str
end
--
function library:page(props)
	-- // properties
	local name = props.name or props.Name or props.pageName or props.PageName or props.pagename or props.Pagename or props.title or props.Title or "new page"
	-- // variables
	local page = {}
	-- // main
	local size = 1
	local ammount = 1
	--
	for ind,val in pairs(self.buttons:GetChildren()) do
		if val.ClassName == "Frame" then
			ammount = ammount+1
		end
	end
	--
	for i,v in pairs(self.buttons:GetChildren()) do
		if v.ClassName == "Frame" then
			v.Size = UDim2.new(1/ammount,0,1,0)
		end
	end
	--
	local frame = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Parent = self.tabs,
			Visible = false
		}
	)
	--
	local tabbutton = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1/ammount,0,1,0),
			Parent = self.buttons
		}
	)
	--
	local title = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Font = "Ubuntu",
			Text = name,
			TextColor3 = Color3.fromRGB(175, 175, 175),
			TextSize = self.textsize[2],
			TextStrokeTransparency = 0.5,
			Parent = tabbutton
		}
	)
	--
	local outline = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,1),
			BackgroundColor3 = self.color,
			BorderColor3 = Color3.fromRGB(0,0,0),
			BorderSizePixel = 0,
			Size = UDim2.new(0,0,0,2),
			Position = UDim2.new(0.5,0,1,0),
			Parent = tabbutton
		}
	)
	--
	local button = utility.new(
		"TextButton",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Text = "",
			Parent = tabbutton
		}
	)
	--
	local value = utility.new(
		"BoolValue",
		{
			Parent = tabbutton
		}
	)
	--
	tabbutton.MouseEnter:Connect(function()
		if frame.Visible == false then
			ts:Create(title, TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {TextColor3 = self.color}):Play()
		end
		outline:TweenSize(UDim2.new(0,math.clamp(title.TextBounds.X+20,0,tabbutton.AbsoluteSize.X-20),0,2),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.25,true)
	end)
	--
	tabbutton.MouseLeave:Connect(function()
		if frame.Visible == false then
			ts:Create(title, TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {TextColor3 = Color3.fromRGB(175,175,175)}):Play()
		end
		outline:TweenSize(UDim2.new(0,0,0,2),Enum.EasingDirection.In,Enum.EasingStyle.Quad,0.25,true)
	end)
	--
	button.MouseButton1Down:Connect(function()
		if frame.Visible == true then
			frame.Visible = false
			value.Value = false
			ts:Create(title, TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {TextColor3 = Color3.fromRGB(175,175,175)}):Play()
		else
			for i,v in pairs(self.tabs:GetChildren()) do
				if v.ClassName == "Frame" and v.Visible == true then
					v.Visible = false
				end
			end
			for i,v in pairs(self.buttons:GetChildren()) do
				if v.ClassName == "Frame" and v.Value.Value == true then
					ts:Create(v:FindFirstChildOfClass("TextLabel"), TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {TextColor3 = Color3.fromRGB(175,175,175)}):Play()
				end
			end
			frame.Visible = true
			value.Value = true
			ts:Create(title, TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {TextColor3 = self.color}):Play()
		end
	end)
	-- // page tbl
	page = {
		["page"] = frame,
		["window"] = self,
		["tabbutton"] = tabbutton,
		["title"] = title,
		["button"] = button,
		["bvalue"] = value,
	}
	-- // metatable indexing + return
	setmetatable(page, pages)
	return page
end
--
function pages:open()
	for i,v in pairs(self.window.tabs:GetChildren()) do
		if v.ClassName == "Frame" and v.Visible == true then
			v.Visible = false
		end
	end
	for i,v in pairs(self.window.buttons:GetChildren()) do
		if v.ClassName == "Frame" and v.Value.Value == true then
			ts:Create(v:FindFirstChildOfClass("TextLabel"), TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {TextColor3 = Color3.fromRGB(175,175,175)}):Play()
		end
	end
	self.page.Visible = true
	self.bvalue.Value = true
	ts:Create(self.title, TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {TextColor3 = self.window.color}):Play()
end
--
function pages:section(props)
	-- // properties
	local name = props.name or props.Name or props.pageName or props.PageName or props.pagename or props.Pagename or props.title or props.Title or "new page"
	local sectiontype = props.sectiontype or props.Sectiontype or props.SectionType or props.sectionType or props.sidetype or props.Sidetype or props.SideType or props.sideType or props.side or props.Side or "left"
	sectiontype = sectiontype:lower()
	--
	local size = UDim2.new(0,0,0,0)
	local position = UDim2.new(0,0,0,0)
	local anchor = Vector2.new(0,0)
	--
	if sectiontype == "left" then
		size = UDim2.new(0.5,-5,1,0)
		position = UDim2.new(0,0,0,0)
	elseif sectiontype == "right" then
		size = UDim2.new(0.5,-5,1,0)
		position = UDim2.new(1,0,0,0)
		anchor = Vector2.new(1,0)
	else
		size = UDim2.new(1,0,1,0)
		position = UDim2.new(0,0,0,0)
	end
	-- // variables
	local section = {}
	-- // main
	local frame = utility.new(
		"Frame",
		{
			AnchorPoint = anchor,
			BackgroundColor3 = Color3.fromRGB(22,22,22),
			BorderColor3 = Color3.fromRGB(10, 10, 10),
			BorderMode = "Inset",
			BorderSizePixel = 1,
			Size = size,
			Position = position,
			Parent = self.page
		}
	)
	--
	local content = utility.new(
		"ScrollingFrame",
		{
			AnchorPoint = Vector2.new(0.5,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-10,1,-15),
			Position = UDim2.new(0.5,0,0,10),
			CanvasSize = UDim2.new(0,0,0,0),
			ScrollBarImageTransparency = 0.4,
			BorderSizePixel = 0,
			ScrollBarImageColor3 = Color3.fromRGB(0,0,0),
			ScrollBarThickness = 7,
			Parent = frame
		}
	)
	--
	local title = utility.new(
		"TextLabel",
		{
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-20,0.05,0),
			Position = UDim2.new(0.5,0,0,0),
			Font = "Ubuntu",
			Text = name,
			TextColor3 = Color3.fromRGB(230,230,230),
			TextSize = self.window.textsize[3],
			TextStrokeTransparency = 0.5,
			TextXAlignment = "Left",
			Parent = frame,
			ZIndex = 2
		}
	)
	--
	utility.new(
		"UIListLayout",
		{
			Padding = UDim.new(0,1),
			HorizontalAlignment = "Center",
			Parent = content
		}
	)
	--
	local pixel = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,1),
			Parent = content
		}
	)
	-- // page tbl
	section = {
		["window"] = self.window,
		["content"] = content,
		["title"] = title,
		["yaxis"] = 0,
		["main"] = frame
	}
	-- // metatable indexing + return
	setmetatable(section, sections)
	return section
end
--
function sections:toggle(props)
	-- // properties
	local name = props.name or props.Name or props.title or props.Title or "new page"
	local def = props.def or props.Def or props.default or props.Default or false
	local callback = props.callback or props.Callback or props.CallBack or props.callBack or function()end
	-- // variables
	local toggle = {}
	-- // main
	local holder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-20,0,20),
			Parent = self.content
		}
	)
	--
	self.yaxis = self.yaxis+21
	self.content.CanvasSize = UDim2.new(0,0,0,self.yaxis+5)
	--
	local frame = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(19,19,19),
			BorderColor3 = Color3.fromRGB(4,4,4),
			BorderMode = "Outline",	
			BorderSizePixel = 1,
			Size = UDim2.new(0,15,0,15),
			Position = UDim2.new(0,0,0,0),
			Parent = holder
		}
	)
	--
	local title = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-23,0,15),
			Position = UDim2.new(0,23,0,0),
			Font = "Ubuntu",
			Text = name,
			TextColor3 = Color3.fromRGB(230,230,230),
			TextSize = self.window.textsize[3],
			TextStrokeTransparency = 0.75,
			TextXAlignment = "Left",
			Parent = holder
		}
	)
	--
	local toggled = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundColor3 = Color3.fromRGB(19,19,19),
			BorderSizePixel = 0,
			Size = UDim2.new(0,11,0,11),
			Position = UDim2.new(0.5,0,0.5,0),
			Parent = frame
		}
	)
	--
	utility.new(
		"UIGradient",
		{
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(125, 125, 125))},
			Rotation = 90,
			Parent = toggled
		}
	)
	--
	local button = utility.new(
		"TextButton",
		{
			AnchorPoint = Vector2.new(0,0.5),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0.5,0),
			Text = "",
			Parent = holder
		}
	)
	--
	if def then
		toggled.BackgroundColor3 = self.window.color
	end
	-- // toggle tbl
	toggle = {
		["window"] = self.window,
		["holder"] = holder,
		["frame"] = frame,
		["title"] = title,
		["toggled"] = toggled,
		["button"] = button,
		["callback"] = callback,
		["istoggled"] = def
	}
	--
	button.MouseButton1Down:Connect(function()
		if toggle.istoggled then
			toggle.istoggled = false
			callback(toggle.istoggled)
			ts:Create(toggled, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(19,19,19)}):Play()
		else
			toggle.istoggled = true
			callback(toggle.istoggled)
			ts:Create(toggled, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BackgroundColor3 = self.window.color}):Play()
		end
	end)
	--
	button.MouseEnter:Connect(function()
		ts:Create(frame, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = self.window.color}):Play()
	end)
	--
	button.MouseLeave:Connect(function()
		ts:Create(frame, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = Color3.fromRGB(4,4,4)}):Play()
	end)
	-- // metatable indexing + return
	setmetatable(toggle, toggles)
	return toggle
end
--
function sections:slider(props)
	-- // properties
	local name = props.name or props.Name or props.title or props.Title or "new page"
	local roundnum = true
	for i,v in pairs(props) do
		if i == "decimals" or i == "Decimals" or i == "rounded" or i == "Rounded" or i == "rounding" or i == "Rounding" then
			roundnum = v
		end
	end
	local def = props.def or props.Def or props.default or props.Default or 0
	local max = props.max or props.Max or props.maximum or props.Maximum or 100
	local min = props.min or props.Min or props.minimum or props.Minimum or 0
	def = math.clamp(def,min,max)
	local measurement = props.measurement or props.Measurement or props.digit or props.Digit or props.calc or props.Calc or ""
	local callback = props.callback or props.Callback or props.CallBack or props.callBack or function()end
	-- // variables
	local slider = {}
	-- // main
	local holder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-20,0,30),
			Parent = self.content
		}
	)
	--
	self.yaxis = self.yaxis+31
	self.content.CanvasSize = UDim2.new(0,0,0,self.yaxis+5)
	--
	local frame = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(19,19,19),
			BorderColor3 = Color3.fromRGB(4,4,4),
			BorderMode = "Outline",
			BorderSizePixel = 1,
			Size = UDim2.new(1,0,0,10),
			Position = UDim2.new(0,0,0,15),
			Parent = holder
		}
	)
	--
	local fill = utility.new(
		"Frame",
		{
			BackgroundColor3 = self.window.color,
			BorderSizePixel = 0,
			Size = UDim2.new((1/frame.AbsoluteSize.X)*(frame.AbsoluteSize.X/(max-min)*(def-min)),0,1,0),
			Position = UDim2.new(0,0,0,0),
			Parent = frame
		}
	)
	--
	utility.new(
		"UIGradient",
		{
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(125, 125, 125))},
			Rotation = 90,
			Parent = fill
		}
	)
	--
	local round = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0),
			BackgroundColor3 = Color3.fromRGB(4,4,4),
			BorderSizePixel = 0,
			Size = UDim2.new(0,10,0,10),
			Position = UDim2.new(1,0,0,0),
			ZIndex = 2,
			Parent = fill
		}
	)
	--
	utility.new(
		"UICorner",
		{
			CornerRadius = UDim.new(1,0),
			Parent = round
		}
	)
	--
	local mid = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundColor3 = Color3.fromRGB(255,255,255),
			BorderSizePixel = 0,
			Size = UDim2.new(1,-2,1,-2),
			Position = UDim2.new(0.5,0,0.5,0),
			Parent = round
		}
	)
	--
	utility.new(
		"UICorner",
		{
			CornerRadius = UDim.new(1,0),
			Parent = mid
		}
	)
	--
	local title = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,10),
			Position = UDim2.new(0,0,0,0),
			Font = "Ubuntu",
			Text = name,
			TextColor3 = Color3.fromRGB(230,230,230),
			TextSize = self.window.textsize[3],
			TextStrokeTransparency = 0.75,
			TextXAlignment = "Left",
			Parent = holder
		}
	)
	--
	local value = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,10),
			Position = UDim2.new(0,0,0,0),
			Font = "Ubuntu",
			Text = def..measurement.."/"..max..measurement,
			TextColor3 = Color3.fromRGB(230,230,230),
			TextSize = self.window.textsize[3],
			TextStrokeTransparency = 0.75,
			TextXAlignment = "Right",
			Parent = holder
		}
	)
	--
	local button = utility.new(
		"TextButton",
		{
			AnchorPoint = Vector2.new(0,0.5),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0.5,0),
			Text = "",
			Parent = holder
		}
	)
	-- // toggle tbl
	slider = {
		["holding"] = false,
		["holder"] = holder,
		["slider"] = frame,
		["title"] = title,
		["value"] = value,
		["fill"] = fill,
		["round"] = round,
		["max"] = max,
		["min"] = min,
		["measurement"] = measurement,
		["rounded"] = roundnum,
		["callback"] = callback
	}
	--
	button.MouseButton1Down:Connect(function()
		slider.holding = true
		local size = math.clamp(plr:GetMouse().X-frame.AbsolutePosition.X,0,frame.AbsoluteSize.X)
		fill:TweenSize(UDim2.new((1/frame.AbsoluteSize.X)*size,0,1,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.25,true)
		local result = (max-min)/frame.AbsoluteSize.X*size+min
		if roundnum then
			value.Text = math.floor(result)..measurement.."/"..max..measurement
			callback(math.floor(result))
		else
			value.Text = utility.round(result,2)..measurement.."/"..max..measurement
			callback(utility.round(result,2))
		end
	end)
	--
	uis.InputChanged:Connect(function()
		if slider.holding then
			local size = math.clamp(plr:GetMouse().X-frame.AbsolutePosition.X,0,frame.AbsoluteSize.X)
			fill:TweenSize(UDim2.new((1/frame.AbsoluteSize.X)*size,0,1,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.25,true)
			local result = (max-min)/frame.AbsoluteSize.X*size+min
			if roundnum then
				value.Text = math.floor(result)..measurement.."/"..max..measurement
				callback(math.floor(result))
			else
				value.Text = utility.round(result,2)..measurement.."/"..max..measurement
				callback(utility.round(result,2))
			end
		end
	end)
	--
	uis.InputEnded:Connect(function(Input)
		if Input.UserInputType.Name == 'MouseButton1' and slider.holding then
			slider.holding = false
			ts:Create(frame, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = Color3.fromRGB(4,4,4)}):Play()
		end
	end)
	--
	button.MouseEnter:Connect(function()
		ts:Create(frame, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = self.window.color}):Play()
	end)
	--
	button.MouseLeave:Connect(function()
		if slider.holding == false then
			ts:Create(frame, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = Color3.fromRGB(4,4,4)}):Play()
		end
	end)
	-- // metatable indexing + return
	setmetatable(slider, sliders)
	return slider
end
--
function sections:button(props)
	-- // properties
	if props.buttons or props.Buttons then
		local holder = utility.new(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(1,-20,0,20),
				Parent = self.content
			}
		)
		--
		self.yaxis = self.yaxis+21
		self.content.CanvasSize = UDim2.new(0,0,0,self.yaxis+5)
		--
		utility.new(
			"UIListLayout",
			{
				Padding = UDim.new(0,8),
				FillDirection = "Horizontal",
				Parent = holder
			}
		)
		--
		for i,v in pairs(props.buttons) do
			local name = v.name or v.Name or v.title or v.Title or "new button"
			local callback = v.callback or v.Callback or v.CallBack or v.callBack or function()end
			--
			local frame = utility.new(
				"TextButton",
				{
					BackgroundColor3 = Color3.fromRGB(19,19,19),
					BorderColor3 = Color3.fromRGB(4,4,4),
					BorderMode = "Outline",
					BorderSizePixel = 1,
					Size = UDim2.new(0,0,0,15),
					Position = UDim2.new(0,0,0,0),
					AutoButtonColor = false,
					Text = name,
					TextStrokeTransparency = 0.75,
					TextSize = self.window.textsize[3],
					TextColor3 = Color3.fromRGB(230,230,230),
					Font = "Ubuntu",
					Parent = holder
				}
			)
			--
			frame.Size = UDim2.new(0,frame.TextBounds.X+26,0,15)
			--
			--
			frame.MouseButton1Down:Connect(function()
				callback()
				ts:Create(frame, TweenInfo.new(0.125,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
				wait(0.125)
				ts:Create(frame, TweenInfo.new(0.125,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(19,19,19)}):Play()
			end)
			--
			frame.MouseEnter:Connect(function()
				ts:Create(frame, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = self.window.color}):Play()
			end)
			--
			frame.MouseLeave:Connect(function()
				ts:Create(frame, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = Color3.fromRGB(4,4,4)}):Play()
			end)
		end
	else
		local name = props.name or props.Name or props.title or props.Title or "new button"
		local callback = props.callback or props.Callback or props.CallBack or props.callBack or function()end
		--
		local holder = utility.new(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(1,-20,0,20),
				Parent = self.content
			}
		)
		--
		self.yaxis = self.yaxis+21
		self.content.CanvasSize = UDim2.new(0,0,0,self.yaxis+5)
		--
		local frame = utility.new(
			"TextButton",
			{
				BackgroundColor3 = Color3.fromRGB(19,19,19),
				BorderColor3 = Color3.fromRGB(4,4,4),
				BorderMode = "Outline",
				BorderSizePixel = 1,
				Size = UDim2.new(0,0,0,15),
				Position = UDim2.new(0,0,0,0),
				AutoButtonColor = false,
				Text = name,
				TextStrokeTransparency = 0.75,
				TextSize = self.window.textsize[3],
				TextColor3 = Color3.fromRGB(230,230,230),
				Font = "Ubuntu",
				Parent = holder
			}
		)
		--
		frame.Size = UDim2.new(0,frame.TextBounds.X+26,0,15)
		--
		frame.MouseButton1Down:Connect(function()
			callback()
			ts:Create(frame, TweenInfo.new(0.125,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
			wait(0.125)
			ts:Create(frame, TweenInfo.new(0.125,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(19,19,19)}):Play()
		end)
		--
		frame.MouseEnter:Connect(function()
			ts:Create(frame, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = self.window.color}):Play()
		end)
		--
		frame.MouseLeave:Connect(function()
			ts:Create(frame, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = Color3.fromRGB(4,4,4)}):Play()
		end)
	end
end
--
function sections:label(props)
	-- // properties
	local name = props.name or props.Name or props.title or props.Title or "new page"
	local label = {}
	-- // main
	local holder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-20,0,20),
			Parent = self.content
		}
	)
	--
	self.yaxis = self.yaxis+21
	self.content.CanvasSize = UDim2.new(0,0,0,self.yaxis+5)
	--
	local title = utility.new(
		"TextLabel",
		{
			AnchorPoint = Vector2.new(0,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,15),
			Position = UDim2.new(0,0,0,0),
			Font = "Ubuntu",
			Text = name,
			TextColor3 = Color3.fromRGB(230,230,230),
			TextSize = self.window.textsize[3],
			TextStrokeTransparency = 0.75,
			Parent = holder
		}
	)
	--
	local line1 = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(1,0.5),
			BackgroundColor3 = self.window.color,
			BorderColor3 = Color3.fromRGB(4,4,4),
			BorderMode = "Outline",
			BorderSizePixel = 1,
			Size = UDim2.new(0,0,0,1),
			Position = UDim2.new(1,0,0.5,0),
			Parent = title
		}
	)
	--
	local line2 = utility.new(
		"Frame",
		{
			BackgroundColor3 = self.window.color,
			BorderColor3 = Color3.fromRGB(4,4,4),
			BorderMode = "Outline",
			BorderSizePixel = 1,
			Size = UDim2.new(0,0,0,1),
			Position = UDim2.new(0,0,0.5,0),
			Parent = title
		}
	)
	--
	line1.Size = UDim2.new(0.5,-((title.TextBounds.X/2)+10),0,1)
	line2.Size = line1.Size
	-- // toggle tbl
	label = {
		["title"] = title,
		["line1"] = line1,
		["line2"] = line2
	}
	-- // metatable indexing + return
	setmetatable(label, labels)
	return label
end
--
function sections:dropdown(props)
	-- // properties
	local name = props.name or props.Name or props.title or props.Title or "new page"
	local callback = props.callback or props.Callback or props.CallBack or props.callBack or function()end
	local options = props.options or props.Options or props.option or props.Option or props.dropdown or props.Dropdown or {}
	local def = props.def or props.Def or props.default or props.Default
	local current = "..."
	if def ~= nil and tonumber(def) > 0 then
		if options[def] then
			current = options[def]
		end
	end
	-- // main
	local holder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-20,0,20),
			ZIndex = 2,
			Parent = self.content
		}
	)
	--
	self.yaxis = self.yaxis+21
	self.content.CanvasSize = UDim2.new(0,0,0,self.yaxis+5)
	--
	local button = utility.new(
		"TextButton",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,20),
			Position = UDim2.new(0,0,0,0),
			Text = "",
			Parent = holder
		}
	)
	--
	local frame = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(19,19,19),
			BorderColor3 = Color3.fromRGB(4,4,4),
			BorderMode = "Outline",
			BorderSizePixel = 1,
			Size = UDim2.new(1,0,0,15),
			Position = UDim2.new(0,0,0,0),
			Parent = holder
		}
	)
	--
	local title = utility.new(
		"TextLabel",
		{
			AnchorPoint = Vector2.new(0.5,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(0.96,0,0,15),
			Position = UDim2.new(0.5,0,0,0),
			Font = "Ubuntu",
			Text = name.." ( "..current.." )",
			TextColor3 = Color3.fromRGB(230,230,230),
			TextSize = self.window.textsize[3],
			TextStrokeTransparency = 0.75,
			TextXAlignment = "Left",
			Parent = holder
		}
	)
	--
	local line = utility.new(
		"TextLabel",
		{
			AnchorPoint = Vector2.new(0.5,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(0.96,0,0,15),
			Position = UDim2.new(0.5,0,0,0),
			Font = "Ubuntu",
			Text = "--",
			TextColor3 = Color3.fromRGB(230,230,230),
			TextSize = self.window.textsize[3],
			TextStrokeTransparency = 0.75,
			TextXAlignment = "Right",
			Parent = holder
		}
	)
	--
	local optionholder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,1,1),
			Parent = frame
		}
	)
	--
	local dropdown = {
		["holder"] = holder,
		["title"] = title,
		["name"] = name,
		["current"] = current,
		["options"] = options,
		["openoptions"] = {},
		["optionsopen"] = false,
		["callback"] = callback
	}
	--
	local makeoptions = function(opt)
		for i,v in pairs(opt) do
			local optionholderframe = utility.new(
				"Frame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.new(1,0,1,0),
					Position = UDim2.new(0,0,i-1,0),
					ZIndex = 2,
					Parent = optionholder
				}
			)
			--
			local optionbutton = utility.new(
				"TextButton",
				{
					BackgroundTransparency = 1,
					Size = UDim2.new(1,0,1,0),
					Position = UDim2.new(0,0,0,0),
					Text = "",
					Parent = optionholderframe
				}
			)
			--
			local optionframe = utility.new(
				"Frame",
				{
					BackgroundColor3 = Color3.fromRGB(19,19,19),
					BorderColor3 = Color3.fromRGB(4,4,4),
					BorderMode = "Inset",
					BorderSizePixel = 1,
					Size = UDim2.new(1,0,1,0),
					Position = UDim2.new(0,0,0,0),
					Parent = optionholderframe
				}
			)
			--
			local titlecol = Color3.fromRGB(230,230,230)
			--
			if v == dropdown.current then
				titlecol = self.window.color
			end
			--
			local optiontitle = utility.new(
				"TextLabel",
				{
					AnchorPoint = Vector2.new(0.5,0),
					BackgroundTransparency = 1,
					Size = UDim2.new(0.96,0,0,15),
					Position = UDim2.new(0.5,0,0,0),
					Font = "Ubuntu",
					Text = "  "..v,
					TextColor3 = titlecol,
					TextSize = self.window.textsize[3],
					TextStrokeTransparency = 0.75,
					TextXAlignment = "Left",
					Parent = optionholderframe
				}
			)
			--
			local option = {
				["holder"] = optionholderframe,
				["frame"] = optionframe,
				["button"] = optionbutton,
				["title"] = optiontitle,
				["callback"] = callback
			}
			--
			table.insert(dropdown.openoptions,option)
			--
			optionbutton.MouseButton1Down:Connect(function()
				callback(v)
				dropdown.current = v
				title.Text = name.." ( "..dropdown.current.." )"
				for i,v in pairs(dropdown.openoptions) do
					v.holder:Remove()
				end
				holder.Size = UDim2.new(1,-20,0,20)
				dropdown.openoptions = {}
				dropdown.optionsopen = false
			end)
			--
			optionbutton.MouseEnter:Connect(function()
				ts:Create(optionframe, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = self.window.color}):Play()
			end)
			--
			optionbutton.MouseLeave:Connect(function()
				ts:Create(optionframe, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = Color3.fromRGB(4,4,4)}):Play()
			end)
		end
	end
	--
	local th = 0
	--
	button.MouseButton1Down:Connect(function()
		if dropdown.optionsopen then
			for i,v in pairs(dropdown.openoptions) do
				v.holder:Remove()
			end
			holder.Size = UDim2.new(1,-20,0,20)
			--
			self.yaxis = self.yaxis-th
			self.content.CanvasSize = UDim2.new(0,0,0,self.yaxis+5)
			--
			th = 0
			dropdown.openoptions = {}
			dropdown.optionsopen = false
		else
			makeoptions(dropdown.options)
			th = 15*#dropdown.options
			holder.Size = UDim2.new(1,-20,0,20+(th))
			--
			self.yaxis = self.yaxis+th
			self.content.CanvasSize = UDim2.new(0,0,0,self.yaxis+5)
			--
			self.content.CanvasPosition = Vector2.new(0,self.content.CanvasPosition.Y-1)
			ts:Create(self.content, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {CanvasPosition = Vector2.new(0,self.content.CanvasPosition.Y+(15*#dropdown.options))}):Play()
			dropdown.optionsopen = true
		end
	end)
	--
	button.MouseEnter:Connect(function()
		ts:Create(frame, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = self.window.color}):Play()
	end)
	--
	button.MouseLeave:Connect(function()
		ts:Create(frame, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = Color3.fromRGB(4,4,4)}):Play()
	end)
	-- // metatable indexing + return
	setmetatable(dropdown, dropdowns)
	return dropdown
end
--
function sections:multidropdown(props)
	-- // properties
	local name = props.name or props.Name or props.title or props.Title or "new page"
	local callback = props.callback or props.Callback or props.CallBack or props.callBack or function()end
	local options = props.options or props.Options or props.option or props.Option or props.dropdown or props.Dropdown or {}
	local cutoff = props.cut or props.Cut or props.cutoff or props.cutOff or props.CutOff or props.Cutoff or false
	local lettersam = props.letters or props.Letters or 99999
	local def = props.def or props.Def or props.default or props.Default or {}
	local current = {}
	for i,v in pairs(def) do
		if v ~= nil and tonumber(v) > 0 then
			if options[v] then
				table.insert(current,options[v])
			end
		end
	end
	-- // main
	local holder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-20,0,20),
			ZIndex = 2,
			Parent = self.content
		}
	)
	--
	self.yaxis = self.yaxis+21
	self.content.CanvasSize = UDim2.new(0,0,0,self.yaxis+5)
	--
	local button = utility.new(
		"TextButton",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,20),
			Position = UDim2.new(0,0,0,0),
			Text = "",
			Parent = holder
		}
	)
	--
	local frame = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(19,19,19),
			BorderColor3 = Color3.fromRGB(4,4,4),
			BorderMode = "Outline",
			BorderSizePixel = 1,
			Size = UDim2.new(1,0,0,15),
			Position = UDim2.new(0,0,0,0),
			Parent = holder
		} 
	)
	--
	local titlestring = ""
	for i,v in pairs(current) do
		if i == #current then
			if cutoff then
				titlestring = titlestring..string.sub(v,1,lettersam)..".."
			else
				titlestring = titlestring..v
			end
		else
			if cutoff then
				titlestring = titlestring..string.sub(v,1,lettersam)..".."..", "
			else
				titlestring = titlestring..v..", "
			end
		end
	end
	if titlestring == "" then
		titlestring = "..."
	end
	--
	local title = utility.new(
		"TextLabel",
		{
			AnchorPoint = Vector2.new(0.5,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(0.96,0,0,15),
			Position = UDim2.new(0.5,0,0,0),
			Font = "Ubuntu",
			Text = name.." ( "..titlestring.." )",
			TextColor3 = Color3.fromRGB(230,230,230),
			TextSize = self.window.textsize[3],
			TextStrokeTransparency = 0.75,
			TextXAlignment = "Left",
			Parent = holder
		}
	)
	--
	local line = utility.new(
		"TextLabel",
		{
			AnchorPoint = Vector2.new(0.5,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(0.96,0,0,15),
			Position = UDim2.new(0.5,0,0,0),
			Font = "Ubuntu",
			Text = "--",
			TextColor3 = Color3.fromRGB(230,230,230),
			TextSize = self.window.textsize[3],
			TextStrokeTransparency = 0.75,
			TextXAlignment = "Right",
			Parent = holder
		}
	)
	--
	local optionholder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,1,1),
			Parent = frame
		}
	)
	--
	local multidropdown = {
		["holder"] = holder,
		["title"] = title,
		["name"] = name,
		["current"] = current,
		["options"] = options,
		["openoptions"] = {},
		["optionsopen"] = false,
		["callback"] = callback,
		["cutoff"] = true,
		["letters"] = lettersam
	}
	--
	local makeoptions = function(opt)
		for i,v in pairs(opt) do
			local optionholderframe = utility.new(
				"Frame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.new(1,0,1,0),
					Position = UDim2.new(0,0,i-1,0),
					ZIndex = 2,
					Parent = optionholder
				}
			)
			--
			local optionbutton = utility.new(
				"TextButton",
				{
					BackgroundTransparency = 1,
					Size = UDim2.new(1,0,1,0),
					Position = UDim2.new(0,0,0,0),
					Text = "",
					Parent = optionholderframe
				}
			)
			--
			local optionframe = utility.new(
				"Frame",
				{
					BackgroundColor3 = Color3.fromRGB(19,19,19),
					BorderColor3 = Color3.fromRGB(4,4,4),
					BorderMode = "Inset",
					BorderSizePixel = 1,
					Size = UDim2.new(1,0,1,0),
					Position = UDim2.new(0,0,0,0),
					Parent = optionholderframe
				}
			)
			--
			local titlecol = Color3.fromRGB(230,230,230)
			local iscurrent = false
			--
			if table.find(multidropdown.current,v)then
				titlecol = self.window.color
				iscurrent = true
			end
			--
			local optiontitle = utility.new(
				"TextLabel",
				{
					AnchorPoint = Vector2.new(0.5,0),
					BackgroundTransparency = 1,
					Size = UDim2.new(0.96,0,0,15),
					Position = UDim2.new(0.5,0,0,0),
					Font = "Ubuntu",
					Text = "  "..v,
					TextColor3 = titlecol,
					TextSize = self.window.textsize[3],
					TextStrokeTransparency = 0.75,
					TextXAlignment = "Left",
					Parent = optionholderframe
				}
			)
			--
			local option = {
				["holder"] = optionholderframe,
				["frame"] = optionframe,
				["button"] = optionbutton,
				["title"] = optiontitle,
				["callback"] = callback
			}
			--
			table.insert(multidropdown.openoptions,option)
			--
			optionbutton.MouseButton1Down:Connect(function()
				if iscurrent then
					iscurrent = false
					local place = table.find(multidropdown.current,v)
					table.remove(multidropdown.current,place)
					ts:Create(optiontitle, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(230,230,230)}):Play()
				else
					iscurrent = true
					table.insert(multidropdown.current,v)
					ts:Create(optiontitle, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {TextColor3 = self.window.color}):Play()
				end
				callback(multidropdown.current)
				--
				local optiontitlestring = ""
				--
				for i,v in pairs(multidropdown.current) do
					if i == #multidropdown.current then
						if cutoff then
							if #v > lettersam then
								optiontitlestring = optiontitlestring..string.sub(v,1,lettersam)..".."
							else
								optiontitlestring = optiontitlestring..v
							end
						else
							optiontitlestring = optiontitlestring..v
						end
					else
						if cutoff then
							if #v > lettersam then
								optiontitlestring = optiontitlestring..string.sub(v,1,lettersam)..".."..", "
							else
								optiontitlestring = optiontitlestring..v..", "
							end
						else
							optiontitlestring = optiontitlestring..v..", "
						end
					end
				end
				--
				if optiontitlestring == "" then
					optiontitlestring = "..."
				end
				--
				title.Text = name.." ( "..optiontitlestring.." )"
			end)
			--
			optionbutton.MouseEnter:Connect(function()
				ts:Create(optionframe, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = self.window.color}):Play()
			end)
			--
			optionbutton.MouseLeave:Connect(function()
				ts:Create(optionframe, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = Color3.fromRGB(4,4,4)}):Play()
			end)
		end
	end
	--
	local th = 0
	--
	button.MouseButton1Down:Connect(function()
		if multidropdown.optionsopen then
			for i,v in pairs(multidropdown.openoptions) do
				v.holder:Remove()
			end
			holder.Size = UDim2.new(1,-20,0,20)
			--
			self.yaxis = self.yaxis-th
			self.content.CanvasSize = UDim2.new(0,0,0,self.yaxis+5)
			--
			th = 0
			--
			multidropdown.openoptions = {}
			multidropdown.optionsopen = false
		else
			makeoptions(multidropdown.options)
			--
			th = 15*#multidropdown.options
			holder.Size = UDim2.new(1,-20,0,20+(th))
			--
			self.yaxis = self.yaxis+th
			self.content.CanvasSize = UDim2.new(0,0,0,self.yaxis+5)
			--
			self.content.CanvasPosition = Vector2.new(0,self.content.CanvasPosition.Y-1)
			ts:Create(self.content, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {CanvasPosition = Vector2.new(0,self.content.CanvasPosition.Y+(15*#multidropdown.options))}):Play()
			multidropdown.optionsopen = true
		end
	end)
	--
	button.MouseEnter:Connect(function()
		ts:Create(frame, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = self.window.color}):Play()
	end)
	--
	button.MouseLeave:Connect(function()
		ts:Create(frame, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = Color3.fromRGB(4,4,4)}):Play()
	end)
	-- // metatable indexing + return
	setmetatable(multidropdown, multidropdowns)
	return multidropdown
end
--
function sections:keybind(props)
	-- // properties
	local name = props.name or props.Name or props.title or props.Title or "new page"
	local def = props.def or props.Def or props.default or props.Default or ""
	local callback = props.callback or props.Callback or props.CallBack or props.callBack or function()end
	local current = nil
	if typeof(def) == "EnumItem" then
		current = def
	else
		current = nil
	end
	-- // variables
	local keybind = {}
	-- // main
	local holder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-20,0,20),
			Parent = self.content
		}
	)
	--
	self.yaxis = self.yaxis+21
	self.content.CanvasSize = UDim2.new(0,0,0,self.yaxis+5)
	--
	local frame = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(19,19,19),
			BorderColor3 = Color3.fromRGB(4,4,4),
			BorderMode = "Outline",	
			BorderSizePixel = 1,
			Size = UDim2.new(0,30,0,15),
			Position = UDim2.new(0,0,0,0),
			Parent = holder
		}
	)
	--
	local title = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(1.1,0,0,0),
			Font = "Ubuntu",
			Text = name,
			TextColor3 = Color3.fromRGB(230,230,230),
			TextSize = self.window.textsize[3],
			TextStrokeTransparency = 0.75,
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			Parent = frame
		}
	)
	--
	local val = "..."
	if def == Enum.UserInputType.MouseButton1 then
		val = "MB1"
	elseif def == Enum.UserInputType.MouseButton2 then
		val = "MB2"
	elseif def == Enum.UserInputType.MouseButton3 then
		val = "MB3"
	else
		val = def.Name
	end
	--
	local value = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Font = "Ubuntu",
			Text = val or "...",
			TextColor3 = Color3.fromRGB(230,230,230),
			TextSize = self.window.textsize[3],
			TextStrokeTransparency = 0.75,
			Parent = frame
		}
	)
	--
	frame.Size = UDim2.new(0,value.TextBounds.X+20,0,15)
	title.Position = UDim2.new(1,8,0,0)
	--
	local button = utility.new(
		"TextButton",
		{
			AnchorPoint = Vector2.new(0,0.5),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0.5,0),
			Text = "",
			Parent = holder
		}
	)
	-- // toggle tbl
	keybind = {
		["window"] = self.window,
		["holder"] = holder,
		["frame"] = frame,
		["title"] = title,
		["value"] = value,
		["button"] = button,
		["callback"] = callback,
		["turned"] = false,
		["current"] = current
	}
	--
	button.MouseButton1Down:Connect(function()
		if keybind.turned == false then
			ts:Create(frame, TweenInfo.new(0.125,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
			wait()
			keybind.turned = true
		end
	end)
	--
	button.MouseButton2Down:Connect(function()
		if keybind.turned == false then
			value.Text = "..."
			keybind.current = nil
			--
			frame.Size = UDim2.new(0,value.TextBounds.X+20,0,15)
			--
			ts:Create(frame, TweenInfo.new(0.125,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
			wait(0.125)
			ts:Create(frame, TweenInfo.new(0.125,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(19, 19, 19)}):Play()
		end
	end)
	--
	uis.InputBegan:Connect(function(Input)
		if keybind.turned then
			local inp = nil
			local real = nil
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				inp = "MB1"
				real = Enum.UserInputType.MouseButton1
			elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
				inp = "MB2"
				real = Enum.UserInputType.MouseButton2
			elseif Input.UserInputType == Enum.UserInputType.MouseButton3 then
				inp = "MB3"
				real = Enum.UserInputType.MouseButton3
			elseif Input.UserInputType == Enum.UserInputType.Keyboard then
				inp = Input.KeyCode.Name
				real = Input.KeyCode
			end
			--
			if inp ~= nil and real ~= nil then
				value.Text = inp
				keybind.current = real
				--
				frame.Size = UDim2.new(0,value.TextBounds.X+20,0,15)
				--
				wait()
				keybind.turned = false
				--
				ts:Create(frame, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = Color3.fromRGB(4,4,4)}):Play()
				ts:Create(frame, TweenInfo.new(0.125,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(19, 19, 19)}):Play()
			end
		end
		if keybind.turned == false then
			if keybind.current ~= nil then
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					if keybind.current == Enum.UserInputType.MouseButton1 then
						keybind.callback()
						ts:Create(frame, TweenInfo.new(0.125,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
						wait(0.125)
						ts:Create(frame, TweenInfo.new(0.125,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(19, 19, 19)}):Play()
					end
				elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
					if keybind.current == Enum.UserInputType.MouseButton2 then
						keybind.callback()
						ts:Create(frame, TweenInfo.new(0.125,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
						wait(0.125)
						ts:Create(frame, TweenInfo.new(0.125,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(19, 19, 19)}):Play()
					end
				elseif Input.UserInputType == Enum.UserInputType.MouseButton3 then
					if keybind.current == Enum.UserInputType.MouseButton3 then
						keybind.callback()
						ts:Create(frame, TweenInfo.new(0.125,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
						wait(0.125)
						ts:Create(frame, TweenInfo.new(0.125,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(19, 19, 19)}):Play()
					end
				elseif Input.UserInputType == Enum.UserInputType.Keyboard then
					if Input.KeyCode == keybind.current then
						keybind.callback()
						ts:Create(frame, TweenInfo.new(0.125,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
						wait(0.125)
						ts:Create(frame, TweenInfo.new(0.125,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(19, 19, 19)}):Play()
					end
				end
			end
		end
	end)
	--
	button.MouseEnter:Connect(function()
		ts:Create(frame, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = self.window.color}):Play()
	end)
	--
	button.MouseLeave:Connect(function()
		if keybind.turned == false then
			ts:Create(frame, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = Color3.fromRGB(4,4,4)}):Play()
		end
	end)
	-- // metatable indexing + return
	setmetatable(keybind, keybinds)
	return keybind
end
--
function sections:textbox(props)
	-- // properties
	local name = props.name or props.Name or props.title or props.Title or "new button"
	local def = props.def or props.Def or props.default or props.Default or ""
	local callback = props.callback or props.Callback or props.CallBack or props.callBack or function()end
	-- // variables
	local textbox = {}
	-- // main
	local holder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-20,0,20),
			Parent = self.content
		}
	)
	--
	self.yaxis = self.yaxis+21
	self.content.CanvasSize = UDim2.new(0,0,0,self.yaxis+5)
	--
	local box = utility.new(
		"TextBox",
		{
			Size = UDim2.new(0.5,-4,0,15),
			BackgroundColor3 = Color3.fromRGB(19,19,19),
			BorderColor3 = Color3.fromRGB(4,4,4),
			Text = def,
			TextColor3 = Color3.fromRGB(230,230,230),
			PlaceholderText = "",
			PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
			Font = "Ubuntu",
			TextSize = self.window.textsize[3],
			Parent = holder
		}
	)
	--
	local done = false
	--
	local repeating = function()
		if box.TextBounds.X > (box.AbsoluteSize.X-8) then
			if box.TextSize == 1 then
				done = true
			else
				box.TextSize = box.TextSize-1
			end
		else
			done = true
		end
	end
	--
	repeat repeating() until done
	--
	local title = utility.new(
		"TextLabel",
		{
			AnchorPoint = Vector2.new(1,0),
			BackgroundTransparency = 1,
			Size = UDim2.new(0.5,-4,0,15),
			Position = UDim2.new(1,0,0,0),
			Font = "Ubuntu",
			Text = name,
			TextColor3 = Color3.fromRGB(230,230,230),
			TextSize = self.window.textsize[3],
			TextStrokeTransparency = 0.75,
			TextXAlignment = "Left",
			Parent = holder
		}
	)
	--
	local button = utility.new(
		"TextButton",
		{
			AnchorPoint = Vector2.new(0,0.5),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0.5,0),
			Text = "",
			Parent = holder
		}
	)
	-- // toggle tbl
	textbox = {
		["holder"] = holder,
		["box"] = box,
		["title"] = title,
		["button"] = button,
		["turned"] = false,
		["value"] = def
	}
	--
	button.MouseButton1Down:Connect(function()
		box:CaptureFocus()
	end)
	--
	box:GetPropertyChangedSignal("Text"):connect(function(text)
		textbox.value = box.Text
		local textsize = box.TextSize
		if box.TextBounds.X <= (box.AbsoluteSize.X-8) then
			box.TextSize = self.window.textsize[3]
			if box.TextBounds.X > (box.AbsoluteSize.X-8) then
				box.TextSize = textsize
			end
		elseif box.TextBounds.X > (box.AbsoluteSize.X-8) then
			if box.TextSize ~= 1 then
				box.TextSize = box.TextSize-1
			end
		end
		callback(textbox.value)
	end)
	--
	box.Focused:Connect(function()
		textbox.turned = true
		ts:Create(box, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = self.window.color}):Play()
		ts:Create(box, TweenInfo.new(0.125,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
	end)
	--
	box.FocusLost:connect(function()
		textbox.value = box.Text
		callback(textbox.value)
		textbox.turned = false
		ts:Create(box, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = Color3.fromRGB(4,4,4)}):Play()
		ts:Create(box, TweenInfo.new(0.125,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(19, 19, 19)}):Play()
	end)
	--
	uis.InputBegan:connect(function(input)
		if input.KeyCode == Enum.KeyCode.Escape and box:IsFocused() then
			textbox.turned = false
			box:ReleaseFocus()
		end
	end)
	--
	button.MouseEnter:Connect(function()
		ts:Create(box, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = self.window.color}):Play()
	end)
	--
	button.MouseLeave:Connect(function()
		if textbox.turned == false then
			ts:Create(box, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = Color3.fromRGB(4,4,4)}):Play()
		end
	end)
	-- // metatable indexing + return
	setmetatable(textbox, textboxs)
	return textbox
end
--
function sections:colorpicker(props)
	-- // properties
	local name = props.name or props.Name or props.title or props.Title or "new page"
	local def = props.def or props.Def or props.default or props.Default or props.color or props.Color or Color3.fromRGB(255, 255, 255)
	local callback = props.callback or props.Callback or props.CallBack or props.callBack or function()end
	-- // variables
	local colorpicker = {}
	-- // main
	local holder = utility.new(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-20,0,20),
			Parent = self.content
		}
	)
	--
	self.yaxis = self.yaxis+21
	self.content.CanvasSize = UDim2.new(0,0,0,self.yaxis+5)
	--
	local frame = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(19,19,19),
			BorderColor3 = Color3.fromRGB(4,4,4),
			BorderMode = "Outline",	
			BorderSizePixel = 1,
			Size = UDim2.new(0,30,0,15),
			Position = UDim2.new(0,0,0,0),
			Parent = holder
		}
	)
	--
	local title = utility.new(
		"TextLabel",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(1,8,0,0),
			Font = "Ubuntu",
			Text = name,
			TextColor3 = Color3.fromRGB(230,230,230),
			TextSize = self.window.textsize[3],
			TextStrokeTransparency = 0.75,
			TextXAlignment = "Left",
			Parent = frame
		}
	)
	--
	local color = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundColor3 = def,
			BorderSizePixel = 0,
			Size = UDim2.new(0,30-4,0,15-4),
			Position = UDim2.new(0.5,0,0.5,0),
			Parent = frame
		}
	)
	--
	local button = utility.new(
		"TextButton",
		{
			AnchorPoint = Vector2.new(0,0.5),
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0.5,0),
			Text = "",
			Parent = holder
		}
	)
	--
	local cpholder = utility.new(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(19,19,19),
			BorderSizePixel = 1,
			BorderColor3 = Color3.fromRGB(4,4,4),
			Size = UDim2.new(0.6,0,0,100),
			Position = UDim2.new(0,0,0,20),
			Visible = false,
			Parent = holder
		}
	)
	--
	local picker = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0,0.5),
			BackgroundColor3 = def,
			BorderSizePixel = 1,
			BorderColor3 = Color3.fromRGB(4,4,4),
			Size = UDim2.new(0.75,3,1,-10),
			Position = UDim2.new(0,5,0.5,0),
			Parent = cpholder
		}
	)
	--
	local huepicker = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(1,0.5),
			BackgroundColor3 = Color3.fromRGB(19,19,19),
			BorderSizePixel = 1,
			BorderColor3 = Color3.fromRGB(4,4,4),
			Size = UDim2.new(0.1,0,1,-10),
			Position = UDim2.new(1,-5,0.5,0),
			Parent = cpholder
		}
	)
	--
	local pickerimage = utility.new(
		"ImageButton",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Image = "rbxassetid://6951351449",
			Parent = picker
		}
	)
	--
	local pickercursor = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundColor3 = def,
			BorderSizePixel = 1,
			BorderColor3 = Color3.fromRGB(0,0,0),
			Size = UDim2.new(0,3,0,3),
			Position = UDim2.new(0,0,0,0),
			Parent = pickerimage
		}
	)
	--
	local hsv = utility.new(
		"TextButton",
		{
			Text = "",
			AutoButtonColor = false,
			BackgroundColor3 = Color3.fromRGB(255,255,255),
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,1,0),
			Position = UDim2.new(0,0,0,0),
			Parent = huepicker
		}
	)
	--
	local h,s,v = def:ToHSV()
	local new = Color3.fromHSV(h,1,1)
	--
	local hsvcursor = utility.new(
		"Frame",
		{
			AnchorPoint = Vector2.new(0,0.5),
			BackgroundColor3 = new,
			BorderSizePixel = 1,
			BorderColor3 = Color3.fromRGB(0,0,0),
			Size = UDim2.new(1,0,0,3),
			Position = UDim2.new(0,0,0,0),
			Parent = hsv
		}
	)
	--
	pickercursor.Position = UDim2.new(s,0,1-v,0)
	hsvcursor.Position = UDim2.new(0,0,h,0)
	--
	utility.new(
		"UIGradient",
		{
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(125, 125, 125))},
			Rotation = 330,
			Parent = color
		}
	)
	--
	utility.new(
		"UIGradient",
		{
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 153, 0)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(209, 255, 0)), ColorSequenceKeypoint.new(0.30, Color3.fromRGB(55, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 102)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 102, 255)), ColorSequenceKeypoint.new(0.70, Color3.fromRGB(51, 0, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(204, 0, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 153)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))},
			Rotation = 90,
			Parent = hsv
		}
	)
	-- // colorpicker tbl
	colorpicker = {
		["holder"] = holder,
		["cpholder"] = cpholder,
		["color"] = color,
		["title"] = title,
		["button"] = button,
		["pickercursor"] = pickercursor,
		["hsvcursor"] = hsvcursor,
		["picker"] = picker,
		["turned"] = false,
		["holding"] = false,
		["cp"] = false,
		["hue"] = false,
		["h"] = h,
		["s"] = s,
		["v"] = v,
		["callback"] = callback
	}
	--
	local th = 0
	--
	button.MouseButton1Down:Connect(function()
		if colorpicker.turned then
			colorpicker.turned = false
			cpholder.Visible = false
			holder.Size = UDim2.new(1,-20,0,20)
			--
			self.yaxis = self.yaxis-th
			self.content.CanvasSize = UDim2.new(0,0,0,self.yaxis+5)
			--
			th = 0
		else
			colorpicker.turned = true
			cpholder.Visible = true
			holder.Size = UDim2.new(1,-20,0,125)
			--
			th = 105
			--
			self.yaxis = self.yaxis+th
			self.content.CanvasSize = UDim2.new(0,0,0,self.yaxis+5)
		end
	end)
	--
	pickerimage.MouseButton1Down:Connect(function()
		colorpicker.holding = true
		colorpicker.cp = true
		local posx, posy = math.clamp(plr:GetMouse().X-pickerimage.AbsolutePosition.X,0,pickerimage.AbsoluteSize.X), math.clamp(plr:GetMouse().Y-pickerimage.AbsolutePosition.Y,0,pickerimage.AbsoluteSize.Y)
		local resx, resy = (1/pickerimage.AbsoluteSize.X)*posx, (1/pickerimage.AbsoluteSize.Y)*posy
		colorpicker.s = resx
		colorpicker.v = 1-resy
		pickercursor.BackgroundColor3 = Color3.fromHSV(colorpicker.h,colorpicker.s,colorpicker.v)
		pickercursor.BorderColor3 = Color3.fromHSV(0,0,resy)
		pickercursor:TweenPosition(UDim2.new(resx,0,resy,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.15,true)
		callback(res)
	end)
	--
	hsv.MouseButton1Down:Connect(function()
		colorpicker.holding = true
		colorpicker.hue = true
		local pos = math.clamp(plr:GetMouse().Y-hsv.AbsolutePosition.Y,0,hsv.AbsoluteSize.Y)
		local res = (1/hsv.AbsoluteSize.Y)*pos
		colorpicker.h = res
		hsvcursor.BackgroundColor3 = Color3.fromHSV(res,1,1)
		picker.BackgroundColor3 = Color3.fromHSV(res,1,1)
		pickercursor.BackgroundColor3 = Color3.fromHSV(colorpicker.h,colorpicker.s,colorpicker.v)
		hsvcursor:TweenPosition(UDim2.new(0,0,res,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.15,true)
		callback(res)
	end)
	--
	uis.InputChanged:Connect(function()
		if colorpicker.cp then
			local posx, posy = math.clamp(plr:GetMouse().X-pickerimage.AbsolutePosition.X,0,pickerimage.AbsoluteSize.X), math.clamp(plr:GetMouse().Y-pickerimage.AbsolutePosition.Y,0,pickerimage.AbsoluteSize.Y)
			local resx, resy = (1/pickerimage.AbsoluteSize.X)*posx, (1/pickerimage.AbsoluteSize.Y)*posy
			colorpicker.s = resx
			colorpicker.v = 1-resy
			pickercursor.BackgroundColor3 = Color3.fromHSV(colorpicker.h,colorpicker.s,colorpicker.v)
			pickercursor.BorderColor3 = Color3.fromHSV(0,0,resy)
			pickercursor:TweenPosition(UDim2.new(resx,0,resy,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.15,true)
			callback(res)
		end
		if colorpicker.hue then
			local pos = math.clamp(plr:GetMouse().Y-hsv.AbsolutePosition.Y,0,hsv.AbsoluteSize.Y)
			local res = (1/hsv.AbsoluteSize.Y)*pos
			colorpicker.h = res
			hsvcursor.BackgroundColor3 = Color3.fromHSV(res,1,1)
			picker.BackgroundColor3 = Color3.fromHSV(res,1,1)
			pickercursor.BackgroundColor3 = Color3.fromHSV(colorpicker.h,colorpicker.s,colorpicker.v)
			hsvcursor:TweenPosition(UDim2.new(0,0,res,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.15,true)
			callback(res)
		end
	end)
	--
	uis.InputEnded:Connect(function(Input)
		if Input.UserInputType.Name == 'MouseButton1' then
			if colorpicker.cp then
				colorpicker.holding = false
				colorpicker.cp = false
			end
			if colorpicker.hue then
				colorpicker.holding = false
				colorpicker.hue = false
			end
		end
	end)
	--
	button.MouseEnter:Connect(function()
		ts:Create(frame, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = self.window.color}):Play()
		ts:Create(cpholder, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = self.window.color}):Play()
	end)
	--
	button.MouseLeave:Connect(function()
		if colorpicker.holding == false then
			ts:Create(frame, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = Color3.fromRGB(4,4,4)}):Play()
			ts:Create(cpholder, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BorderColor3 = Color3.fromRGB(4,4,4)}):Play()
		end
	end)
	-- // metatable indexing + return
	setmetatable(colorpicker, colorpickers)
	return colorpicker
end
--
function toggles:set(bool,callback)
	self.istoggled = bool
	if bool then
		if callback then
			self.callback(bool)
		end
		ts:Create(self.toggled, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BackgroundColor3 = self.window.color}):Play()
	else
		if callback then
			self.callback(bool)
		end
		ts:Create(self.toggled, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(19,19,19)}):Play()
	end
end
--
function sliders:set(val,callback)
	local val = math.clamp(val,self.min,self.max)
	if callback then
		self.callback(val)
	end
	local valueval = val
	if self.rounded then
		valueval = math.floor(valueval)
	end
	self.value.Text = valueval..self.measurement.."/"..self.max..self.measurement
	self.fill:TweenSize(UDim2.new((1/self.slider.AbsoluteSize.X)*(self.slider.AbsoluteSize.X/(self.max-self.min)*(val-self.min)),0,1,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.25,true)
end
--
function labels:set(val)
	self.title.Text = val
	self.line1.Size = UDim2.new(0.5,-((self.title.TextBounds.X/2)+10),0,1)
	self.line2.Size = self.line1.Size
end
--
function dropdowns:set(options,default,callback)
	local options = options or {}
	local current = "..."
	--
	if default ~= nil and tonumber(default) > 0 then
		if options[default] then
			current = options[default]
		end
	end
	--
	if self.optionsopen then
		for i,v in pairs(self.openoptions) do
			v.holder:Remove()
		end
		self.holder.Size = UDim2.new(1,-20,0,20)
		self.openoptions = {}
		self.optionsopen = false
	end
	--
	self.default = current
	self.options = options
	self.current = current
	self.title.Text = self.name.." ( "..self.current.." )"
	if callback then
		if current ~= "..." then
			self.callback(current)
		end
	end
end
--
function multidropdowns:set(options,default,callback)
	local options = options or {}
	local default = default or {}
	--
	local current = {}
	for i,v in pairs(default) do
		if v ~= nil and tonumber(v) > 0 then
			if options[v] then
				table.insert(current,options[v])
			end
		end
	end
	--
	if self.optionsopen then
		for i,v in pairs(self.openoptions) do
			v.holder:Remove()
		end
		self.holder.Size = UDim2.new(1,-20,0,20)
		self.openoptions = {}
		self.optionsopen = false
	end
	--
	self.default = current
	self.options = options
	self.current = current
	--
	local titlestring = ""
	--
	for i,v in pairs(self.current) do
		if i == #self.current then
			if self.cutoff then
				if #v > self.letters then
					titlestring = titlestring..string.sub(v,1,self.letters)..".."
				else
					titlestring = titlestring..v
				end
			else
				titlestring = titlestring..v
			end
		else
			if self.cutoff then
				if #v > self.letters then
					titlestring = titlestring..string.sub(v,1,self.letters)..".."..", "
				else
					titlestring = titlestring..v..", "
				end
			else
				titlestring = titlestring..v..", "
			end
		end
	end
	--
	if titlestring == "" then
		titlestring = "..."
	end
	--
	self.title.Text = self.name.." ( "..titlestring.." )"
	if callback then
		if self.current ~= {} then
			self.callback(self.current)
		end
	end
end
--
function keybinds:set(keybind,callbackchange,callback)
	local keybind = keybind or nil
	local callback = callback or false
	local callbackchange = callbackchange or false
	if keybind ~= nil and typeof(keybind) == "EnumItem" then
		self.current = keybind
		local val = "..."
		if keybind == Enum.UserInputType.MouseButton1 then
			val = "MB1"
		elseif keybind == Enum.UserInputType.MouseButton2 then
			val = "MB2"
		elseif keybind == Enum.UserInputType.MouseButton3 then
			val = "MB3"
		else
			val = keybind.Name
		end
		--
		self.value.Text = val or "..."
		--
		self.frame.Size = UDim2.new(0,self.value.TextBounds.X+20,0,15)
		--
		if callback then
			self.callback()
		end
	end
	if callbackchange then
		if callbackchange ~= nil then
			self.callback = callbackchange
			if callback then
				self.callback()
			end
		end
	end
end
--
function textboxs:set(value,callback)
	local value = value or nil
	local callback = callback or false
	if value then
		self.value = value
		self.box.Text = value
		--
		local done = false
		--
		local repeating = function()
			if self.box.TextBounds.X > (self.box.AbsoluteSize.X-8) then
				if self.box.TextSize == 1 then
					done = true
				else
					self.box.TextSize = self.box.TextSize-1
				end
			else
				done = true
			end
		end
		--
		repeat repeating() until done
		--
		if callback then
			self.callback(self.value)
		end
	end
end
--
function colorpickers:set(color,callback)
	local value = color or Color3.fromRGB(255,255,255)
	local callback = callback or false
	if value then
		local h,s,v = value:ToHSV()
		self.h = h
		self.s = s
		self.v = v
		--
		self.pickercursor.Position = UDim2.new(s,0,1-v,0)
		self.pickercursor.BackgroundColor3 = value
	    self.hsvcursor.Position = UDim2.new(0,0,h,0)
	    self.hsvcursor.BackgroundColor3 = Color3.fromHSV(h,1,1)
	    --
	    self.color.BackgroundColor3 = value
	    self.picker.BackgroundColor3 = value
	    --
		if callback then
			self.callback(Color3.fromHSV(self.h,self.s,self.v))
		end
	end
end
-- // init
local lol = library:new({Name = "123"})
local lol2 = lol:page({Name = "123"})
local lol3 = lol2:section({Name = "123"})
lol3:toggle({Name = "123"})
