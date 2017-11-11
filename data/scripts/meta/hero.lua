-- Initialize hero behavior specific to this quest.

require("scripts/multi_events")

local hero_meta = sol.main.get_metatable("hero")

-- Returns the force of attacking with the sword.
function hero_meta:get_force()

  local game = self:get_game()
  local force = game:get_item("sword"):get_variant()
  return force
end

-- Returns the defense of the hero.
-- Depends on the current shield and tunic.
function hero_meta:get_defense()

  local game = self:get_game()
  local defense = game:get_item("shield"):get_variant() + game:get_item("tunic"):get_variant() - 1
  return defense
end

-- Redefine how to calculate the damage received by the hero.
function hero_meta:on_taking_damage(damage)

  -- In the parameter, the damage unit is 1/2 of a heart.
  local game = self:get_game()
  local defense = self:get_defense()
  local life_to_remove
  if defense <= 0 then
    -- Multiply the damage by two if the hero has no defense at all.
    life_to_remove = damage * 2
  else
    life_to_remove = math.floor(damage / defense)
    if life_to_remove <= 0 and damage > 0 then
      life_to_remove = 1
    end
  end

  game:remove_life(life_to_remove)
end

-- Detect the position of the hero to mark visited rooms in dungeons.
hero_meta:register_event("on_position_changed", function(hero)

  local map = hero:get_map()
  local game = map:get_game()
  local dungeon = game:get_dungeon()

  if dungeon == nil then
    return
  end

  local map_width, map_height = map:get_size()
  local room_width, room_height = 320, 240  -- TODO don't hardcode these numbers
  local num_columns = math.floor(map_width / room_width)

  local hero_x, hero_y = hero:get_center_position()
  local column = math.floor(hero_x / room_width)
  local row = math.floor(hero_y / room_height)
  local room = row * num_columns + column + 1

  game:set_explored_dungeon_room(nil, nil, room)
end)

-- Send the hero to lower floors when falling in a hole.
hero_meta:register_event("on_state_changed", function(hero, state)

  local map = hero:get_map()
  local game = map:get_game()

  if state == "falling" then
    hero.life_before_falling = game:get_life()
  end

  -- TODO check how much life is lost in the original game in normal holes

  if state == "back to solid ground" and
      hero:get_previous_state() == "falling" then
    local dungeon_index = game:get_dungeon_index()
    local floor = map:get_floor()
    if dungeon_index ~= nil and
        floor ~= nil and
        floor > game:get_dungeon_lowest_floor(dungeon_index) then
      local next_floor = floor - 1
      local destination_map_id = "dungeons/" .. dungeon_index .. "/" .. game:get_floor_name(next_floor)
      game:set_life(hero.life_before_falling)  -- Cancel removing life points after falling.
      hero:teleport(destination_map_id, "_same")
    end
  end
end)

function hero_meta:get_previous_state()
  return self.previous_state
end

hero_meta:register_event("on_state_changed", function(hero, state)
  -- Should be done after other on_state_changed() events.
  hero.previous_state = state
end)

return true
