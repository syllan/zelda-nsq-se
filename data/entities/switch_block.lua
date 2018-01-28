local block = ...
local game = block:get_game()
local map = block:get_map()
local sprite

function block:on_created()
  block:set_size(16, 16)
  block:set_origin(8, 13)
  if block:get_sprite() == nil then
    block:create_sprite("entities/switch_block")
  end
  sprite = block:get_sprite()
  block:set_state(true)
end

function block:change_state()
  block:set_state(not block:get_state())
end

function block:set_state(state)
  
  if state then
    sprite:set_animation("raised")
    block:set_modified_ground("low_wall")
  else
    sprite:set_animation("lowered")
    block:set_modified_ground("traversable")
  end
end

function block:get_state()
  return block:get_modified_ground() ~= "traversable"
end
