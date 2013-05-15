# -*- encoding : utf-8 -*-
# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  skip_before_filter :login_required
  # render login form
  # will show the captcha
  def new
  end

  # post to login
  # will validates the captcha
  def create
    logout_keeping_session!
#    if params[:captcha].upcase != session[:captcha].upcase
#      flash[:error] = '验证码错误'
#      @login       = params[:login]
#      @remember_me = params[:remember_me]
#      return render( :action => 'new')
#    end
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/myaccount')
      flash[:notice] = I18n.t(:Logged_in_successfully)
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  # logout
  def destroy
    logout_killing_session!
    flash[:notice] = I18n.t(:Logged_out)
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
