DRAGONFLIGHT()
-- i will add some more features so i keep this seperated from init lua; for now its just a flag;

local detectList = {'pfQuest'}

local compatFrame = CreateFrame('Frame')
compatFrame:RegisterEvent('ADDON_LOADED')
compatFrame:RegisterEvent('VARIABLES_LOADED')
compatFrame:SetScript('OnEvent', function()
    if event == 'ADDON_LOADED' then
        for _, addon in pairs(detectList) do
            if arg1 == addon then
                DF.others[addon] = true
            end
        end
    end

    if event == 'VARIABLES_LOADED' then
        compatFrame:UnregisterAllEvents()

        -- Patch 9 (1.18.1) changed the UISpecialFrames loop in CloseWindows from
        -- frame:IsVisible() to frame:IsShown(). IsVisible() returns false when a
        -- parent frame is hidden, so child custom-bg frames parented to UIPanelWindows
        -- frames (CharacterFrame, MailFrame, etc.) were correctly skipped - they were
        -- already implicitly hidden and would re-show with their parent.
        -- IsShown() ignores parent visibility, so those same child frames now get
        -- explicitly hidden, and WoW will NOT auto-show them when their parent re-shows.
        -- This one-line regression broke every DF custom background panel.
        -- We restore the IsVisible() behaviour here, fixing all panels at once.
        if CloseSpecialWindows then
            _G.CloseSpecialWindows = function()
                local found
                for _, value in pairs(UISpecialFrames) do
                    local frame = _G[value]
                    if frame and frame:IsVisible() then
                        frame:Hide()
                        found = 1
                    end
                end
                return found
            end
        end
    end
end)
