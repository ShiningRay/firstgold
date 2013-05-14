# User controller
class UsersController < ApplicationController
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge, :edit, :update]
  skip_before_filter :login_required, :except => [:myaccount, :edit, :update]
  # redirect to profile page for current user
  def myaccount
    redirect_to user_path(current_user)
  end

  # edit user profile, only current user's own profile
  def edit
    return redirect_to(@user) if @user != current_user
  end

  # update user profile, only current user's own profile
  def update
    return redirect_to(@user) if @user != current_user
    if @user.update_attributes params[:user]
      flash[:notice] = I18n.t('profile_updated')
      return redirect_to(@user)
    else
      render :template => 'users/edit'
    end
  end

  # to show all the users
  # not in use at present
  def index
    @users = User.all
  end
  
  # show specific user
  def show
    @user = User.find params[:id]
    @is_current = current_user == @user
  end
  
  # sign up(registration) action
  def new
    @user = User.new
#    @user.profile = {}
  end

  # post to register new user
  # will validates captcha
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.state = 'active'
#    @user.profile ||= {}
#    @user.profile.symbolize_keys!
#    if session[:captcha].upcase != params[:captcha].upcase
#      flash[:error] = '验证码错误'
#      return render( :action => 'new')
#    end
#    @user.register! if @user && @user.valid?
    @user.save if @user && @user.valid?
    success = @user && @user.valid?

    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = I18n.t('thanks_for_signing_up')
    else
      flash[:error]  = I18n.t('cannot_set_up_account')
      render :action => 'new'
    end
  end

  #user activiation
  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
# There's no page here to update or destroy a user.  If you add those, be
# smart -- make sure you check that the visitor is authorized to do so, that they
# supply their old password along with a new one to update it, etc.
#  def suspend
#    @user.suspend!
#    redirect_to users_path
#  end
#
#  def unsuspend
#    @user.unsuspend!
#    redirect_to users_path
#  end
#  def destroy
#    @user.delete!
#    redirect_to users_path
#  end
#
#  def purge
#    @user.destroy
#    redirect_to users_path
#  end
  
  # generating captcha images
  # use the convert command from imagemagick
  # generate a captcha picture in tmp directory
  # and send it
#  def captcha
#    generate_captcha
#    file = File.join(RAILS_ROOT , "tmp", "#{session.session_id[0,8]}.jpg")
#    @output = `convert -size 80x20 xc:white -pointsize 18 -fill black -draw "text 10,15 '#{session[:captcha]}'" -fill white -draw "path 'M 1,1 L 70,20 M 1,20 L 80,1'" -trim #{file}`
#    puts @output
#    send_file(file, :type => 'image/jpeg', :disposition => 'inline')
#  end

protected
#  CHARS = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')
  # a before filter to find specific user against params
  def find_user
    @user = User[:id => params[:id]]
  end
  # generate captcha string
#  def generate_captcha
#    session[:captcha] = 4.times.collect{CHARS[rand(CHARS.length - 1)]}.join
#  end
end
