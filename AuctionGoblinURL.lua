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
            if key == "ESCAPE" then
                self:Hide()
            elseif IsModifierKeyDown() and key == "C" then
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

-- Function to handle the /ag command
SLASH_ITEMHISTORY1 = "/ag"
SlashCmdList["ITEMHISTORY"] = function()
    if frame.itemLink then
        local itemID = frame.itemLink:match("item:(%d+):")
        if itemID then
            ShowItemLinkPopup(itemID)
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