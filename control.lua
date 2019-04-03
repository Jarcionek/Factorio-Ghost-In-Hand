local function memory_of(player)
    global.player_memory = global.player_memory or {}

    if not global.player_memory[player.index] then
        global.player_memory[player.index] = {
            last_held_item_name = nil,
            ignore_next = false,
            is_gui_open = false
        }
    end

    return global.player_memory[player.index]
end

script.on_event(defines.events.on_player_cursor_stack_changed, function(event)
    local player = game.players[event.player_index]

    if memory_of(player).ignore_next then
        memory_of(player).ignore_next = false
        return
    end

    if player.cursor_stack and player.cursor_stack.valid and player.cursor_stack.valid_for_read then
        if player.cursor_stack.prototype.place_result or player.cursor_stack.prototype.place_as_tile_result then
            memory_of(player).last_held_item_name = player.cursor_stack.name
        else
            memory_of(player).last_held_item_name = nil
        end

    else
        if player.mod_settings["GhostInHand_disable-when-gui-open"].value and memory_of(player).is_gui_open then
            return
        end

        -- TODO check if player has the last held item in inventory, and if they do, don't set the ghost (because it means that they put that item back themselves)
        -- do I then still need clean-cursor event?

        if memory_of(player).last_held_item_name then
            player.cursor_ghost = memory_of(player).last_held_item_name
        end
    end
end)

script.on_event("GhostInHand_clean-cursor", function(event)
    local player = game.players[event.player_index]
    memory_of(player).ignore_next = true
end)

script.on_event(defines.events.on_gui_opened, function(event)
    local player = game.players[event.player_index]
    memory_of(player).is_gui_open = true;
end)

script.on_event(defines.events.on_gui_closed, function(event)
    local player = game.players[event.player_index]
    memory_of(player).is_gui_open = false;
end)
