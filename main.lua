SMODS.Atlas {
    key = 'harambe_jokers',
    path = 'harambe_jokers.png',
    px = 71,
    py = 95
}

SMODS.Sound {
    key = 'spawn',
    path = 'spawn.ogg',
    pitch = 1.0,
    volume = 2.5
}

SMODS.Joker {
    key = 'harambes_chosen',
    atlas = 'harambe_jokers',
    pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,
    yes_pool_flag = 'NEVER', -- this property doesn't actually exist, so it won't be in pool
    eternal_compat = true,
    perishable_compat = false,
    blueprint_compat = true,
    rarity = 4, -- for cool Legendary badge!
    config = {
        extra = {
            xmult = 10000
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
}

SMODS.Joker:take_ownership('cavendish',
        {
            config = {
                extra = {
                    odds = 1,
                    Xmult = 399
                }
            },
            calculate = function(self, card, context)
                if context.end_of_round and not context.blueprint and context.main_eval then
                    local pseudo = pseudorandom('cavendishseed')
                    local odds = G.GAME.probabilities.normal / card.ability.extra.odds
                    if pseudo < odds then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                play_sound('tarot1')
                                card.T.r = -0.2
                                card:juice_up(0.3, 0.4)
                                card.states.drag.is = true
                                card.children.center.pinch.x = true
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'after',
                                    delay = 0.3,
                                    blockable = false,
                                    func = function()
                                        G.jokers:remove_card(card)
                                        card:remove()

                                        -- you can do more AFTER stuff here
                                        G.E_MANAGER:add_event(Event({
                                            trigger = 'after',
                                            delay = 2.5,
                                            blockable = false,
                                            func = function()
                                                SMODS.add_card({
                                                    key = 'j_harambe_harambes_chosen',
                                                    set = 'Joker',
                                                    area = G.jokers,
                                                    no_edition = true,
                                                })

                                                return true
                                            end
                                        }))

                                        return true
                                    end
                                }))
                                return true
                            end
                        }))
                        return {
                            message = 'Finally..',
                            sound = 'harambe_spawn'
                        }
                    else
                        return {
                            message = localize('k_safe_ex')
                        }
                    end
                end
            end
        },
        true -- silent | suppresses mod badge
)
