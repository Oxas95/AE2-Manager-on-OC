local fs = require("filesystem")
local shell = require("shell")
local component = require("component")
local net = component.internet

local folder = "AE2 Manager.app"

local repo = "https://raw.githubusercontent.com/Oxas95/AE2-Manager-on-OC/master/AE2%20Manager.app/"

if fs.exists("/home/" .. folder) then
  fs.remove("/home/" ..folder)
end
fs.makeDirectory("/home/" .. folder)
shell.setWorkingDirectory("/home/" .. folder)

os.execute("wget -f " .. repo .. "Main.lua")
os.execute("wget -f " .. repo .. "Strings.lua")
os.execute("wget -f " .. repo .. "config.cfg")

