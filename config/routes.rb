class MobileConstraint
  
  def matches? request
    wap_device?(request) || search_bot?(request) || facebook_bot?(request) || ie_6?(request)
  end
  
  def wap_device? request
    request.user_agent.to_s.downcase =~ /blackberry|nokia|ericsson|webos/
  end
  
  def search_bot? request
    if request.user_agent.present?
      user_agent = request.user_agent.downcase
      [ 'msnbot', 'yahoo! slurp','googlebot'].detect { |bot| user_agent.include? bot }
    end
  end
  
  def facebook_bot? request
    request.user_agent.to_s.downcase =~ /facebookexternalhit/
  end
  
  def ie_6? request
    request.user_agent.to_s.downcase =~ /msie 6/
  end
  
end

class TouchConstraint
  
  def matches? request
    touch_device?(request) || touch_subdomain?(request)
  end
  
  def touch_device? request
    request.user_agent.to_s.downcase =~ /iphone|android/
  end
  
  def touch_subdomain? request
    request.subdomain.present? && request.subdomain == "touch"
  end
  
end

Joinplato::Application.routes.draw do
  
  # redirect www to .
  match "/" => redirect {|params| "http://voxe.org" }, :constraints => {:subdomain => "www"}
  match "/*path" => redirect {|params| "http://voxe.org/#{params[:path]}" }, :constraints => {:subdomain => "www"}
  
  # sitemap
  match 'sitemap.xml' => 'web/sitemap#index', format: 'xml'
  
  # admin

  namespace :admin do
    match '/' => 'dashboard#index'
    resources :users
    resources :elections
    resources :candidates
    resources :tags
    resources :propositions do
      collection do
        get :manage
      end
    end
  end
  
  # API

  namespace :api, format: :json do
    namespace :v1 do

      resources :elections, except: :index do
        member do
          post :addtag
          delete :removetag
          post :addcandidacy
          post :movetags
          post :addcontributor
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
        collection do
          get :search
        end
      end
      
      resources :tags do
        collection do
          get :search
        end
      end
      
      resources :propositions do
        collection do
          get :search
        end
        member do
          get :comments
          post :addcomment
          post :addembed
          delete :removeembed
          delete :removecomment
        end
      end

      resources :candidacies do
        member do
          post :addorganization
        end
      end

      resources :users do
        collection do
          get :search
          get :verify
          get :self
          post :facebookconnect
        end
      end

      resources :organizations
      
      resources :comparisons do
        collection do
          get :search
        end
      end

    end
  end
  
  # webviews
  namespace :webviews, format: "touch" do
    resources :comparisons, only: :index
    resources :propositions, only: :show
  end
  # resources :webviews, :only => :index do
  #   collection do
  #     get :compare
  #     get :proposition
  #   end
  # end
  
  # web-app
  namespace :embed do
    resources :elections, only: :show
    resources :live, only: :index
    resources :partners, only: :index do
      collection do
        get :huffingtonpost
      end
    end
  end
  
  # api doc
  
  match 'platform' => 'platform#index'
  
  namespace :platform do
    resources :endpoints do
      collection do
        get :elections
        get :candidates
        get :propositions
        get :tags
        get :candidacies
        get :users
        get :organizations
      end
    end
    resources :models do
      collection do
        get :election
        get :candidate
        get :proposition
        get :tag
        get :candidacy
        get :user
        get :organization
      end
    end
    resources :embed, :only => :index do
      collection do
        get :button
        get :bookmarklet
      end
    end
    resources :mobile, :only => :index
  end

  devise_for :users
  
  # all platforms
  match 'about/' => 'Web::Static#about', :as => :about
  match 'about/how' => 'Web::Static#how', :as => :how
  match 'about/team' => 'Web::Static#team', :as => :team
  match 'about/press' => 'Web::Static#press', :as => :press
  match 'about/terms' => 'Web::Static#terms', :as => :terms
  match 'about/thanks' => 'Web::Static#thanks', :as => :thanks
  match 'join' => 'Web::Static#join', :as => :join
  match 'apps' => 'Web::Static#apps', :as => :apps
  match 'live' => 'Web::Static#live', :as => :live
  
  # touch
  scope :module => "touch", format: "touch", constraints: TouchConstraint.new do
    match ':namespace/:candidacies/:tag' => 'comparisons#show', :as => :compare
    match ':namespace/:candidacies' => 'tags#index', :as => :tags
    match ':namespace' => 'elections#show', :as => :election
    
    root to: 'elections#index'
  end
  
  # mobile
  scope :module => "mobile", format: "mobile", constraints: MobileConstraint.new do
    match ':namespace/:candidacies/:tag' => 'elections#compare', :as => :compare
    
    match 'propositions/:id' => 'propositions#show', :as => :proposition
    
    match ':namespace/candidacies' => 'candidacies#create', :as => :candidacies
    match ':namespace/:candidacies' => 'tags#index', :as => :tags
    match ':namespace' => 'elections#show', :as => :election
    
    root to: 'elections#index'
  end
  
  # web
  scope :module => "web", format: "html" do
    match 'propositions/:id' => 'propositions#show', :as => :proposition
    
    match ':namespace/:candidacies/:tag' => 'comparisons#show', :as => :compare
    match ':namespace/:candidacies' => 'tags#index', :as => :tags
    match ':namespace' => 'elections#show', :as => :election
    
    root to: 'application#index'
  end
  
end