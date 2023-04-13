GameSettings = {}
-- these are all specific to Pokemon FireRed
GameSettings.party_memory_start         = 0x02024284
GameSettings.enemy_memory_start         = 0x0202402C
GameSettings.box_memory_start_pointer   = 0x03005010
GameSettings.num_party_pokemon          = 0x02024029

GameSettings.active_pokemon_index       = 0x02023BCE
GameSettings.enemy_active_pokemon_index = 0x02023BD0

-- Starts at 6
-- 023C02 is player accuracy
-- 023C56 is enemy defense

-- Player likely goes from 023BFC -> 023C03
--[[
0x023BFC = 0x023C54 = // might be placeholder for hp?
0x023BFD = 0x023C55 = attack
0x023BFE = 0x023C56 = defense
0x023BFF = 0x023C57 = speed
0x023C00 = 0x023C58 = special attack
0x023C01 = 0x023C59 = special defense
0x023C02 = 0x023C5A = accuracy
0x023C03 = 0x023C5B = evasiveness
]]
-- Enemy likely goes from 023C54 -> 023C5B
GameSettings.player_stat_defense_change_offset  = 0x02023BFE -- these start at 6
GameSettings.player_stat_defense_change_offset  = 0x02023C02 -- goes from 023BFC -> 023C03