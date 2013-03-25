Basl::Application.routes.draw do
  get 'admin' => 'admin#index', :as => :admin

  get 'administrivia' => 'administrivia#index', :as => :administrivia

  post 'seasons/:id/update_game_duration' => 'games#update_game_duration', :as => :update_game_duration

  post 'seasons/redirect' => 'seasons#redirect', :as => :season_redirect

  resources :commercial_listings

  get 'games/:id/cancel_edit' => 'games#cancel_edit', :as => :cancel_edit

  get 'games/cancel_new' => 'games#cancel_new', :as => :cancel_new

  resources :users

  resources :users

  resources :rules

  resources :pools

  resources :players

  resources :news_bytes

  get 'news_bytes/limit/:limit/offset/:offset' => 'news_bytes#index', :as => :news_page

  resources :game_types

  resources :fields

  resources :seasons do

    resources :teams

    resources :games

    resources :standings

  end

  match 'login' => 'login#index'

  match 'logout' => 'login#logout'

  match 'authenticate' => 'login#authenticate'

  match 'teams/:team_id/photo' => 'teams#photo', :as => :photo

  match 'teams/:team_id/players' => 'players#index', :as => :team_players

  match 'teams/:team_id/new_player' => 'players#new', :as => :new_team_player

  match 'teams/:id/games' => 'teams#games', :as => :team_games

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
  # root :to => 'welcome#index'
  root :to => "news_bytes#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
