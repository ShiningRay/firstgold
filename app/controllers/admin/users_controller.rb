class Admin::UsersController < Admin::BaseController
  def index
    cond = ['state <> ?', 'deleted']
    if params[:q]
      cond[0] << ' AND login LIKE ? OR name LIKE ?'
      c = "%#{params[:q]}%"
      cond<<c<<c
    end
    @users = User.paginate :page => params[:page], :conditions => cond
  end

  def show
    @user = User.find params[:id]
  end

  def new
    
  end
  
  def create

  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    
    if params[:user][:role_ids]
      @user.role_ids = *params[:user][:role_ids]
    else
      @user.roles.clear
    end
    
    if params[:user][:state]
#      transitions
#      @user.send params[:user][:state] + '!'
      @user['state'] = params[:user][:state]
    end
    
    @user.update_attributes params[:user]
    redirect_to admin_users_path
  end

  def destroy
    @user = User.find params[:id]
    @user.delete!
  end

  # 用户审批
  def approve
    if request.post?
      users = {}
      User.find(params[:ids].keys).each{|u|users[u.id]=u}
      params[:ids].each_pair do |id, approved|
        id = id.to_i
        approved = approved.to_i
        if users[id]
          if approved == 1
            users[id].activate!
          else
            users[id].delete!
          end
        end
      end
    end
    @pending_users = User.find :all, :conditions => {:state => 'pending'}, :limit => 50
  end
end
