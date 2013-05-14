class Drop < ActiveRecord::Base
  belongs_to :npc
  belongs_to :item_template

  def roll
    item_template.generate if rand(100) <= chance
  end
end
