--[[
    Roblox UI Library
    Features:
    - Draggable UI with title bar
    - Left-side tabs
    - Right-side content sections
    - Buttons, sliders, toggles, dropdowns
    - Scrolling frames for all content
    - Mobile and PC compatible
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- Main UI Container
local library = {}
library.theme = {
    BackgroundColor = Color3.fromRGB(30, 30, 40),
    TabColor = Color3.fromRGB(40, 40, 50),
    ActiveTabColor = Color3.fromRGB(60, 60, 80),
    SectionColor = Color3.fromRGB(40, 40, 50),
    ButtonColor = Color3.fromRGB(60, 60, 80),
    ButtonHoverColor = Color3.fromRGB(80, 80, 100),
    TextColor = Color3.fromRGB(220, 220, 220),
    AccentColor = Color3.fromRGB(100, 150, 255),
    SliderColor = Color3.fromRGB(100, 150, 255),
    ToggleOnColor = Color3.fromRGB(100, 255, 150),
    ToggleOffColor = Color3.fromRGB(255, 100, 100),
}

function library:CreateWindow(title)
    local window = {}
    local dragging = false
    local dragStartPos = Vector2.new(0, 0)
    local startPos = Vector2.new(0, 0)
    
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LibraryUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.Parent = gui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.BackgroundColor3 = self.theme.BackgroundColor
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.Size = UDim2.new(0, 400, 0, 350)
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    -- Corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Drop shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.ZIndex = -1
    shadow.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundColor3 = self.theme.BackgroundColor
    titleBar.BorderSizePixel = 0
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.Parent = mainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.Text = title or "UI Library"
    titleLabel.TextColor3 = self.theme.TextColor
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- Bottom labels
    local leftBottomLabel = Instance.new("TextLabel")
    leftBottomLabel.Name = "LeftBottomLabel"
    leftBottomLabel.BackgroundTransparency = 1
    leftBottomLabel.Position = UDim2.new(0, 10, 1, -20)
    leftBottomLabel.Size = UDim2.new(0, 150, 0, 20)
    leftBottomLabel.Font = Enum.Font.Gotham
    leftBottomLabel.Text = "Left Label"
    leftBottomLabel.TextColor3 = self.theme.TextColor
    leftBottomLabel.TextSize = 12
    leftBottomLabel.TextXAlignment = Enum.TextXAlignment.Left
    leftBottomLabel.Parent = mainFrame
    
    local rightBottomLabel = Instance.new("TextLabel")
    rightBottomLabel.Name = "RightBottomLabel"
    rightBottomLabel.BackgroundTransparency = 1
    rightBottomLabel.Position = UDim2.new(1, -160, 1, -20)
    rightBottomLabel.Size = UDim2.new(0, 150, 0, 20)
    rightBottomLabel.Font = Enum.Font.Gotham
    rightBottomLabel.Text = "Right Label"
    rightBottomLabel.TextColor3 = self.theme.TextColor
    rightBottomLabel.TextSize = 12
    rightBottomLabel.TextXAlignment = Enum.TextXAlignment.Right
    rightBottomLabel.Parent = mainFrame
    
    -- Dragging functionality
    local function updateInput(input)
        if dragging then
            local delta = input.Position - dragStartPos
            mainFrame.Position = UDim2.new(
                0, startPos.X + delta.X,
                0, startPos.Y + delta.Y
            )
        end
    end
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStartPos = input.Position
            startPos = Vector2.new(mainFrame.AbsolutePosition.X, mainFrame.AbsolutePosition.Y)
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            updateInput(input)
        end
    end)
    
    -- Tab System
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = "TabFrame"
    tabFrame.BackgroundColor3 = self.theme.TabColor
    tabFrame.BorderSizePixel = 0
    tabFrame.Position = UDim2.new(0, 0, 0, 30)
    tabFrame.Size = UDim2.new(0, 100, 1, -50)
    tabFrame.Parent = mainFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabFrame
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Name = "TabListLayout"
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Parent = tabFrame
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.Name = "TabPadding"
    tabPadding.PaddingTop = UDim.new(0, 5)
    tabPadding.PaddingLeft = UDim.new(0, 5)
    tabPadding.PaddingRight = UDim.new(0, 5)
    tabPadding.Parent = tabFrame
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.BackgroundTransparency = 1
    contentFrame.Position = UDim2.new(0, 105, 0, 30)
    contentFrame.Size = UDim2.new(1, -110, 1, -50)
    contentFrame.Parent = mainFrame
    
    local contentScrolling = Instance.new("ScrollingFrame")
    contentScrolling.Name = "ContentScrolling"
    contentScrolling.BackgroundTransparency = 1
    contentScrolling.Size = UDim2.new(1, 0, 1, 0)
    contentScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentScrolling.ScrollBarThickness = 5
    contentScrolling.ScrollBarImageColor3 = self.theme.AccentColor
    contentScrolling.Parent = contentFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Name = "ContentLayout"
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = contentScrolling
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentScrolling.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Tab functions
    function window:CreateTab(tabName)
        local tab = {}
        local tabButton = Instance.new("TextButton")
        tabButton.Name = "TabButton"
        tabButton.BackgroundColor3 = self.theme.TabColor
        tabButton.Size = UDim2.new(1, -10, 0, 30)
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.Text = tabName or "Tab"
        tabButton.TextColor3 = self.theme.TextColor
        tabButton.TextSize = 14
        tabButton.AutoButtonColor = false
        tabButton.Parent = tabFrame
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 5)
        tabCorner.Parent = tabButton
        
        local sectionContainer = Instance.new("Frame")
        sectionContainer.Name = "SectionContainer"
        sectionContainer.BackgroundTransparency = 1
        sectionContainer.Size = UDim2.new(1, 0, 1, 0)
        sectionContainer.Visible = false
        sectionContainer.Parent = contentScrolling
        
        local sectionLayout = Instance.new("UIListLayout")
        sectionLayout.Name = "SectionLayout"
        sectionLayout.Padding = UDim.new(0, 10)
        sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
        sectionLayout.Parent = sectionContainer
        
        sectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            contentScrolling.CanvasSize = UDim2.new(0, 0, 0, sectionLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Highlight first tab
        if #tabFrame:GetChildren() == 3 then -- Layout + Padding + First tab
            tabButton.BackgroundColor3 = self.theme.ActiveTabColor
            sectionContainer.Visible = true
        end
        
        -- Tab button click event
        tabButton.MouseButton1Click:Connect(function()
            for _, child in ipairs(tabFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = self.theme.TabColor
                end
            end
            
            for _, child in ipairs(contentScrolling:GetChildren()) do
                if child:IsA("Frame") then
                    child.Visible = false
                end
            end
            
            tabButton.BackgroundColor3 = self.theme.ActiveTabColor
            sectionContainer.Visible = true
        end)
        
        -- Section functions
        function tab:CreateSection(sectionName)
            local section = {}
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = "SectionFrame"
            sectionFrame.BackgroundColor3 = self.theme.SectionColor
            sectionFrame.Size = UDim2.new(1, 0, 0, 0)
            sectionFrame.Parent = sectionContainer
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 5)
            sectionCorner.Parent = sectionFrame
            
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Name = "SectionTitle"
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Position = UDim2.new(0, 10, 0, 5)
            sectionTitle.Size = UDim2.new(1, -20, 0, 20)
            sectionTitle.Font = Enum.Font.GothamSemibold
            sectionTitle.Text = sectionName or "Section"
            sectionTitle.TextColor3 = self.theme.TextColor
            sectionTitle.TextSize = 14
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            sectionTitle.Parent = sectionFrame
            
            local sectionContent = Instance.new("Frame")
            sectionContent.Name = "SectionContent"
            sectionContent.BackgroundTransparency = 1
            sectionContent.Position = UDim2.new(0, 10, 0, 30)
            sectionContent.Size = UDim2.new(1, -20, 0, 0)
            sectionContent.Parent = sectionFrame
            
            local contentLayout = Instance.new("UIListLayout")
            contentLayout.Name = "ContentLayout"
            contentLayout.Padding = UDim.new(0, 10)
            contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            contentLayout.Parent = sectionContent
            
            contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                sectionContent.Size = UDim2.new(1, -20, 0, contentLayout.AbsoluteContentSize.Y)
                sectionFrame.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y + 35)
            end)
            
            -- Button
            function section:CreateButton(buttonName, callback)
                local button = Instance.new("TextButton")
                button.Name = "Button"
                button.BackgroundColor3 = self.theme.ButtonColor
                button.Size = UDim2.new(1, 0, 0, 30)
                button.Font = Enum.Font.Gotham
                button.Text = buttonName or "Button"
                button.TextColor3 = self.theme.TextColor
                button.TextSize = 14
                button.AutoButtonColor = false
                button.Parent = sectionContent
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 5)
                buttonCorner.Parent = button
                
                -- Hover effect
                button.MouseEnter:Connect(function()
                    button.BackgroundColor3 = self.theme.ButtonHoverColor
                end)
                
                button.MouseLeave:Connect(function()
                    button.BackgroundColor3 = self.theme.ButtonColor
                end)
                
                -- Click event
                button.MouseButton1Click:Connect(function()
                    if callback then
                        callback()
                    end
                end)
                
                -- Touch support
                local touchCount = 0
                button.TouchTap:Connect(function()
                    touchCount = touchCount + 1
                    if touchCount == 1 then
                        if callback then
                            callback()
                        end
                    end
                    task.delay(0.5, function()
                        touchCount = 0
                    end)
                end)
            end
            
            -- Toggle
            function section:CreateToggle(toggleName, defaultState, callback)
                local toggle = {}
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Name = "ToggleFrame"
                toggleFrame.BackgroundTransparency = 1
                toggleFrame.Size = UDim2.new(1, 0, 0, 30)
                toggleFrame.Parent = sectionContent
                
                local toggleLabel = Instance.new("TextLabel")
                toggleLabel.Name = "ToggleLabel"
                toggleLabel.BackgroundTransparency = 1
                toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
                toggleLabel.Font = Enum.Font.Gotham
                toggleLabel.Text = toggleName or "Toggle"
                toggleLabel.TextColor3 = self.theme.TextColor
                toggleLabel.TextSize = 14
                toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                toggleLabel.Parent = toggleFrame
                
                local toggleButton = Instance.new("TextButton")
                toggleButton.Name = "ToggleButton"
                toggleButton.BackgroundColor3 = defaultState and self.theme.ToggleOnColor or self.theme.ToggleOffColor
                toggleButton.Position = UDim2.new(0.7, 5, 0.5, -10)
                toggleButton.Size = UDim2.new(0.3, -5, 0, 20)
                toggleButton.Font = Enum.Font.Gotham
                toggleButton.Text = defaultState and "ON" or "OFF"
                toggleButton.TextColor3 = Color3.new(1, 1, 1)
                toggleButton.TextSize = 12
                toggleButton.AutoButtonColor = false
                toggleButton.Parent = toggleFrame
                
                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 5)
                toggleCorner.Parent = toggleButton
                
                local state = defaultState or false
                
                local function updateToggle()
                    if state then
                        toggleButton.BackgroundColor3 = self.theme.ToggleOnColor
                        toggleButton.Text = "ON"
                    else
                        toggleButton.BackgroundColor3 = self.theme.ToggleOffColor
                        toggleButton.Text = "OFF"
                    end
                    
                    if callback then
                        callback(state)
                    end
                end
                
                toggleButton.MouseButton1Click:Connect(function()
                    state = not state
                    updateToggle()
                end)
                
                toggleButton.TouchTap:Connect(function()
                    state = not state
                    updateToggle()
                end)
                
                function toggle:SetState(newState)
                    state = newState
                    updateToggle()
                end
                
                function toggle:GetState()
                    return state
                end
                
                return toggle
            end
            
            -- Slider
            function section:CreateSlider(sliderName, minValue, maxValue, defaultValue, callback)
                local slider = {}
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Name = "SliderFrame"
                sliderFrame.BackgroundTransparency = 1
                sliderFrame.Size = UDim2.new(1, 0, 0, 50)
                sliderFrame.Parent = sectionContent
                
                local sliderLabel = Instance.new("TextLabel")
                sliderLabel.Name = "SliderLabel"
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Size = UDim2.new(1, 0, 0, 20)
                sliderLabel.Font = Enum.Font.Gotham
                sliderLabel.Text = sliderName or string.format("Slider: %.1f", defaultValue or minValue)
                sliderLabel.TextColor3 = self.theme.TextColor
                sliderLabel.TextSize = 14
                sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                sliderLabel.Parent = sliderFrame
                
                local sliderBar = Instance.new("Frame")
                sliderBar.Name = "SliderBar"
                sliderBar.BackgroundColor3 = self.theme.TabColor
                sliderBar.Position = UDim2.new(0, 0, 0, 25)
                sliderBar.Size = UDim2.new(1, 0, 0, 5)
                sliderBar.Parent = sliderFrame
                
                local sliderBarCorner = Instance.new("UICorner")
                sliderBarCorner.CornerRadius = UDim.new(1, 0)
                sliderBarCorner.Parent = sliderBar
                
                local sliderFill = Instance.new("Frame")
                sliderFill.Name = "SliderFill"
                sliderFill.BackgroundColor3 = self.theme.SliderColor
                sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
                sliderFill.Parent = sliderBar
                
                local sliderFillCorner = Instance.new("UICorner")
                sliderFillCorner.CornerRadius = UDim.new(1, 0)
                sliderFillCorner.Parent = sliderFill
                
                local sliderButton = Instance.new("TextButton")
                sliderButton.Name = "SliderButton"
                sliderButton.BackgroundColor3 = Color3.new(1, 1, 1)
                sliderButton.Position = UDim2.new(0.5, -5, 0, -5)
                sliderButton.Size = UDim2.new(0, 10, 0, 10)
                sliderButton.Text = ""
                sliderButton.AutoButtonColor = false
                sliderButton.Parent = sliderBar
                
                local sliderButtonCorner = Instance.new("UICorner")
                sliderButtonCorner.CornerRadius = UDim.new(1, 0)
                sliderButtonCorner.Parent = sliderButton
                
                minValue = minValue or 0
                maxValue = maxValue or 100
                defaultValue = defaultValue or minValue
                
                local value = math.clamp(defaultValue, minValue, maxValue)
                local sliding = false
                
                local function updateSlider(newValue)
                    value = math.clamp(newValue, minValue, maxValue)
                    local ratio = (value - minValue) / (maxValue - minValue)
                    
                    sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
                    sliderButton.Position = UDim2.new(ratio, -5, 0, -5)
                    sliderLabel.Text = string.format("%s: %.1f", sliderName or "Slider", value)
                    
                    if callback then
                        callback(value)
                    end
                end
                
                local function slide(input)
                    local sliderAbsoluteSize = sliderBar.AbsoluteSize.X
                    local sliderAbsolutePosition = sliderBar.AbsolutePosition.X
                    
                    local pos = math.clamp(input.Position.X, sliderAbsolutePosition, sliderAbsolutePosition + sliderAbsoluteSize)
                    local ratio = (pos - sliderAbsolutePosition) / sliderAbsoluteSize
                    local newValue = minValue + (maxValue - minValue) * ratio
                    
                    updateSlider(newValue)
                end
                
                sliderButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = true
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                sliding = false
                            end
                        end)
                    end
                end)
                
                sliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        slide(input)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        slide(input)
                    end
                end)
                
                updateSlider(defaultValue)
                
                function slider:SetValue(newValue)
                    updateSlider(newValue)
                end
                
                function slider:GetValue()
                    return value
                end
                
                return slider
            end
            
            -- Dropdown
            function section:CreateDropdown(dropdownName, options, defaultOption, callback)
                local dropdown = {}
                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Name = "DropdownFrame"
                dropdownFrame.BackgroundTransparency = 1
                dropdownFrame.Size = UDim2.new(1, 0, 0, 30)
                dropdownFrame.Parent = sectionContent
                
                local dropdownLabel = Instance.new("TextLabel")
                dropdownLabel.Name = "DropdownLabel"
                dropdownLabel.BackgroundTransparency = 1
                dropdownLabel.Size = UDim2.new(0.5, 0, 1, 0)
                dropdownLabel.Font = Enum.Font.Gotham
                dropdownLabel.Text = dropdownName or "Dropdown"
                dropdownLabel.TextColor3 = self.theme.TextColor
                dropdownLabel.TextSize = 14
                dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                dropdownLabel.Parent = dropdownFrame
                
                local dropdownButton = Instance.new("TextButton")
                dropdownButton.Name = "DropdownButton"
                dropdownButton.BackgroundColor3 = self.theme.ButtonColor
                dropdownButton.Position = UDim2.new(0.5, 5, 0, 0)
                dropdownButton.Size = UDim2.new(0.5, -5, 1, 0)
                dropdownButton.Font = Enum.Font.Gotham
                dropdownButton.Text = defaultOption or "Select"
                dropdownButton.TextColor3 = self.theme.TextColor
                dropdownButton.TextSize = 14
                dropdownButton.AutoButtonColor = false
                dropdownButton.Parent = dropdownFrame
                
                local dropdownCorner = Instance.new("UICorner")
                dropdownCorner.CornerRadius = UDim.new(0, 5)
                dropdownCorner.Parent = dropdownButton
                
                local dropdownList = Instance.new("ScrollingFrame")
                dropdownList.Name = "DropdownList"
                dropdownList.BackgroundColor3 = self.theme.SectionColor
                dropdownList.Position = UDim2.new(0.5, 5, 1, 5)
                dropdownList.Size = UDim2.new(0.5, -5, 0, 0)
                dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
                dropdownList.ScrollBarThickness = 5
                dropdownList.ScrollBarImageColor3 = self.theme.AccentColor
                dropdownList.Visible = false
                dropdownList.Parent = dropdownFrame
                
                local dropdownListLayout = Instance.new("UIListLayout")
                dropdownListLayout.Name = "DropdownListLayout"
                dropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                dropdownListLayout.Parent = dropdownList
                
                local dropdownListCorner = Instance.new("UICorner")
                dropdownListCorner.CornerRadius = UDim.new(0, 5)
                dropdownListCorner.Parent = dropdownList
                
                local isOpen = false
                local selectedOption = defaultOption
                
                local function toggleDropdown()
                    isOpen = not isOpen
                    
                    if isOpen then
                        dropdownList.Visible = true
                        dropdownList:TweenSize(
                            UDim2.new(0.5, -5, 0, math.min(150, #options * 30)),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Quad,
                            0.2,
                            true
                        )
                    else
                        dropdownList:TweenSize(
                            UDim2.new(0.5, -5, 0, 0),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Quad,
                            0.2,
                            true,
                            function()
                                dropdownList.Visible = false
                            end
                        )
                    end
                end
                
                local function selectOption(option)
                    selectedOption = option
                    dropdownButton.Text = option
                    toggleDropdown()
                    
                    if callback then
                        callback(option)
                    end
                end
                
                -- Populate dropdown options
                for _, option in ipairs(options) do
                    local optionButton = Instance.new("TextButton")
                    optionButton.Name = "OptionButton"
                    optionButton.BackgroundColor3 = self.theme.ButtonColor
                    optionButton.Size = UDim2.new(1, 0, 0, 30)
                    optionButton.Font = Enum.Font.Gotham
                    optionButton.Text = option
                    optionButton.TextColor3 = self.theme.TextColor
                    optionButton.TextSize = 14
                    optionButton.AutoButtonColor = false
                    optionButton.Parent = dropdownList
                    
                    local optionCorner = Instance.new("UICorner")
                    optionCorner.CornerRadius = UDim.new(0, 5)
                    optionCorner.Parent = optionButton
                    
                    optionButton.MouseButton1Click:Connect(function()
                        selectOption(option)
                    end)
                    
                    optionButton.TouchTap:Connect(function()
                        selectOption(option)
                    end)
                    
                    -- Hover effect
                    optionButton.MouseEnter:Connect(function()
                        optionButton.BackgroundColor3 = self.theme.ButtonHoverColor
                    end)
                    
                    optionButton.MouseLeave:Connect(function()
                        optionButton.BackgroundColor3 = self.theme.ButtonColor
                    end)
                end
                
                dropdownListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    dropdownList.CanvasSize = UDim2.new(0, 0, 0, dropdownListLayout.AbsoluteContentSize.Y)
                end)
                
                dropdownButton.MouseButton1Click:Connect(toggleDropdown)
                dropdownButton.TouchTap:Connect(toggleDropdown)
                
                -- Close dropdown when clicking outside
                local function onInputBegan(input)
                    if isOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local absolutePosition = dropdownList.AbsolutePosition
                        local absoluteSize = dropdownList.AbsoluteSize
                        local mousePosition = input.Position
                        
                        if not (mousePosition.X >= absolutePosition.X and mousePosition.X <= absolutePosition.X + absoluteSize.X and
                               mousePosition.Y >= absolutePosition.Y and mousePosition.Y <= absolutePosition.Y + absoluteSize.Y) then
                            toggleDropdown()
                        end
                    end
                end
                
                UserInputService.InputBegan:Connect(onInputBegan)
                
                function dropdown:SetOption(option)
                    if table.find(options, option) then
                        selectOption(option)
                    end
                end
                
                function dropdown:GetOption()
                    return selectedOption
                end
                
                return dropdown
            end
            
            -- Label
            function section:CreateLabel(labelText)
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, 0, 0, 20)
                label.Font = Enum.Font.Gotham
                label.Text = labelText or "Label"
                label.TextColor3 = self.theme.TextColor
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = sectionContent
                
                return label
            end
            
            return section
        end
        
        return tab
    end
    
    -- Window functions
    function window:SetTitle(newTitle)
        titleLabel.Text = newTitle or "UI Library"
    end
    
    function window:SetLeftLabel(newText)
        leftBottomLabel.Text = newText or "Left Label"
    end
    
    function window:SetRightLabel(newText)
        rightBottomLabel.Text = newText or "Right Label"
    end
    
    function window:Toggle()
        mainFrame.Visible = not mainFrame.Visible
    end
    
    function window:Destroy()
        screenGui:Destroy()
    end
    
    return window
end

return library

local Library = require(script.Parent.Library) -- Adjust path to where you put the module

-- Create a window
local window = Library:CreateWindow("My Cool UI")

-- Set bottom labels
window:SetLeftLabel("Version 1.0")
window:SetRightLabel("Made by You")

-- Create tabs
local mainTab = window:CreateTab("Main")
local settingsTab = window:CreateTab("Settings")

-- Main Tab Sections
local playerSection = mainTab:CreateSection("Player")
local gameSection = mainTab:CreateSection("Game")

-- Player Section Elements
playerSection:CreateButton("Reset Character", function()
    game:GetService("Players").LocalPlayer.Character:BreakJoints()
end)

local walkSpeedToggle = playerSection:CreateToggle("Speed Boost", false, function(state)
    if state then
        game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = 32
    else
        game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

local jumpSlider = playerSection:CreateSlider("Jump Power", 50, 200, 100, function(value)
    game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = value
end)

-- Game Section Elements
local timeDropdown = gameSection:CreateDropdown("Time of Day", {"Morning", "Noon", "Evening", "Night"}, "Noon", function(option)
    if option == "Morning" then
        game:GetService("Lighting").ClockTime = 6
    elseif option == "Noon" then
        game:GetService("Lighting").ClockTime = 12
    elseif option == "Evening" then
        game:GetService("Lighting").ClockTime = 18
    elseif option == "Night" then
        game:GetService("Lighting").ClockTime = 0
    end
end)

-- Settings Tab
local uiSettings = settingsTab:CreateSection("UI Settings")
uiSettings:CreateLabel("Coming soon!")
