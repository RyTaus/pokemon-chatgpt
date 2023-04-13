-- This template lives at `.../Lua/.template.lua`.

Pokemon = {}

function Pokemon.getPokemonData(start)
	local personality = Memory.readdword(start)
	local otid = Memory.readdword(start + 4)
	local magicword = personality ~ otid

	local aux = personality % 24
	local attackoffset = (TableData.attack[aux + 1] - 1) * 12
	local growthoffset = (TableData.growth[aux + 1] - 1) * 12

	-- get the 4 words of attacks.
	-- get this in this step so we can bxor with the entire magicword
	local attack1 = Memory.readdword(start + 32 + attackoffset) ~ magicword
	local attack2 = Memory.readdword(start + 32 + attackoffset + 4) ~ magicword

	local move1 = Utils.getbits(attack1, 0, 16)
	local move2 = Utils.getbits(attack1, 16, 16)
	local move3 = Utils.getbits(attack2, 0, 16)
	local move4 = Utils.getbits(attack2, 16, 16)

	-- get pokemon species
	local species_dword = Memory.readdword(start + 32 + growthoffset) ~ magicword
	local pokemon_id = Utils.getbits(species_dword, 0, 16)

	-- get Current HP. This is junk if reading from box pokemon.
	local level_and_currenthp = Memory.readdword(start + 84)
	local maxhp_and_atk = Memory.readdword(start + 88)

	local currenthp = Utils.getbits(level_and_currenthp, 16, 16)
	local maxhp = Utils.getbits(maxhp_and_atk, 0, 16)

	local status_aux = Memory.readdword(start + 80)

	-- stat stages are from another place only during battle, so need to grab them from there.
	return {
		pokemon_id = pokemon_id,
		moves = { move1, move2, move3, move4 },
		currenthp = currenthp,
		maxhp = maxhp,
		status = Status.GetStatusName(status_aux)
	}
end

function Pokemon.IsValid(pokemon)
	return pokemon ~= nil and pokemon.pokemon_id ~= nil and pokemon.pokemon_id >= 1 and pokemon.pokemon_id < #Data.Pokemon
end

local function GetPokemonList(start, offset, amount)
	local party = { }
	local current_pointer = start
	local current_party_idx = 1
	for idx = 0, amount - 1 do
		local pokemon = Pokemon.getPokemonData(current_pointer)
		if (Pokemon.IsValid(pokemon)) then
			party[current_party_idx] = pokemon
			current_party_idx = current_party_idx + 1
		end
		current_pointer = current_pointer + offset
	end
	return party
end

local function GetPartyPokemonList(start, offset, amount, active_idx)
	local party = { }
	local current_pointer = start
	local current_party_idx = 1
	for idx = 0, amount - 1 do
		local pokemon = Pokemon.getPokemonData(current_pointer)
		if (not Pokemon.IsValid(pokemon)) then
			break
		end
		party[current_party_idx] = pokemon
		current_party_idx = current_party_idx + 1
		current_pointer = current_pointer + offset
	end
	party[1], party[active_idx] = party[active_idx], party[1]
	return party
end

function Pokemon.GetParty()
	local active_idx = Memory.read8(GameSettings.active_pokemon_index)
	return GetPartyPokemonList(GameSettings.party_memory_start, 100, 6, active_idx + 1)
end

function Pokemon.GetEnemyParty()
	local active_idx = Memory.read8(GameSettings.enemy_active_pokemon_index)
	return GetPartyPokemonList(GameSettings.enemy_memory_start, 100, 6, active_idx + 1)
end

function Pokemon.GetBoxPokemon()
	return GetPokemonList(Memory.read32(GameSettings.box_memory_start_pointer) + 4, 80, 420)
end

function Pokemon.getPokemonString(pokemon)
	local moves = {}
	for key, value in pairs(pokemon.moves) do
		if value ~= 0 then
			moves[key] = Data.Moves[value + 1]
		end
	end
	local health = string.format("%.0f%%", 100 * pokemon.currenthp / pokemon.maxhp)
	local status = Utils.inlineIf(pokemon.status == "NONE", "", "[" .. pokemon.status .. "]")
	return Data.Pokemon[pokemon.pokemon_id + 1] .. " ["  .. health .. "] " .. status .. " [" .. table.concat(moves, ", ") .. "]"
end

function Pokemon.getEnemyPokemonString(pokemon)
	local moves = {}
	for key, value in pairs(pokemon.moves) do
		if value ~= 0 then
			moves[key] = Data.Moves[value + 1]
		end
	end
	local health = string.format("%.0f%%", 100 * pokemon.currenthp / pokemon.maxhp)
	local status = Utils.inlineIf(pokemon.status == "NONE", "", " [" .. pokemon.status .. "]")
	return Data.Pokemon[pokemon.pokemon_id + 1] .. status .. " ["  .. health .. "]"
end

function Pokemon.getBoxPokemonString(pokemon)
	local moves = {}
	for key, value in pairs(pokemon.moves) do
		if value ~= 0 then
			moves[key] = Data.Moves[value + 1]
		end
	end
	return Data.Pokemon[pokemon.pokemon_id + 1] .. " [" .. table.concat(moves, ", ") .. "]"
end