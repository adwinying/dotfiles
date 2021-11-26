local present, whichkey = pcall(require, "which-key")

if not (present) then return end

whichkey.setup()
