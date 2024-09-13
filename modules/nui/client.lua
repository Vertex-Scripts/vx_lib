-- TODO: Needs testing

vx.nui = {}
vx.registerNuiCallback = RegisterNUICallback

local registeredStores = {}

function vx.nui.sendAction(action, data)
   SendNUIMessage({
      action = action,
      data = data
   })
end

---@generic T
---@param name string
---@param defaultValue T
---@return { name: string, value: T, set: fun(self, val: T), onUpdate: fun(self, val: T) }
function vx.nui.createStore(name, defaultValue)
   if registeredStores[name] then
      return registeredStores[name]
   end

   local store = {
      name = name,
      value = defaultValue
   }

   function store:set(value)
      self.value = value

      nui.sendAction("updateStore", {
         name = self.name,
         value = self.value
      })

      store:onUpdate(self.value)
   end

   function store:onUpdate(val) end

   setmetatable(store, {
      __gc = function()
         registeredStores[store.name] = nil
      end
   })

   registeredStores[store.name] = store
   return store
end

function vx.nui.onInitialized(func)
   vx.registerNuiCallback("initialized", function(_, cb)
      func()
      cb()
   end)
end

vx.registerNuiCallback("getStoreValue", function(name, cb)
   local store = registeredStores[name]
   cb(store?.value)
end)

vx.registerNuiCallback("setStoreValue", function(data, cb)
   local store = registeredStores[data.name]
   store:set(data.value)

   cb()
end)
