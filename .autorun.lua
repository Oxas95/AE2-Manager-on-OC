--create a floppy disk for installation

local os = require("os")
local component = require("component")
local disk = component.disk_drive
os.execute("pastebin run 7Uq7uTtB")
disk.eject(1)
os.execute("reboot")