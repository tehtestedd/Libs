-- // tables
local library = {}
local pages = {}
local sections = {}
local clickables = {}
--
local utility = {}
local colors = {
	["mainframe"] = Color3.fromRGB(25, 25, 25),
	["topbar"] = Color3.fromRGB(25, 25, 25),
	["maincol"] = Color3.fromRGB(35, 35, 35),
	["accent"] = Color3.fromHSV(0,0.75,1)
}
-- // variables
local ws = game:GetService("Workspace")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")
local plrs = game:GetService("Players")
local cam = ws.CurrentCamera
local plr = plrs.LocalPlayer
-- // util functions
utility.Position = function(xs,xo,ys,yo,ins,anchor)
	local vx,vy = cam.ViewportSize.x,cam.ViewportSize.y
	if ins then
		local x = ins.Position.x+xs*ins.Size.x+xo
		local y = ins.Position.y+ys*ins.Size.y+yo
		if anchor then
			x = x-(anchor[1].Size.X*anchor[2])
			y = y-(anchor[1].Size.Y*anchor[3])
		end
		return Vector2.new(x,y)
	else
		local x = xs*vx+xo
		local y = ys*vy+yo
		if anchor then
			x = x-(anchor[1].Size.X*anchor[2])
			y = y-(anchor[1].Size.Y*anchor[3])
		end
		return Vector2.new(x,y)
	end
end
--
utility.Size = function(xs,xo,ys,yo,ins)
	local vx,vy = cam.ViewportSize.x,cam.ViewportSize.y
	if ins then
		local x = xs*ins.Size.x+xo
		local y = ys*ins.Size.y+yo
		return Vector2.new(x,y)
	else
		local x = xs*vx+xo
		local y = ys*vy+yo
		return Vector2.new(x,y)
	end
end
--
utility.New = function(ins,props)
	local props = props or {}
	local instance = nil
	if ins == "Frame" or ins == "frame" then
		local frame = Drawing.new("Square")
		frame.Visible = props.Visible or true
		frame.Filled = props.Filled or true
		frame.Thickness = props.Thickness or 0
		frame.Color = props.Color or Color3.fromRGB(255,255,255)
		frame.Size = props.Size or Vector2.new(100,100)
		frame.Position = props.Position or Vector2.new(0,0)
		for i,v in pairs(props) do
			frame[i] = v
		end
		instance = frame
	elseif ins == "TextLabel" or ins == "Text" or ins == "textlabel" or ins == "text" or ins == "textLabel" then
		local text = Drawing.new("Text")
		text.Font = 3
		text.Visible = true
		text.Outline = true
		text.Center = false
		text.Color = Color3.fromRGB(255,255,255)
		for i,v in pairs(props) do
			text[i] = v
		end
		instance = text
	end
	return instance
end
--
utility.MouseLocation = function()
	return uis:GetMouseLocation()
end
--
utility.MouseOver = function(vals)
	local X1, Y1, X2, Y2 = vals[1], vals[2], vals[3], vals[4]
	local ml = utility.MouseLocation()
	return (ml.x >= X1 and ml.x <= (X1 + (X2 - X1))) and (ml.y >= Y1 and ml.y <= (Y1 + (Y2 - Y1)))
end
--
utility.Round = function(num, dec)
	return math.round(num * 10 ^ dec) / (10 ^ dec)
end
--
utility.Cursor = {}
--
utility.Cursor.Update = function()
	if utility.Cursor["one"] then
		utility.Cursor["one"]:Remove()
	end
	if utility.Cursor["two"] then
		utility.Cursor["two"]:Remove()
	end
	local one = utility.New("Frame",{
		Size = utility.Size(0,13,0,1),
		Visible = true,
		Color = Color3.fromRGB(255,255,255)
	})
	--
	local two = utility.New("Frame",{
		Size = utility.Size(0,1,0,13),
		Visible = true,
		Color = Color3.fromRGB(255,255,255)
	})
	--
	utility.Cursor["one"] = one;utility.Cursor["two"] = two
end
-- // indexes
library.__index = library
pages.__index = pages
sections.__index = sections
-- // functions
function library:newwindow(props)
	-- // vars	
	local colors = props.Colors or props.colors or colors
	local size = props.size or props.Size or Vector2.new(300,400)
	local name = props.name or props.Name or props.title or props.Title or "new ui"
	-- // main
	local outline = utility.New("Frame",{	
		Size = utility.Size(0,size.X+2,0,size.Y+2),
		Color = colors.accent or colors.Accent,
		Filled = false,
		Thickness = 1
	})
	--
	local outline2 = utility.New("Frame",{	
		Size = utility.Size(0,size.X+2,0,size.Y+2),
		Color = colors.accent or colors.Accent,
		Filled = false,
		Thickness = 1
	})
	--
	local mainframe = utility.New("Frame",{
		Size = utility.Size(0,size.X,0,size.Y),
		Color = colors.mainframe or colors.MainFrame or colors.mainFrame
	})
	mainframe.Position = utility.Position(0.5,0,0.5,0,nil,{mainframe,0.5,0.5})
	outline.Position = utility.Position(0,-1,0,-2,mainframe)
	outline2.Position = utility.Position(0,0,0,0,outline)
	--
	local topbar = utility.New("Frame",{
		Size = utility.Size(1,0,0,20,mainframe),
		Color = colors.topbar or colors.TopBar or colors.topBar
	})
	topbar.Position = utility.Position(0,0,0,-1,mainframe)
	--
	local title = utility.New("TextLabel",{
		Size = 16,
		Center = false,
		Text = tostring(name),
		Font = 1,
		Outline = true,
		OutlineColor = Color3.fromRGB(15, 15, 15)
	})
	title.Position = utility.Position(0,5,0.5,-(title.TextBounds.Y/2),topbar)
	--
	local tabbar = utility.New("Frame",{
		Size = utility.Size(1,0,0,20,mainframe),
		Color = colors.maincol or colors.Maincol or colors.mainCol or colors.MainCol or colors.maincolor or colors.Maincolor or colors.mainColor or colors.MainColor
	})
	tabbar.Position = utility.Position(0,0,0,20,mainframe)
	--
	local window = {
		mainframe = mainframe,
		outline = outline,
		topbar = topbar,
		title = title,
		tabbar = tabbar,
		tabbuttonsoffset = 0,
		tabs = {}
	}
	setmetatable(window, library)
	--
	return window
end
--
function library:newpage(props)
	-- // vars
	local colors = props.Colors or props.colors or colors
	local name = props.name or props.Name or props.title or props.Title or "new page"
	-- // main
	--
	local tabbutton = utility.New("Frame",{
		Size = utility.Size(0,0,1,0,self.tabbar),
		Transparency = 0
	})
	tabbutton.Position = utility.Position(0,self.tabbuttonsoffset,0,0,self.tabbar)
	--
	local tabbuttonlabel = utility.New("TextLabel",{
		Size = 16,
		Center = true,
		Text = tostring(name),
		Font = 1,
		Outline = true,
		OutlineColor = Color3.fromRGB(15, 15, 15)
	})
	tabbutton.Size = utility.Size(0,tabbuttonlabel.TextBounds.X+20,1,0,self.tabbar)
	tabbuttonlabel.Position = utility.Position(0.5,0,0.5,-(tabbuttonlabel.TextBounds.Y/2),tabbutton)
	--
	local tabbuttonblackbar = utility.New("Frame",{
		Size = utility.Size(0,1,1,0,tabbutton),
		Color = colors.topbar or colors.TopBar or colors.topBar
	})
	tabbuttonblackbar.Position = utility.Position(1,0,0,0,tabbutton)
	--
	local sectionholder = utility.New("Frame",{
		Size = utility.Size(1,-20,1,-60,self.mainframe),
		Transparency = 0
	})
	sectionholder.Position = utility.Position(0.5,-(sectionholder.Size.X/2),0,50,self.mainframe)
	--
	local page = {
		window = self,
		tabbutton = tabbutton,
		tabbuttonlabel = tabbuttonlabel,
		tabbuttonblackbar = tabbuttonblackbar,
		sectionholder = sectionholder,
		sectionaxis = {
			left = 0,
			right = 0
		},
		open = false,
		sections = {}
	}
	--
	local clickfunc = function()
		for i,v in pairs(self.tabs) do
			if v.tabbutton ~= tabbutton then
				v.open = false
				for i,v in pairs(v.sections) do
					v.section.Visible = false
					for i,v in pairs(v.content) do
						if v.istype == "button" then
							v.button.Visible = false
							v.buttonllabel.Visible = false
						elseif v.istype == "toggle" then
							v.toggle.Visible = false
							v.label.Visible = false
							v.togglecolor.Visible = false
						elseif v.istype == "label" then
							v.label.Visible = false
							v.line1.Visible = false
							v.line2.Visible = false
						elseif v.istype == "slider" then
							v.slider.Visible = false
							v.slidercolor.Visible = false
							v.label.Visible = false
						elseif v.istype == "dropdown" then
							v.button.Visible = false
							v.label.Visible = false
							v.line.Visible = false
							for z,x in pairs(v.options) do
								x.frame:Remove()
								x.label:Remove()
								x.line:Remove()
							end
							v.options = {}
							v.optionsopen = false
							v.optionsyaxis = 16
						end
					end
				end
			end
		end
		if page.open == false then
			page.open = true
			for i,v in pairs(page.sections) do
				v.section.Visible = true
				for i,v in pairs(v.content) do
					if v.istype == "button" then
						v.button.Visible = true
						v.buttonllabel.Visible = true
					elseif v.istype == "toggle" then
						v.toggle.Visible = true
						v.label.Visible = true
						v.togglecolor.Visible = v.toggled
					elseif v.istype == "label" then
						v.label.Visible = true
						v.line1.Visible = true
						v.line2.Visible = true
					elseif v.istype == "slider" then
						v.slider.Visible = true
						v.slidercolor.Visible = true
						v.label.Visible = true
					elseif v.istype == "dropdown" then
						v.button.Visible = true
						v.label.Visible = true
						v.line.Visible = true
					end
				end
			end
		end
	end
	--
	table.insert(clickables,{instance = tabbutton,callback = clickfunc})
	table.insert(self.tabs,page)
	--
	self.tabbuttonsoffset = self.tabbuttonsoffset+tabbutton.Size.X+1
	setmetatable(page, pages)
	--
	return page
end
--
function pages:togglepage()
	for i,v in pairs(self.window.tabs) do
		if v.tabbutton ~= self.tabbutton then
			v.open = false
			for i,v in pairs(v.sections) do
				v.section.Visible = false
				for i,v in pairs(v.content) do
					if v.istype == "button" then
						v.button.Visible = false
						v.buttonllabel.Visible = false
					elseif v.istype == "toggle" then
						v.toggle.Visible = false
						v.label.Visible = false
						v.togglecolor.Visible = false
					elseif v.istype == "label" then
						v.label.Visible = false
						v.line1.Visible = false
						v.line2.Visible = false
					elseif v.istype == "slider" then
						v.slider.Visible = false
						v.slidercolor.Visible = false
						v.label.Visible = false
					elseif v.istype == "dropdown" then
						v.button.Visible = false
						v.label.Visible = false
						v.line.Visible = false
						for z,x in pairs(v.options) do
							x.frame:Remove()
							x.label:Remove()
							x.line:Remove()
						end
						v.options = {}
						v.optionsopen = false
						v.optionsyaxis = 16
					end
				end
			end
		end
	end
	self.open = true
	for i,v in pairs(self.sections) do
		v.section.Visible = true
		for i,v in pairs(v.content) do
			if v.istype == "button" then
				v.button.Visible = true
				v.buttonllabel.Visible = true
			elseif v.istype == "toggle" then
				v.toggle.Visible = true
				v.label.Visible = true
				v.togglecolor.Visible = v.toggled
			elseif v.istype == "label" then
				v.label.Visible = true
				v.line1.Visible = true
				v.line2.Visible = true
			elseif v.istype == "slider" then
				v.slider.Visible = true
				v.slidercolor.Visible = true
				v.label.Visible = true
			elseif v.istype == "dropdown" then
				v.button.Visible = true
				v.label.Visible = true
				v.line.Visible = true
			end
		end
	end
end
--
function pages:newsection(props)
	local colors = props.Colors or props.colors or colors
	local name = props.name or props.Name or props.title or props.Title or "new button"
	local side = props.side or props.Side or "Left"
	local size = props.size or props.Size or 50
	local yaxis = props.y or props.Y or props.yaxis or props.YAxis or props.yAxis or props.Yaxis or 5
	side = side:lower()
	--
	local xpos = 0
	local xadd = 0
	local ypos = self.sectionaxis[side]
	if side == "right" then
		xpos = 0.5
		xadd = 5
	end
	-- // main
	local frame = utility.New("Frame",{
		Size = utility.Size(0.5,-5,0,size,self.sectionholder),
		Visible = self.open,
		Color = colors.maincol or colors.Maincol or colors.mainCol or colors.MainCol or colors.maincolor or colors.Maincolor or colors.mainColor or colors.MainColor
	})
	--
	frame.Position = utility.Position(xpos,xadd,0,ypos,self.sectionholder)
	--
	local section = {
		page = self,
		side = side,
		section = frame,
		currentyaxis = yaxis,
		content = {},
		dropdown = false
	}
	--
	self.sectionaxis[side] = self.sectionaxis[side]+size+10
	--
	setmetatable(section, sections)
	table.insert(self.sections,section)
	--
	return section
end
--
function sections:newbutton(props)
	local colors = props.Colors or props.colors or colors
	local name = props.name or props.Name or props.title or props.Title or "new button"
	local callback = props.callback or props.CallBack or props.callBack or props.Callback or function() end
	-- // main
	local frame = utility.New("Frame",{
		Size = utility.Size(1,-10,0,15,self.section),
		Visible = self.page.open,
		Color = colors.mainframe
	})
	--
	frame.Position = utility.Position(0,5,0,self.currentyaxis,self.section)
	--
	local buttonllabel = utility.New("TextLabel",{
		Size = 16,
		Center = true,
		Text = name,
		Font = 1,
		Outline = true,
		OutlineColor = Color3.fromRGB(15, 15, 15),
		Visible = self.page.open
	})
	buttonllabel.Position = utility.Position(0.5,0,0.5,-(buttonllabel.TextBounds.Y/2),frame)
	--
	local button = {
		istype = "button",
		button = frame,
		buttonllabel = buttonllabel
	}
	--
	table.insert(clickables,{instance = frame,callback = callback})
	self.currentyaxis = self.currentyaxis+15+5
	table.insert(self.content,button)
end
--
function sections:newtoggle(props)
	local colors = props.Colors or props.colors or colors
	local name = props.name or props.Name or props.title or props.Title or "new button"
	local current = props.current or props.Current or props.bool or props.Bool or props.toggled or props.Toggled or false
	local callback = props.callback or props.CallBack or props.callBack or props.Callback or function() end
	-- // main
	local frame = utility.New("Frame",{
		Size = utility.Size(0,15,0,15,self.section),
		Visible = self.page.open,
		Color = colors.mainframe
	})
	--
	frame.Position = utility.Position(1,-20,0,self.currentyaxis,self.section)
	--
	local framecolor = utility.New("Frame",{
		Size = utility.Size(0,13,0,13,self.section),
		Visible = self.page.open and current,
		Color = colors.accent
	})
	--
	framecolor.Position = utility.Position(0,1,0,1,frame)
	--
	local label = utility.New("TextLabel",{
		Size = 16,
		Center = false,
		Text = name,
		Font = 1,
		Outline = true,
		OutlineColor = Color3.fromRGB(15, 15, 15),
		Visible = self.page.open
	})
	label.Position = utility.Position(0,5,0,self.currentyaxis,self.section)
	--
	local toggle = {
		istype = "toggle",
		toggled = current,
		toggle = frame,
		togglecolor = framecolor,
		label = label
	}
	--
	local clickfunc = function()
		if toggle.toggled then
			toggle.toggled = false
			framecolor.Visible = false
		else
			toggle.toggled = true
			framecolor.Visible = true
		end
		callback(toggle.toggled)
	end
	--
	table.insert(clickables,{instance = frame,callback = clickfunc})
	self.currentyaxis = self.currentyaxis+15+5
	table.insert(self.content,toggle)
end
--
function sections:newlabel(props)
	local colors = props.Colors or props.colors or colors
	local name = props.name or props.Name or props.title or props.Title or "new button"
	-- // main
	local label = utility.New("TextLabel",{
		Size = 16,
		Center = true,
		Text = name,
		Font = 1,
		Outline = true,
		OutlineColor = Color3.fromRGB(15, 15, 15),
		Visible = self.page.open
	})
	label.Position = utility.Position(0.5,0,0,self.currentyaxis,self.section)
	--
	local line = utility.New("Frame",{
		Visible = self.page.open,
		Color = colors.mainframe
	})
	--
	local line2 = utility.New("Frame",{
		Visible = self.page.open,
		Color = colors.mainframe
	})
	--
	local calc = (self.section.Size.X/2)-(label.TextBounds.X/2)-10
	line.Position = utility.Position(0,5,0,self.currentyaxis+7,self.section)
	line2.Position = utility.Position(1,-(5+calc),0,self.currentyaxis+7,self.section)
	line.Size = utility.Size(0,calc,0,1,self.section)
	line2.Size = utility.Size(0,calc,0,1,self.section)
	--
	local label = {
		istype = "label",
		label = label,
		line1 = line,
		line2 = line2
	}
	--
	self.currentyaxis = self.currentyaxis+15+5
	table.insert(self.content,label)
end
--
function sections:newslider(props)
	local colors = props.Colors or props.colors or colors
	local name = props.name or props.Name or props.title or props.Title or "new button"
	local def = props.default or props.Default or props.def or props.Def or 0
	local max = props.max or props.Max or props.maximum or props.Maximum or 100
	local min = props.min or props.Min or props.minimum or props.Minimum or 0
	local decimals = props.decimals or props.Decimals or props.dec or props.Dec or false
	local units = props.units or props.Units or props.unit or props.Unit or props.prefix or props.Prefix or ""
	local callback = props.callback or props.CallBack or props.callBack or props.Callback or function() end
	-- // main
	local frame = utility.New("Frame",{
		Size = utility.Size(1,-10,0,15,self.section),
		Visible = self.page.open,
		Color = colors.mainframe
	})
	--
	frame.Position = utility.Position(0,5,0,self.currentyaxis,self.section)
	--
	local framecolor = utility.New("Frame",{
		Size = utility.Size(0,(frame.Size.X/(max-min))*(def-min),1,0,frame),
		Position = utility.Position(0,0,0,0,frame),
		Visible = self.page.open,
		Color = colors.accent
	})
	--
	local label = utility.New("TextLabel",{
		Size = 16,
		Center = true,
		Text = name.." : "..def..units,
		Font = 1,
		Outline = true,
		OutlineColor = Color3.fromRGB(15, 15, 15),
		Visible = self.page.open
	})
	label.Position = utility.Position(0.5,0,0.5,-(label.TextBounds.Y/2),frame)
	--
	local slider = {
		istype = "slider",
		slider = frame,
		slidercolor = framecolor,
		label = label,
		sliding = false,
		current = def
	}
	--
	local changeval = function(val)
		slider.current = val
		if decimals then
			val = utility.Round(val,2)
		else
			val = tostring(math.floor(val))
		end
		label.Text = name.." : "..val..units
		callback(val)
	end
	--
	local callfunc = function()
		slider.sliding = true
		local msX = math.clamp(utility.MouseLocation().X-frame.Position.X,0,frame.Size.X)
		local res = ((max-min)/frame.Size.x) * msX + min
		framecolor.Size = utility.Size(0,msX,1,0,frame)

		changeval(res)
	end
	--
	local holdfunc = function()
		slider.sliding = false
	end
	--
	uis.InputChanged:Connect(function()
		if slider.sliding then
			local msX = math.clamp(utility.MouseLocation().X-frame.Position.X,0,frame.Size.X)
			local res = ((max-min)/frame.Size.x) * msX + min
			framecolor.Size = utility.Size(0,msX,1,0,frame)
			changeval(res)
		end
	end)
	--
	table.insert(clickables,{instance = frame,callback = callfunc,holding = true,holdval = false,holdingcallback = holdfunc})
	--
	self.currentyaxis = self.currentyaxis+15+5
	table.insert(self.content,slider)
end
--
function sections:newdropdown(props)
	local colors = props.Colors or props.colors or colors
	local name = props.name or props.Name or props.title or props.Title or "new button"
	local options = props.options
	local callback = props.callback or props.CallBack or props.callBack or props.Callback or function() end
	-- // main
	if options then
		local frame = utility.New("Frame",{
			Size = utility.Size(1,-10,0,15,self.section),
			Visible = self.page.open,
			Color = colors.mainframe
		})
		--
		frame.Position = utility.Position(0,5,0,self.currentyaxis,self.section)
		--
		local label = utility.New("TextLabel",{
			Size = 16,
			Center = true,
			Text = name,
			Font = 1,
			Outline = true,
			OutlineColor = Color3.fromRGB(15, 15, 15),
			Visible = self.page.open
		})
		label.Position = utility.Position(0.5,0,0.5,-(label.TextBounds.Y/2),frame)
		--
		local line = utility.New("TextLabel",{
			Size = 16,
			Center = false,
			Text = "-",
			Font = 1,
			Outline = true,
			OutlineColor = Color3.fromRGB(15, 15, 15),
			Visible = self.page.open
		})
		line.Position = utility.Position(1,-(line.TextBounds.X+5),0.5,-(line.TextBounds.Y/2),frame)
		--
		local spacing = utility.New("Frame",{
			Size = utility.Size(1,0,0,1,frame),
			Position = utility.Position(0,0,1,0,frame),
			Visible = false,
			Color = colors.maincol
		})
		--
		local dropdown = {
			istype = "dropdown",
			button = frame,
			label = label,
			line = line,
			spacing = spacing,
			options = {},
			optionsopen = false,
			optionsyaxis = 16
		}
		--
		local makeoption = function(optionname)
			local optionn = utility.New("Frame",{
				Size = utility.Size(1,0,1,0,frame),
				Visible = false,
				Color = colors.mainframe
			})
			--
			optionn.Position = utility.Position(0,0,0,dropdown.optionsyaxis,frame)
			--
			local line = utility.New("Frame",{
				Size = utility.Size(1,0,0,1,optionn),
				Position = utility.Position(0,0,1,0,optionn),
				Visible = false,
				Color = colors.maincol
			})
			--
			local label = utility.New("TextLabel",{
				Size = 16,
				Center = true,
				Text = optionname,
				Font = 1,
				Outline = true,
				OutlineColor = Color3.fromRGB(15, 15, 15),
				Visible = false
			})
			label.Position = utility.Position(0.5,0,0.5,-(label.TextBounds.Y/2),optionn)
			--
			local option = {
				frame = optionn,
				label = label,
				line = line
			}
			--
			local con = uis.InputBegan:Connect(function(input)
				if input.UserInputType.Name == 'MouseButton1' then
					local add = 0
					local vals = {
						optionn.Position.X-add,
						optionn.Position.Y-add,
						optionn.Position.X + optionn.Size.X+add,
						optionn.Position.Y + optionn.Size.Y+add
					}
					if utility.MouseOver(vals) then	
						for i,v in pairs(dropdown.options) do
							v.frame:Remove()
							v.label:Remove()
							v.line:Remove()
							v.connection:Disconnect()
						end
						dropdown.options = {}
						dropdown.optionsopen = false
						dropdown.optionsyaxis = 16
						callback(optionname)
					end
				end
			end)
			--
			option["connection"] = con
			--
			table.insert(dropdown.options,option)
			--
			dropdown.optionsyaxis = dropdown.optionsyaxis+16
		end
		--
		local toggleoptions = function()
			if dropdown.optionsopen then
				for i,v in pairs(dropdown.options) do
					v.frame:Remove()
					v.label:Remove()
					v.line:Remove()
					v.connection:Disconnect()
				end
				dropdown.options = {}
				dropdown.optionsopen = false
				dropdown.optionsyaxis = 16
			else
				dropdown.options = {}
				dropdown.optionsopen = false
				dropdown.optionsyaxis = 16
				for i,v in pairs(options) do
					makeoption(v)
				end
				dropdown.optionsopen = true
				for i,v in pairs(dropdown.options) do
					v.frame.Visible = true
					v.label.Visible = true
					v.line.Visible = true
				end
				utility.Cursor.Update()
			end
		end
		--
		table.insert(clickables,{instance = frame,callback = toggleoptions})
		--
		self.currentyaxis = self.currentyaxis+15+5
		table.insert(self.content,dropdown)
	end
end
--
function library:innit()
	local one = utility.New("Frame",{
		Size = utility.Size(0,13,0,1),
		Visible = true,
		Color = Color3.fromRGB(255,255,255)
	})
	--
	local two = utility.New("Frame",{
		Size = utility.Size(0,1,0,13),
		Visible = true,
		Color = Color3.fromRGB(255,255,255)
	})
	--
	utility.Cursor["one"] = one;utility.Cursor["two"] = two
	--
	rs.RenderStepped:Connect(function()
		pcall(function()
			local mp = utility:MouseLocation()
			--
			utility.Cursor["one"].Position = utility.Position(0,mp.X,0,mp.Y,nil,{utility.Cursor["one"],0.5,0.5})
			utility.Cursor["two"].Position = utility.Position(0.5,0,0.5,0,utility.Cursor["one"],{utility.Cursor["two"],0.5,0.5})
		end)
	end)
end
--
uis.InputBegan:Connect(function(input)
	if input.UserInputType.Name == 'MouseButton1' then
		for i,v in pairs(clickables) do
			if v.instance.Visible then
				local add =  v.add or v.Add or v.addon or v.AddOn or v.addOn or 0
				local instance = v.instance or v.Instance
				local callback = v.callback or v.CallBack or v.callBack or function()end
				local vals = {
					instance.Position.X-add,
					instance.Position.Y-add,
					instance.Position.X + instance.Size.X+add,
					instance.Position.Y + instance.Size.Y+add
				}
				if utility.MouseOver(vals) then	
					callback()
					if v.holding then
						v.holdval = true
					end
				end
			end
		end
	end
end)
--
uis.InputEnded:Connect(function(input)
	if input.UserInputType.Name == 'MouseButton1' then
		for i,v in pairs(clickables) do
			if v.holding and v.holdval == true then
				v.holdval = false
				local holdingcallback = v.holdingcallback or v.holdingCallback or v.holdingCallBack or v.HoldingCallback or v.HoldingCallBack
				holdingcallback()
			end
		end
	end
end)
-- // main
local thing = library:newwindow({name = "coolhub27",size = Vector2.new(300,400)})
--
local page = thing:newpage({name = "roblox"})
local lol = thing:newpage({name = "dumb fuck"})
--
local section = lol:newsection({name = "hi",size = 100})
local section2 = lol:newsection({name = "safsaf",side = "right",size = 200,yaxis = 0})
--
section2:newlabel({name = "new section??"})
section:newlabel({name = "hey"})
section2:newbutton({name = "123",callback = function()print("clicked")end})
section2:newbutton({name = "hi"})
section2:newtoggle({name = "new toggle!",callback = function(bool)print(bool)end})
section2:newtoggle({name = "idk",callback = function(bool)print(bool)end,current = true})
section2:newbutton({name = "hi"})
section2:newslider({name = "hi",callback = function(val)print(val)end,def = 30,unit = "ft"})
section2:newslider({name = "egew",callback = function(val)print(val)end,def = 60,max = 200,min = 30})
section2:newslider({name = "slider",callback = function(val)print(val)end,decimals = true,units = "%"})
section2:newdropdown({name = "dropdown",callback = function(val)print(val)end,options = {"hello","fuck","12","123E4J2DJ3WQF"}})
section:newdropdown({name = "z\cxc",callback = function(val)print(val)end,options = {"hello","fuck","12","123E4J2DJ3WQF"}})
thing:innit()
wait(0.5)
lol:togglepage()
