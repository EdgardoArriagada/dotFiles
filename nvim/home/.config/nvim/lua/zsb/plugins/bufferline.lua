return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "famiu/bufdelete.nvim" },
	config = Config("bufferline", function(bufferline)
		bufferline.setup()

		local function is_last_listed_buffer(bufnr)
			if not vim.bo[bufnr].buflisted then
				return false
			end

			local listed_count = 0
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
					listed_count = listed_count + 1
					if listed_count > 1 then
						return false
					end
				end
			end

			return true
		end

		Kset("n", "Q", function()
			local current_buffer = vim.api.nvim_get_current_buf()
			if is_last_listed_buffer(current_buffer) then
				vim.notify("Cannot delete the last buffer", vim.log.levels.WARN)
				return
			end

			require("bufdelete").bufdelete(0, true)
		end)

		Kset("n", "<C-n>", function()
			bufferline.cycle(1)
		end)

		Kset("n", "<C-b>", function()
			bufferline.cycle(-1)
		end)
	end),
}
