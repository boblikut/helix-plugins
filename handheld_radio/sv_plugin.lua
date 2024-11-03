local PLUGIN = PLUGIN

util.AddNetworkString("FrequencyRequest")
util.AddNetworkString("FrequencyChanging")
util.AddNetworkString("ForceSpeak")

net.Receive("FrequencyChanging", function(len, client)
	local frequency = net.ReadString()
	local item_id = net.ReadInt(32)
	
	local character = client:GetCharacter()
	local inventory = character:GetInventory()
	
	for item in inventory:Iter() do
		if item:GetID() == item_id then
			item:SetData("frequency", frequency)
		end
	end
	
end)

function PLUGIN:PlayerButtonDown(client, button)
	if button == KEY_T then
		local character = client:GetCharacter()
		local inventory = character:GetInventory()
		client.isRadioSpeaking = false
		for item in inventory:Iter() do
			if item.base == "base_radio" and item:GetData("enabled") then
				client.frequency = item:GetData("frequency", "00.000")
				client.isRadioSpeaking = true
				net.Start("ForceSpeak")
				net.WriteBool(true)
				net.Send(client)
				client:EmitSound("npc/metropolice/vo/on1.wav", 75, 100, 0.2)
				break
			end
		end
	end
end

function PLUGIN:PlayerButtonUp(client, button)
	if button == KEY_T then
		net.Start("ForceSpeak")
		net.WriteBool(false)
		net.Send(client)
		client.isRadioSpeaking = false
		client:EmitSound("npc/metropolice/vo/off1.wav", 75, 100, 0.2)
	end
end

function PLUGIN:PlayerCanHearPlayersVoice(listener, talker)
	if listener.isRadioSpeaking and talker.isRadioSpeaking then
		if listener.frequency == talker.frequency then
			return true
		end
	end
end