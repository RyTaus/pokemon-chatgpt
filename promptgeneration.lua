Prompt = {}

local function shufflelist(list)
	for i = #list, 2, -1 do
		local j = math.random(i)
		list[i], list[j] = list[j], list[i]
	end
end

local function GenerateTeamString(party, tostringfunction, prefix)
	local active = tostringfunction(party[1])

	local remaining = {}
	for idx, poke in ipairs(party) do
		if idx ~= 1 then
			if poke.currenthp ~= 0 then
				remaining[#remaining+1] = " - " .. tostringfunction(poke)
			end
		end
	end
	shufflelist(remaining)
	local remaining_string = ""
	for _, value in ipairs(remaining) do
		remaining_string = remaining_string .. "\n" .. value
	end

	local stringbuilder = ""
	stringbuilder = stringbuilder .. prefix .. "ACTIVE pokemon: " .. active
	
	if #remaining > 0 then
		stringbuilder = stringbuilder .. "\n"
		stringbuilder = stringbuilder .. prefix .. "PARTY pokemon: " .. remaining_string
	end
	return stringbuilder
end

local function GenerateActionListString()
	local stringbuilder = "ACTION list: "
	local party = Pokemon.GetParty()

	local action_list = {}
	for index, value in ipairs(party) do
		if index ~= 1 and value.currenthp > 0 then
			action_list[#action_list+1] = " - SWITCH to " .. Data.Pokemon[value.pokemon_id + 1]
		end
	end
	for index, value in ipairs(party[1].moves) do
		if value ~= 0 then
			action_list[#action_list+1] = " - ATTACK with " .. Data.Moves[value + 1]
		end
	end
	shufflelist(action_list)
	for index, value in ipairs(action_list) do
		stringbuilder = stringbuilder .. "\n"
		stringbuilder = stringbuilder .. value
	end

	return stringbuilder
end

function Prompt.GenerateBattlePrompt()
	print(GenerateTeamString(Pokemon.GetParty(), Pokemon.getPokemonString, ""))
	print("")
	print(GenerateTeamString(Pokemon.GetEnemyParty(), Pokemon.getEnemyPokemonString, "ENEMY "))
	print("")
	print(GenerateActionListString())
end

function Prompt.GeneratePartyPrompt()
	print("I need you to choose a team of pokemon for a battle in Pokemon Fire Red. I only have certain pokemon available I can use. Below are the pokemon available to use along with the moves that they know.")
	print("")

	local pokemon_number = 1

	local party = Pokemon.GetParty()
	for idx, poke in ipairs(party) do
		print(pokemon_number .. ". " .. Pokemon.getBoxPokemonString(poke))
		pokemon_number = pokemon_number + 1
	end

	local pc = Pokemon.GetBoxPokemon()
	for idx, poke in ipairs(pc) do
		print(pokemon_number .. ". " .. Pokemon.getBoxPokemonString(poke))
		pokemon_number = pokemon_number + 1
	end

	print("")
end