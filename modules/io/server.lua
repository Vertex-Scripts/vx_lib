vx.io = {}

---@param filename string
function vx.io.readFile(filename)
   local file = io.open(filename, "r")
   if not file then
      return nil
   end

   local content = file:read("*a")
   file:close()

   return content
end

---@param filename string
function vx.io.readJsonFile(filename)
   local content = vx.io.readFile(filename)
   if not content then
      return nil
   end

   return json.decode(content)
end

---@param filename string
---@param content string
function vx.io.writeFile(filename, content)
   local file = io.open(filename, "w")
   if not file then
      return false
   end

   file:write(content)
   file:close()

   return true
end

---@param filename string
---@param content table
function vx.io.writeJsonFile(filename, content)
   local encoded = json.encode(content)
   return vx.io.writeFile(filename, encoded)
end

---@param filename string
function vx.io.removeFile(filename)
   os.remove(filename)
end

function vx.io.fileExists(filename)
   local file = io.open(filename, "r")
   if file then
      file:close()
   end

   return file ~= nil
end

return vx.io
