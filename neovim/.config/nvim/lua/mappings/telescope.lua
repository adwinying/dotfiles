local map = require("helpers").map

map("n", "<leader>ff", ":Telescope find_files <CR>")
map("n", "<leader>fa", ":Telescope find_files hidden=true <CR>")
map("n", "<leader>fb", ":Telescope buffers <CR>")
map("n", "<leader>fh", ":Telescope help_tags <CR>")
map("n", "<leader>fw", ":Telescope live_grep <CR>")
map("n", "<leader>fgc", ":Telescope git_bcommits <CR>")
map("n", "<leader>fgs", ":Telescope git_status <CR>")
