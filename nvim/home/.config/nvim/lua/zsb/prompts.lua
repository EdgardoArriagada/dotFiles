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

--- 

Before proceeding, ask me any clarifying questions you need to complete this task perfectly. 

Please follow these rules for your questions:
1. Present them in a numbered list.
2. Whenever possible, provide multiple-choice options lettered as a), b), c), etc.
3. Suggest a recommended answer for each question when you can.

Wait for my response before executing the task. If my answers resolve your doubts, proceed with the final output. If not, ask follow-up questions.
]]
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

Carefully resolve the merge conflicts. Preserve the intended behavior from both sides when possible, avoid discarding unrelated changes, and run the relevant tests or checks after resolving them.

After resolving the conflicts, add the files with git add . and create a Git commit from the currently staged files.]]
	end,
}

M.sheaper_prompts = {
	desc = "Sheaper prompts",
	get = function()
		return [[
**During this session, use both ponytail and caveman skills.**
]]
	end,
}

M.ponytail_review = {
	desc = "Ponytail review",
	get = function()
		return [[
$ponytail:ponytail-review review the git staged files]]
	end,
}

M.post_pr_comments_online = {
	desc = "Post pr comments online",
	get = function()
		return [[
Post each finding as an inline comment on this GitHub pull request. (One inline comment for each finding)]]
	end,
}

return M
