---
--- Created by Xerxes.
--- DateTime: 10/28/2020 5:48 AM
---

function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

function EvaluateTablePropability(tbl)
	local newTbl = deepcopy(tbl)
	local value = 100.0
	for i,k in ipairs(newTbl) do
		k.probability = value - k.probability
		value = k.probability
	end
	return newTbl
end


-- decimal is the amount of decimal places
function GetRandomWeightedItem(tbl, decimal)
	if not decimal then decimal = 1 end

	local toVal = 100
	local decVal = 1
	for i = 1, decimal, 1 do
		toVal = toVal * 10
		decVal = decVal * 10
	end

	local RandomNum = math.random(1, toVal)
	RandomNum = RandomNum/decVal
	local val
	for i,k in ipairs(tbl) do
		if RandomNum >= k.probability then
			val = k
			break
		end
	end
	if val and val.name then
		return val.name
	else
		print('ERROR: Got nil!')
		return tbl[#tbl].name
	end
end

-- Example
-- Tables used need a name and a probability value
-- probability is % dont convert your self, example if you want 33.3 % just put 33.3
-- needs to add up to 100%
-- start with lowest --> highest
-- table indexs must be numerical and counting up, dont skip number, uses ipairs
local BloodTypes = {
	[1] = { ['name'] = 'AB-', ['probability'] = 0.6 }, -- 0.6%
	[2] = { ['name'] = 'B-', ['probability'] = 1.5 }, -- 1.5%
	[3] = { ['name'] = 'AB+', ['probability'] = 3.4 }, -- 3.4%
	[4] = { ['name'] = 'A-', ['probability'] = 6.3 }, -- 6.3%
	[5] = { ['name'] = 'O-', ['probability'] = 6.6 }, -- 6.6%
	[6] = { ['name'] = 'B+', ['probability'] = 8.5 }, -- 8.5 %
	[7] = { ['name'] = 'A+', ['probability'] = 35.7 }, -- 35.7%
	[8] = { ['name'] = 'O+', ['probability'] = 37.4 }, -- 37.4%
}
local count = {
	['AB-'] = 0,
	['B-'] = 0,
	['AB+'] = 0,
	['A-'] = 0,
	['O-'] = 0,
	['B+'] = 0,
	['A+'] = 0,
	['O+'] = 0,
}

-- to call from other scripts use
-- local EvaluatedTable = exports['RandomWeight']:EvaluateTablePropability(BloodTypes)
-- local res = exports['RandomWeight']:GetRandomWeightedItem(EvaluatedTable, 1)

-- Formats the probability - NEEDED to work, does not overwrite original table
-- dont call this in a loop its irrelivent to do it and will cause lag
local EvaluatedTable = EvaluateTablePropability(BloodTypes)
for i=1, 1000, 1 do
	local res = GetRandomWeightedItem(EvaluatedTable, 1)
	if count[res] then
		count[res] = count[res] + 1
	end
end
for i,k in pairs(count) do
	print(i, k)
end

-- GetRandomWeightedItem(EvaluatedTable, 1)
-- when calling second parm is the amount of decimal places
-- not needed but it is fine, ex. prob = 10.12 then decimal = 2

-- works so ya cool
