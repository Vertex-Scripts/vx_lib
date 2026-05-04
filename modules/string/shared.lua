vx.string = {}

---@param str string
---@param start string
---@return boolean
function vx.string.startsWith(str, start)
    return str:sub(1, #start) == start
end

---@param str string
---@param ending string
---@return boolean
function vx.string.endsWith(str, ending)
    return ending == "" or str:sub(- #ending) == ending
end

---@param str string
---@param sep string
---@return VxArray<string>
function vx.string.split(str, sep)
    local result = vx.array.ofType("string")
    local start = 1

    while true do
        local pos = string.find(str, sep, start, true)
        if not pos then
            result:push(string.sub(str, start))
            break
        end

        result:push(string.sub(str, start, pos - 1))
        start = pos + #sep
    end

    return result
end

return vx.string
