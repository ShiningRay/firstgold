# Base Controller for all our controllers
# here handle some common logics
# pay attention to that only the frontpage is open for anonymous users
class ApplicationController < ActionController::Base
  # AuthenticatedSystem must be included for RoleRequirement, and is provided by
  # installing acts_as_authenticates and running 'script/generate authenticated
  # account user'.
  # You can move this into a different controller, if you wish.  This module
  # gives you the require_role helpers, and others.
  include AuthenticatedSystem
  include RoleRequirementSystem

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery # :secret => '5297bcdda3ddfb3382df18cf9e25faa8'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password

  before_filter :login_required
protected
  def character_required
    unless session[:character_id] and current_character
      flash[:error] = 'Please choose a character to continue'
      return redirect_to(current_user)
    end
    if current_user.id != current_character.user_id
      session.delete(:character_id)
      redirect_to current_user
    end
  end

  def current_character
    @current_character ||= Character.find_by_id session[:character_id]
  end
  helper_method :current_character
  def admin_required
    redirect_to login_path unless logged_in? and current_user.is_admin?
  end
end
