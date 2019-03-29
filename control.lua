local held_item_name
local ignore_next = false

script.on_event(defines.events.on_player_cursor_stack_changed, function(event)
    local player = game.players[event.player_index]

    if ignore_next then
        ignore_next = false
        do
            return
        end
    end

    if player.cursor_stack ~= nil and player.cursor_stack.valid and player.cursor_stack.valid_for_read then
        held_item_name = player.cursor_stack.name
    else
        player.cursor_ghost = held_item_name
    end
end)

script.on_event("GhostInHand_clean-cursor", function(event)
    local player = game.players[event.player_index]

    ignore_next = true
end)
