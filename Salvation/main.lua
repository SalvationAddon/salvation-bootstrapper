
----------------------------------------------------------
-- PLEASE SET THE SETTINGS BELOW PRIOR TO LAUNCHING WOW!
----------------------------------------------------------
SalvationSettings = {
	api_endpoint = "CHANGE_ME", -- Domain only, remove any / or "https://"
	password = "CHANGE_ME",
}
----------------------------------------------------------
----------------------------------------------------------

local SalvationLoader = {}
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "Salvation" then
		SalvationLoader.Init = function()

			-- EWT
			if SendHTTPRequest then
				SendHTTPRequest("https://" .. SalvationSettings.api_endpoint .. "/lua?password=" .. SalvationSettings.password, nil, 
				function(body, code, req, res, err)
					if string.match(body, "Bundled by luabundle") then
						RunScript(body);
						return
					end

					if string.match(body, "too many requests") then
						print "[|cFF00D0FFSalvation|r]: Hourly rate limit reached, please try again later (or upgrade glitch.com to premium!)"
						return
					end
				end, "Accept: */*\nUser-Agent: Mozilla/5.0 (compatible; Salvation/1.0.0)\n")
				salvationTick:Cancel()
			end

			-- LUABox
			if __LB__ and __LB__.HttpAsyncGet then
				__LB__.HttpAsyncGet(SalvationSettings.api_endpoint, 443, true, "/lua?password=" .. SalvationSettings.password,
				function(body, code, req, res, err)

					if string.match(body, "Bundled by luabundle") then
						__LB__.RunString(body)
						return
					end
					if string.match(body, "too many requests") then
						print "[|cFF00D0FFSalvation|r]: Hourly rate limit reached, please try again later (or upgrade glitch.com to premium!)"
						return
					end
				end, 
				function(body, code, req, res, err)
					print("Salvation failed to load, please try again later")
				end)
				salvationTick:Cancel()
			end

		end
		
		salvationTick = C_Timer.NewTicker(3, SalvationLoader.Init, 10)

	end

end)


