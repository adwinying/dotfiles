local present, nvim_comment = pcall(require, "nvim_comment")

if not present then return end

nvim_comment.setup()
