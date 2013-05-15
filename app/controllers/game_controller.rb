# -*- encoding : utf-8 -*-
class GameController < ApplicationController
  before_filter :character_required
  def index
    @character = current_character
    @character.scenario = Scenario.first unless @character.scenario
  end
end
