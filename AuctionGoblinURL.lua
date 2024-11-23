local frame = CreateFrame("Frame", "ItemLinkFrame", UIParent)

-- StaticPopupDialog for item link URL
StaticPopupDialogs["ITEM_LINK_URL"] = {
    text = "Auction Goblin Item Link",
    button1 = "Close",
    OnAccept = function() end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
    OnShow = function(self, data)
        self.editBox:SetText(data.ItemURL)
        self.editBox:HighlightText()
        self.editBox:SetFocus()
        self.editBox:SetScript("OnKeyDown", function(_, key)
            local isMac = IsMacClient()
            if key == "ESCAPE" then
                self:Hide()
            elseif (isMac and IsMetaKeyDown() or IsControlKeyDown()) and key == "C" then
                self:Hide()
            end
        end)
    end,
    hasEditBox = true
}

-- Function to generate the Auction Goblin URL and show the popup
local AUCTION_GOBLIN_URL = "https://www.auctiongoblin.com/items/"

local function showItemLinkPopup(itemID)
    local itemURL = AUCTION_GOBLIN_URL .. itemID
    local popupData = { ItemURL = itemURL }
    StaticPopup_Show("ITEM_LINK_URL", "", "", popupData)
end

-- Function to handle the item click with modifier key
local function onModifierClick()
    if frame.itemLink then
        local itemID = frame.itemLink:match("item:(%d+):")
        if itemID then
            C_Timer.After(0, function() showItemLinkPopup(itemID) end)
        else
            print("No item ID found.")
        end
    else
        print("No item is being hovered over.")
    end
end

-- Hook the GameTooltip to keep track of the hovered item
frame:SetScript("OnUpdate", function(self, elapsed)
    if GameTooltip:IsVisible() then
        local _, itemLink = GameTooltip:GetItem()
        if itemLink then
            frame.itemLink = itemLink
        end
    else
        frame.itemLink = nil
    end
end)

-- Create a frame to handle key detection without interfering with the game
local keyFrame = CreateFrame("Frame", "KeyDetectFrame", UIParent)
keyFrame:SetPropagateKeyboardInput(true)
keyFrame:SetScript("OnKeyDown", function(self, key)
    local isMac = IsMacClient()
    if key == "P" and (IsControlKeyDown() or (isMac and IsMetaKeyDown())) then
        onModifierClick()
    end
end)

keyFrame:EnableKeyboard(true)
keyFrame:SetPoint("CENTER")
keyFrame:SetSize(1, 1)