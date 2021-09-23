local thread = require("thread")
local component = require("component")
local me = component.me_interface
local redstone = component.redstone
local sides = require("sides")
local os = require("os")
local cpus = nil
os.execute("Strings")
demandes = nil


local args = {...}

local function Requete(_itemName, _damage, _comparator, _count, _toCraft, _damage2, _exp)
  r = {
    itemName = _itemName,
    damage = tonumber(_damage),
    comparator = _comparator,
    count = tonumber(_count),
    toCraft = _toCraft,
    damage2 = tonumber(_damage2),
    exp = _exp
  }
  return r
end

local function getAvailableCpu()
  cpus = me.getCpus()
  for i = 1, #cpus do
    if cpus[i].busy == false then
      return cpus[i]
    end
  end
  return nil
end

local function requestCraft(demande)
  for i = 1, #cpus do
    if cpus[i].busy == false then
      demande.craft.request(demande.craftCount,false,cpus[i].name)
      refreshCpus()
      if cpus[i].busy == true then
        print("create request for " .. demande.craftCount .. " " .. demande.craft.getItemStack().label .. " using cpu " .. cpu[i].name)
        return
      end
    end
  end
end

local function parseExp(demande)
  success, value = tonumber(demande.exp)
  if success == true then
    demande.craftCount = value
  else
    str = string.gsub(demande.exp, "n", tostring(demande.item.size))
    str = string.gsub(str, "m", tostring(demande.craft.getItemStack().size))
    func = assert(load("return " .. str))
    demande.craftCount = func()
    if demande.craftCount % 1 ~= 0 then
      demande.craftCount = demande.craftCount + 1
    end
    demande.craftCount = math.floor(demande.craftCount)
  end
end

local function getItem(demandes)
  item = me.getItemsInNetwork()
  for j = 1, #demandes do
    for i = 1, #item do
      if item[i].name == demandes[j].itemName and item[i].damage == demandes[j].damage then
        demandes[j].item = item[i]
        parseExp(demandes[j])
      end
    end
  end
end

local function getCraft(demandes)
  craft = me.getCraftables()
  item = {}
  for i = 1, #craft do
    item[i] = craft[i].getItemStack()
  end
  for j = 1, #demandes do
    for i = 1, #craft do
      if item[i].name == demandes[j].toCraft and item[i].damage == demandes[j].damage2 then
        demandes[j].craft = craft[i]
        i = #craft + 1
      end
    end
  end
end

local function refreshCpus()
  cpus = me.getCpus()
end

function refreshData(demandes)
  refreshCpus()
  getItem(demandes)
end

local function readConfig(path)
  demandes = {}
  file = io.open(path, "r")
  repeat
    line = file:read()
    str = strings:split(line, ";")
    if str ~= nil then
      r = Requete(str[0], str[1], str[2], str[3], str[4], str[5], str[6])
      table.insert(demandes, r)
    end
  until line == nil
  file:close()
  return demandes
end

local function traiteDemande(demande)
  if demande.craft ~= nil and demande.item ~= nil then
    cpu = getAvailableCpu(demande.craftCount)
    if demande.comparator == "<" then
      if demande.item.size < demande.count then
        if cpu ~= nil then
          print("request for " .. demande.craft.getItemStack().label)
          requestCraft(demande)
        end
      end
    elseif demande.comparator == ">" then
      if demande.item.size > demande.count then
        if cpu ~= nil then
          print("request for " .. demande.craft.getItemStack().label)
          requestCraft(demande)
        end
      end
    elseif demande.comparator == "<=" then
      if demande.item.size <= demande.count then
        if cpu ~= nil then 
          print("request for " .. demande.craft.getItemStack().label)
          requestCraft(demande)
        end
      end
    elseif demande.comparator == ">=" then
      if demande.item.size >= demande.count then
        if cpu ~= nil then 
          print("request for " .. demande.craft.getItemStack().label)
          requestCraft(demande)
        end
      end
    elseif demande.comparator == "==" then
      if demande.item.size == demande.count then
        if cpu ~= nil then
          print("request for " .. demande.craft.getItemStack().label) 
          requestCraft(demande)
        end
      end
    elseif demande.comparator == "!=" then
      if demande.item.size ~= demande.count then
        if cpu ~= nil then 
          print("request for " .. demande.craft.getItemStack().label)
          requestCraft(demande)
        end
      end
    else
      print("Error : invalid Comparator")
      os.exit()
    end
  else
    return false
  end
  return true
end

local function run(demandes)
  refreshData(demandes)
  for i = 1, #demandes do
    ret = traiteDemande(demandes[i])
    if ret == false then
      getCraft(demandes)
    end
  end
end

local function main()
  demandes = readConfig("config.cfg")
  side = sides.back
  if #demandes ~= 0 then
    if redstone.getInput(side) > 0 then
      getCraft(demandes)
    end
    while redstone.getInput(side) > 0 do
      run(demandes)
      os.sleep(60)
    end
  end
  strings = nil
end

main()
