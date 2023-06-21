include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/humans/group01/female_02.mdl")
	self:SetSolid(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_STEP)
end

net.Receive("gmstation_store", function()
	local store_type = net.ReadString()
	local message = net.ReadString()
	local exitMessage = net.ReadString()
	local store_items = {}
	GMST_DisplaySpeech(nil, message, "Shopkeeper")

	if GUIElements.store then
		GUIElements.store:Remove()
	end

	if CL_GLOBALS.currentSound then
		CL_GLOBALS.currentSound:ChangeVolume(0.01, 0.5)
	end

	local music = CreateSound(LocalPlayer(), "gmstation/music/store.mp3")
	music:Stop()
	music:PlayEx(CL_GLOBALS.volume, 100)

	timer.Create("gmstation_store_music", 60, 0, function()
		music:Stop()
		music:PlayEx(CL_GLOBALS.volume, 100)
	end)

	GUIElements.store = vgui.Create("DPanel")
	GUIElements.store:SetSize(math.min(600, ScrW() - 100), ScrH())
	GUIElements.store:SetX(ScrW())
	GUIElements.store:MoveTo(ScrW() - GUIElements.store:GetWide(), 0, 0.5, 0, 0.5, function() end)
	GUIElements.store:MakePopup()
	local loading = vgui.Create("DLabel", GUIElements.store)
	loading:Dock(FILL)
	loading:SetFont("Trebuchet32")
	loading:SetText("Fetching items...")
	loading:SetContentAlignment(5)

	GUIElements.store.close = function()
		hook.Remove("Think", "gmstation_store_close")
		gui.HideGameUI()

		GUIElements.store:MoveTo(ScrW(), 0, 0.5, 0, 0.5, function()
			GUIElements.store:Remove()
		end)

		timer.Remove("gmstation_store_music")
		GMST_DisplaySpeech(nil, exitMessage, "Shopkeeper")
		music:FadeOut(1)

		if CL_GLOBALS.currentSound then
			CL_GLOBALS.currentSound:ChangeVolume(CL_GLOBALS.volume * CL_GLOBALS.ogVolume)
		end
	end

	local store = vgui.Create("DScrollPanel", GUIElements.store)
	store:Dock(FILL)
	store:DockMargin(5, 5, 5, 5)

	apiCall("store_items", {
		store_id = "1"
	}, function(data)
		local cartItems = {}
		local total = 0
		local count = 0
		store_items = data
		loading:Remove()
		if !IsValid(store) then return end
		local cartPanel = vgui.Create("DPanel", GUIElements.store)
		cartPanel:SetTall(48)
		cartPanel:Dock(BOTTOM)
		cartPanel:DockMargin(5, 5, 5, 5)

		cartPanel.Paint = function(self, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 100))
		end

		local cart = vgui.Create("DLabel", cartPanel)
		cart:Dock(LEFT)
		cart:DockMargin(8, 8, 0, 8)
		cart:SetFont("Trebuchet24Bold")
		cart:SetText("Cart: 0 items / 0cc")
		cart:SizeToContents()
		local review = vgui.Create("DButton", cartPanel)
		review:Dock(RIGHT)
		review:DockMargin(8, 8, 8, 8)
		review:SetWide(64)
		review:SetText("Review")

		review.DoClick = function()
			if count == 0 then
				GMST_DisplaySpeech(nil, "You have no items in your cart!", "Shopkeeper")

				return
			end

			local reviewPanel = vgui.Create("DFrame", GUIElements.store)
			reviewPanel:SetSize(math.min(600, ScrW() - 100), math.min(600, ScrH() - 100))
			reviewPanel:Center()
			reviewPanel:SetDraggable(false)
			reviewPanel:SetTitle("Review cart")
			local reviewItems = vgui.Create("DScrollPanel", reviewPanel)
			reviewItems:Dock(FILL)
			reviewItems:DockMargin(5, 5, 5, 5)

			for v, k in pairs(cartItems) do
				k = GMSTBase_GetItemInfo(v)
				local item = vgui.Create("DPanel", reviewItems)
				item:Dock(TOP)
				item:DockMargin(0, 0, 0, 5)
				item:SetTall(128)
				item:InvalidateLayout(true)

				item.Paint = function(self, w, h)
					draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 100))
				end

				local model = vgui.Create("DModelPanel", item)
				model:SetModel(k.model)
				model:Dock(LEFT)
				model:SetWide(128)
				model:SetModel(k.model)
				model:SetCamPos(Vector(100, 100, 50))
				model:SetLookAt(Vector(0, 0, 0))
				model:SetFOV(40)
				model:SetAnimSpeed(20)
				local remove = vgui.Create("DButton", item)
				remove:Dock(BOTTOM)
				remove:DockMargin(8, 8, 8, 8)
				remove:SetWide(64)
				remove:SetText("Remove")
				local name = vgui.Create("DLabel", item)
				name:Dock(TOP)
				name:DockMargin(8, 8, 0, 0)
				name:SetFont("Trebuchet24Bold")
				name:SetText(k.name .. " (" .. cartItems[v] .. ")")
				name:SizeToContents()
				local desc = vgui.Create("DLabel", item)
				desc:Dock(TOP)
				desc:DockMargin(8, 2, 0, 0)
				desc:SetFont("Trebuchet8")
				desc:SetText(k.description)

				remove.DoClick = function()
					surface.PlaySound("buttons/button14.wav")

					if cartItems[v] == 1 then
						cartItems[v] = nil
						item:Remove()
					else
						cartItems[v] = cartItems[v] - 1
						name:SetText(k.name .. " (" .. cartItems[v] .. ")")
					end

					count = 0

					for v, k in pairs(cartItems) do
						count = count + k
					end

					total = total - k.price

					if count == 0 then
						reviewPanel:Remove()
					end

					cart:SetText("Cart: " .. count .. " items / " .. total .. "cc")
					cart:SizeToContents()
				end
			end

			local purchase = vgui.Create("DButton", reviewPanel)
			purchase:Dock(BOTTOM)
			purchase:DockMargin(5, 5, 5, 5)
			purchase:SetTall(48)
			purchase:SetText("Purchase")

			purchase.DoClick = function()
				surface.PlaySound("buttons/button14.wav")

				if count == 0 then
					GMST_DisplaySpeech(nil, "You have no items in your cart!", "Shopkeeper")

					return
				end

				if count > 500 then
					GMST_DisplaySpeech(nil, "You can only purchase 500 items at a time!", "Shopkeeper")

					return
				end

				if CL_GLOBALS.money < total then
					GMST_DisplaySpeech(nil, "You do not have enough money to purchase these items!", "Shopkeeper")

					return
				end

				GUIElements.buying = vgui.Create("DPanel")
				GUIElements.buying:SetSize(ScrW(), ScrH())
				GUIElements.buying:MakePopup()

				GUIElements.buying.Paint = function(self, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
					draw.SimpleText("Purchasing...", "Trebuchet48Bold", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				net.Start("gmstation_store")
				net.WriteTable(cartItems)
				net.SendToServer()
			end
		end

		for v, k in ipairs(store_items) do
			local id = k
			k = GMSTBase_GetItemInfo(k)
			local item = vgui.Create("DPanel", store)
			item:Dock(TOP)
			item:DockMargin(0, 0, 0, 5)
			item:SetTall(128)
			item:InvalidateLayout(true)

			item.Paint = function(self, w, h)
				draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 100))
			end

			local model = vgui.Create("DModelPanel", item)
			model:Dock(LEFT)
			model:SetWide(128)
			model:SetModel(k.model)
			model:SetCamPos(Vector(100, 100, 50))
			model:SetLookAt(Vector(0, 0, 0))
			model:SetFOV(40)
			model:SetAnimSpeed(20)
			local addtocart = vgui.Create("DButton", item)
			addtocart:Dock(BOTTOM)
			addtocart:DockMargin(8, 8, 8, 8)
			addtocart:SetWide(64)
			addtocart:SetText("Add to cart")

			addtocart.DoClick = function()
				if k.type == "hat" then
					if cartItems[id] then
						GMST_DisplaySpeech(nil, "I think you already have this hat in your cart...", "Shopkeeper")

						return
					elseif CL_GLOBALS.inventory[id] then
						GMST_DisplaySpeech(nil, "I don't think you need two of these hats...", "Shopkeeper")

						return
					end
				end

				surface.PlaySound("buttons/button14.wav")
				total = total + k.price

				if !cartItems[id] then
					cartItems[id] = 1
				else
					cartItems[id] = cartItems[id] + 1
				end

				count = 0

				for v, k in pairs(cartItems) do
					count = count + k
				end

				cart:SetText("Cart: " .. count .. " items / " .. total .. "cc")
				cart:SizeToContents()
			end

			local name = vgui.Create("DLabel", item)
			name:Dock(TOP)
			name:DockMargin(8, 8, 0, 0)
			name:SetText(k.name)
			name:SetFont("Trebuchet24Bold")
			name:SetTall(32)
			local desc = vgui.Create("DLabel", item)
			desc:Dock(FILL)
			desc:DockMargin(8, 2, 0, 0)
			desc:SetContentAlignment(7)
			desc:SetFont("Trebuchet8")
			desc:SetText(k.description)
			desc:SetVerticalScrollbarEnabled(false)
			local price = vgui.Create("DLabel", item)
			price:SetFont("Trebuchet8")
			price:SetText(k.price .. "cc")
			price:SetContentAlignment(9)
			price:SetWide(GUIElements.store:GetWide() - 16 - 8)
			price:SetPos(0, 14)
		end
	end)

	local titlebar = vgui.Create("DPanel", GUIElements.store)
	titlebar:SetSize(GUIElements.store:GetWide(), 48)
	titlebar:Dock(TOP)
	local title = vgui.Create("DLabel", titlebar)
	title:Dock(LEFT)
	title:DockMargin(16, 0, 0, 0)
	title:SetFont("Trebuchet32")
	title:SetText("Store")
	title:SizeToContents()
	local closebutton = vgui.Create("DImageButton", titlebar)
	closebutton:Dock(RIGHT)
	closebutton:SetWide(32)
	closebutton:DockMargin(0, 8, 8, 8)
	closebutton:SetImage("icon16/cross.png")

	closebutton.DoClick = function()
		GUIElements.store.close()
	end

	hook.Add("Think", "gmstation_store_close", function()
		if input.IsKeyDown(KEY_ESCAPE) then
			GUIElements.store.close()
		end
	end)
end)

net.Receive("gmstation_purchased", function()
	if IsValid(GUIElements.buying) then
		GUIElements.buying:Remove()
	end

	if IsValid(GUIElements.store) then
		GUIElements.store.close()
	end
end)
