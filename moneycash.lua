local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ROOT = getgenv and getgenv() or _G
local PROJECT_NAME = "MoneyCash"
local GUI_NAME = "MoneyCashAutomationGui"
local STATE_KEY = "__MoneyCashAutomationState"
local RUN_KEY = "__MoneyCashAutomationRunId"

local localPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local playerGui = localPlayer:WaitForChild("PlayerGui")

if type(ROOT[STATE_KEY]) == "table" and type(ROOT[STATE_KEY].Stop) == "function" then
    pcall(function()
        ROOT[STATE_KEY]:Stop()
    end)
end

ROOT[RUN_KEY] = (tonumber(ROOT[RUN_KEY]) or 0) + 1
local currentRunId = ROOT[RUN_KEY]

local function getEventsFolder()
    return ReplicatedStorage:WaitForChild("Events")
end

local function getClickMoneyRemote()
    return getEventsFolder():WaitForChild("ClickMoney")
end

local function getUpgradeRemote()
    return getEventsFolder():WaitForChild("Upgrade")
end

local EVENTS = {
    {
        Id = "click_money",
        Title = "Click Money",
        Description = 'game:GetService("ReplicatedStorage").Events.ClickMoney:FireServer()',
        ToggleKey = Enum.KeyCode.F,
        Delay = 0.01,
        Run = function()
            getClickMoneyRemote():FireServer()
        end,
    },
    {
        Id = "melhoria_cash",
        Title = "Melhoria Cash",
        Description = "Executa os upgrades 1, 2, 2 max e 3 em sequencia",
        ToggleKey = Enum.KeyCode.G,
        Delay = 0.1,
        Run = function()
            local remote = getUpgradeRemote()
            remote:FireServer(1, false)
            remote:FireServer(2, false)
            remote:FireServer(2, true)
            remote:FireServer(3, false)
        end,
    },
}

local state = {
    Running = true,
    Visible = true,
    Connections = {},
    EventStates = {},
    Rows = {},
    RunId = currentRunId,
}

for _, child in ipairs(playerGui:GetChildren()) do
    if child.Name == GUI_NAME then
        child:Destroy()
    end
end

local function bind(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(state.Connections, connection)
    return connection
end

local function disconnectAll()
    for _, connection in ipairs(state.Connections) do
        if connection and connection.Disconnect then
            connection:Disconnect()
        end
    end

    table.clear(state.Connections)
end

local function makeCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
    return corner
end

local function makeStroke(instance, color, transparency, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Transparency = transparency or 0
    stroke.Thickness = thickness or 1
    stroke.Parent = instance
    return stroke
end

local function createText(parent, props)
    local isButton = props.Button == true
    local label = Instance.new(isButton and "TextButton" or "TextLabel")

    if props.BackgroundTransparency ~= nil then
        label.BackgroundTransparency = props.BackgroundTransparency
    else
        label.BackgroundTransparency = isButton and 0 or 1
    end

    if props.BackgroundColor3 then
        label.BackgroundColor3 = props.BackgroundColor3
    end

    label.BorderSizePixel = 0
    label.Position = props.Position or UDim2.new()
    label.Size = props.Size or UDim2.new()
    label.Text = props.Text or ""
    label.TextColor3 = props.TextColor3 or Color3.fromRGB(255, 255, 255)
    label.Font = props.Font or Enum.Font.Gotham
    label.TextSize = props.TextSize or 14
    label.TextWrapped = props.TextWrapped == true
    label.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
    label.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center

    if isButton then
        label.AutoButtonColor = true
    end

    label.Parent = parent
    return label
end

local function formatKey(keyCode)
    if typeof(keyCode) ~= "EnumItem" then
        return "-"
    end

    local name = tostring(keyCode.Name or "")
    if name == "" then
        return "-"
    end

    return string.upper(name)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = GUI_NAME
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local isTouchDevice = UserInputService.TouchEnabled == true

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = isTouchDevice and UDim2.new(0, 352, 0, 360) or UDim2.new(0, 430, 0, 430)
mainFrame.Position = UDim2.new(0.5, -(mainFrame.Size.X.Offset / 2), 0.5, -(mainFrame.Size.Y.Offset / 2))
mainFrame.BackgroundColor3 = Color3.fromRGB(24, 31, 46)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
makeCorner(mainFrame, 18)
makeStroke(mainFrame, Color3.fromRGB(93, 181, 255), 0.18, 1.2)

local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(36, 46, 68)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(21, 28, 42)),
})
mainGradient.Rotation = 90
mainGradient.Parent = mainFrame

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 46)
header.BackgroundColor3 = Color3.fromRGB(58, 123, 207)
header.BorderSizePixel = 0
header.Parent = mainFrame
makeCorner(header, 18)

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 16)
headerFix.Position = UDim2.new(0, 0, 1, -16)
headerFix.BackgroundColor3 = header.BackgroundColor3
headerFix.BorderSizePixel = 0
headerFix.Parent = header

createText(header, {
    Position = UDim2.new(0, 16, 0, 0),
    Size = UDim2.new(1, -110, 1, 0),
    Text = PROJECT_NAME .. " Event Panel",
    Font = Enum.Font.GothamBold,
    TextSize = 15,
})

local closeButton = createText(header, {
    Button = true,
    Position = UDim2.new(1, -42, 0.5, -14),
    Size = UDim2.new(0, 28, 0, 28),
    Text = "X",
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Center,
    BackgroundTransparency = 0,
    BackgroundColor3 = Color3.fromRGB(198, 77, 77),
})
makeCorner(closeButton, 9)

local minimizeButton = createText(header, {
    Button = true,
    Position = UDim2.new(1, -76, 0.5, -14),
    Size = UDim2.new(0, 28, 0, 28),
    Text = "-",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Center,
    BackgroundTransparency = 0,
    BackgroundColor3 = Color3.fromRGB(78, 91, 122),
})
makeCorner(minimizeButton, 9)

local body = Instance.new("Frame")
body.BackgroundColor3 = Color3.fromRGB(18, 24, 37)
body.BackgroundTransparency = 0
body.Position = UDim2.new(0, 12, 0, 58)
body.Size = UDim2.new(1, -24, 1, -70)
body.Parent = mainFrame
makeCorner(body, 16)
makeStroke(body, Color3.fromRGB(90, 109, 148), 0.45, 1)

local summaryLabel = createText(body, {
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(1, 0, 0, 18),
    Text = string.format("0 de %d eventos ativos", #EVENTS),
    TextColor3 = Color3.fromRGB(151, 164, 194),
    TextSize = 11,
})

local rowHolder = Instance.new("ScrollingFrame")
rowHolder.BackgroundTransparency = 1
rowHolder.Position = UDim2.new(0, 0, 0, 28)
rowHolder.Size = UDim2.new(1, 0, 1, -28)
rowHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
rowHolder.ScrollBarThickness = 4
rowHolder.BorderSizePixel = 0
rowHolder.AutomaticCanvasSize = Enum.AutomaticSize.None
rowHolder.Parent = body

local rowLayout = Instance.new("UIListLayout")
rowLayout.Padding = UDim.new(0, 8)
rowLayout.Parent = rowHolder

bind(rowLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
    rowHolder.CanvasSize = UDim2.new(0, 0, 0, rowLayout.AbsoluteContentSize.Y + 8)
end)

local openButton = createText(screenGui, {
    Button = true,
    Position = UDim2.new(0, 18, 0.5, -22),
    Size = UDim2.new(0, 110, 0, 44),
    Text = PROJECT_NAME,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Center,
    BackgroundTransparency = 0,
    BackgroundColor3 = Color3.fromRGB(41, 51, 78),
})
openButton.Visible = false
makeCorner(openButton, 14)
makeStroke(openButton, Color3.fromRGB(95, 174, 255), 0.25, 1.1)

local function refreshSummary()
    local enabledCount = 0
    for _, eventState in pairs(state.EventStates) do
        if eventState.Enabled == true then
            enabledCount = enabledCount + 1
        end
    end

    summaryLabel.Text = string.format("%d de %d eventos ativos", enabledCount, #EVENTS)
end

local function refreshRow(eventConfig)
    local eventState = state.EventStates[eventConfig.Id]
    local row = state.Rows[eventConfig.Id]
    if not eventState or not row then
        return
    end

    local enabled = eventState.Enabled == true
    row.Status.Text = enabled and "Status: ligado" or "Status: desligado"
    row.Status.TextColor3 = enabled and Color3.fromRGB(92, 232, 171) or Color3.fromRGB(244, 122, 122)
    row.Button.Text = enabled and "Desligar" or "Ligar"
    row.Button.BackgroundColor3 = enabled and Color3.fromRGB(198, 77, 77) or Color3.fromRGB(62, 159, 102)

    refreshSummary()
end

local function setVisible(visible)
    state.Visible = visible == true
    mainFrame.Visible = state.Visible
    openButton.Visible = not state.Visible
end

local function setEventEnabled(eventId, enabled)
    local eventState = state.EventStates[eventId]
    if not eventState then
        return false
    end

    eventState.Enabled = enabled == true
    refreshRow(eventState.Config)
    return eventState.Enabled
end

local function toggleEvent(eventId)
    local eventState = state.EventStates[eventId]
    if not eventState then
        return false
    end

    return setEventEnabled(eventId, not eventState.Enabled)
end

local function createEventRow(eventConfig)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 130)
    row.BackgroundColor3 = Color3.fromRGB(34, 43, 62)
    row.BorderSizePixel = 0
    row.Parent = rowHolder
    makeCorner(row, 16)
    makeStroke(row, Color3.fromRGB(106, 124, 168), 0.3, 1)

    createText(row, {
        Position = UDim2.new(0, 14, 0, 12),
        Size = UDim2.new(1, -130, 0, 18),
        Text = eventConfig.Title,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
    })

    createText(row, {
        Position = UDim2.new(0, 14, 0, 34),
        Size = UDim2.new(1, -28, 0, 36),
        Text = eventConfig.Description,
        TextColor3 = Color3.fromRGB(157, 168, 194),
        TextSize = 11,
        TextWrapped = true,
    })

    local keyLabel = createText(row, {
        Position = UDim2.new(0, 14, 0, 76),
        Size = UDim2.new(0, 120, 0, 16),
        Text = "Tecla: " .. formatKey(eventConfig.ToggleKey),
        TextColor3 = Color3.fromRGB(140, 154, 186),
        TextSize = 11,
    })

    local statusLabel = createText(row, {
        Position = UDim2.new(0, 14, 0, 96),
        Size = UDim2.new(0, 160, 0, 18),
        Text = "Status: desligado",
        TextColor3 = Color3.fromRGB(244, 122, 122),
        TextSize = 11,
    })

    local toggleButton = createText(row, {
        Button = true,
        Position = UDim2.new(1, -108, 0.5, -18),
        Size = UDim2.new(0, 94, 0, 36),
        Text = "Ligar",
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Center,
        BackgroundTransparency = 0,
        BackgroundColor3 = Color3.fromRGB(62, 159, 102),
    })
    makeCorner(toggleButton, 12)

    state.Rows[eventConfig.Id] = {
        Key = keyLabel,
        Status = statusLabel,
        Button = toggleButton,
    }

    bind(toggleButton.MouseButton1Click, function()
        toggleEvent(eventConfig.Id)
    end)
end

for _, eventConfig in ipairs(EVENTS) do
    state.EventStates[eventConfig.Id] = {
        Config = eventConfig,
        Enabled = false,
        Delay = tonumber(eventConfig.Delay) or 0.01,
    }

    createEventRow(eventConfig)
end

bind(minimizeButton.MouseButton1Click, function()
    setVisible(false)
end)

bind(openButton.MouseButton1Click, function()
    setVisible(true)
end)

function state:Stop()
    if self.Running ~= true then
        return
    end

    self.Running = false
    disconnectAll()

    for _, eventState in pairs(self.EventStates) do
        eventState.Enabled = false
    end

    if screenGui then
        screenGui:Destroy()
    end

    if ROOT[STATE_KEY] == self then
        ROOT[STATE_KEY] = nil
    end
end

bind(closeButton.MouseButton1Click, function()
    state:Stop()
end)

bind(UserInputService.InputBegan, function(input, gameProcessed)
    if state.Running ~= true then
        return
    end

    if input.KeyCode == Enum.KeyCode.Delete then
        setVisible(not state.Visible)
        return
    end

    if gameProcessed then
        return
    end

    for _, eventConfig in ipairs(EVENTS) do
        if input.KeyCode == eventConfig.ToggleKey then
            toggleEvent(eventConfig.Id)
            return
        end
    end
end)

do
    local dragging = false
    local dragStart
    local startPos

    bind(header.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    bind(UserInputService.InputChanged, function(input)
        if not dragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

for _, eventConfig in ipairs(EVENTS) do
    task.spawn(function()
        local eventState = state.EventStates[eventConfig.Id]
        while state.Running and state.RunId == ROOT[RUN_KEY] do
            if eventState.Enabled == true then
                local ok, err = pcall(eventConfig.Run)
                if not ok then
                    warn("[" .. PROJECT_NAME .. "] erro em " .. tostring(eventConfig.Id) .. ": " .. tostring(err))
                    eventState.Enabled = false
                    refreshRow(eventConfig)
                end
            end

            task.wait(eventState.Delay)
        end
    end)
end

ROOT[STATE_KEY] = state

refreshSummary()
for _, eventConfig in ipairs(EVENTS) do
    refreshRow(eventConfig)
end

return state
