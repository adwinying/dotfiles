local map = require("helpers").map

map("n", "<C-U>", ":call smooth_scroll#up(&scroll, 0, 4)<CR>")
map("n", "<C-D>", ":call smooth_scroll#down(&scroll, 0, 4)<CR>")
map("n", "<C-B>", ":call smooth_scroll#up(&scroll*2, 0, 4)<CR>")
map("n", "<C-F>", ":call smooth_scroll#down(&scroll*2, 0, 4)<CR>")
