local function memory_of(player)
    return global.player_memory[player.index]
end

local function init_player(player)
    --if global.player_memory == nil then
    --    return
    --end

    global.player_memory[player.index] = global.player_memory[player.index] or {}

    memory_of(player).held_item_name = nil
    memory_of(player).ignore_next = false
end

script.on_init(function()
    global.player_memory = global.player_memory or {}
    for _, player in pairs(game.players) do
        init_player(player)
    end
end)

script.on_event(defines.events.on_player_created, function(event)
    init_player(game.players[event.player_index])
end)

script.on_event(defines.events.on_player_joined_game, function(event)
    init_player(game.players[event.player_index])
end)



script.on_event(defines.events.on_player_cursor_stack_changed, function(event)
    local player = game.players[event.player_index]

    if memory_of(player).ignore_next then
        memory_of(player).ignore_next = false
        do
            return
        end
    end

    if player.cursor_stack ~= nil and player.cursor_stack.valid and player.cursor_stack.valid_for_read then
        memory_of(player).held_item_name = player.cursor_stack.name
    else
        player.cursor_ghost = memory_of(player).held_item_name
    end
end)

script.on_event("GhostInHand_clean-cursor", function(event)
    local player = game.players[event.player_index]

    memory_of(player).ignore_next = true
end)
