local PLUGIN = PLUGIN

net.Receive("ForceSpeak", function() 
	local b = net.ReadBool()
	permissions.EnableVoiceChat(b)
end)
