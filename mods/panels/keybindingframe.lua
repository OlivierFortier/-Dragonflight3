DRAGONFLIGHT()

DF:NewDefaults('keybinds', {
    version = {value = '1.0'},
    enabled = {value = true},
})

DF:NewModule('keybinds', 1, function()
    local skinned = false
    local function GetKeybindingsFrame()
        return _G.KeyBindingFrame or _G.KeyBindingsFrame or _G.KeyBindingsPanel
    end

    local function SkinKeyBindingFrame()
        local frame = GetKeybindingsFrame()
        if skinned or not frame then return end
        skinned = true

        local regions = {frame:GetRegions()}
        for i = 1, table.getn(regions) do
            local region = regions[i]
            if region:GetObjectType() == 'Texture' then
                local texture = region:GetTexture()
                if texture and (string.find(texture, 'KeyBindingFrame') or string.find(texture, 'UI-Character-') or string.find(texture, 'ClassTrainer') or string.find(texture, 'PaperDollInfoFrame')) then
                    region:Hide()
                end
            end
        end
        if KeyBindingFrameCloseButton then KeyBindingFrameCloseButton:Hide() end

        local customBg = DF.ui.CreatePaperDollFrame('DF_KeyBindingCustomBg', frame, 384, 512, 2)
        customBg:SetPoint('TOPLEFT', frame, 'TOPLEFT', 0, -8)
        customBg:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -32, 10)
        customBg:SetFrameLevel(frame:GetFrameLevel() - 1)
        customBg.Bg:SetDrawLayer('BACKGROUND', -5)
        DF.setups.keybindingBg = customBg.Bg
        if DF.profile and DF.profile.UIParent and DF.profile.UIParent.keybindingBgAlpha then
            customBg.Bg:SetAlpha(DF.profile.UIParent.keybindingBgAlpha)
        end
        if DF.profile and DF.profile.UIParent and DF.profile.UIParent.keybindingScale then
            customBg:SetScale(DF.profile.UIParent.keybindingScale)
            frame:SetScale(DF.profile.UIParent.keybindingScale)
        end

        local closeButton = DF.ui.CreateRedButton(customBg, 'close', function() HideUIPanel(frame) end)
        closeButton:SetPoint('TOPRIGHT', customBg, 'TOPRIGHT', 0, -1)
        closeButton:SetSize(20, 20)
        closeButton:SetFrameLevel(customBg:GetFrameLevel() + 3)

        tinsert(UISpecialFrames, 'DF_KeyBindingCustomBg')
    end

    local frame = CreateFrame('Frame')
    frame:RegisterEvent('ADDON_LOADED')
    frame:SetScript('OnEvent', function()
        if arg1 == 'Blizzard_BindingUI' or GetKeybindingsFrame() then
            SkinKeyBindingFrame()
        end
    end)

    if GetKeybindingsFrame() then
        SkinKeyBindingFrame()
    end

    -- callbacks
    local helpers = {}
    local callbacks = {}
    DF:NewCallbacks('keybinds', callbacks)
end)
