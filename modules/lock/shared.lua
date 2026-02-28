---@class VxLock : VxClass
vx.lock = vx.class("VxLock")

---@private
function vx.lock:constructor()
   self.locked = false
   self.queue = {}
end

function vx.lock:acquire()
   if not self.locked then
      self.locked = true
      return
   end

   local p = promise.new()
   self.queue[#self.queue + 1] = p

   Citizen.Await(p)
end

function vx.lock:release()
   if #self.queue > 0 then
      local nextPromise = table.remove(self.queue, 1)
      nextPromise:resolve()
   else
      self.locked = false
   end
end

function vx.lock:scope(fn)
   self:acquire()

   local ok, err = pcall(fn)
   self:release()

   if not ok then
      error(err)
   end
end

return vx.lock
