Joinplato::Application.routes.draw do
  
  # admin

  namespace :admin do
    match '/' => 'dashboard#index'
    resources :users
    resources :elections
    resources :candidates
    resources :propositions do
      collection do
        get :manage
      end
    end
  end
  
  # API

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do

      resources :elections, except: :index do
        member do
          post :addtheme
          post :addcandidate
        end
        collection do
          get :search
        end
      end

      resources :themes do
        member do
          post :addphoto
        end
      end

      resources :candidates do
        member do
          post :addphoto
        end
      end

      resources :propositions do
        collection do
          get :search
        end
      end

    end
  end
  
  # webviews
  resources :webviews, :only => :index do
    collection do
      get :compare
      get :propositions
    end
  end
  
  # web-app
  
  resources :plugins, :only => :index
  
  namespace :plugins do
    resources :compare, :only => :index do
      collection do
        get :propositions
      end
    end
  end

  devise_for :users
  
  match ':country/:election/:candidates/propositions/:id' => 'propositions#show', :as => :proposition
  match ':country/:election/:candidates/:themes' => 'elections#compare', :as => :election_compare
  match ':country/:election/:candidates' => 'elections#themes', :as => :election_themes
  match ':country/:election' => 'elections#show', :as => :election
  match ':country' => 'countries#show'
  
  root to: 'elections#index'

end