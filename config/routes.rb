Todolist::Application.routes.draw do
  devise_for :users


  devise_scope :user do
    get  'signup'     , to: 'devise/registrations#new' , as: :new_user_registration
    get  'login'      , to: 'devise/sessions#new'      , as: :new_user_session
    get  'logout'     , to: 'devise/sessions#destroy'  , as: :destroy_user_session
    #get  '/i/experts/logout'                  , to: 'easyke_mentors/sessions#destroy', as: :destroy_easyke_mentor_session
    #post '/sessions/oneclass_mentor'          , to: 'easyke_mentors/sessions#create' , as: :easyke_mentor_session
  end

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
  root :to => 'home#index'
  resources :tasks do
    collection do
      get :get_tasks
      get :sort_list
    end
    member do
      post :update_task
      post :update_task_done
      post :update_task_text
      post :remove_task
    end
  end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
