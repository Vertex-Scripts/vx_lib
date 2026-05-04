---@class VxCommandOptions
---@field name string|string[]
---@field suggestion? string

local registeredCommands = vx.array:new()

---@param options VxCommandOptions
---@param handler fun(source: number, args: string[], rawCommand: string)
function vx.registerCommand(options, handler, restricted)
   local names = options.name
   if type(names) == "string" then
      name = { names }
   end

   if type(names) == "table" then -- Just to get rid of the type errors
      for _, name in pairs(names) do
         RegisterCommand(name, handler, restricted)

         local suggestion = options.suggestion
         if suggestion then
            local fullCommand = "/" .. name
            registeredCommands:push({ name = fullCommand, suggestion = suggestion })

            TriggerEvent("chat:addSuggestion", fullCommand, suggestion)
         end
      end
   end
end

return vx.registerCommand
