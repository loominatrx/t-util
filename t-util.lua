-- t-util for Lua 5.1 by Loominatrx
-- Compatible with Luau and Vanilla Lua.

-- Lua's table references

local sort = table.sort
local insert, remove, move = table.insert, table.remove, table.move
local pack, unpack = table.pack, table.unpack
local join = table.concat
local random = math.random

-- Luau's table references

local tfind = table.find
local getn, create = table.getn, table.create
local clear = table.clear

-- New table
local table = {}

-- Private methods

local function tableCheck(v)
    return type(v) == 'table'
end

-- Public Methods

-- Returns the total number of the element in a table.
function table.count(tbl)
    local n = 0
    for _ in pairs(tbl) do
        n = n + 1
    end
    return n
end

-- Returns the total number of the element in a table recursively.
function table.deepCount(tbl)
    local n = 0
    for _, v in pairs(tbl) do
        n = type(v) == 'table' and n + table.deepcount(v) or n + 1
    end
    return n
end

-- Determines whether the table contains a value, returning `true` or `false` as appropriate.
function table.includes(tbl, value)
    for _, v in next, tbl do
        if v == value then return true end
    end
    return false
end

-- Determines if the `tbl` has `index` on it, returning `true` or `false` as appropriate.
function table.has(tbl, index)
    return tbl[index] ~= nil
end

-- Determines if the table is not empty. Returns `true` or `false`, as appropriate.
function table.isEmpty(tbl)
    return next(tbl) == nil
end

-- Determines if the table is a array-like table.
function table.isArray(tbl)

    -- Make sure it's not empty.
    if table.isEmpty(tbl) then
        return false
    end

    -- Make sure that all keys are positive integers
    for key, value in pairs(tbl) do
        if type(key) ~= 'number' or key % 1 ~= 0 or key < 1 then
            return false
        end
    end

    return true
end

-- Determines if the table is a dictionary-like table.
-- A dictionary is defined as a table containing keys that are not positive integers.
function table.isDictionary(tbl)
    return not table.isArray(tbl)
end

-- Returns a new copy of the table, one layer deep.
function table.copy(tbl)
    local ret = {}
    for k, v in pairs(tbl) do
        ret[k] = v
    end
    return ret
end

--[[
Returns a copy of table, recursively.
If a table is encountered, it is recursively deep-copied.
Metatables are not copied.
]]
function table.deepCopy(tbl)
    local ret = {}
    for k, v in pairs(tbl) do
        ret[k] = type(v) == 'table' and table.deepcopy(v) or v
    end
    return ret
end

-- Reverses the element of an array-like table in place.
function table.reverse(tbl)
    if table.isEmpty(tbl) then
        error('`tbl` must not be empty!', 2)
    elseif table.isDictionary(tbl) then
        error('`tbl` must be a array-like table!', 2)
    end

    for i = 1, #tbl do
        insert(tbl, i, remove(tbl))
    end
end

-- Returns a copy of an array-like table with its element in reverse order.
-- The original table remain unchanged.
function table.reversed(tbl)
    if table.isEmpty(tbl) then
        error('`tbl` must not be empty!', 2)
    elseif table.isDictionary(tbl) then
        error('`tbl` must be a array-like table!', 2)
    end

    local ret = {}
    for i = #tbl, 1, -1 do
        insert(ret, tbl[i])
    end
    return ret
end

-- Returns a new array-like table where all of its values are the keys of the original table.
function table.keys(tbl)
    local ret = {}
    for k in pairs(tbl) do
        insert(ret, k)
    end
    return ret
end

-- Returns a new array-like table where all of its values are the values of the original table.
function table.values(tbl)
    local ret = {}
    for _, v in pairs(tbl) do
        insert(ret, v)
    end
    return ret
end

-- Returns a random (index, value) pair from an array-like table.
function table.randomIpair(tbl)
    local i = random(#tbl)
    return i, tbl[i]
end

-- Returns a random (key, value) pair from a dictionary-like table.
function table.randomPair(tbl)
    local rand = random(table.count(tbl))
    local n = 0
    for k, v in pairs(tbl) do
        n = n + 1
        if n == rand then
            return k, v
        end
    end
end

-- Returns a copy of an array-like table sorted using Lua's `table.sort`.
function table.sorted(tbl, fn)
    local ret = {}
    for i, v in ipairs(tbl) do
        ret[i] = v
    end
    sort(ret, fn)
    return ret
end

-- Returns a new table that is a slice of the original, defined by the start and stop bounds and the step size.
-- Default start, stop, and step values are 1, #tbl, and 1 respectively.
function table.slice(tbl, start, stop, step)
    local ret = {}
    for i = start or 1, stop or #tbl, step or 1 do
        insert(ret, tbl[i])
    end
    return ret
end
-- Iterates through a table until a value satisfies the test function.
-- The `value` is returned if it satisfies the test function. Otherwise, `nil` is returned.
function table.findValue(tbl, testFn)
    for key, value in pairs(tbl) do
        if testFn(value, key) == true then
            return value
        end
    end
    return nil
end

-- Iterates through a table until a key satisfies the test function.
-- The `key` is returned if it satisfies the test function. Otherwise, `nil` is returned.
function table.findIndex(tbl, testFn)
    for key, value in pairs(tbl) do
        if testFn(value, key) == true then
            return value
        end
    end
    return nil
end

-- Returns a new table containing all elements of the calling table
-- for which provided filtering function returns `true`.
function table.filter(tbl, filterFn)
    local ret = {}
    for key, value in pairs(tbl) do
        if filterFn(value, key) then
            ret[key] = value
        end
    end
    return ret
end

-- Returns a new table containing the results of calling a function
-- on every element in this table.
function table.map(tbl, mapFn)
    local ret = {}
    for key, value in pairs(tbl) do
        ret[key] = mapFn(value, key)
    end
    return ret
end

-- Iterates through the table and run the test function to to every element to check if it satisfies the check.
-- If all elements satisfies the check, it returns `true`. Otherwise it returns `false`.
function table.every(tbl, testFn)
    for key, value in pairs(tbl) do
        if testFn(value, key) == false then
            return false
        end
    end
    return true
end

-- Returns a new table that is this table joined with other table(s).
function table.concatTable(...)
    local ret = {}
    local tables = {...}
    
    if not table.every(tables, tableCheck) then
        error('`...table` must be a table!', 2)
    end

    for _, t in pairs(tables) do
        for k, v in pairs(t) do
            if type(k) == 'number' then
                insert(ret, v)
            else
                ret[k] = v
            end
        end
    end

    return ret
end
table.merge = table.concatTable

-- Joins all elements of an array-like table into a string.
-- Internally calls vanilla `table.concat` function.
table.join = join

-- Changes all elements in an array-like table to a static value
-- from start index (default: `1`) to an end index (default: `#tbl`).
-- It returns the modified array-like table.
function table.fill(tbl, value, start, End)
    if table.isEmpty(tbl) then
        error('`tbl` must not be empty!', 2)
    elseif table.isDictionary(tbl) then
        error('`tbl` must be a array-like table!', 2)
    elseif start ~= nil and start <= 0 then
        error('`start` must be more than 0!', 2)
    elseif End ~= nil and End > #tbl then
        error('`End` must not exceed #tbl!', 2)
    end

    for i = start or 1, End or #tbl do
        tbl[i] = value
    end

    return tbl
end

-- Iterates through a table and executes `callback` function to every element.
function table.foreach(tbl, callback)
    if table.isEmpty(tbl) then error('`tbl` must not be empty!', 2) end
    for key, value in pairs(tbl) do callback(value, key) end
end

-- Iterates through a array-like table and executes `callback` function to every element.
function table.foreachi(tbl, callback)
    if table.isEmpty(tbl) then error('`tbl` cannot be empty!', 2) end
    if table.isDictionary(tbl) then error('`tbl` can only accept array-like table!', 2) end
    for key, value in ipairs(tbl) do callback(value, key) end
end

-- I don't wrap the methods using metatable, as Roblox don't let us wrap built-in objects
-- and the table object (in Luau) is read-only, meaning we can't add/modify functions on it.
if _VERSION ~= 'Luau' then
    return setmetatable(_G.table, {
        __index = table,
        __tostring = function ()
            return 't-util by Loominatrx'
        end
    })
else
    -- Had to reference all of the built-ins due to Roblox's restrictions.

    table.insert = insert
    table.remove = remove
    table.sort = sort
    table.pack = pack
    table.unpack = unpack
    table.move = move
    table.getn = getn -- deprecated in Lua 5.1, dunno why did they brought it to Luau.
                      -- but I reference it anyways for those who still uses `table.getn()` in 2021 (lol).

    table.clear = clear -- Luau exclusive.
    table.create = create -- Luau exclusive.
    table.find = tfind -- Luau exclusive.

    return setmetatable(table, {
        __newindex = function()
            error('Attempting to modify this object.', 2)
        end,
        __metatable = 'This metatable is locked.',
        __tostring = function()
            return 't-util by Loominatrx'
        end
    })
end
