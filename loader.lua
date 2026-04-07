local BASE_URL = "https://raw.githubusercontent.com/marcoscarneiroaj/moneycash/main/"
local cacheBust = tostring(os.time())
local scriptUrl = BASE_URL .. "moneycash.lua?v=" .. cacheBust

local source = game:HttpGet(scriptUrl, true)
if type(source) ~= "string" or source == "" then
    error("falha ao carregar moneycash.lua")
end

return loadstring(source, "@moneycash/loader.lua")()
