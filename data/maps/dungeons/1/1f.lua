local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started(destination)
  map:set_doors_open("auto_door_k", true)
  --[[
  if game:get_value("trap_auto_door_k") ~= false then
    -- TODO squeletons instead of stalfos
  end
  --]]
end

--[[
-- trap door
function auto_door_k:on_opened()
  if map:get_entities_count("auto_enemy_auto_door_k") == 0 then
    game:set_value("trap_auto_door_k", false)
  end
end
function close_auto_door_k_sensor:on_activated()
  if map:get_entities_count("auto_enemy_auto_door_k") > 0
      and game:get_value("trap_auto_door_k") ~= false then
    map:close_doors("auto_door_k")
    -- TODO squeletons replaced by stalfos
  end
end
--]]

function auto_switch_switch_block_a:on_activated()
  map:set_custom_crystal_state("family", false)
end