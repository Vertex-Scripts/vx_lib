vx = vx or {}
vx.formatting = {}

function vx.formatting.formatDecimal(num)
   local formatted = tostring(num):reverse():gsub("(%d%d%d)", "%1."):reverse()
   local result = formatted:gsub("^%.", "")

   return result
end

function vx.formatting.formatCurrency(num)
   return string.format("%s%s", vx.sharedConfig.currencySymbol, vx.formatting.formatDecimal(num))
end

return vx.formatting
