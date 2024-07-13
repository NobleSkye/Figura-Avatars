---@meta _
---@diagnostic disable: duplicate-set-field


---==================================================================================================================---
---  ACTIONWHEELAPI                                                                                                  ---
---==================================================================================================================---

---@alias ActionWheelAPI.clickFunc fun(): boolean?

---@alias ActionWheelAPI.scrollFunc fun(dir?: number): boolean?


---==================================================================================================================---
---  ACTION                                                                                                          ---
---==================================================================================================================---

---@alias Action.clickFunc fun(self?: Action)

---@alias Action.toggleFunc fun(state?: boolean, self?: Action)

---@alias Action.untoggleFunc fun(state?: false, self?: Action)

---@alias Action.scrollFunc fun(dir?: number, self?: Action)
