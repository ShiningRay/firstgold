# -*- encoding : utf-8 -*-
Firstgold::Application.routes.draw do
  resources :formulas do 
    member do 
      post :apply
    end
  end

  resources :item_templates

  resources :mails

  resources :auctions do 
    resources :bids do
      member do 
        post :buyout
      end
    end
  end

  resources :npcs

#  resources :merchandises

  resources :shops do
    resources :merchandises do
      member do
        post :buy
      end
    end
  end

  resources :scenarios do
    resources :underlings
    member do 
      post :buy 
      post :sell
    end
  end
  resources :npcs do
    resources :drops
    member do 
      post :copy
    end
  end
  resources :badges

  resources :icons

  resources :abilities

  resources :characters do 
    member  do 
      post :inc_point 
      post :dec_point
    end
    resources :items do 
      member do
        post :equip 
        post :unequip
        post :refresh
      end
    end
  end

  resources :users 
  match     '/'=> 'home#index', :as => 'home'
  match   '/logout'=> 'sessions#destroy', :as => 'logout'
  match    '/login'=> 'sessions#new', :as => 'login'
  match '/register'=> 'users#create', :as => 'register'
  match   '/signup'=> 'users#new', :as => 'signup'
  match '/myaccount'=> 'users#myaccount', :as => 'myaccount'
  #live_search '/live_search'=> 'questions#live_search'
  #captcha '/captcha'=> 'users#captcha'
  resource :session
  match '/users/activate/:activation_code'=> 'users#activate', :as => 'activate'
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   connect 'products/:id'=> 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   purchase 'products/:id/purchase'=> 'catalog#purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  
  namespace :admin do 
    # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
    resources :categories do
      member do 
        get :moveup 
        get :movedown 
      end
    end
    resources :questions
    resources :answers
    resources :users do 
      collection do 
        get :approve 
      end
    end
    match '/' => 'dashboard#index'
  end

  # You can have the root of your site routed with root -- just remember to delete public/index.html.
  # root :controller => "welcome"

  # See how all your routes lay out with "rake routes"
  root :to => 'home#index'
  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  match ':controller/:action/:id'
  match ':controller/:action/:id.:format'
end
