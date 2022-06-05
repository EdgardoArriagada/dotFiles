-- you can configure Hop the way you like here; see :h hop-config
require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }

keymap.set("n" , "s", function()
  require('hop').hint_char2()
end, { noremap = false, silent = true })
