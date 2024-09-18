return {
	keys = { "(", ")" },
	"ThePrimeagen/harpoon",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = Config("harpoon.ui", function(harpoon_ui)
		Kset("n", "(", harpoon_ui.nav_prev)
		Kset("n", ")", harpoon_ui.nav_next)
	end),
}
