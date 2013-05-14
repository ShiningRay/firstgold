class Admin::BaseController < ApplicationController
  #TODO: protect admin panels with checking admin privileges
  require_role 'admin'
  layout 'admin'
  #skip_before_filter :login_required
#  before_filter :admin_required
end