vx.caller = {}

local function createCaller(system, functions)
   local func = functions[system]
   if not func then
      error(("System '%s' is not supported"):format(system))
   end

   return func, system
end

function vx.caller.createFrameworkCaller(functions)
   return createCaller(vx.systems.framework, functions)
end

function vx.caller.createInventoryCaller(functions)
   return createCaller(vx.systems.inventory, functions)
end

function vx.caller.createTargetCaller(functions)
   return createCaller(vx.systems.target, functions)
end

return vx.caller
