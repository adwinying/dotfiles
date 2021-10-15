--
-- spoons.lua
-- configure spoons
--

-- SpoonInstall
if not hs.spoons.isInstalled("SpoonInstall") then
  local spoon_dir = hs.configdir .. "/Spoons"
  local spoon_install_zip_url = "https://raw.githubusercontent.com/Hammerspoon/Spoons/master/Spoons/SpoonInstall.spoon.zip"

  hs.notify.new({
    title = "Downloading spoon",
    informativeText = "Downloading SpoonInstall",
  }):send()

  local _, success = hs.execute(string.format([[
    mkdir -p %s &&
    cd %s &&
    curl -o temp.zip %s &&
    unzip temp.zip &&
    rm temp.zip
  ]], spoon_dir, spoon_dir, spoon_install_zip_url))

  if not success then
    hs.notify.new({
      title = "Spoon download failed",
      informativeText = "Failed to download SpoonInstall",
      autoWithdraw = false,
    }):send()
  end
end

-- Load SpoonInstall
SpoonInstall = hs.loadSpoon("SpoonInstall")

-- VimMode
if not hs.spoons.isInstalled("VimMode") then
  local spoon_dir = hs.configdir .. "/Spoons"
  local spoon_repo_url = "https://github.com/dbalatero/VimMode.spoon"

  hs.notify.new({
    title = "Downloading spoon",
    informativeText = "Downloading VimMode",
  }):send()

  local _, success = hs.execute(string.format([[
    mkdir -p %s &&
    cd %s &&
    git clone %s
  ]], spoon_dir, spoon_dir, spoon_repo_url))

  if not success then
    hs.notify.new({
      title = "Spoon download failed",
      informativeText = "Failed to download VimMode",
      autoWithdraw = false,
    }):send()
  end
end

-- Load VimMode
require("modules.vimmode")
