local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Workspace = game:GetService("Workspace")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StarterGui = game:GetService("StarterGui")
local StarterPack = game:GetService("StarterPack")
local StarterPlayer = game:GetService("StarterPlayer")

local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local ContentProvider = game:GetService("ContentProvider")

local Chat = game:GetService("Chat")
local TextChatService = game:GetService("TextChatService")
local TextService = game:GetService("TextService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local VoiceChatService = game:GetService("VoiceChatService")

local Teams = game:GetService("Teams")
local CollectionService = game:GetService("CollectionService")
local PathfindingService = game:GetService("PathfindingService")
local PhysicsService = game:GetService("PhysicsService")

local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local PolicyService = game:GetService("PolicyService")
local LocalizationService = game:GetService("LocalizationService")

local UserService = game:GetService("UserService")
local GroupService = game:GetService("GroupService")
local BadgeService = game:GetService("BadgeService")
local AvatarEditorService = game:GetService("AvatarEditorService")
local SocialService = game:GetService("SocialService")

local GuiService = game:GetService("GuiService")
local VRService = game:GetService("VRService")
local HapticService = game:GetService("HapticService")

local LogService = game:GetService("LogService")
local Stats = game:GetService("Stats")
local TestService = game:GetService("TestService")

local InsertService = game:GetService("InsertService")
local KeyframeSequenceProvider = game:GetService("KeyframeSequenceProvider")
local AnimationClipProvider = game:GetService("AnimationClipProvider")

local DataStoreService = game:GetService("DataStoreService")
local MemoryStoreService = game:GetService("MemoryStoreService")
local MessagingService = game:GetService("MessagingService")

local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

local Config = {
    Name = "007n7's hub",
    Version = "0.1.0",
    Creator = "x_c00lkidd_x",

    DesktopSize = Vector2.new(700, 450),
    MobileWidthScale = 0.88,
    MobileHeightScale = 0.68,

    MinimizedSize = 30,

    Colors = {
        Background = Color3.fromRGB(13, 15, 18),
        Surface = Color3.fromRGB(18, 20, 24),
        SurfaceLight = Color3.fromRGB(25, 28, 33),
        Border = Color3.fromRGB(45, 49, 57),
        Accent = Color3.fromRGB(0, 170, 255),
        AccentHover = Color3.fromRGB(35, 185, 255),
        Text = Color3.fromRGB(245, 247, 250),
        SecondaryText = Color3.fromRGB(160, 165, 175),
        MutedText = Color3.fromRGB(95, 100, 110),
        Success = Color3.fromRGB(75, 220, 145),
        Error = Color3.fromRGB(255, 90, 90),
        Warning = Color3.fromRGB(255, 190, 75)
    }
}

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local function FindExistingHub()
    local ExistingHub

    pcall(function()
        ExistingHub = CoreGui:FindFirstChild("007n7sHub", true)
    end)

    if ExistingHub then
        return ExistingHub
    end

    ExistingHub = PlayerGui:FindFirstChild("007n7sHub", true)

    return ExistingHub
end

if FindExistingHub() then
    return
end

local Camera = Workspace.CurrentCamera
local CameraViewportConnection

local function Create(ClassName, Properties)
    local Object = Instance.new(ClassName)

    for Property, Value in pairs(Properties) do
        Object[Property] = Value
    end

    return Object
end

local function Tween(Object, Duration, Properties, EasingStyle, EasingDirection)
    local Animation = TweenService:Create(
        Object,
        TweenInfo.new(
            Duration or 0.25,
            EasingStyle or Enum.EasingStyle.Quint,
            EasingDirection or Enum.EasingDirection.Out
        ),
        Properties
    )

    Animation:Play()

    return Animation
end

local function AddCorner(Object, Radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, Radius),
        Parent = Object
    })
end

local function AddStroke(Object, Color, Thickness, Transparency)
    return Create("UIStroke", {
        Color = Color,
        Thickness = Thickness or 1,
        Transparency = Transparency or 0,
        Parent = Object
    })
end

local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function BindAutoScroll(ScrollingFrame, Content, Layout)
    local function Update()
        local ContentHeight = Layout.AbsoluteContentSize.Y + 12
        local ViewportHeight = ScrollingFrame.AbsoluteSize.Y

        ScrollingFrame.CanvasSize = UDim2.fromOffset(
            0,
            math.max(ContentHeight, ViewportHeight)
        )
    end

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Update)
    ScrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(Update)
    Content:GetPropertyChangedSignal("AbsoluteSize"):Connect(Update)

    task.defer(Update)

    return Update
end

local function BindInnerScroll(ScrollingFrame, Content)
    local function Update()
        local ContentHeight = Content.AbsoluteSize.Y + 18
        local ViewportHeight = ScrollingFrame.AbsoluteSize.Y

        ScrollingFrame.CanvasSize = UDim2.fromOffset(
            0,
            math.max(ContentHeight, ViewportHeight)
        )
    end

    Content:GetPropertyChangedSignal("AbsoluteSize"):Connect(Update)
    ScrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(Update)

    task.defer(Update)

    return Update
end

local ScreenGui = Create("ScreenGui", {
    Name = "007n7sHub",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
    DisplayOrder = 100
})

local CoreGuardSource = game:HttpGet(
    "https://raw.githubusercontent.com/samuelwahbe/CoreGuard/v0.1.1/CoreGuard.luau"
)

local CoreGuard = loadstring(CoreGuardSource)()

CoreGuard:Init({
    Players = Players,
    CoreGui = CoreGui,
    RunService = RunService
})

CoreGuard:Mount(ScreenGui)
CoreGuard:Monitor(ScreenGui)

local function GetWindowSize()
    if not Camera then
        return Config.DesktopSize
    end

    local Viewport = Camera.ViewportSize

    if IsMobile() then
        return Vector2.new(
            math.floor(Viewport.X * Config.MobileWidthScale),
            math.floor(Viewport.Y * Config.MobileHeightScale)
        )
    end

    return Config.DesktopSize
end

local InitialSize = GetWindowSize()
local FullWindowSize = InitialSize
local CurrentTitleHeight = 50
local Collapsed = false
local CurrentPage = "Execution"
local PageSwitching = false

local SwitchPage

local Window = Create("Frame", {
    Name = "Window",
    Size = UDim2.fromOffset(InitialSize.X, InitialSize.Y),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Config.Colors.Background,
    BorderSizePixel = 0,
    ClipsDescendants = false,
    Parent = ScreenGui
})

AddCorner(Window, 14)
AddStroke(Window, Config.Colors.Border, 1, 0.15)

local WindowScale = Create("UIScale", {
    Scale = 0.92,
    Parent = Window
})

local Shadow = Create("ImageLabel", {
    Name = "Shadow",
    Size = UDim2.new(1, 36, 1, 36),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    Image = "rbxassetid://6014261993",
    ImageColor3 = Color3.fromRGB(0, 0, 0),
    ImageTransparency = 0.45,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(49, 49, 450, 450),
    ZIndex = 0,
    Parent = Window
})

Window.ZIndex = 2

local TitleBar = Create("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 50),
    BackgroundColor3 = Config.Colors.Accent,
    BorderSizePixel = 0,
    ZIndex = 5,
    Parent = Window
})

AddCorner(TitleBar, 14)

local TitleBarFill = Create("Frame", {
    Name = "TitleBarFill",
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 1, -16),
    BackgroundColor3 = Config.Colors.Accent,
    BorderSizePixel = 0,
    ZIndex = 5,
    Parent = TitleBar
})

local Title = Create("TextLabel", {
    Name = "Title",
    Size = UDim2.new(1, -120, 0, 23),
    Position = UDim2.fromOffset(16, 6),
    BackgroundTransparency = 1,
    Text = Config.Name,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 17,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    Parent = TitleBar
})

local Subtitle = Create("TextLabel", {
    Name = "Subtitle",
    Size = UDim2.new(1, -120, 0, 14),
    Position = UDim2.fromOffset(17, 28),
    BackgroundTransparency = 1,
    Text = "Luau execution environment",
    TextColor3 = Color3.fromRGB(225, 245, 255),
    TextTransparency = 0.15,
    TextSize = 10,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    Parent = TitleBar
})

local MinimizeButton = Create("TextButton", {
    Name = "MinimizeButton",
    Size = UDim2.fromOffset(32, 32),
    Position = UDim2.new(1, -72, 0.5, -16),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.88,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "—",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    ZIndex = 7,
    Parent = TitleBar
})

AddCorner(MinimizeButton, 9)

local ExpandButton = Create("TextButton", {
    Name = "ExpandButton",
    Size = UDim2.fromOffset(32, 32),
    Position = UDim2.new(1, -72, 0.5, -16),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.88,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "□",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    Visible = false,
    ZIndex = 7,
    Parent = TitleBar
})

AddCorner(ExpandButton, 9)

local CloseButton = Create("TextButton", {
    Name = "CloseButton",
    Size = UDim2.fromOffset(32, 32),
    Position = UDim2.new(1, -38, 0.5, -16),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.88,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "×",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 19,
    Font = Enum.Font.GothamBold,
    ZIndex = 7,
    Parent = TitleBar
})

AddCorner(CloseButton, 9)

local Content = Create("CanvasGroup", {
    Name = "Content",
    Size = UDim2.new(1, 0, 1, -50),
    Position = UDim2.fromOffset(0, 50),
    BackgroundColor3 = Config.Colors.Background,
    BackgroundTransparency = 0,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    GroupTransparency = 0,
    ZIndex = 3,
    Parent = Window
})

AddCorner(Content, 14)

local Sidebar = Create("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, 135, 1, 0),
    BackgroundColor3 = Config.Colors.Surface,
    BorderSizePixel = 0,
    ZIndex = 4,
    Parent = Content
})

local SidebarPadding = Create("UIPadding", {
    PaddingTop = UDim.new(0, 12),
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8),
    Parent = Sidebar
})

local Navigation = Create("Frame", {
    Name = "Navigation",
    Size = UDim2.new(1, 0, 0, 121),
    BackgroundTransparency = 1,
    Parent = Sidebar
})

local NavigationLayout = Create("UIListLayout", {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = Navigation
})

local ExecutionButton = Create("TextButton", {
    Name = "Execution",
    Size = UDim2.new(1, 0, 0, 38),
    LayoutOrder = 1,
    BackgroundColor3 = Config.Colors.Accent,
    BackgroundTransparency = 0,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "Execution",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 13,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Navigation
})

AddCorner(ExecutionButton, 9)

Create("UIPadding", {
    PaddingLeft = UDim.new(0, 11),
    Parent = ExecutionButton
})

local ScriptBloxButton = Create("TextButton", {
    Name = "ScriptBlox",
    Size = UDim2.new(1, 0, 0, 38),
    LayoutOrder = 2,
    BackgroundColor3 = Config.Colors.Surface,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "ScriptBlox",
    TextColor3 = Config.Colors.SecondaryText,
    TextSize = 13,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Navigation
})

AddCorner(ScriptBloxButton, 9)

Create("UIPadding", {
    PaddingLeft = UDim.new(0, 11),
    Parent = ScriptBloxButton
})

local SettingsButton = Create("TextButton", {
    Name = "Settings",
    Size = UDim2.new(1, 0, 0, 38),
    LayoutOrder = 3,
    BackgroundColor3 = Config.Colors.Surface,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "Settings",
    TextColor3 = Config.Colors.SecondaryText,
    TextSize = 13,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Navigation
})

AddCorner(SettingsButton, 9)

Create("UIPadding", {
    PaddingLeft = UDim.new(0, 11),
    Parent = SettingsButton
})

local Creator = Create("TextLabel", {
    Name = "Creator",
    Size = UDim2.new(1, -16, 0, 35),
    Position = UDim2.new(0, 8, 1, -47),
    BackgroundTransparency = 1,
    Text = "Made by x_c00lkidd_x",
    TextColor3 = Config.Colors.MutedText,
    TextSize = 9,
    Font = Enum.Font.Gotham,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Sidebar
})

local MainArea = Create("Frame", {
    Name = "MainArea",
    Size = UDim2.new(1, -135, 1, 0),
    Position = UDim2.fromOffset(135, 0),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    Parent = Content
})

local ExecutionPage = Create("CanvasGroup", {
    Name = "ExecutionPage",
    Size = UDim2.fromScale(1, 1),
    Position = UDim2.fromScale(0, 0),
    BackgroundTransparency = 1,
    GroupTransparency = 0,
    ClipsDescendants = true,
    Parent = MainArea
})

local ExecutionScroll = Create("ScrollingFrame", {
    Name = "ExecutionScroll",
    Size = UDim2.fromScale(1, 1),
    Position = UDim2.fromScale(0, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.fromOffset(0, 0),
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Config.Colors.Border,
    ScrollBarImageTransparency = 0.15,
    ScrollingEnabled = true,
    ClipsDescendants = true,
    AutomaticCanvasSize = Enum.AutomaticSize.None,
    Parent = ExecutionPage
})

local ExecutionContent = Create("Frame", {
    Name = "ExecutionContent",
    Size = UDim2.new(1, -8, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    Parent = ExecutionScroll
})

local ExecutionLayout = Create("UIListLayout", {
    Padding = UDim.new(0, 10),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = ExecutionContent
})

Create("UIPadding", {
    PaddingLeft = UDim.new(0, 14),
    PaddingRight = UDim.new(0, 8),
    PaddingTop = UDim.new(0, 11),
    PaddingBottom = UDim.new(0, 12),
    Parent = ExecutionContent
})

local ExecutionScale = Create("UIScale", {
    Scale = 1,
    Parent = ExecutionPage
})

local PageTitle = Create("TextLabel", {
    Size = UDim2.new(1, -32, 0, 26),
    LayoutOrder = 1,
    BackgroundTransparency = 1,
    Text = "Execution",
    TextColor3 = Config.Colors.Text,
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ExecutionContent
})

local PageDescription = Create("TextLabel", {
    Size = UDim2.new(1, -32, 0, 18),
    LayoutOrder = 2,
    BackgroundTransparency = 1,
    Text = "Write and execute Luau code.",
    TextColor3 = Config.Colors.SecondaryText,
    TextSize = 11,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ExecutionContent
})

local EditorCard = Create("Frame", {
    Name = "EditorCard",
    Size = UDim2.new(1, 0, 0, 205),
    LayoutOrder = 3,
    BackgroundColor3 = Color3.fromRGB(10, 12, 15),
    BorderSizePixel = 0,
    Parent = ExecutionContent
})

AddCorner(EditorCard, 10)
AddStroke(EditorCard, Config.Colors.Border, 1, 0.25)

local EditorHeader = Create("Frame", {
    Name = "EditorHeader",
    Size = UDim2.new(1, 0, 0, 31),
    BackgroundColor3 = Config.Colors.Surface,
    BackgroundTransparency = 0.25,
    BorderSizePixel = 0,
    Parent = EditorCard
})

AddCorner(EditorHeader, 10)

local EditorHeaderFill = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 1, -12),
    BackgroundColor3 = Config.Colors.Surface,
    BackgroundTransparency = 0.25,
    BorderSizePixel = 0,
    Parent = EditorHeader
})

local EditorTitle = Create("TextLabel", {
    Size = UDim2.new(0.5, -10, 1, 0),
    Position = UDim2.fromOffset(11, 0),
    BackgroundTransparency = 1,
    Text = "CODE",
    TextColor3 = Config.Colors.Text,
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = EditorHeader
})

local LineCount = Create("TextLabel", {
    Size = UDim2.new(0.5, -10, 1, 0),
    Position = UDim2.new(0.5, 0, 0, 0),
    BackgroundTransparency = 1,
    Text = "0 lines",
    TextColor3 = Config.Colors.MutedText,
    TextSize = 9,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Right,
    Parent = EditorHeader
})

local EditorScroll = Create("ScrollingFrame", {
    Name = "EditorScroll",
    Size = UDim2.new(1, -2, 1, -32),
    Position = UDim2.fromOffset(1, 32),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.fromOffset(0, 0),
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Config.Colors.Border,
    ScrollBarImageTransparency = 0.15,
    ScrollingEnabled = true,
    AutomaticCanvasSize = Enum.AutomaticSize.None,
    Parent = EditorCard
})

local Editor = Create("TextBox", {
    Name = "Editor",
    Size = UDim2.new(1, -22, 0, 170),
    AutomaticSize = Enum.AutomaticSize.Y,
    Position = UDim2.fromOffset(11, 9),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ClearTextOnFocus = false,
    MultiLine = true,
    Text = "",
    PlaceholderText = "Enter Luau code...",
    PlaceholderColor3 = Color3.fromRGB(75, 80, 90),
    TextColor3 = Config.Colors.Text,
    TextSize = 13,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = false,
    Parent = EditorScroll
})

Create("UIPadding", {
    PaddingTop = UDim.new(0, 1),
    PaddingBottom = UDim.new(0, 12),
    PaddingLeft = UDim.new(0, 1),
    PaddingRight = UDim.new(0, 1),
    Parent = Editor
})

local EditorScrollUpdate = BindInnerScroll(EditorScroll, Editor)

local ActionBar = Create("Frame", {
    Name = "ActionBar",
    Size = UDim2.new(1, 0, 0, 36),
    LayoutOrder = 4,
    BackgroundTransparency = 1,
    Parent = ExecutionContent
})

local ActionLayout = Create("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = ActionBar
})

local ExecuteButton = Create("TextButton", {
    Name = "Execute",
    Size = UDim2.fromOffset(105, 36),
    LayoutOrder = 1,
    BackgroundColor3 = Config.Colors.Accent,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "Execute",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    Parent = ActionBar
})

AddCorner(ExecuteButton, 9)

local ClearButton = Create("TextButton", {
    Name = "Clear",
    Size = UDim2.fromOffset(105, 36),
    LayoutOrder = 2,
    BackgroundColor3 = Config.Colors.SurfaceLight,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "Clear",
    TextColor3 = Config.Colors.Text,
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    Parent = ActionBar
})

AddCorner(ClearButton, 9)
AddStroke(ClearButton, Config.Colors.Border, 1, 0.2)

local ExecutionStatus = Create("TextLabel", {
    Name = "ExecutionStatus",
    Size = UDim2.new(1, -230, 0, 36),
    LayoutOrder = 3,
    BackgroundTransparency = 1,
    Text = "Ready",
    TextColor3 = Config.Colors.MutedText,
    TextSize = 9,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    Parent = ActionBar
})

local OutputCard = Create("Frame", {
    Name = "OutputCard",
    Size = UDim2.new(1, 0, 0, 145),
    LayoutOrder = 5,
    BackgroundColor3 = Color3.fromRGB(10, 12, 15),
    BorderSizePixel = 0,
    Parent = ExecutionContent
})

AddCorner(OutputCard, 10)
AddStroke(OutputCard, Config.Colors.Border, 1, 0.25)

local OutputHeader = Create("Frame", {
    Name = "OutputHeader",
    Size = UDim2.new(1, 0, 0, 31),
    BackgroundColor3 = Config.Colors.Surface,
    BackgroundTransparency = 0.25,
    BorderSizePixel = 0,
    Parent = OutputCard
})

AddCorner(OutputHeader, 10)

local OutputHeaderFill = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 1, -12),
    BackgroundColor3 = Config.Colors.Surface,
    BackgroundTransparency = 0.25,
    BorderSizePixel = 0,
    Parent = OutputHeader
})

local OutputTitle = Create("TextLabel", {
    Size = UDim2.new(0.5, -10, 1, 0),
    Position = UDim2.fromOffset(11, 0),
    BackgroundTransparency = 1,
    Text = "OUTPUT",
    TextColor3 = Config.Colors.Text,
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = OutputHeader
})

local OutputStatus = Create("TextLabel", {
    Size = UDim2.new(0.5, -10, 1, 0),
    Position = UDim2.new(0.5, 0, 0, 0),
    BackgroundTransparency = 1,
    Text = "Ready",
    TextColor3 = Config.Colors.MutedText,
    TextSize = 9,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Right,
    Parent = OutputHeader
})

local OutputScroll = Create("ScrollingFrame", {
    Name = "OutputScroll",
    Size = UDim2.new(1, -2, 1, -32),
    Position = UDim2.fromOffset(1, 32),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.fromOffset(0, 0),
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Config.Colors.Border,
    ScrollBarImageTransparency = 0.15,
    ScrollingEnabled = true,
    AutomaticCanvasSize = Enum.AutomaticSize.None,
    Parent = OutputCard
})

local Output = Create("TextLabel", {
    Name = "Output",
    Size = UDim2.new(1, -22, 0, 80),
    AutomaticSize = Enum.AutomaticSize.Y,
    Position = UDim2.fromOffset(11, 8),
    BackgroundTransparency = 1,
    Text = "[ 007n7's hub ] Ready.",
    TextColor3 = Config.Colors.SecondaryText,
    TextSize = 10,
    Font = Enum.Font.Code,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    Parent = OutputScroll
})

local OutputScrollUpdate = BindInnerScroll(OutputScroll, Output)

local function CountLines(Source)
    if Source == "" then
        return 0
    end

    local _, Count = Source:gsub("\n", "")

    return Count + 1
end

local function UpdateLineCount()
    local Count = CountLines(Editor.Text)

    if Count == 1 then
        LineCount.Text = "1 line"
    else
        LineCount.Text = tostring(Count) .. " lines"
    end

    task.defer(EditorScrollUpdate)
end

local function SetOutput(Text, Color, Status)
    Output.Text = Text
    Output.TextColor3 = Color or Config.Colors.SecondaryText
    OutputStatus.Text = Status or "Ready"

    task.defer(function()
        OutputScrollUpdate()

        OutputScroll.CanvasPosition = Vector2.new(
            0,
            math.max(0, OutputScroll.AbsoluteCanvasSize.Y)
        )
    end)
end

local function ExecuteScript()
    local Source = Editor.Text

    if Source:match("^%s*$") then
        SetOutput(
            "[ 007n7's hub ] Nothing to execute.",
            Config.Colors.Warning,
            "Empty"
        )

        ExecutionStatus.Text = "Nothing to execute"
        ExecutionStatus.TextColor3 = Config.Colors.Warning

        return
    end

    local Loader = loadstring

    if type(Loader) ~= "function" then
        SetOutput(
            "[ 007n7's hub ] loadstring is unavailable.",
            Config.Colors.Error,
            "Unavailable"
        )

        ExecutionStatus.Text = "loadstring unavailable"
        ExecutionStatus.TextColor3 = Config.Colors.Error

        return
    end

    ExecutionStatus.Text = "Compiling..."
    ExecutionStatus.TextColor3 = Config.Colors.Accent
    OutputStatus.Text = "Compiling"

    local Started = os.clock()

    local CompileSuccess, Function, CompileError = pcall(function()
        return Loader(Source)
    end)

    if not CompileSuccess then
        local Message = tostring(Function)

        SetOutput(
            "[ COMPILE ERROR ]\n\n" .. Message,
            Config.Colors.Error,
            "Compile error"
        )

        ExecutionStatus.Text = "Compile error"
        ExecutionStatus.TextColor3 = Config.Colors.Error

        return
    end

    if not Function then
        local Message = tostring(CompileError)

        SetOutput(
            "[ COMPILE ERROR ]\n\n" .. Message,
            Config.Colors.Error,
            "Compile error"
        )

        ExecutionStatus.Text = "Compile error"
        ExecutionStatus.TextColor3 = Config.Colors.Error

        return
    end

    ExecutionStatus.Text = "Executing..."
    ExecutionStatus.TextColor3 = Config.Colors.Accent
    OutputStatus.Text = "Executing"

    local ExecutionSuccess, Result = pcall(Function)
    local Duration = os.clock() - Started

    if not ExecutionSuccess then
        local Message = tostring(Result)

        SetOutput(
            "[ EXECUTION ERROR ]\n\n"
                .. Message
                .. "\n\nDuration: "
                .. string.format("%.3fs", Duration),
            Config.Colors.Error,
            "Execution error"
        )

        ExecutionStatus.Text = "Execution error"
        ExecutionStatus.TextColor3 = Config.Colors.Error

        return
    end

    local ResultText = ""

    if Result ~= nil then
        ResultText = "\n\nResult:\n" .. tostring(Result)
    end

    SetOutput(
        "[ SUCCESS ]\n\nCode executed successfully.\n\nDuration: "
            .. string.format("%.3fs", Duration)
            .. ResultText,
        Config.Colors.Success,
        "Success"
    )

    ExecutionStatus.Text = "Executed in " .. string.format("%.3fs", Duration)
    ExecutionStatus.TextColor3 = Config.Colors.Success
end

local function ClearExecution()
    Editor.Text = ""

    SetOutput(
        "[ 007n7's hub ] Output cleared.",
        Config.Colors.SecondaryText,
        "Cleared"
    )

    ExecutionStatus.Text = "Ready"
    ExecutionStatus.TextColor3 = Config.Colors.MutedText

    UpdateLineCount()
end

Editor:GetPropertyChangedSignal("Text"):Connect(UpdateLineCount)

ExecuteButton.MouseButton1Click:Connect(function()
    ExecuteScript()
end)

ClearButton.MouseButton1Click:Connect(function()
    ClearExecution()
end)

UserInputService.InputBegan:Connect(function(Input, Processed)
    if Processed then
        return
    end

    if not Editor:IsFocused() then
        return
    end

    if Input.KeyCode == Enum.KeyCode.Return
        and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        ExecuteScript()
        return
    end
end)

local ScriptBloxPage = Create("CanvasGroup", {
    Name = "ScriptBloxPage",
    Size = UDim2.fromScale(1, 1),
    Position = UDim2.fromScale(1, 0),
    BackgroundTransparency = 1,
    GroupTransparency = 1,
    Visible = false,
    ClipsDescendants = true,
    Parent = MainArea
})

local ScriptBloxScale = Create("UIScale", {
    Scale = 1,
    Parent = ScriptBloxPage
})

local ScriptBloxTitle = Create("TextLabel", {
    Size = UDim2.new(1, -32, 0, 26),
    Position = UDim2.fromOffset(16, 14),
    BackgroundTransparency = 1,
    Text = "ScriptBlox",
    TextColor3 = Config.Colors.Text,
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ScriptBloxPage
})

local ScriptBloxDescription = Create("TextLabel", {
    Size = UDim2.new(1, -32, 0, 18),
    Position = UDim2.fromOffset(16, 39),
    BackgroundTransparency = 1,
    Text = "Search and load scripts from ScriptBlox.",
    TextColor3 = Config.Colors.SecondaryText,
    TextSize = 11,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ScriptBloxPage
})

local ScriptBloxSearchBar = Create("Frame", {
    Name = "SearchBar",
    Size = UDim2.new(1, -32, 0, 42),
    Position = UDim2.fromOffset(16, 68),
    BackgroundColor3 = Config.Colors.Surface,
    BorderSizePixel = 0,
    Parent = ScriptBloxPage
})

AddCorner(ScriptBloxSearchBar, 10)
AddStroke(ScriptBloxSearchBar, Config.Colors.Border, 1, 0.3)

local ScriptBloxSearchBox = Create("TextBox", {
    Name = "SearchBox",
    Size = UDim2.new(1, -105, 1, 0),
    Position = UDim2.fromOffset(12, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ClearTextOnFocus = false,
    Text = "",
    PlaceholderText = "Search ScriptBlox...",
    PlaceholderColor3 = Config.Colors.MutedText,
    TextColor3 = Config.Colors.Text,
    TextSize = 11,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ScriptBloxSearchBar
})

local ScriptBloxSearchButton = Create("TextButton", {
    Name = "Search",
    Size = UDim2.fromOffset(82, 32),
    Position = UDim2.new(1, -88, 0.5, -16),
    BackgroundColor3 = Config.Colors.Accent,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "Search",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    Parent = ScriptBloxSearchBar
})

AddCorner(ScriptBloxSearchButton, 8)

local ScriptBloxStatus = Create("TextLabel", {
    Size = UDim2.new(1, -32, 0, 18),
    Position = UDim2.fromOffset(16, 116),
    BackgroundTransparency = 1,
    Text = "Enter a search query.",
    TextColor3 = Config.Colors.MutedText,
    TextSize = 9,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ScriptBloxPage
})

local ScriptBloxResultsScroll = Create("ScrollingFrame", {
    Name = "ResultsScroll",
    Size = UDim2.new(1, -32, 1, -180),
    Position = UDim2.fromOffset(16, 140),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.fromOffset(0, 0),
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Config.Colors.Border,
    ScrollBarImageTransparency = 0.15,
    ScrollingEnabled = true,
    AutomaticCanvasSize = Enum.AutomaticSize.None,
    ClipsDescendants = true,
    Parent = ScriptBloxPage
})

local ScriptBloxResults = Create("Frame", {
    Name = "Results",
    Size = UDim2.new(1, -8, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    Parent = ScriptBloxResultsScroll
})

local ScriptBloxResultsLayout = Create("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = ScriptBloxResults
})

Create("UIPadding", {
    PaddingBottom = UDim.new(0, 12),
    Parent = ScriptBloxResults
})

local ScriptBloxPowered = Create("TextLabel", {
    Size = UDim2.new(1, -32, 0, 16),
    Position = UDim2.new(0, 16, 1, -20),
    BackgroundTransparency = 1,
    Text = "Powered by ScriptBlox.com",
    TextColor3 = Config.Colors.MutedText,
    TextSize = 8,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Right,
    Parent = ScriptBloxPage
})

local ScriptBloxPageLabel = Create("TextLabel", {
    Size = UDim2.fromOffset(90, 28),
    Position = UDim2.new(0, 16, 1, -40),
    BackgroundTransparency = 1,
    Text = "Page 1",
    TextColor3 = Config.Colors.MutedText,
    TextSize = 9,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ScriptBloxPage
})

local ScriptBloxPrevious = Create("TextButton", {
    Name = "Previous",
    Size = UDim2.fromOffset(82, 28),
    Position = UDim2.new(1, -190, 1, -40),
    BackgroundColor3 = Config.Colors.SurfaceLight,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "Previous",
    TextColor3 = Config.Colors.Text,
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    Parent = ScriptBloxPage
})

AddCorner(ScriptBloxPrevious, 8)
AddStroke(ScriptBloxPrevious, Config.Colors.Border, 1, 0.2)

local ScriptBloxNext = Create("TextButton", {
    Name = "Next",
    Size = UDim2.fromOffset(82, 28),
    Position = UDim2.new(1, -100, 1, -40),
    BackgroundColor3 = Config.Colors.SurfaceLight,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "Next",
    TextColor3 = Config.Colors.Text,
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    Parent = ScriptBloxPage
})

AddCorner(ScriptBloxNext, 8)
AddStroke(ScriptBloxNext, Config.Colors.Border, 1, 0.2)

local ScriptBloxCurrentPage = 1
local ScriptBloxTotalPages = 1
local ScriptBloxSearching = false

local function UpdateScriptBloxScroll()
    local Height = ScriptBloxResultsLayout.AbsoluteContentSize.Y + 16
    local Viewport = ScriptBloxResultsScroll.AbsoluteSize.Y

    ScriptBloxResultsScroll.CanvasSize = UDim2.fromOffset(
        0,
        math.max(Height, Viewport)
    )
end

ScriptBloxResultsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
    UpdateScriptBloxScroll
)

ScriptBloxResultsScroll:GetPropertyChangedSignal("AbsoluteSize"):Connect(
    UpdateScriptBloxScroll
)

local function ClearScriptBloxResults()
    for _, Child in ipairs(ScriptBloxResults:GetChildren()) do
        if Child:IsA("GuiObject") and Child ~= ScriptBloxResultsLayout then
            Child:Destroy()
        end
    end
end

local function FormatViews(Views)
    Views = tonumber(Views) or 0

    if Views >= 1000000 then
        return string.format("%.1fM", Views / 1000000)
    end

    if Views >= 1000 then
        return string.format("%.1fK", Views / 1000)
    end

    return tostring(Views)
end

local function SetEditorSource(Source)
    Editor.Text = Source or ""
    UpdateLineCount()
    EditorScroll.CanvasPosition = Vector2.zero
end

local function CopyToClipboard(Source)
    if type(setclipboard) ~= "function" then
        return false
    end

    local Success = pcall(function()
        setclipboard(Source)
    end)

    return Success
end

local function CreateScriptBloxCard(ScriptData, Index)
    local Card = Create("Frame", {
        Name = "Script_" .. tostring(Index),
        Size = UDim2.new(1, 0, 0, 112),
        BackgroundColor3 = Config.Colors.Surface,
        BorderSizePixel = 0,
        LayoutOrder = Index,
        Parent = ScriptBloxResults
    })

    AddCorner(Card, 10)
    AddStroke(Card, Config.Colors.Border, 1, 0.3)

    local Title = Create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 21),
        Position = UDim2.fromOffset(12, 10),
        BackgroundTransparency = 1,
        Text = tostring(ScriptData.title or "Untitled"),
        TextColor3 = Config.Colors.Text,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Card
    })

    local GameName = "Universal"

    if ScriptData.game and ScriptData.game.name then
        GameName = tostring(ScriptData.game.name)
    end

    local Info = Create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 18),
        Position = UDim2.fromOffset(12, 32),
        BackgroundTransparency = 1,
        Text = GameName
            .. "  •  "
            .. FormatViews(ScriptData.views)
            .. " views",
        TextColor3 = Config.Colors.SecondaryText,
        TextSize = 9,
        Font = Enum.Font.Code,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Card
    })

    local Tags = {}

    if ScriptData.verified then
        table.insert(Tags, "Verified")
    end

    if ScriptData.isUniversal then
        table.insert(Tags, "Universal")
    end

    if ScriptData.key then
        table.insert(Tags, "Key")
    else
        table.insert(Tags, "No Key")
    end

    if ScriptData.isPatched then
        table.insert(Tags, "Patched")
    else
        table.insert(Tags, "Working")
    end

    local TagText = table.concat(Tags, "  •  ")

    local Metadata = Create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 17),
        Position = UDim2.fromOffset(12, 51),
        BackgroundTransparency = 1,
        Text = TagText,
        TextColor3 = Config.Colors.MutedText,
        TextSize = 8,
        Font = Enum.Font.Code,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Card
    })

    local LoadButton = Create("TextButton", {
        Name = "Load",
        Size = UDim2.fromOffset(74, 27),
        Position = UDim2.new(1, -164, 1, -38),
        BackgroundColor3 = Config.Colors.Accent,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "Load",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        Parent = Card
    })

    AddCorner(LoadButton, 7)

    local CopyButton = Create("TextButton", {
        Name = "Copy",
        Size = UDim2.fromOffset(74, 27),
        Position = UDim2.new(1, -82, 1, -38),
        BackgroundColor3 = Config.Colors.SurfaceLight,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "Copy",
        TextColor3 = Config.Colors.Text,
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        Parent = Card
    })

    AddCorner(CopyButton, 7)
    AddStroke(CopyButton, Config.Colors.Border, 1, 0.2)

    LoadButton.MouseEnter:Connect(function()
        Tween(LoadButton, 0.15, {
            BackgroundColor3 = Config.Colors.AccentHover
        })
    end)

    LoadButton.MouseLeave:Connect(function()
        Tween(LoadButton, 0.15, {
            BackgroundColor3 = Config.Colors.Accent
        })
    end)

    CopyButton.MouseEnter:Connect(function()
        Tween(CopyButton, 0.15, {
            BackgroundColor3 = Config.Colors.Border
        })
    end)

    CopyButton.MouseLeave:Connect(function()
        Tween(CopyButton, 0.15, {
            BackgroundColor3 = Config.Colors.SurfaceLight
        })
    end)

    LoadButton.MouseButton1Click:Connect(function()
        local Source = tostring(ScriptData.script or "")

        if Source == "" then
            ScriptBloxStatus.Text = "This script has no source code."
            ScriptBloxStatus.TextColor3 = Config.Colors.Warning
            return
        end

        SetEditorSource(Source)

        ScriptBloxStatus.Text =
            "Loaded: "
            .. tostring(ScriptData.title or "Untitled")

        ScriptBloxStatus.TextColor3 = Config.Colors.Success

        SwitchPage("Execution")
    end)

    CopyButton.MouseButton1Click:Connect(function()
        local Source = tostring(ScriptData.script or "")

        if Source == "" then
            ScriptBloxStatus.Text = "This script has no source code."
            ScriptBloxStatus.TextColor3 = Config.Colors.Warning
            return
        end

        if CopyToClipboard(Source) then
            ScriptBloxStatus.Text =
                "Copied: "
                .. tostring(ScriptData.title or "Untitled")

            ScriptBloxStatus.TextColor3 = Config.Colors.Success
        else
            ScriptBloxStatus.Text = "Clipboard is unavailable."
            ScriptBloxStatus.TextColor3 = Config.Colors.Warning
        end
    end)

    return Card
end

local function SearchScriptBlox(Page)
    if ScriptBloxSearching then
        return
    end

    local Query = ScriptBloxSearchBox.Text

    if Query:match("^%s*$") then
        ScriptBloxStatus.Text = "Enter a search query."
        ScriptBloxStatus.TextColor3 = Config.Colors.Warning
        return
    end

    ScriptBloxSearching = true

    ScriptBloxStatus.Text = "Searching ScriptBlox..."
    ScriptBloxStatus.TextColor3 = Config.Colors.Accent

    ClearScriptBloxResults()

    local EncodedQuery = HttpService:UrlEncode(Query)

    local Url =
        "https://scriptblox.com/api/script/search?q="
        .. EncodedQuery
        .. "&page="
        .. tostring(Page)
        .. "&max=20"

    local Success, Response = pcall(function()
        return game:HttpGet(Url)
    end)

    if not Success then
        ScriptBloxSearching = false
        ScriptBloxStatus.Text =
            "Request failed: "
            .. tostring(Response)

        ScriptBloxStatus.TextColor3 = Config.Colors.Error

        return
    end

    local DecodeSuccess, Data = pcall(function()
        return HttpService:JSONDecode(Response)
    end)

    if not DecodeSuccess or type(Data) ~= "table" then
        ScriptBloxSearching = false
        ScriptBloxStatus.Text = "Invalid ScriptBlox response."
        ScriptBloxStatus.TextColor3 = Config.Colors.Error

        return
    end

    if Data.message then
        ScriptBloxSearching = false
        ScriptBloxStatus.Text = tostring(Data.message)
        ScriptBloxStatus.TextColor3 = Config.Colors.Error

        return
    end

    local Result = Data.result

    if type(Result) ~= "table" then
        ScriptBloxSearching = false
        ScriptBloxStatus.Text = "No results returned."
        ScriptBloxStatus.TextColor3 = Config.Colors.Warning

        return
    end

    local Scripts = Result.scripts

    if type(Scripts) ~= "table" or #Scripts == 0 then
        ScriptBloxSearching = false

        ScriptBloxTotalPages =
            tonumber(Result.totalPages) or 1

        ScriptBloxCurrentPage = Page
        ScriptBloxPageLabel.Text =
            "Page "
            .. tostring(Page)

        ScriptBloxStatus.Text = "No scripts found."
        ScriptBloxStatus.TextColor3 = Config.Colors.Warning

        ScriptBloxPrevious.Active = Page > 1
        ScriptBloxNext.Active = Page < ScriptBloxTotalPages

        UpdateScriptBloxScroll()

        return
    end

    ScriptBloxCurrentPage = Page

    ScriptBloxTotalPages =
        tonumber(Result.totalPages) or Page

    for Index, ScriptData in ipairs(Scripts) do
        CreateScriptBloxCard(ScriptData, Index)
    end

    ScriptBloxPageLabel.Text =
        "Page "
        .. tostring(ScriptBloxCurrentPage)
        .. " / "
        .. tostring(ScriptBloxTotalPages)

    ScriptBloxStatus.Text =
        tostring(#Scripts)
        .. " scripts found."

    ScriptBloxStatus.TextColor3 =
        Config.Colors.SecondaryText

    ScriptBloxPrevious.Active =
        ScriptBloxCurrentPage > 1

    ScriptBloxNext.Active =
        ScriptBloxCurrentPage < ScriptBloxTotalPages

    UpdateScriptBloxScroll()

    ScriptBloxSearching = false
end

ScriptBloxSearchButton.MouseEnter:Connect(function()
    Tween(ScriptBloxSearchButton, 0.15, {
        BackgroundColor3 = Config.Colors.AccentHover
    })
end)

ScriptBloxSearchButton.MouseLeave:Connect(function()
    Tween(ScriptBloxSearchButton, 0.15, {
        BackgroundColor3 = Config.Colors.Accent
    })
end)

ScriptBloxSearchButton.MouseButton1Click:Connect(function()
    ScriptBloxCurrentPage = 1
    SearchScriptBlox(1)
end)

ScriptBloxSearchBox.FocusLost:Connect(function(EnterPressed)
    if EnterPressed then
        ScriptBloxCurrentPage = 1
        SearchScriptBlox(1)
    end
end)

ScriptBloxPrevious.MouseButton1Click:Connect(function()
    if ScriptBloxSearching then
        return
    end

    if ScriptBloxCurrentPage <= 1 then
        return
    end

    SearchScriptBlox(ScriptBloxCurrentPage - 1)
end)

ScriptBloxNext.MouseButton1Click:Connect(function()
    if ScriptBloxSearching then
        return
    end

    if ScriptBloxCurrentPage >= ScriptBloxTotalPages then
        return
    end

    SearchScriptBlox(ScriptBloxCurrentPage + 1)
end)

local SettingsPage = Create("CanvasGroup", {
    Name = "SettingsPage",
    Size = UDim2.fromScale(1, 1),
    Position = UDim2.fromScale(1, 0),
    BackgroundTransparency = 1,
    GroupTransparency = 1,
    Visible = false,
    ClipsDescendants = true,
    Parent = MainArea
})

local SettingsScale = Create("UIScale", {
    Scale = 1,
    Parent = SettingsPage
})

local SettingsTitle = Create("TextLabel", {
    Size = UDim2.new(1, -32, 0, 26),
    Position = UDim2.fromOffset(16, 14),
    BackgroundTransparency = 1,
    Text = "Settings",
    TextColor3 = Config.Colors.Text,
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = SettingsPage
})

local SettingsDescription = Create("TextLabel", {
    Size = UDim2.new(1, -32, 0, 18),
    Position = UDim2.fromOffset(16, 39),
    BackgroundTransparency = 1,
    Text = "Configure your 007n7's hub experience.",
    TextColor3 = Config.Colors.SecondaryText,
    TextSize = 11,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = SettingsPage
})

local SettingsScroll = Create("ScrollingFrame", {
    Name = "SettingsScroll",
    Size = UDim2.new(1, -28, 1, -58),
    Position = UDim2.fromOffset(14, 58),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.fromOffset(0, 0),
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Config.Colors.Border,
    ScrollBarImageTransparency = 0.15,
    ScrollingEnabled = true,
    ClipsDescendants = true,
    AutomaticCanvasSize = Enum.AutomaticSize.None,
    Parent = SettingsPage
})

local SettingsContent = Create("Frame", {
    Name = "SettingsContent",
    Size = UDim2.new(1, -8, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    Parent = SettingsScroll
})

local SettingsLayout = Create("UIListLayout", {
    Padding = UDim.new(0, 10),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = SettingsContent
})

Create("UIPadding", {
    PaddingRight = UDim.new(0, 8),
    PaddingBottom = UDim.new(0, 12),
    Parent = SettingsContent
})

local AboutCard = Create("Frame", {
    Name = "AboutCard",
    Size = UDim2.new(1, 0, 0, 110),
    LayoutOrder = 1,
    BackgroundColor3 = Config.Colors.Surface,
    BorderSizePixel = 0,
    Parent = SettingsContent
})

AddCorner(AboutCard, 10)
AddStroke(AboutCard, Config.Colors.Border, 1, 0.35)

local AboutTitle = Create("TextLabel", {
    Size = UDim2.new(1, -24, 0, 22),
    Position = UDim2.fromOffset(12, 12),
    BackgroundTransparency = 1,
    Text = Config.Name,
    TextColor3 = Config.Colors.Text,
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = AboutCard
})

local AboutVersion = Create("TextLabel", {
    Size = UDim2.new(1, -24, 0, 18),
    Position = UDim2.fromOffset(12, 38),
    BackgroundTransparency = 1,
    Text = "Version " .. Config.Version,
    TextColor3 = Config.Colors.SecondaryText,
    TextSize = 11,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = AboutCard
})

local AboutCreator = Create("TextLabel", {
    Size = UDim2.new(1, -24, 0, 18),
    Position = UDim2.fromOffset(12, 62),
    BackgroundTransparency = 1,
    Text = "Made by " .. Config.Creator,
    TextColor3 = Config.Colors.SecondaryText,
    TextSize = 11,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = AboutCard
})

local CoreGuardCard = Create("Frame", {
    Name = "CoreGuardCard",
    Size = UDim2.new(1, 0, 0, 190),
    LayoutOrder = 2,
    BackgroundColor3 = Config.Colors.Surface,
    BorderSizePixel = 0,
    Parent = SettingsContent
})

AddCorner(CoreGuardCard, 10)
AddStroke(CoreGuardCard, Config.Colors.Border, 1, 0.35)

local CoreGuardTitle = Create("TextLabel", {
    Size = UDim2.new(1, -24, 0, 22),
    Position = UDim2.fromOffset(12, 11),
    BackgroundTransparency = 1,
    Text = "CoreGuard",
    TextColor3 = Config.Colors.Text,
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = CoreGuardCard
})

local CoreGuardStatus = Create("TextLabel", {
    Size = UDim2.new(1, -24, 0, 18),
    Position = UDim2.fromOffset(12, 36),
    BackgroundTransparency = 1,
    Text = "Status: Checking...",
    TextColor3 = Config.Colors.SecondaryText,
    TextSize = 10,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = CoreGuardCard
})

local CoreGuardContainer = Create("TextLabel", {
    Size = UDim2.new(1, -24, 0, 18),
    Position = UDim2.fromOffset(12, 57),
    BackgroundTransparency = 1,
    Text = "Container: Checking...",
    TextColor3 = Config.Colors.SecondaryText,
    TextSize = 10,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = CoreGuardCard
})

local CoreGuardMonitor = Create("TextLabel", {
    Size = UDim2.new(1, -24, 0, 18),
    Position = UDim2.fromOffset(12, 78),
    BackgroundTransparency = 1,
    Text = "Monitor: Checking...",
    TextColor3 = Config.Colors.SecondaryText,
    TextSize = 10,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = CoreGuardCard
})

local CoreGuardFallback = Create("TextLabel", {
    Size = UDim2.new(1, -24, 0, 18),
    Position = UDim2.fromOffset(12, 99),
    BackgroundTransparency = 1,
    Text = "Fallback: Ready",
    TextColor3 = Config.Colors.SecondaryText,
    TextSize = 10,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = CoreGuardCard
})

local CoreGuardVersion = Create("TextLabel", {
    Size = UDim2.new(1, -24, 0, 18),
    Position = UDim2.fromOffset(12, 120),
    BackgroundTransparency = 1,
    Text = "Version " .. CoreGuard.Version,
    TextColor3 = Config.Colors.SecondaryText,
    TextSize = 10,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = CoreGuardCard
})

local CoreGuardRecover = Create("TextButton", {
    Name = "Recover",
    Size = UDim2.fromOffset(92, 30),
    Position = UDim2.new(1, -104, 1, -41),
    BackgroundColor3 = Config.Colors.SurfaceLight,
    BackgroundTransparency = 0,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "Recover",
    TextColor3 = Config.Colors.Text,
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    Parent = CoreGuardCard
})

AddCorner(CoreGuardRecover, 8)
AddStroke(CoreGuardRecover, Config.Colors.Border, 1, 0.2)

local function UpdateCoreGuardStatus()
    local UsingCoreGui = CoreGuard:IsUsingCoreGui()
    local MonitorActive = CoreGuard:IsMonitoring()
    local Enabled = CoreGuard:IsEnabled()

    CoreGuardStatus.Text =
        "Status: "
        .. (Enabled and "Enabled" or "Disabled")

    CoreGuardContainer.Text =
        "Container: "
        .. (UsingCoreGui and "CoreGui" or "PlayerGui")

    CoreGuardMonitor.Text =
        "Monitor: "
        .. (MonitorActive and "Active" or "Inactive")

    CoreGuardFallback.Text =
        "Fallback: "
        .. (UsingCoreGui and "Ready" or "Active")

    if Enabled then
        CoreGuardStatus.TextColor3 = Config.Colors.Accent
    else
        CoreGuardStatus.TextColor3 = Config.Colors.MutedText
    end

    if UsingCoreGui then
        CoreGuardContainer.TextColor3 = Config.Colors.Accent
    else
        CoreGuardContainer.TextColor3 = Config.Colors.SecondaryText
    end

    CoreGuardMonitor.TextColor3 =
        MonitorActive
        and Config.Colors.Text
        or Config.Colors.MutedText

    CoreGuardFallback.TextColor3 =
        UsingCoreGui
        and Config.Colors.SecondaryText
        or Config.Colors.Accent
end

CoreGuardRecover.MouseEnter:Connect(function()
    Tween(CoreGuardRecover, 0.15, {
        BackgroundColor3 = Config.Colors.Border
    })
end)

CoreGuardRecover.MouseLeave:Connect(function()
    Tween(CoreGuardRecover, 0.15, {
        BackgroundColor3 = Config.Colors.SurfaceLight
    })
end)

CoreGuardRecover.MouseButton1Click:Connect(function()
    CoreGuardRecover.Active = false
    CoreGuardRecover.Text = "Recovering..."

    local Success = CoreGuard:Recover(ScreenGui)

    if Success then
        CoreGuardRecover.Text = "Recovered"
    else
        CoreGuardRecover.Text = "Failed"
    end

    UpdateCoreGuardStatus()

    task.delay(1.2, function()
        if CoreGuardRecover.Parent then
            CoreGuardRecover.Text = "Recover"
            CoreGuardRecover.Active = true
        end
    end)
end)

UpdateCoreGuardStatus()

local UpdateExecutionScroll = BindAutoScroll(
    ExecutionScroll,
    ExecutionContent,
    ExecutionLayout
)

local UpdateSettingsScroll = BindAutoScroll(
    SettingsScroll,
    SettingsContent,
    SettingsLayout
)

local MiniButton = Create("TextButton", {
    Name = "ReopenButton",
    Size = UDim2.fromOffset(
        Config.MinimizedSize,
        Config.MinimizedSize
    ),
    Position = UDim2.fromOffset(12, 12),
    BackgroundColor3 = Config.Colors.Accent,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "7",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    Visible = false,
    ZIndex = 100,
    Parent = ScreenGui
})

AddCorner(MiniButton, 8)

local MiniButtonStroke = AddStroke(
    MiniButton,
    Config.Colors.AccentHover,
    1,
    0.15
)

local Dragging = false
local DragStart
local StartPosition

TitleBar.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = Input.Position
        StartPosition = Window.Position

        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not Dragging then
        return
    end

    if Input.UserInputType ~= Enum.UserInputType.MouseMovement
        and Input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local Delta = Input.Position - DragStart

    Window.Position = UDim2.new(
        StartPosition.X.Scale,
        StartPosition.X.Offset + Delta.X,
        StartPosition.Y.Scale,
        StartPosition.Y.Offset + Delta.Y
    )
end)

local function UpdateMiniButtonPosition()
    local TopLeftInset = GuiService:GetGuiInset()

    MiniButton.Position = UDim2.fromOffset(
        math.max(8, TopLeftInset.X + 8),
        math.max(8, TopLeftInset.Y + 8)
    )
end

local function UpdateLayout()
    if not Camera then
        Camera = Workspace.CurrentCamera
    end

    if not Camera then
        return
    end

    local Viewport = Camera.ViewportSize
    local Mobile = IsMobile()

    local WindowSize

    if Mobile then
        WindowSize = Vector2.new(
            math.floor(Viewport.X * Config.MobileWidthScale),
            math.floor(Viewport.Y * Config.MobileHeightScale)
        )
    else
        WindowSize = Config.DesktopSize
    end

    FullWindowSize = WindowSize

    local Compact = Mobile or WindowSize.X < 580

    local TitleHeight = Compact and 46 or 50
    local SidebarWidth = Compact and 105 or 135

    CurrentTitleHeight = TitleHeight

    if Collapsed then
        Window.Size = UDim2.fromOffset(
            WindowSize.X,
            TitleHeight
        )
    else
        Window.Size = UDim2.fromOffset(
            WindowSize.X,
            WindowSize.Y
        )
    end

    TitleBar.Size = UDim2.new(1, 0, 0, TitleHeight)

    Title.Size = UDim2.new(1, -105, 0, 21)
    Title.Position = UDim2.fromOffset(13, 5)
    Title.TextSize = Compact and 14 or 17

    Subtitle.Size = UDim2.new(1, -105, 0, 13)
    Subtitle.Position = UDim2.fromOffset(14, 25)
    Subtitle.TextSize = Compact and 8 or 10

    MinimizeButton.Size = UDim2.fromOffset(29, 29)
    MinimizeButton.Position = UDim2.new(1, -64, 0.5, -14.5)
    MinimizeButton.TextSize = Compact and 14 or 16

    ExpandButton.Size = UDim2.fromOffset(29, 29)
    ExpandButton.Position = UDim2.new(1, -64, 0.5, -14.5)
    ExpandButton.TextSize = Compact and 14 or 16

    CloseButton.Size = UDim2.fromOffset(29, 29)
    CloseButton.Position = UDim2.new(1, -34, 0.5, -14.5)
    CloseButton.TextSize = Compact and 17 or 19

    Content.Position = UDim2.fromOffset(0, TitleHeight)
    Content.Size = UDim2.new(1, 0, 1, -TitleHeight)

    Sidebar.Size = UDim2.new(0, SidebarWidth, 1, 0)

    SidebarPadding.PaddingTop = UDim.new(0, 9)
    SidebarPadding.PaddingLeft = UDim.new(0, 6)
    SidebarPadding.PaddingRight = UDim.new(0, 6)

    Navigation.Size = UDim2.new(1, 0, 0, 121)

    ExecutionButton.Size = UDim2.new(1, 0, 0, 35)
    ScriptBloxButton.Size = UDim2.new(1, 0, 0, 35)
    SettingsButton.Size = UDim2.new(1, 0, 0, 35)

    ExecutionButton.TextSize = Compact and 10 or 13
    ScriptBloxButton.TextSize = Compact and 10 or 13
    SettingsButton.TextSize = Compact and 10 or 13

    MainArea.Position = UDim2.fromOffset(SidebarWidth, 0)
    MainArea.Size = UDim2.new(1, -SidebarWidth, 1, 0)

    Creator.Size = UDim2.new(1, -12, 0, 30)
    Creator.Position = UDim2.new(0, 6, 1, -40)
    Creator.TextSize = Compact and 7 or 9

    PageTitle.TextSize = Compact and 16 or 20
    PageDescription.TextSize = Compact and 9 or 11

    EditorCard.Size = UDim2.new(
        1,
        0,
        0,
        Compact and 175 or 205
    )

    EditorHeader.Size = UDim2.new(
        1,
        0,
        0,
        Compact and 28 or 31
    )

    EditorScroll.Position = UDim2.fromOffset(
        1,
        Compact and 29 or 32
    )

    EditorScroll.Size = UDim2.new(
        1,
        -2,
        1,
        -(Compact and 30 or 33)
    )

    Editor.TextSize = Compact and 10 or 13

    ActionBar.Size = UDim2.new(
        1,
        0,
        0,
        Compact and 31 or 36
    )

    ExecuteButton.Size = UDim2.fromOffset(
        Compact and 82 or 105,
        Compact and 31 or 36
    )

    ClearButton.Size = UDim2.fromOffset(
        Compact and 82 or 105,
        Compact and 31 or 36
    )

    ExecuteButton.TextSize = Compact and 10 or 12
    ClearButton.TextSize = Compact and 10 or 12
    ExecutionStatus.TextSize = Compact and 8 or 9

    OutputCard.Size = UDim2.new(
        1,
        0,
        0,
        Compact and 125 or 145
    )

    OutputHeader.Size = UDim2.new(
        1,
        0,
        0,
        Compact and 28 or 31
    )

    OutputScroll.Position = UDim2.fromOffset(
        1,
        Compact and 29 or 32
    )

    OutputScroll.Size = UDim2.new(
        1,
        -2,
        1,
        -(Compact and 30 or 33)
    )

    Output.TextSize = Compact and 8 or 10
    EditorTitle.TextSize = Compact and 8 or 9
    LineCount.TextSize = Compact and 8 or 9
    OutputTitle.TextSize = Compact and 8 or 9
    OutputStatus.TextSize = Compact and 8 or 9

    ScriptBloxTitle.Position = UDim2.fromOffset(
        Compact and 14 or 16,
        Compact and 11 or 14
    )

    ScriptBloxTitle.TextSize = Compact and 16 or 20

    ScriptBloxDescription.Position = UDim2.fromOffset(
        Compact and 14 or 16,
        Compact and 34 or 39
    )

    ScriptBloxDescription.TextSize = Compact and 9 or 11

    ScriptBloxSearchBar.Position = UDim2.fromOffset(
        Compact and 14 or 16,
        Compact and 60 or 68
    )

    ScriptBloxSearchBar.Size = UDim2.new(
        1,
        Compact and -28 or -32,
        0,
        Compact and 38 or 42
    )

    ScriptBloxSearchButton.Size = UDim2.fromOffset(
        Compact and 72 or 82,
        Compact and 29 or 32
    )

    ScriptBloxSearchButton.Position = UDim2.new(
        1,
        Compact and -78 or -88,
        0.5,
        Compact and -14.5 or -16
    )

    ScriptBloxSearchBox.TextSize = Compact and 9 or 11

    ScriptBloxStatus.Position = UDim2.fromOffset(
        Compact and 14 or 16,
        Compact and 103 or 116
    )

    ScriptBloxStatus.TextSize = Compact and 8 or 9

    ScriptBloxResultsScroll.Position = UDim2.fromOffset(
        Compact and 14 or 16,
        Compact and 126 or 140
    )

    ScriptBloxResultsScroll.Size = UDim2.new(
        1,
        Compact and -28 or -32,
        1,
        Compact and -166 or -180
    )

    ScriptBloxPowered.Size = UDim2.new(
        1,
        Compact and -28 or -32,
        0,
        16
    )

    ScriptBloxPowered.Position = UDim2.new(
        0,
        Compact and 14 or 16,
        1,
        -20
    )

    ScriptBloxPowered.TextSize = Compact and 7 or 8

    ScriptBloxPageLabel.Position = UDim2.new(
        0,
        Compact and 14 or 16,
        1,
        -40
    )

    ScriptBloxPageLabel.TextSize = Compact and 8 or 9

    ScriptBloxPrevious.Size = UDim2.fromOffset(
        Compact and 70 or 82,
        Compact and 27 or 28
    )

    ScriptBloxPrevious.Position = UDim2.new(
        1,
        Compact and -162 or -190,
        1,
        -40
    )

    ScriptBloxPrevious.TextSize = Compact and 8 or 9

    ScriptBloxNext.Size = UDim2.fromOffset(
        Compact and 70 or 82,
        Compact and 27 or 28
    )

    ScriptBloxNext.Position = UDim2.new(
        1,
        Compact and -84 or -100,
        1,
        -40
    )

    ScriptBloxNext.TextSize = Compact and 8 or 9

    SettingsTitle.Position = UDim2.fromOffset(14, 11)
    SettingsTitle.TextSize = Compact and 16 or 20

    SettingsDescription.Position = UDim2.fromOffset(14, 34)
    SettingsDescription.TextSize = Compact and 9 or 11

    AboutCard.Size = UDim2.new(
        1,
        0,
        0,
        Compact and 95 or 110
    )

    CoreGuardCard.Size = UDim2.new(
        1,
        0,
        0,
        Compact and 180 or 190
    )

    AboutTitle.Position = UDim2.fromOffset(11, 10)
    AboutTitle.TextSize = Compact and 12 or 14

    AboutVersion.Position = UDim2.fromOffset(11, 34)
    AboutVersion.TextSize = Compact and 9 or 11

    AboutCreator.Position = UDim2.fromOffset(11, 56)
    AboutCreator.TextSize = Compact and 9 or 11

    CoreGuardTitle.TextSize = Compact and 12 or 14
    CoreGuardStatus.TextSize = Compact and 9 or 10
    CoreGuardContainer.TextSize = Compact and 9 or 10
    CoreGuardMonitor.TextSize = Compact and 9 or 10
    CoreGuardFallback.TextSize = Compact and 9 or 10
    CoreGuardVersion.TextSize = Compact and 9 or 10

    CoreGuardRecover.Size = UDim2.fromOffset(
        Compact and 82 or 92,
        Compact and 28 or 30
    )

    CoreGuardRecover.TextSize = Compact and 9 or 10

    task.defer(function()
        UpdateExecutionScroll()
        UpdateSettingsScroll()
        EditorScrollUpdate()
        OutputScrollUpdate()
        UpdateScriptBloxScroll()
    end)
end

local function CollapseWindow()
    if Collapsed then
        return
    end

    Collapsed = true

    local TargetHeight = CurrentTitleHeight
    local TargetWidth = FullWindowSize.X

    local ContentAnimation = Tween(Content, 0.18, {
        GroupTransparency = 1
    })

    ContentAnimation.Completed:Connect(function()
        Content.Visible = false
    end)

    Tween(Window, 0.3, {
        Size = UDim2.fromOffset(
            TargetWidth,
            TargetHeight
        )
    })

    Tween(MinimizeButton, 0.18, {
        BackgroundTransparency = 1,
        TextTransparency = 1
    }).Completed:Connect(function()
        MinimizeButton.Visible = false
        MinimizeButton.BackgroundTransparency = 0.88
        MinimizeButton.TextTransparency = 0

        ExpandButton.Visible = true
        ExpandButton.BackgroundTransparency = 1
        ExpandButton.TextTransparency = 1

        Tween(ExpandButton, 0.2, {
            BackgroundTransparency = 0.88,
            TextTransparency = 0
        })
    end)
end

local function ExpandWindow()
    if not Collapsed then
        return
    end

    Collapsed = false

    Content.Visible = true
    Content.GroupTransparency = 1

    Window.Size = UDim2.fromOffset(
        FullWindowSize.X,
        CurrentTitleHeight
    )

    Tween(Window, 0.3, {
        Size = UDim2.fromOffset(
            FullWindowSize.X,
            FullWindowSize.Y
        )
    })

    Tween(Content, 0.25, {
        GroupTransparency = 0
    })

    Tween(ExpandButton, 0.15, {
        BackgroundTransparency = 1,
        TextTransparency = 1
    }).Completed:Connect(function()
        ExpandButton.Visible = false
        ExpandButton.BackgroundTransparency = 0.88
        ExpandButton.TextTransparency = 0

        MinimizeButton.Visible = true
        MinimizeButton.BackgroundTransparency = 1
        MinimizeButton.TextTransparency = 1

        Tween(MinimizeButton, 0.2, {
            BackgroundTransparency = 0.88,
            TextTransparency = 0
        })
    end)
end

local function ShowWindow()
    Collapsed = false

    FullWindowSize = GetWindowSize()

    Window.Visible = true
    Window.Size = UDim2.fromOffset(
        FullWindowSize.X,
        FullWindowSize.Y
    )

    Content.Visible = true
    Content.GroupTransparency = 0

    MinimizeButton.Visible = true
    ExpandButton.Visible = false

    MinimizeButton.BackgroundTransparency = 0.88
    MinimizeButton.TextTransparency = 0

    WindowScale.Scale = 0.92

    Tween(WindowScale, 0.3, {
        Scale = 1
    })
end

local function HideWindow()
    local Animation = Tween(WindowScale, 0.22, {
        Scale = 0.82
    })

    Animation.Completed:Connect(function()
        Window.Visible = false
    end)
end

local function CloseWindow()
    Collapsed = false

    Content.Visible = true
    Content.GroupTransparency = 0

    Window.Size = UDim2.fromOffset(
        FullWindowSize.X,
        FullWindowSize.Y
    )

    MinimizeButton.Visible = true
    ExpandButton.Visible = false

    MinimizeButton.BackgroundTransparency = 0.88
    MinimizeButton.TextTransparency = 0

    HideWindow()

    task.delay(0.22, function()
        MiniButton.Visible = true
        MiniButton.Size = UDim2.fromOffset(0, 0)

        UpdateMiniButtonPosition()

        Tween(MiniButton, 0.25, {
            Size = UDim2.fromOffset(
                Config.MinimizedSize,
                Config.MinimizedSize
            )
        })
    end)
end

SwitchPage = function(Target)
    if Target == CurrentPage or PageSwitching then
        return
    end

    if Target ~= "Execution"
        and Target ~= "ScriptBlox"
        and Target ~= "Settings" then
        return
    end

    PageSwitching = true

    local Pages = {
        Execution = {
            Page = ExecutionPage,
            Scale = ExecutionScale,
            Button = ExecutionButton
        },

        ScriptBlox = {
            Page = ScriptBloxPage,
            Scale = ScriptBloxScale,
            Button = ScriptBloxButton
        },

        Settings = {
            Page = SettingsPage,
            Scale = SettingsScale,
            Button = SettingsButton
        }
    }

    local PageOrder = {
        Execution = 1,
        ScriptBlox = 2,
        Settings = 3
    }

    local Previous = Pages[CurrentPage]
    local Incoming = Pages[Target]

    local Direction

    if PageOrder[Target] > PageOrder[CurrentPage] then
        Direction = 1
    else
        Direction = -1
    end

    CurrentPage = Target

    Incoming.Page.Visible = true
    Incoming.Page.GroupTransparency = 1
    Incoming.Page.Position = UDim2.new(
        0,
        Direction * 10,
        0,
        0
    )

    Incoming.Scale.Scale = 0.985

    Tween(
        Previous.Page,
        0.16,
        {
            GroupTransparency = 1,
            Position = UDim2.new(
                0,
                -Direction * 10,
                0,
                0
            )
        },
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.In
    )

    Tween(
        Previous.Scale,
        0.16,
        {
            Scale = 0.985
        },
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.In
    )

    task.delay(0.035, function()
        Tween(
            Incoming.Page,
            0.25,
            {
                GroupTransparency = 0,
                Position = UDim2.fromScale(0, 0)
            },
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        )

        Tween(
            Incoming.Scale,
            0.25,
            {
                Scale = 1
            },
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        )
    end)

    for Name, Data in pairs(Pages) do
        if Name == Target then
            Tween(
                Data.Button,
                0.2,
                {
                    BackgroundTransparency = 0,
                    BackgroundColor3 = Config.Colors.Accent,
                    TextColor3 = Config.Colors.Text
                }
            )
        else
            Tween(
                Data.Button,
                0.2,
                {
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Config.Colors.Surface,
                    TextColor3 = Config.Colors.SecondaryText
                }
            )
        end
    end

    task.delay(0.18, function()
        Previous.Page.Visible = false
        Previous.Page.Position = UDim2.fromScale(0, 0)
        Previous.Page.GroupTransparency = 0
        Previous.Scale.Scale = 1
    end)

    task.delay(0.29, function()
        PageSwitching = false
    end)
end

CloseButton.MouseEnter:Connect(function()
    Tween(CloseButton, 0.15, {
        BackgroundTransparency = 0.7
    })
end)

CloseButton.MouseLeave:Connect(function()
    Tween(CloseButton, 0.15, {
        BackgroundTransparency = 0.88
    })
end)

MinimizeButton.MouseEnter:Connect(function()
    Tween(MinimizeButton, 0.15, {
        BackgroundTransparency = 0.7
    })
end)

MinimizeButton.MouseLeave:Connect(function()
    Tween(MinimizeButton, 0.15, {
        BackgroundTransparency = 0.88
    })
end)

ExpandButton.MouseEnter:Connect(function()
    Tween(ExpandButton, 0.15, {
        BackgroundTransparency = 0.7
    })
end)

ExpandButton.MouseLeave:Connect(function()
    Tween(ExpandButton, 0.15, {
        BackgroundTransparency = 0.88
    })
end)

ExecuteButton.MouseEnter:Connect(function()
    Tween(ExecuteButton, 0.15, {
        BackgroundColor3 = Config.Colors.AccentHover
    })
end)

ExecuteButton.MouseLeave:Connect(function()
    Tween(ExecuteButton, 0.15, {
        BackgroundColor3 = Config.Colors.Accent
    })
end)

ClearButton.MouseEnter:Connect(function()
    Tween(ClearButton, 0.15, {
        BackgroundColor3 = Config.Colors.Border
    })
end)

ClearButton.MouseLeave:Connect(function()
    Tween(ClearButton, 0.15, {
        BackgroundColor3 = Config.Colors.SurfaceLight
    })
end)

ExecutionButton.MouseEnter:Connect(function()
    if CurrentPage == "Execution" then
        Tween(ExecutionButton, 0.15, {
            BackgroundColor3 = Config.Colors.AccentHover
        })
    end
end)

ExecutionButton.MouseLeave:Connect(function()
    if CurrentPage == "Execution" then
        Tween(ExecutionButton, 0.15, {
            BackgroundColor3 = Config.Colors.Accent
        })
    end
end)

ScriptBloxButton.MouseEnter:Connect(function()
    if CurrentPage ~= "ScriptBlox" then
        Tween(ScriptBloxButton, 0.15, {
            BackgroundTransparency = 0.9,
            BackgroundColor3 = Config.Colors.SurfaceLight
        })
    else
        Tween(ScriptBloxButton, 0.15, {
            BackgroundColor3 = Config.Colors.AccentHover
        })
    end
end)

ScriptBloxButton.MouseLeave:Connect(function()
    if CurrentPage == "ScriptBlox" then
        Tween(ScriptBloxButton, 0.15, {
            BackgroundColor3 = Config.Colors.Accent
        })
    else
        Tween(ScriptBloxButton, 0.15, {
            BackgroundTransparency = 1,
            BackgroundColor3 = Config.Colors.Surface
        })
    end
end)

SettingsButton.MouseEnter:Connect(function()
    if CurrentPage ~= "Settings" then
        Tween(SettingsButton, 0.15, {
            BackgroundTransparency = 0.9,
            BackgroundColor3 = Config.Colors.SurfaceLight
        })
    else
        Tween(SettingsButton, 0.15, {
            BackgroundColor3 = Config.Colors.AccentHover
        })
    end
end)

SettingsButton.MouseLeave:Connect(function()
    if CurrentPage == "Settings" then
        Tween(SettingsButton, 0.15, {
            BackgroundColor3 = Config.Colors.Accent
        })
    else
        Tween(SettingsButton, 0.15, {
            BackgroundTransparency = 1,
            BackgroundColor3 = Config.Colors.Surface
        })
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    CloseWindow()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    CollapseWindow()
end)

ExpandButton.MouseButton1Click:Connect(function()
    ExpandWindow()
end)

MiniButton.MouseEnter:Connect(function()
    Tween(MiniButton, 0.15, {
        BackgroundColor3 = Config.Colors.AccentHover
    })

    Tween(MiniButtonStroke, 0.15, {
        Transparency = 0
    })
end)

MiniButton.MouseLeave:Connect(function()
    Tween(MiniButton, 0.15, {
        BackgroundColor3 = Config.Colors.Accent
    })

    Tween(MiniButtonStroke, 0.15, {
        Transparency = 0.15
    })
end)

MiniButton.MouseButton1Click:Connect(function()
    Tween(MiniButton, 0.18, {
        Size = UDim2.fromOffset(0, 0)
    }).Completed:Connect(function()
        MiniButton.Visible = false
        ShowWindow()
    end)
end)

ScriptBloxButton.MouseButton1Click:Connect(function()
    SwitchPage("ScriptBlox")
end)

ExecutionButton.MouseButton1Click:Connect(function()
    SwitchPage("Execution")
end)

SettingsButton.MouseButton1Click:Connect(function()
    SwitchPage("Settings")
end)

UpdateLineCount()
UpdateLayout()
UpdateMiniButtonPosition()

local function ConnectCameraViewport()
    if CameraViewportConnection then
        CameraViewportConnection:Disconnect()
        CameraViewportConnection = nil
    end

    if not Camera then
        return
    end

    CameraViewportConnection =
        Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            UpdateLayout()

            if MiniButton.Visible then
                UpdateMiniButtonPosition()
            end
        end)
end

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = Workspace.CurrentCamera

    ConnectCameraViewport()
    UpdateLayout()
    UpdateMiniButtonPosition()
end)

ConnectCameraViewport()

ShowWindow()
