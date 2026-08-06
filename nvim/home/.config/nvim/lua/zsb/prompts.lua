local M = {}

M.debug = {
	desc = "Debug",
	get = function()
		return [[
- add debug logs writing to the filesystem any information you think is neccessary
- ask me to run the script again and I will tell you when is done so you can check the logs
- lets repeat untill we find the issue]]
	end,
}

M.ask = {
	desc = "Ask",
	get = function()
		return [[
- Before proceeding, ask me every question you need answered to complete this task. Keep asking until you have no more doubts, then execute.]]
	end,
}

M.jira = {
	desc = "Jira",
	get = function()
		return [[
- Create a jira ticket with the fields described in the image
- Give me the link to the ticket at the end]]
	end,
}

M.pc = {
	desc = "Commit staged files",
	get = function()
		return [[
Create a Git commit from the currently staged files.]]
	end,
}

M.tdd = {
	desc = "Use TDD",
	get = function()
		return [[
- Use TDD (Test Driven Development).]]
	end,
}

M.merge_conflicts = {
	desc = "Resolve merge conflicts",
	get = function()
		return [[
I ran `git pull origin develop`, and it resulted in merge conflicts.

Carefully resolve the merge conflicts. Preserve the intended behavior from both sides when possible, avoid discarding unrelated changes, and run the relevant tests or checks after resolving them.]]
	end,
}

M.sheaper_prompts = {
	desc = "Sheaper prompts",
	get = function()
		return [[
- During this session, use both ponytail and caveman skills.
]]
	end,
}

M.ponytail_review = {
	desc = "Ponytail review",
	get = function()
		return [[
/ponytail:ponytail-review review the git staged files]]
	end,
}

return M
