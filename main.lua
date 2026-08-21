local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- فحص ذكي ومتوافق مع جميع الهاكات
local iyFound = false
local function checkForIY(parent)
    if iyFound then return end
    pcall(function()
        if parent then
            for _, child in pairs(parent:GetChildren()) do
                if child.Name == "EdgeHouse" or child.Name == "IY_GUI" or string.find(string.lower(child.Name), "inf") then
                    iyFound = true
                    break
                end
                checkForIY(child)
            end
        end
    end)
end

pcall(function() checkForIY(CoreGui) end)
pcall(function() checkForIY(PlayerGui) end)

-- تنظيف القائمة القديمة
if PlayerGui:FindFirstChild("Travexa_Gui") then PlayerGui.Travexa_Gui:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "Travexa_Gui"
ScreenGui.ResetOnSpawn = false

-- الواجهة الرئيسية (تبدأ مخفية)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -120, 0.35, -120)
MainFrame.Size = UDim2.new(0, 240, 0, 255)
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Visible = false

local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
TitleLabel.Text = "🔥 Travexa / ترفكسا 🔥"
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 18

local function createBox(pos, text)
    local box = Instance.new("TextBox", MainFrame)
    box.Size = UDim2.new(0.8, 0, 0, 30)
    box.Position = pos
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    box.TextColor3 = Color3.fromRGB(0, 170, 255)
    box.Text = text
    box.ClearTextOnFocus = true
    return box
end

local HourBox = createBox(UDim2.new(0.1, 0, 0.18, 0), "88")
local MinuteBox = createBox(UDim2.new(0.1, 0, 0.34, 0), "6")
local SecondBox = createBox(UDim2.new(0.1, 0, 0.50, 0), "5")

local ApplyButton = Instance.new("TextButton", MainFrame)
ApplyButton.Size = UDim2.new(0.8, 0, 0, 35)
ApplyButton.Position = UDim2.new(0.1, 0, 0.75, 0)
ApplyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ApplyButton.TextColor3 = Color3.fromRGB(0, 170, 255)
ApplyButton.Text = "Apply Custom Info"
ApplyButton.Font = Enum.Font.SourceSansBold
ApplyButton.TextSize = 16

-- الزر الدائري العائم
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
-- تحديد الموقع الأولي بالـ Offset بدلاً من Scale
local screenWidth = Camera.ViewportSize.X
local screenHeight = Camera.ViewportSize.Y
ToggleButton.Position = UDim2.new(0, screenWidth - 60, 0, screenHeight/2 - 25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.TextColor3 = Color3.fromRGB(0, 170, 255)
ToggleButton.Text = "T"
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 24
ToggleButton.AutoButtonColor = false

local Corner = Instance.new("UICorner", ToggleButton)
Corner.CornerRadius = UDim.new(1, 0)

-- وظيفة تقييد الموضع داخل حدود الشاشة
local function clampToScreen(posX, posY)
    local buttonSize = ToggleButton.AbsoluteSize
    local maxX = Camera.ViewportSize.X - buttonSize.X
    local maxY = Camera.ViewportSize.Y - buttonSize.Y
    return math.clamp(posX, 0, maxX), math.clamp(posY, 0, maxY)
end

-- متغيرات السحب
local isDragging = false
local startOffsetX = 0
local startOffsetY = 0
local startMousePos = Vector2.new(0, 0)
local moved = false

-- بدء السحب (ماوس)
ToggleButton.MouseButton1Down:Connect(function()
    isDragging = true
    moved = false
    startOffsetX = ToggleButton.Position.X.Offset
    startOffsetY = ToggleButton.Position.Y.Offset
    startMousePos = UserInputService:GetMouseLocation()
end)

ToggleButton.MouseButton1Up:Connect(function()
    if isDragging and not moved then
        -- ضغطة سريعة
        MainFrame.Visible = not MainFrame.Visible
    end
    isDragging = false
end)

-- بدء السحب (لمس)
ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        moved = false
        startOffsetX = ToggleButton.Position.X.Offset
        startOffsetY = ToggleButton.Position.Y.Offset
        startMousePos = input.Position
    end
end)

ToggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        if isDragging and not moved then
            MainFrame.Visible = not MainFrame.Visible
        end
        isDragging = false
    end
end)

-- تحديث الحركة
local function updateDrag()
    if isDragging then
        local currentMousePos = UserInputService:GetMouseLocation()
        local delta = currentMousePos - startMousePos
        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
            moved = true
        end
        local newX, newY = clampToScreen(startOffsetX + delta.X, startOffsetY + delta.Y)
        ToggleButton.Position = UDim2.new(0, newX, 0, newY)
    end
end

RunService.RenderStepped:Connect(updateDrag)

-- نظام التزوير والمراقبة
local startHours = 88
local startMinutes = 6
local startSeconds = 5

local totalSeconds = (startHours * 3600) + (startMinutes * 60) + startSeconds
local startTime = os.clock()
local isActivated = false 

local function formatAndApply(child)
    if not isActivated then return end 
    
    local elapsedTime = os.clock() - startTime
    local currentTime = totalSeconds + math.floor(elapsedTime)
    
    local hours = math.floor(currentTime / 3600)
    local minutes = math.floor((currentTime % 3600) / 60)
    local seconds = currentTime % 60
    
    local currentText = child.Text
    if string.find(currentText, "Hour") or string.find(currentText, "Minute") or string.find(currentText, "Second") then
        child.Text = string.format("%d Hour(s), %d Minute(s), %d Second(s)", hours, minutes, seconds)
    else
        child.Text = string.format("%d:%02d:%02d", hours, minutes, seconds)
    end
end

local function watchGui(parent)
    pcall(function()
        if parent then
            for _, child in pairs(parent:GetChildren()) do
                if child:IsA("TextLabel") then
                    if string.find(child.Text, "^%d+:%d+:%d+$") or string.find(child.Text, "Hour%(s%)") or child.Name == "Time" then
                        formatAndApply(child)
                        child:GetPropertyChangedSignal("Text"):Connect(function()
                            formatAndApply(child)
                        end)
                    end
                end
                watchGui(child)
            end
        end
    end)
end

task.spawn(function()
    while task.wait(0.5) do
        pcall(function() watchGui(CoreGui) end)
        pcall(function() watchGui(PlayerGui) end)
    end
end)

ApplyButton.MouseButton1Click:Connect(function()
    startHours = tonumber(HourBox.Text) or 0
    startMinutes = tonumber(MinuteBox.Text) or 0
    startSeconds = tonumber(SecondBox.Text) or 0
    totalSeconds = (startHours * 3600) + (startMinutes * 60) + startSeconds
    startTime = os.clock()
    isActivated = true 

    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeY/infiniteyield/master/source'))()
        end)
    end)
end)
