# The frontpage controller
# Show the http://ask.keykang.com
class HomeController < ApplicationController
  skip_before_filter :login_required
  # the homepage action
  def index
    @scenarios = {}
    @matrix = {}
    Scenario.find( :all, :order => 'id asc').each do |s|
      @scenarios[s.id] = s
    end
    @users=User.recent_register_users
  end
end
