local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- فحص ذكي ومتوافق مع جميع الهاكات (بيسي وجوال)
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

-- تنظيف القائمة القديمة لو موجودة
if PlayerGui:FindFirstChild("Travexa_Gui") then PlayerGui.Travexa_Gui:Destroy() end

-- إنشاء قائمة Travexa / ترفكسا
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "Travexa_Gui"
ScreenGui.ResetOnSpawn = false

-- الواجهة الرئيسية
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- أسود
MainFrame.Position = UDim2.new(0.5, -120, 0.35, -120)
MainFrame.Size = UDim2.new(0, 240, 0, 255)
MainFrame.Draggable = true
MainFrame.Active = true

local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(0, 170, 255) -- أزرق
TitleLabel.Text = "🔥 Travexa / ترفكسا 🔥"
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 18

local function createBox(pos, text)
    local box = Instance.new("TextBox", MainFrame)
    box.Size = UDim2.new(0.8, 0, 0, 30)
    box.Position = pos
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- أسود فاتح قليلاً
    box.TextColor3 = Color3.fromRGB(0, 170, 255) -- أزرق
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
ApplyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- أسود
ApplyButton.TextColor3 = Color3.fromRGB(0, 170, 255) -- أزرق
ApplyButton.Text = "Apply Custom Info"
ApplyButton.Font = Enum.Font.SourceSansBold
ApplyButton.TextSize = 16

-- زر دائري عائم قابل للسحب على اليمين
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(1, -60, 0.5, -25) -- يمين الشاشة
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- أسود
ToggleButton.TextColor3 = Color3.fromRGB(0, 170, 255) -- أزرق
ToggleButton.Text = "T"
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 24
ToggleButton.AutoButtonColor = false -- نمنع تغيير اللون عند الضغط

-- جعل الزر دائرياً
local Corner = Instance.new("UICorner", ToggleButton)
Corner.CornerRadius = UDim.new(1, 0)

-- نظام السحب للزر الدائري
local dragging = false
local dragStartPos = nil
local dragStartMouse = nil
local dragThreshold = 5 -- بكسلات للتفريق بين السحب والضغط

ToggleButton.MouseButton1Down:Connect(function()
    dragging = true
    dragStartPos = ToggleButton.Position
    dragStartMouse = UserInputService:GetMouseLocation()
    UserInputService.MouseIconEnabled = false
end)

ToggleButton.MouseButton1Up:Connect(function()
    if dragging then
        local currentMouse = UserInputService:GetMouseLocation()
        local delta = currentMouse - dragStartMouse
        if math.abs(delta.X) < dragThreshold and math.abs(delta.Y) < dragThreshold then
            -- يعتبر ضغطة، نبدل الواجهة
            MainFrame.Visible = not MainFrame.Visible
        end
    end
    dragging = false
    UserInputService.MouseIconEnabled = true
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local currentMouse = UserInputService:GetMouseLocation()
        local delta = currentMouse - dragStartMouse
        local newX = dragStartPos.X.Offset + delta.X
        local newY = dragStartPos.Y.Offset + delta.Y
        ToggleButton.Position = UDim2.new(0, newX, 0, newY)
    end
end)

-- نظام التزوير والمراقبة المتطور للصيغتين (الرقمية واللفظية)
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
    
    -- فحص النص الحالي عشان نحدد الصيغة المطلوبة للتبديل
    local currentText = child.Text
    if string.find(currentText, "Hour") or string.find(currentText, "Minute") or string.find(currentText, "Second") then
        -- تبديل الصيغة اللفظية (حقت الجوال) بنفس الشكل المظبوط بالملي
        child.Text = string.format("%d Hour(s), %d Minute(s), %d Second(s)", hours, minutes, seconds)
    else
        -- تبديل الصيغة الرقمية العادية (حقت البيسي)
        child.Text = string.format("%d:%02d:%02d", hours, minutes, seconds)
    end
end

local function watchGui(parent)
    pcall(function()
        if parent then
            for _, child in pairs(parent:GetChildren()) do
                if child:IsA("TextLabel") then
                    -- الفحص الحين صار يدعم الصيغة الرقمية أو اللفظية أو اسم خانة الوقت "Time"
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

-- حلقة الفحص بالخلفية الآمنة لجميع المنصات
task.spawn(function()
    while task.wait(0.5) do
        pcall(function() watchGui(CoreGui) end)
        pcall(function() watchGui(PlayerGui) end)
    end
end)

-- عند الضغط على زر التطبيق
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
