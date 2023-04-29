net.Receive("gmstation_reward", function()
    timer.Stop("gmstation_payout_timer")
    local rewards = net.ReadTable()
    local i = 1

    if IsValid(GUIElements.reward) then
        GUIElements.reward:Remove()
    end

    GUIElements.reward = vgui.Create("DPanel")
    GUIElements.reward:SetSize(300, ScrH())
    GUIElements.reward:SetX(ScrW() - GUIElements.reward:GetWide())
    GUIElements.reward.Paint = function(self, w, h) end

    timer.Create("gmstation_payout_timer", 0.56, #rewards + 1, function()
        local reward = vgui.Create("DPanel", GUIElements.reward)
        reward:SetWide(GUIElements.reward:GetWide())
        reward:SetTall(32)
        reward:SetPos(reward:GetWide() + 1, ScrH() - reward:GetTall() - (i - 1) * 32)

		surface.PlaySound("gmstation/sfx/payout/roll.mp3")

        if i ~= #rewards + 1 then
            local text = vgui.Create("DLabel", reward)
            text:Dock(FILL)
            text:DockMargin(8, 0, 8, 0)
            text:SetContentAlignment(4)
            text:SetFont("Trebuchet8")
            text:SetText(rewards[i][1])
            text:SizeToContents()
            local moneytext = vgui.Create("DLabel", reward)
            moneytext:Dock(RIGHT)
            moneytext:DockMargin(8, 0, 8, 0)
            moneytext:SetContentAlignment(4)
            moneytext:SetFont("Trebuchet24Bold")
            moneytext:SetText(rewards[i][2] .. "cc")
            moneytext:SizeToContents()

			local ii = i

            reward:MoveTo(0, reward:GetY(), 0.56, 0, 16, function()
				surface.PlaySound("gmstation/sfx/payout/goal" .. math.min(ii, 5) .. ".wav")
			end)
        else
            reward:SetTall(64)
            reward:SetY(ScrH() - reward:GetTall() - (i - 1) * 32)
            local sum = 0

            for k, v in pairs(rewards) do
                sum = sum + v[2]
            end

            local totaltext = vgui.Create("DLabel", reward)
            totaltext:Dock(FILL)
            totaltext:DockMargin(8, 0, 8, 0)
            totaltext:SetContentAlignment(4)
            totaltext:SetFont("Trebuchet16")
            totaltext:SetText("Total")
            totaltext:SizeToContents()
            local moneytext = vgui.Create("DLabel", reward)
            moneytext:Dock(RIGHT)
            moneytext:DockMargin(8, 0, 8, 0)
            moneytext:SetContentAlignment(6)
            moneytext:SetFont("Trebuchet32Bold")
            moneytext:SetText(sum .. "cc")
            moneytext:SizeToContents()

            reward:MoveTo(0, reward:GetY(), 0.56, 0, 16, function()
                surface.PlaySound("gmstation/sfx/payout/payout_end.mp3")

                GUIElements.reward:MoveTo(GUIElements.reward:GetX(), GUIElements.reward:GetY() - 64, 4, 0, 1, function()
                    GUIElements.reward:Remove()
                end)

                GUIElements.reward:AlphaTo(0, 4, 0)
            end)
        end

        i = i + 1
    end)
end)