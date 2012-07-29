VotingModule::Application.routes.draw do
        
  root :to => "initiatives#index"
        
  match '/auth/:provider/callback' => 'authentications#create'
  #match '/auth/facebook', :to => 'authentications#facebook_setup'
  match '/auth/facebook/setup', :to => 'authentications#facebook_setup'
  match '/auth/twitter/setup', :to => 'authentications#twitter_setup'
  match '/auth/linkedin/setup', :to => 'authentications#linkedin_setup'

  devise_for :users, :controllers => {:registrations => 'registrations'} 
  
  get "language/info"
  get "language/intro"
  get "language/fra"
  get "language/ndl"
  get "language/eng"
  get "tutorial/video"
  get "info/homepage"
  get "info/contact"
  
  resources :user 
  resources :delegations
  resources :delegates
  resources :communities
  
  resources :authentications
  
  resources :referendums, :path => 'referendums' do
    resources :comments
    resources :arguments
    resources :amendments
    resources :brainstorm
  end
  resources :initiatives, :path => 'initiatives' do
    resources :comments
    resources :arguments
    resources :amendments
    resources :brainstorm
  end
  resources :amendments, :path => 'amendments' do
    resources :comments
    resources :arguments
    resources :brainstorm
  end
  resources :arguments, :path => 'arguments' do
    resources :comments
  end
  resources :brainstorms, :path => 'brainstorms' do
    resources :ideas
  end
  
  resources :parties

  resources :politicians

  resources :exclusions
  
  resources :categories
  
  resources :candidates
  
  
  match ':controller(/:action(/:id(.:format)))'



  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  
end
