vx.caller = {}

function vx.caller.create(system, functions)
   local func = functions[system]
   if not func then
      error(("System '%s' is not supported"):format(system))
   end

   return func, system
end

---@param functions { ["es_extended" | "qb-core"]: function }
function vx.caller.createFrameworkCaller(functions)
   local framework = vx.systems.framework
   return vx.caller.create(framework, functions)
end

function vx.caller.createInventoryCaller(functions)
   local inventory = vx.systems.inventory
   return vx.caller.create(inventory, functions)
end

function vx.caller.createTargetCaller(functions)
   local target = vx.systems.target
   return vx.caller.create(target, functions)
end

return vx.caller
