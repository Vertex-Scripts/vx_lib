cfx.math = {}

function cfx.math.round(value, numDecimalPlaces)
  numDecimalPlaces = numDecimalPlaces or 0
  local power = 10 ^ numDecimalPlaces
  return math.floor(value * power + 0.5) / power
end

function cfx.math.trim(value)
  if value == nil then
    return nil
  end

  return string.match(value, "^%s*(.-)%s*$")
end

return cfx.math
