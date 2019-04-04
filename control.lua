local function memory_of(player)
    global.player_memory = global.player_memory or {}

    if not global.player_memory[player.index] then
        global.player_memory[player.index] = {
            last_held_item_name = nil
        }
    end

    return global.player_memory[player.index]
end

local function count_item(player, item_name)
    local count = player.get_main_inventory().get_item_count(item_name)
    if player.cursor_stack and player.cursor_stack.valid and player.cursor_stack.valid_for_read then
        count = count + player.cursor_stack.count
    end
    return count
end

local function attempt_place_ghost_in_hands(player)
    if player.cursor_stack and player.cursor_stack.valid and player.cursor_stack.valid_for_read then
        return
    end
    if not memory_of(player).last_held_item_name then
        return
    end
    if count_item(player, memory_of(player).last_held_item_name) > 0 then
        return
    end
    player.cursor_ghost = memory_of(player).last_held_item_name
end

script.on_event(defines.events.on_player_cursor_stack_changed, function(event)
    local player = game.players[event.player_index]

    if player.cursor_stack and player.cursor_stack.valid and player.cursor_stack.valid_for_read then
        if player.cursor_stack.prototype.place_result or player.cursor_stack.prototype.place_as_tile_result then
            memory_of(player).last_held_item_name = player.cursor_stack.name
        end
    else
--        player.print("on_player_cursor_stack_changed, nothing in cursor now")
--        memory_of(player).last_held_item_name = nil
    end

    attempt_place_ghost_in_hands(player)
end)

-- the only event fired for building real tiles
script.on_event(defines.events.on_player_built_tile, function(event)
    local player = game.players[event.player_index]
--    if player.cursor_stack and player.cursor_stack.valid and player.cursor_stack.valid_for_read then
--        player.print("on_player_built_tile, count " .. player.cursor_stack.count)
--    else
--        player.print("on_player_built_tile, cursor invalid")
--    end

    attempt_place_ghost_in_hands(player)
end)

-- the only event fired for building ghost tiles
-- 1. placing item normally
script.on_event(defines.events.on_built_entity, function(event)
    local player = game.players[event.player_index]
--    if player.cursor_stack and player.cursor_stack.valid and player.cursor_stack.valid_for_read then
--        player.print("on_built_entity, count " .. player.cursor_stack.count)
--    else
--        player.print("on_built_entity, cursor invalid")
--    end

    attempt_place_ghost_in_hands(player)
end)

script.on_event(defines.events.on_put_item, function(event)
    local player = game.players[event.player_index]
--    if player.cursor_stack and player.cursor_stack.valid and player.cursor_stack.valid_for_read then
--        player.print("on_put_item, count " .. player.cursor_stack.count)
--    else
--        player.print("on_put_item, cursor invalid")
--    end

    attempt_place_ghost_in_hands(player)
end)

local function cursor_ghost_string(player)
    if player.cursor_ghost then
        return player.cursor_ghost.name
    else
        return "nil"
    end
end

local function as_string(nullable_string)
    if nullable_string then
        return nullable_string
    else
        return "nil"
    end
end

local function nullable_count(player, nullable_string)
    if nullable_string then
        count_item(player, nullable_string)
    else
        return "nil"
    end
end

-- TODO what if players puts something in chest? while holding that item?
script.on_event(defines.events.on_player_main_inventory_changed, function(event)
    local player = game.players[event.player_index]
--    if player.cursor_stack and player.cursor_stack.valid and player.cursor_stack.valid_for_read then
--        player.print("on_player_main_inventory_changed, count " .. player.cursor_stack.count)
--    else
--        player.print("on_player_main_inventory_changed, cursor invalid")
--    end

    attempt_place_ghost_in_hands(player)

    local last_held_item_name = memory_of(player).last_held_item_name

    player.print("last_held_item_name = " .. as_string(last_held_item_name) .. ", cursor_ghost = " .. cursor_ghost_string(player) .. ", count = " .. nullable_count(player, last_held_item_name))

    if last_held_item_name and player.cursor_ghost == last_held_item_name and count_item(player, last_held_item_name) > 0 then
        local item_stack = player.get_main_inventory().find_item_stack(last_held_item_name)
        player.print("item_stack is " .. item_stack.name .. " and count is " .. item_stack.count)
        if player.cursor_stack.can_set_stack(item_stack) then --TODO or should I use swap stack here? is this going to duplicate items?
            player.print("can set in cursor")
            player.cursor_stack.set_stack(item_stack)
        end
    end
end)

-- scenarios to test:
-- 1. player puts a real item
--      a) no more items in inventory
--      b) next stack is taken from main inventory
-- 2. player puts an item holding shift (and personal robots take it from inventory)
--      a) no more items in inventory
--      b) next stack is taken from main inventory
-- 3. player puts a real tile
--      a) no more items in inventory
--      b) next stack is taken from main inventory
-- 4. player puts a tile holding shift (and personal robots take it from inventory)
--      a) no more items in inventory
--      b) next stack is taken from main inventory

-- if a player held a lamp and put it down, and then went towards a placed ghost lamp and robots took it from main inventory
-- then ghost lamp should not be put in players hands
