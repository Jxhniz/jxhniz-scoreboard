local isHolding = false

-- Main thread: check if key is held
CreateThread(function()
    while true do
        Wait(0)

        if IsControlPressed(0, Config.HoldKey) then
            if not isHolding then
                isHolding = true
            end
            DrawPlayerIDs()
        else
            if isHolding then
                isHolding = false
            end
        end
    end
end)

-- Draw IDs for ALL nearby players (including yourself)
function DrawPlayerIDs()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then  -- Removed: ped ~= playerPed
            local pedCoords = GetEntityCoords(ped)
            local dist = #(playerCoords - pedCoords)

            if dist <= Config.MaxDistance then
                local headBone = GetPedBoneCoords(ped, 0x796E, 0.0, 0.0, 0.0) -- Skull bone
                local onScreen, x, y = GetScreenCoordFromWorldCoord(headBone.x, headBone.y, headBone.z + 0.3)

                if onScreen then
                    local scale = (1 / dist) * Config.TextSize * 2.0
                    if scale > 0.6 then scale = 0.6 end

                    SetTextScale(0.0, scale)
                    SetTextFont(Config.TextFont)
                    SetTextColour(Config.TextColor[1], Config.TextColor[2], Config.TextColor[3], Config.TextColor[4])
                    SetTextCentre(true)
                    SetTextOutline()
                    SetTextDropShadow()

                    local serverId = GetPlayerServerId(player)
                    
                    -- Optional: Highlight your own ID
                    local prefix = (player == PlayerId()) and "~b~[ME: ~w~" or "~y~[ID: ~w~"
                    local suffix = (player == PlayerId()) and "~b~]" or "~y~]"

                    BeginTextCommandDisplayText('STRING')
                    AddTextComponentSubstringPlayerName(prefix .. serverId .. suffix)
                    EndTextCommandDisplayText(x, y)
                end
            end
        end
    end
end