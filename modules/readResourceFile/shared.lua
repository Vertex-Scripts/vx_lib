function vx.readResourceFile(resource, filename, json)
   local content = LoadResourceFile(resource, filename)
   if json then
      return json.decode(content)
   end

   return content
end

return vx.readResourceFile
