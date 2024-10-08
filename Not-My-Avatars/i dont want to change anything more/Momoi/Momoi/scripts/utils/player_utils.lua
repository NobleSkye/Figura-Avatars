---@alias PlayerUtils.DamageStatus
---| "NONE" ダメージなし
---| "DAMAGE" ダメージを受けた
---| "DIED" 死亡した

---@class PlayerUtils プレイヤーに関するユーティリティ関数群
PlayerUtils = {
    ---現在のティックのダメージステータス
    ---@type PlayerUtils.DamageStatus
    DamageStatus = "NONE",

    ---現在のティックのダメージステータスを返す。
    ---@return PlayerUtils.DamageStatus damageStatus 現在のティックのダメージステータス
    getDamageStatus = function (self)
        return self.DamageStatus
    end,

    ---初期化関数
    init = function (self)
        local healthPrev = player:getHealth()
        events.TICK:register(function()
            local health = player:getHealth()
            self.DamageStatus = healthPrev > health and (health == 0 and "DIED" or "DAMAGE") or "NONE"
            healthPrev = health
        end)
    end
}

PlayerUtils:init()

return PlayerUtils