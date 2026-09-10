local source = {}

local function normalize(path)
	return vim.fs.normalize(vim.fn.expand(path))
end

local function config_home(env_name, fallback)
	local configured = vim.env[env_name]
	return normalize(configured and configured ~= "" and configured or fallback)
end

local function client_for_path(path)
	path = normalize(path)
	local directory = vim.fs.dirname(path)
	local filename = vim.fs.basename(path)
	local codex_home = config_home("CODEX_HOME", "~/.codex")

	if directory == vim.fs.joinpath(codex_home, "editor") and filename:match("^%.tmp.+%.md$") then
		return { name = "codex", prefix = "$" }
	end

	if filename:match("^claude%-prompt%-.+%.md$") and vim.fs.basename(directory):match("^claude%-%d+$") then
		return { name = "claude", prefix = "/" }
	end
end

local function clean_scalar(value)
	value = vim.trim(value)
	local quote = value:sub(1, 1)
	if (quote == '"' or quote == "'") and value:sub(-1) == quote then
		return value:sub(2, -2)
	end
	return value
end

local function read_skill(path)
	local ok, lines = pcall(vim.fn.readfile, path, "", 80)
	if not ok or lines[1] ~= "---" then
		return
	end

	local name
	local description = {}
	local reading_description = false
	for index = 2, #lines do
		local line = lines[index]
		if line == "---" then
			break
		end

		local key, value = line:match("^([%w_-]+):%s*(.*)$")
		if key then
			reading_description = key == "description" and value:match("^[>|]") ~= nil
			if key == "name" then
				name = clean_scalar(value)
			elseif key == "description" and not reading_description then
				description[1] = clean_scalar(value)
			end
		elseif reading_description and line:match("^%s+") then
			description[#description + 1] = vim.trim(line)
		end
	end

	local directory = vim.fs.basename(vim.fs.dirname(path))
	name = name or directory
	if not name:match("^[%w_.:-]+$") or not directory:match("^[%w_.:-]+$") then
		return
	end

	local summary = table.concat(description, " "):gsub("%s+", " ")
	if vim.fn.strchars(summary) > 500 then
		summary = vim.fn.strcharpart(summary, 0, 500) .. "…"
	end
	return { name = name, directory = directory, description = summary, path = path }
end

local function add_root(roots, path, namespace)
	path = normalize(path)
	if vim.fn.isdirectory(path) == 1 then
		roots[#roots + 1] = { path = path, namespace = namespace }
	end
end

local function add_project_roots(roots, directory)
	local current = normalize(vim.fn.getcwd())
	local root = vim.fs.root(current, ".git") or current
	while true do
		add_root(roots, vim.fs.joinpath(current, directory))
		if current == root then
			break
		end
		local parent = vim.fs.dirname(current)
		if parent == current then
			break
		end
		current = parent
	end
end

local function read_json(path)
	local size = vim.fn.getfsize(path)
	if size < 0 or size > 1024 * 1024 then
		return
	end
	local ok, lines = pcall(vim.fn.readfile, path)
	if not ok then
		return
	end
	local decoded, value = pcall(vim.json.decode, table.concat(lines, "\n"))
	return decoded and value or nil
end

local function add_claude_plugins(roots, claude_home)
	local plugins = read_json(vim.fs.joinpath(claude_home, "plugins", "installed_plugins.json"))
	local settings = read_json(vim.fs.joinpath(claude_home, "settings.json")) or {}
	local enabled = settings.enabledPlugins or {}
	for id, installs in pairs((plugins or {}).plugins or {}) do
		if enabled[id] ~= false then
			local namespace = id:match("^([^@]+)")
			for _, install in ipairs(installs) do
				add_root(roots, install.installPath, namespace)
			end
		end
	end
end

local function roots_for(client)
	local roots = {}
	if client.name == "codex" then
		local codex_home = config_home("CODEX_HOME", "~/.codex")
		add_project_roots(roots, ".agents/skills")
		add_root(roots, "~/.agents/skills")
		add_root(roots, vim.fs.joinpath(codex_home, "skills"))
		add_root(roots, "/etc/codex/skills")

		local cache = vim.fs.joinpath(codex_home, "plugins", "cache")
		add_root(roots, cache, function(path)
			local relative = path:sub(#cache + 2)
			return relative:match("^[^/]+/([^/]+)/")
		end)
	else
		local claude_home = config_home("CLAUDE_CONFIG_DIR", "~/.claude")
		add_root(roots, vim.fs.joinpath(claude_home, "skills"))
		add_project_roots(roots, ".claude/skills")
		add_claude_plugins(roots, claude_home)
	end
	return roots
end

local function find_skill_files(root)
	local files = {}
	local seen = {}
	local function walk(directory)
		local realpath = vim.uv.fs_realpath(directory)
		if not realpath or seen[realpath] or #files >= 1000 then
			return
		end
		seen[realpath] = true

		local skill = vim.fs.joinpath(directory, "SKILL.md")
		if (vim.uv.fs_stat(skill) or {}).type == "file" then
			files[#files + 1] = skill
			return
		end

		local scanner = vim.uv.fs_scandir(directory)
		if not scanner then
			return
		end
		while true do
			local name, kind = vim.uv.fs_scandir_next(scanner)
			if not name then
				break
			end
			local path = vim.fs.joinpath(directory, name)
			if kind == "directory" or (kind == "link" and (vim.uv.fs_stat(path) or {}).type == "directory") then
				walk(path)
			end
		end
	end

	walk(root)
	return files
end

local function discover(client)
	local skills = {}
	local seen = {}
	for _, root in ipairs(roots_for(client)) do
		-- ponytail: cap discovery per root; raise if a skill tree exceeds 1000 entries.
		for _, path in ipairs(find_skill_files(root.path)) do
			local skill = read_skill(path)
			if skill then
				local name = client.name == "claude" and skill.directory or skill.name
				local namespace = type(root.namespace) == "function" and root.namespace(path) or root.namespace
				name = namespace and namespace .. ":" .. name or name
				if not seen[name] then
					seen[name] = true
					skill.name = name
					skills[#skills + 1] = skill
				end
			end
		end
	end
	table.sort(skills, function(left, right)
		return left.name < right.name
	end)
	return skills
end

function source.new()
	return setmetatable({ cache = {} }, { __index = source })
end

function source:get_debug_name()
	return "agent_skills"
end

function source:get_trigger_characters()
	return { "$", "/" }
end

function source:get_keyword_pattern()
	return [[\%(\$\|/\)\S*]]
end

function source:is_available()
	return client_for_path(vim.api.nvim_buf_get_name(0)) ~= nil
end

function source:complete(params, callback)
	local client = client_for_path(vim.api.nvim_buf_get_name(0))
	if not client then
		callback({})
		return
	end

	local line = params.context.cursor_before_line
	local pattern = client.prefix == "$" and "%$[%w_.:%-]*$" or "/[%w_.:%-]*$"
	local start = line:find(pattern)
	if not start or (start > 1 and not line:sub(start - 1, start - 1):match("%s")) then
		callback({})
		return
	end

	local key = client.name .. "\0" .. vim.fn.getcwd()
	self.cache[key] = self.cache[key] or discover(client)
	local cursor = params.context.cursor
	local items = {}
	for _, skill in ipairs(self.cache[key]) do
		local label = client.prefix .. skill.name
		local path = vim.fn.fnamemodify(skill.path, ":~:."):gsub("`", "\\`")
		local documentation = skill.description ~= "" and skill.description .. "\n\n" or ""
		items[#items + 1] = {
			label = label,
			filterText = label,
			sortText = skill.name,
			detail = client.name .. " skill",
			documentation = { kind = "markdown", value = documentation .. "`" .. path .. "`" },
			textEdit = {
				newText = label,
				range = {
					start = { line = cursor.line, character = start - 1 },
					["end"] = { line = cursor.line, character = cursor.character },
				},
			},
		}
	end
	callback(items)
end

source._client_for_path = client_for_path
source._read_skill = read_skill

return source
