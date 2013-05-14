ActionController::Routing::Routes.draw do |map|
  map.resources :formulas, :member => {:apply => :any}

  map.resources :item_templates

  map.resources :mails

  map.resources :auctions, :has_many => :bids , :member=>{:buyout =>:post}

  map.resources :npcs

#  map.resources :merchandises

  map.resources :shops do |shop|
    shop.resources :merchandises, :member => {:buy => :post}
  end

  map.resources :scenarios, :has_many => :underlings,
    :member => {:buy => :any, :sell => :any}
  map.resources :npcs, :has_many => :drops, :member => {:copy => :post}
  map.resources :badges

  map.resources :icons

  map.resources :abilities

  map.resources :characters, 
    :member => {:inc_point => :post, :dec_point => :post} do |character|
    character.resources :items, :member => {:equip => :any, :unequip => :any, :refresh => :any}
  end

  map.resources :users 
  map.home     '/',         :controller => 'home',     :action => 'index'
  map.logout   '/logout',   :controller => 'sessions', :action => 'destroy'
  map.login    '/login',    :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users',    :action => 'create'
  map.signup   '/signup',   :controller => 'users',    :action => 'new'
  map.myaccount'/myaccount',:controller => 'users',    :action => 'myaccount'
  #map.live_search '/live_search', :controller => 'questions', :action => 'live_search'
  #map.captcha '/captcha', :controller => 'users', :action => 'captcha'
  map.resource :session
  map.activate '/users/activate/:activation_code', :controller => 'users', :action => 'activate'
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  
  map.namespace :admin do |admin|
    # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
    admin.resources :categories, :member => {:moveup => :get, :movedown => :get}
    admin.resources :questions
    admin.resources :answers
    admin.resources :users, :collection => {:approve => :get}
    admin.home '/', :controller => 'dashboard', :action => 'index'
  end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
