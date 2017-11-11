local item = ...

function item:on_created()

  self:set_savegame_variable("possession_invisibility_cloak")
end

function item:on_variant_changed(variant)
  -- The possession state of the invisibility_cloak determines the built-in ability
  -- TODO invisibility
end

