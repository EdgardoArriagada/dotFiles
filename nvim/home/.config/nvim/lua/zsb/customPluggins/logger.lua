local function jsLogger()
	Execute('normal<Esc>"xyiwoconsole.log(\'le <Esc>"xpa\', <Esc>"xpa)<Esc><left><left>')
end

local function luaLogger()
	Execute('normal<Esc>"xyiwoprint(\'le <Esc>"xpa\', <Esc>"xpa)<Esc><left><left>')
end

local function rustLogger()
	Execute('normal<Esc>"xyiwoprintln!("le <Esc>"xpa {}", <Esc>"xpa);<Esc><left><left><left>')
end

local function zshLogger()
	Execute('normal<Esc>"xyiwoprint "le <Esc>"xpa: ${<Esc>"xpa}"; <Esc><left><left><left>b')
end

local extensionToFunction = {
	["js"] = jsLogger,
	["ts"] = jsLogger,
	["jsx"] = jsLogger,
	["tsx"] = jsLogger,
	["lua"] = luaLogger,
	["rs"] = rustLogger,
	["zsh"] = zshLogger,
}

function Logger()
	local extension = vim.fn.expand("%:e")
	local fun = extensionToFunction[extension]

	if fun == nil then
		print("No logger function for '" .. extension .. "' extension")
		return
	end

	fun()
end
