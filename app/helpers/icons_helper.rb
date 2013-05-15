# -*- encoding : utf-8 -*-
module IconsHelper
  def icon_select(f)
    f.select :icon_id, Icon.all.collect {|c| [ c.name, c.id ] }
  end
end
