-- you can configure Hop the way you like here; see :h hop-config
whenOk(require, 'hop', function(hop)
  hop.setup { keys = 'etovxqpdygfblzhckisuran' }
end)

keymap.set("n" , "s", function()
  require('hop').hint_char2()
end, { noremap = false, silent = true })
