return {
	keys = { "<leader>", "(", ")" },
	"ThePrimeagen/harpoon",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = Config("harpoon.ui", function(harpoon_ui)
		kset("n", "(", harpoon_ui.nav_prev)
		kset("n", ")", harpoon_ui.nav_next)
	end),
}
