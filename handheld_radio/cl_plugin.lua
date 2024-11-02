local PLUGIN = PLUGIN

net.Receive("FrequencyRequest", function()
	local frequency = net.ReadString()
	local item_id = net.ReadInt(32)
	Derma_StringRequest(
			"Radio", 
			"Write frequency",
			frequency,
			function(text) 
				local reg = string.match(text, "^%d%d%.%d%d%d$")
				if reg then
					LocalPlayer():Notify("You changed frequency of handheld radio on "..reg.."!")
					net.Start("FrequencyChanging")
					net.WriteString(reg)
					net.WriteInt(item_id, 32)
					net.SendToServer()
				else
					LocalPlayer():Notify("You typed incorect frequency!")
				end
			end)
end)

net.Receive("ForceSpeak", function() 
	local b = net.ReadBool()
	permissions.EnableVoiceChat(b)
end)