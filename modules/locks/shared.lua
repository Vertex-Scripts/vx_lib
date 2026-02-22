vx.locks = {}

local locked = false
local queue = {}

function vx.locks.acquire()
   if not locked then
      locked = true
      return
   end

   local p = promise.new()
   queue[#queue + 1] = p

   Citizen.Await(p)
end

function vx.locks.release()
   if #queue > 0 then
      local nextPromise = table.remove(queue, 1)
      nextPromise:resolve()
   else
      locked = false
   end
end

function vx.locks.scope(fn)
   vx.locks.acquire()

   local ok, err = pcall(fn)

   vx.locks.release()

   if not ok then
      error(err)
   end
end

return vx.locks
