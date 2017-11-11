local item = ...

function item:on_created()

  self:set_savegame_variable("possession_cane_of_byrna")
end

function item:on_variant_changed(variant)
  -- TODO
end

