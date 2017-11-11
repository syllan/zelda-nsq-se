return function(item)

  -- This script handles all bottles (each bottle script runs it).
  -- Variants:
  -- 1: empty
  -- 2: red potion
  -- 3: green potion
  -- 4: blue potion
  -- 5: yellow potion
  -- 6: orange potion
  -- 7: purple potion
  -- 8: grey potion

  local function drink_potion(variant)

    local game = item:get_game()
    local map = item:get_map()
    local hero = map:get_hero()

    hero:freeze()
    hero:set_animation("drinking")
    local hero_x, hero_y, hero_layer = hero:get_position()
    local potion = map:create_custom_entity({
      direction = 0,
      x = hero_x,
      y = hero_y,
      layer = hero_layer,
      width = 16,
      height = 16,
    })
    potion:set_drawn_in_y_order(true)
    local potion_sprite = potion:create_sprite("entities/drinking_potion")
    potion_sprite:set_animation(variant)

    function potion_sprite:on_animation_finished()

      if variant == 2 or variant == 4 or variant == 6 or variant == 8 then
        game:add_life(game:get_max_life())
      end
      if variant == 3 or variant == 4 or variant == 7 or variant == 8 then
        game:add_magic(game:get_max_magic())
      end
      if variant == 5 or variant == 6 or variant == 7 or variant == 8 then
        -- TODO game:add_navi(game:get_max_navi())
      end
      if variant == 8 then
        -- TODO max bombs and max arrows
      end
      item:set_variant(1)
      potion:remove()
      hero:unfreeze()
    end
  end

  function item:on_using()

    local variant = self:get_variant()
    local game = self:get_game()

    -- empty bottle
    if variant == 1 then
      sol.audio.play_sound("wrong")
      item:set_finished()

      -- red potion
    elseif variant == 2 then
      if game:get_life() >= game:get_max_life() then
        game:start_dialog("potion_not_needed")
      else
        drink_potion(variant)
      end
      item:set_finished()

      -- green potion
    elseif variant == 3 then
      if game:get_magic() >= game:get_max_magic() then
        game:start_dialog("potion_not_needed")
      else
        drink_potion(variant)
      end
      item:set_finished()

      -- blue potion
    elseif variant == 4 then
      if game:get_life() >= game:get_max_life() and
          game:get_magic() >= game:get_max_magic() then
        game:start_dialog("potion_not_needed")
      else
        drink_potion(variant)
      end
      item:set_finished()

      -- yellow potion
    elseif variant == 5 then
    --  if game:get_navi() >= game:get_max_navi() then
    --    game:start_dialog("potion_not_needed")
    --  else
        drink_potion(variant)
    --  end
      item:set_finished()

      -- orange potion
    elseif variant == 6 then
      if game:get_life() >= game:get_max_life() then --and
          -- game:get_navi() >= game:get_max_navi() then
        game:start_dialog("potion_not_needed")
      else
        drink_potion(variant)
      end
      item:set_finished()

      -- purple potion
    elseif variant == 7 then
      if game:get_magic() >= game:get_max_magic() then --and
          -- game:get_navi() >= game:get_max_navi() then
        game:start_dialog("potion_not_needed")
      else
        drink_potion(variant)
      end
      item:set_finished()

      -- grey potion
    elseif variant == 8 then
      if game:get_life() >= game:get_max_life() and
          game:get_magic() >= game:get_max_magic() then --and
          -- game:get_navi() >= game:get_max_navi() then
        game:start_dialog("potion_not_needed")
      else
        drink_potion(variant)
      end
      item:set_finished()

    end
  end
end
