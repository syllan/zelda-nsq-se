local item = ...

function item:on_created()

  self:set_savegame_variable("possession_ocarina")
end

function item:on_variant_changed(variant)
  -- TODO
end

