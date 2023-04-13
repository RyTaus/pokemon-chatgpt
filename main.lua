Buttons = {
	PrintStateButton = {
		x = client.bufferwidth(),
		y = 0,
		w = 100,
		h = 20,
		text = "Battle State",
		onclick = function ()
			console.clear()
			print(State.PrintStateString())
		end,
	},

	PrintAllPokemonOwnedButton = {
		x = client.bufferwidth(),
		y = 22,
		w = 100,
		h = 20,
		text = "Planning State",
		onclick = function ()
			console.clear()
			print(State.PrintAllOwnedPokemon())
		end,
	},

	DebugButton = {
		x = client.bufferwidth(),
		y = 100,
		w = 100,
		h = 20,
		text = "Debug",
		onclick = function ()
			console.clear()
			print("address at box")
			print(string.format("%x", Memory.read32(GameSettings.box_memory_start_pointer)))
		end,
	},
}

Program = {}

Program.MouseDownInPreviousFrame = false

function Program.RenderButton(button)
	gui.drawRectangle(
		button.x,
		button.y,
		button.w,
		button.h,
		0xFFFFFFFF,
		0xDDFFFFFF)
	gui.drawText(
		button.x + (button.w / 2),
		button.y + (button.h / 2),
		button.text,
		0xFF000000,
		nil,
		11,
		"Arial", nil, "center", "middle"
	)
end

function Program.HandleInputs()
	local mouse = input.getmouse()
	if mouse.Left and not Program.MouseDownInPreviousFrame then
		for key, button in pairs(Buttons) do
			if (true
				and mouse.X > button.x
				and mouse.X < button.x + button.w
				and mouse.Y > button.y
				and mouse.Y < button.y + button.h) then
					button.onclick()
				end
		end
	end 
	Program.MouseDownInPreviousFrame = mouse.Left
end

function Program.Render()
	for key, button in pairs(Buttons) do
		Program.RenderButton(button)
	end
end

function Program.Initialize()
	-- Draw Static Button
	for key, button in pairs(Buttons) do
		Program.RenderButton(button)
	end
end

function Program.mainloop()
	Program.HandleInputs()
	Program.Render()
	emu.frameadvance()
end

function Program.Run()
	Program.Initialize()
	while true do
		Program.mainloop()
	end
end

Program.Run()