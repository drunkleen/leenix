local M = {}

local function purge(prefix)
  for name in pairs(package.loaded) do
    if name == prefix or name:sub(1, #prefix + 1) == prefix .. "." then
      package.loaded[name] = nil
    end
  end
end

function M.reload_module(name)
  purge(name)
  return require(name)
end

return M
