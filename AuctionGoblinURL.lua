local frame = CreateFrame("Frame", "ItemLinkFrame", UIParent)

-- StaticPopupDialog for item link URL
StaticPopupDialogs["ITEM_LINK_URL"] = {
    text = "Copy and paste this URL into your browser.",
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
local AuctionGoblinURL = "https://www.auctiongoblin.com/items/"

local function ShowItemLinkPopup(itemID)
    local ItemURL = AuctionGoblinURL .. itemID
    local PopupDataFill = {ItemURL = ItemURL}
    StaticPopup_Show("ITEM_LINK_URL", "", "", PopupDataFill)
end

-- Function to handle the item click with modifier key
local function OnModifierClick()
    if frame.itemLink then
        local itemID = frame.itemLink:match("item:(%d+):")
        if itemID then
            -- Add a 250ms delay before showing the popup
            C_Timer.After(0.25, function() ShowItemLinkPopup(itemID) end)
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
        OnModifierClick()
    end
end)

keyFrame:EnableKeyboard(true)
keyFrame:SetPoint("CENTER")
keyFrame:SetSize(1, 1)

-- Test message to ensure the script is loaded
print("Custom key combination script loaded.")