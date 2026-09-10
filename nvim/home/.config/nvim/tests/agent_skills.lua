local agent_skills = require("zsb.customPluggins.cmpAgentSkills")
local temporary = vim.fn.tempname()
local original_cwd = vim.fn.getcwd()

vim.fn.mkdir(temporary .. "/.agents/skills/test-codex", "p")
vim.fn.mkdir(temporary .. "/.claude/skills/test-claude", "p")
vim.fn.mkdir(temporary .. "/linked-skill", "p")
vim.fn.writefile(
	{ "---", "name: test-codex", "description: >", "  Codex fixture", "---" },
	temporary .. "/.agents/skills/test-codex/SKILL.md"
)
vim.fn.writefile(
	{ "---", "name: ignored-by-claude", "description: Claude fixture", "---" },
	temporary .. "/.claude/skills/test-claude/SKILL.md"
)
vim.fn.writefile(
	{ "---", "name: linked-skill", "description: Symlink fixture", "---" },
	temporary .. "/linked-skill/SKILL.md"
)
assert(vim.uv.fs_symlink(temporary .. "/linked-skill", temporary .. "/.agents/skills/linked-skill"))

local parsed = agent_skills._read_skill(temporary .. "/.agents/skills/test-codex/SKILL.md")
assert(parsed.name == "test-codex" and parsed.description == "Codex fixture")

local function complete(path, input, expected)
	local buffer = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_current_buf(buffer)
	vim.api.nvim_buf_set_name(buffer, path)
	local items
	agent_skills.new():complete({
		context = {
			cursor_before_line = input,
			cursor = { line = 0, character = #input },
		},
	}, function(result)
		items = result
	end)
	assert(
		vim.iter(items):any(function(item)
			return item.label == expected
		end),
		"missing " .. expected
	)
end

vim.cmd.cd(vim.fn.fnameescape(temporary))
local codex_home = vim.env.CODEX_HOME and vim.env.CODEX_HOME ~= "" and vim.env.CODEX_HOME or vim.fn.expand("~/.codex")
complete(vim.fs.joinpath(codex_home, "editor", ".tmp-test.md"), "$test", "$test-codex")
complete(vim.fs.joinpath(codex_home, "editor", ".tmp-linked.md"), "$linked", "$linked-skill")
complete(vim.fs.joinpath(vim.fn.tempname(), "claude-1", "claude-prompt-test.md"), "/test", "/test-claude")

vim.cmd.cd(vim.fn.fnameescape(original_cwd))
vim.fn.delete(temporary, "rf")
print("agent skill completion: ok")
