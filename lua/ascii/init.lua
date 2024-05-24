local utils = require("ascii.utils")
local ui = require("ascii.ui")

local art = require("ascii.art")

local M = {
	art = art,
}

local function has_value(tab, val)
	for _, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	return false
end

-- shallow print of key names
M.print_category = function()
	local categories = {}

	for _, v in pairs(M.art) do
		for k, _ in pairs(v) do
			table.insert(categories, k)
		end
	end

	utils.DeepPrint(categories)
end

M.print_subcategory = function(category, subcategory)
	print("Category: ", category)

	local print_art = M.art[category][subcategory]

	utils.DeepPrint(print_art)
end

M.preview = function()
	ui.open()
end

M.get_random = function(category, subcategory)
	local pieces = M.art[category][subcategory]

	local keys = {}
	for k, _ in pairs(pieces) do
		table.insert(keys, k)
	end

	local random_key = math.random(1, #keys)
	local actual_key = keys[random_key]

	local piece = pieces[actual_key]

	return piece
end

M.get_random_global = function(omitted_categories)
	local category = utils.get_random_key(M.art)
	if omitted_categories and category == has_value(omitted_categories, category) then
		return M.get_random(omitted_categories)
	end
	local subcategories = M.art[category]
	local subcategory_key = utils.get_random_key(subcategories)
	local piece = M.get_random(category, subcategory_key)
	return piece
end

M.get_holiday_random = function()
	local holiday
	local time = os.date()
	print(time.month)
	if time.month == 5 then
		holiday = "easter"
	elseif time.month == 10 then
		holiday = "halloween"
	elseif time.month == 11 or time.month == 12 then
		holiday = "christmas"
	else
		return M.get_random_global({ "easter", "halloween", "christmas" })
	end
	local piece = M.get_random("holidays", holiday)
	return piece
end

return M
