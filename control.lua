local function memory_of(player)
    global.player_memory = global.player_memory or {}

    if not global.player_memory[player.index] then
        global.player_memory[player.index] = {
            last_held_item_name = nil,
            is_gui_open = false
        }
    end

    return global.player_memory[player.index]
end

script.on_event(defines.events.on_player_cursor_stack_changed, function(event)
    local player = game.players[event.player_index]

    if player.cursor_stack and player.cursor_stack.valid and player.cursor_stack.valid_for_read then
        if (player.cursor_stack.prototype.place_result or player.cursor_stack.prototype.place_as_tile_result)
                and player.cursor_stack.name ~= "construction-robot" and player.cursor_stack.name ~= "logistic-robot"
        then
            memory_of(player).last_held_item_name = player.cursor_stack.name
        else
            memory_of(player).last_held_item_name = nil
        end

    else
        if player.cursor_ghost then
            return -- player replaced held item with a ghost (by e.g. clicking on the toolbelt)
        end
        if player.mod_settings["GhostInHand_disable-when-gui-open"].value and memory_of(player).is_gui_open then
            return
        end

        local last_held_item = memory_of(player).last_held_item_name;
        if last_held_item then
            if player.get_main_inventory().get_item_count(last_held_item) > 0 then
                return -- player has that item in their inventory, so they must have put it down themselves (by using 'clean cursor' action or clicking the item on the toolbelt)
            end
            player.cursor_ghost = last_held_item
            memory_of(player).last_held_item_name = nil
        end
    end
end)

script.on_event(defines.events.on_gui_opened, function(event)
    local player = game.players[event.player_index]
    memory_of(player).is_gui_open = true;
end)

script.on_event(defines.events.on_gui_closed, function(event)
    local player = game.players[event.player_index]
    memory_of(player).is_gui_open = false;
end)
