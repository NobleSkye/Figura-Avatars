---@meta _

---Loads the given module, returns any value returned by the given module.
---
---~~[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-require"])~~  
---This function has been modified by Figura and does not work how it does in normal Lua 5.2.
---@*error Does not return `true` on `nil` returns.
---@param modname string
---@return unknown ...
function require(modname) end
