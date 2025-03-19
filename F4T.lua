game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    warn("Anti afk berlari-lari")
end)

-- Load UI Library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/uupwww/Gdje-ka-ada-/refs/heads/main/63834sadwi121jisd", true))()
local window = library:CreateWindow({ text = "Fishing4Trouble" })

-- Auto Fish
window:AddToggle("Auto Fish", function(state)
    getfenv().fish = (state and true or false)
    while getfenv().fish do
        task.wait()
        local chr = game.Players.LocalPlayer.Character
        if not chr:FindFirstChildOfClass("Tool") or chr:FindFirstChildOfClass("Tool"):GetAttribute("type") ~= "Rods" then
            local plr = game.Players.LocalPlayer.UserId
            for i,v in pairs(game:GetService("ReplicatedStorage").ToolsCache[plr]:GetChildren()) do
                if v:GetAttribute("type") == "Rods" then
                    rod = v
                end
            end
            game:GetService("ReplicatedStorage").CloudFrameShared.DataStreams.EquipTool:InvokeServer(rod)
        end

        repeat task.wait()
            if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Bobber.RopeConstraint.Length < 1 then
                local Camera = workspace.Camera
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2, 0, true, game, 1)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2, 0, false, game, 1)
                wait(0.1)
            end
        until game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Bobber.RopeConstraint.Length > 1

        task.wait(0.1)
        repeat task.wait()
        until #game:GetService("Players").LocalPlayer.PlayerGui.FishBubbles:GetChildren() > 1 or game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Bobber.RopeConstraint.Length < 1
        

        local Camera = workspace.Camera
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2, 0, true, game, 1)
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2, 0, false, game, 1)
        
        repeat task.wait()
            game:GetService("VirtualInputManager"):SendMouseButtonEvent(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2, 0, true, game, 1)
            game:GetService("VirtualInputManager"):SendMouseButtonEvent(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2, 0, false, game, 1)
            wait(0.1)
        until game:GetService("Players").LocalPlayer.PlayerGui.Interface.Fishing.FishingMeter.Visible or game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Bobber.RopeConstraint.Length < 1

        repeat task.wait()
            -- rubah bagian -3 ke -5 kalo belum upgrade skill biar ga lepas --
            if game:GetService("Players").LocalPlayer.PlayerGui.Interface.Fishing.FishingMeter.Mover.Rotation < 0 and game:GetService("Players").LocalPlayer.PlayerGui.Interface.Fishing.FishingMeter.Visible then
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2, 0, true, game, 1)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2, 0, false, game, 1)
            end
        until game:GetService("Players").LocalPlayer.PlayerGui.Interface.Fishing.FishingMeter.Visible == false or game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Bobber.RopeConstraint.Length < 1
    end
end)

-- **No Cooldown Spear Toggle**
_G.noCooldownSpear = false

function toggleNoCooldownSpear(state)
    _G.noCooldownSpear = state

    if state then
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "reloadTime") then
                v.reloadTime = 0
            end
        end

        local mt = getrawmetatable(game)
        local old = mt.__namecall
        setreadonly(mt, false)

        mt.__namecall = newcclosure(function(self, ...)
            local args = {...}
            if self.Name == "SpearThrown" then
                args[4] = tick() + math.random(0.1, 0.2)
            elseif self.Name == "MonsterHit" then
                args[3] = true
            end
            return old(self, unpack(args))
        end)

        setreadonly(mt, true)

    else
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "reloadTime") then
                v.reloadTime = 1.5
            end
        end
    end
end

-- **Auto Farm Mobs**
_G.selectedMob = "KillerWhale"
_G.autoFarmMobs = false

function toggleAutoFarmMobs(state)
    _G.autoFarmMobs = state
    while _G.autoFarmMobs do
        task.wait()
        pcall(function()
            local plr = game.Players.LocalPlayer.UserId
            local spear = nil
            for _, v in pairs(game:GetService("ReplicatedStorage").ToolsCache[plr]:GetChildren()) do
                if v:GetAttribute("type") == "Spears" then
                    spear = v.Name
                end
            end
            for _, v in pairs(workspace:GetChildren()) do
                if v.ClassName == "Model" and v:FindFirstChild("Hitbox") and v.Name == _G.selectedMob and _G.autoFarmMobs then
                    repeat
                        task.wait()
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.PrimaryPart.CFrame * CFrame.new(0, 0, 20)
                        game:GetService("ReplicatedStorage").CloudFrameShared.DataStreams.SpearThrown:FireServer(spear, v.PrimaryPart.CFrame, v.PrimaryPart.Position, tonumber("1696341607.0" .. math.random(100000, 1000000)))
                        game:GetService("ReplicatedStorage").CloudFrameShared.DataStreams.MonsterHit:FireServer(v, spear, true)
                        task.wait(2)
                    until v.Health.Value == 0 or not _G.autoFarmMobs or v.Parent == nil
                end
            end
        end)
    end
end

-- **Anti-Mob Damage**
_G.antiMobDamage = true

function toggleAntiMobDamage()
    while _G.antiMobDamage and task.wait() do
        pcall(function()
            for _, v in pairs(workspace:GetChildren()) do
                if v.ClassName == "Model" and v:FindFirstChild("Hitbox") and v.Hitbox:FindFirstChild("TouchInterest") then
                    v.Hitbox:FindFirstChild("TouchInterest"):Destroy()
                end
            end
        end)
    end
end
task.spawn(toggleAntiMobDamage)

-- AutoLock
_G.autoLockKeys = false
local lockedItems = {}

function toggleAutoLockKeys(state)
    _G.autoLockKeys = state
    if state then
        lockedItems = {}
    end
    
    task.spawn(function()
        while _G.autoLockKeys do
            for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Interface.Inventory.Inventory.Frame.Backpack.List.Container:GetChildren()) do
                if v:IsA("Frame") and v:FindFirstChild("DraggableComponent") then
                    local itemModel = v.DraggableComponent:FindFirstChild("Contents") and 
                                      v.DraggableComponent.Contents:FindFirstChild("ItemViewport") and 
                                      v.DraggableComponent.Contents.ItemViewport:FindFirstChild("Model") and 
                                      v.DraggableComponent.Contents.ItemViewport.Model:GetChildren()[1]

                    if itemModel and (itemModel.Name:lower() == "whalekey" or itemModel.Name:lower() == "krakenkey") then
                        if not lockedItems[v.Name] then
                            local args = {
                                [1] = "SeaCreatureDrops",
                                [2] = v.Name, -- Gunakan nama acak seperti key_399
                                [3] = true
                            }
                            game:GetService("ReplicatedStorage").CloudFrameShared.DataStreams.SetInventoryItemLock:InvokeServer(unpack(args))
                            lockedItems[v.Name] = true
                            print("Locked:", v.Name, "(", itemModel.Name, ")")
                        end
                    end
                end
            end
            task.wait(3)
        end
    end)
end

-- **Auto Sell Loot**
_G.autoSellLoot = false
function toggleAutoSellLoot(state)
    _G.autoSellLoot = state
    while _G.autoSellLoot do
        game:GetService("ReplicatedStorage").CloudFrameShared.DataStreams.processGameItemSold:InvokeServer("SellEverything")
        task.wait(1)
    end
end

-- autoOpenChest
_G.autoOpenChest = false
_G.selectedChest = "stonechest"

function toggleAutoOpenChest(state)
    _G.autoOpenChest = state
    task.spawn(function()
        while _G.autoOpenChest do
            local args = {
                [1] = _G.selectedChest,
                [2] = false
            }
            game:GetService("ReplicatedStorage").CloudFrameShared.DataStreams.OpenLootboxFunction:InvokeServer(unpack(args))
            print(_G.selectedChest .. " Opened!")

            task.wait(1)
        end
    end)
end

-- Auto Open Lootbox
_G.autoOpenLootbox = false
_G.selectedLootbox = "normalegg"

function toggleAutoOpenLootbox(state)
    _G.autoOpenLootbox = state
    task.spawn(function()
        while _G.autoOpenLootbox do
            local args = {
                [1] = _G.selectedLootbox,
                [2] = false
            }
            game:GetService("ReplicatedStorage").CloudFrameShared.DataStreams.OpenLootboxFunction:InvokeServer(unpack(args))
            print(_G.selectedLootbox .. " Opened!")

            task.wait(1)
        end
    end)
end

-- **Auto Collect Loot**
_G.autoCollectLoot = false
function toggleAutoCollectLoot(state)
    _G.autoCollectLoot = state
    while _G.autoCollectLoot do
        task.wait()
        pcall(function()
            for _, v in pairs(workspace.DroppedItems:GetChildren()) do
                if v.ClassName == "Model" and v.PrimaryPart ~= nil and v.PrimaryPart.Transparency ~= 1 then
                    local owner = v:GetAttribute("OwnerId")
                    local playerId = game.Players.LocalPlayer.UserId
                    if owner == playerId or owner == nil then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.PrimaryPart.CFrame * CFrame.new(0, 0, -2)
                        task.wait(0.2)
                    end
                end
            end
        end)
    end
end

window:AddToggle("No Cooldown Spear", function(state)
    toggleNoCooldownSpear(state)
end)

window:AddLabel("Pilih Ikan Leee:")
window:AddDropdown({"KillerWhale", "UmbralSkimmer", "NeonKillerWhale", "HammerShark", "GreatWhiteShark", "BigGreatWhiteShark", "NeonGreatWhiteShark",  "ArmoredShark", "ElephantSeal", "Piranha", "NeonArmoredShark"}, function(value)
    _G.selectedMob = value
end)

window:AddToggle("Auto Hunt", function(state)
    toggleAutoFarmMobs(state)
end)

window:AddToggle("Auto Lock Keys", function(state)
    toggleAutoLockKeys(state)
end)

window:AddToggle("Auto Sell Loot", function(state)
    toggleAutoSellLoot(state)
end)

window:AddToggle("Auto Collect Loot", function(state)
    toggleAutoCollectLoot(state)
end)

window:AddDropdown({"stonechest", "silverchest", "crownchest", "timberchest"}, function(value)
    _G.selectedChest = value
end)

window:AddToggle("Auto Open Chest", function(state)
    toggleAutoOpenChest(state)
end)

window:AddDropdown({"normalegg", "royalegg"}, function(value)
    _G.selectedLootbox = value
end)

window:AddToggle("Auto Open Lootbox", function(state)
    toggleAutoOpenLootbox(state)
end)
