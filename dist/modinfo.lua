name                        = "Movie Mode"
author                      = "KaiserKatze"
version                     = "1.2.0"
description                 = "Version "..version.."\n\nShoot your own movie from now on!\n"..[[
Press 'C' key (or any other key you bind) to toggle the visibility of the HUD and your character.
]]
forumthread                 = ""
api_version                 = 10

-- Compatibilities
dst_compatible              = true
dont_starve_compatible      = false
reign_of_giants_compatible  = false
shipwrecked_compatible      = false
all_clients_require_mod     = false
client_only_mod             = true
server_filter_tags          = { "Movie" }

icon_atlas                  = "modicon.xml"
icon                        = "modicon.tex"

-- alphabet
local alpha = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
-- bound keys
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- update this list if other mods which don't support changing key-binding are found
local bound = {
    "W","A","S","D",    -- directions
    "Q","E",            -- rotate
    "F",                -- attack
    "I",                -- inspect self
    "U",                -- whisper
    "Y"                 -- say
}
-- value of key 'A'
local KEY_A = 97
local keyslist = {}
-- Judge whether character `k` is bound or not
local function IsBound(k)
    for i = 1, #bound do
        if bound[i] == k then
            return true
        end
    end
    return false
end
-- traverse the alphabet to find available keys for binding
local j = 1
for i = 1, #alpha do
    -- get `i`th character in the alphabet
    local c = alpha[i]
    if not IsBound(c) then
        -- the key is not yet bound
        -- get value of this key
        local data  = i + KEY_A - 1
        keyslist[j] =
        {
            description = c,    -- representation
            data        = data  -- data de facto
        }
        j = j + 1
        --print(i, c, data)
    end
end
configuration_options =
{
    {
        name = "MOVIE_KEY",     -- input handle name
        label = "Key Binding",  -- label for input handle 'MOVIE_KEY'
        hover = "Choose an available key as placebo!",
        options = keyslist,     -- options
        default = 99,           -- Button 'C'
    },
}