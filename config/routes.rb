Tb::Application.routes.draw do
  #namespace :fl do
    #resources :posts
    #resources :categories
  #end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :entries,path: "websites",
    :constraints => { :id => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/ } do
    post :check,on: :member
  end

  #resources :posts
  #resources :fenleis,path: "fenlei"


  #resources :sites
  resources :comments,:except=>[:new]

  #mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  #mount Upmin::Engine => '/admin'
  scope ':deleted',:deleted=>/topics|mai|start|browse|categories/ do
    get '(:id)'=>'home#deleted'
  end
  #constraints(ToolsSubdomain) do
    #get '/xiaoliang/:id'=>'tools#xiaoliang',:as=>'xiaoliang'
    #root :to => 'tools#xiaoliang',as: "tools_root"
  #end
  constraints(CitySubdomain) do
    get '/t/:id'=>'city/home#page',:as=>'city_page'
    get '/shop'=>"stores#city",:as=>"shops_city"
    get 'tags/auto_complete'=>"tags#auto_complete"
    get 'tags/:id'=>"tags#city",:as=>"city_tag"

    get '/new'=>"fl/posts#new",:as=>"fl_post_new"
    namespace :fl do
      resources :posts
      resources :categories
    end
    get '/:id'=>"fl/categories#city",:as=>"fl_city_cat"
    root :to => 'home#incity',as: "city_root"
  end
  constraints SiteSubdomain do
    #resources :items,:controller=>'site/items' do
      #collection do
        #get 'manage'
        #get 'apisearch'
        #post 'add'
      #end
    #end
    #resources :shops,:controller=>'site/shops' do
      #collection do
        #get 'manage'
        #get 'apisearch'
        #post 'add'
      #end
    #end
    get "/:id"=>"home#site" ,as: :site
    scope ":id" do
      get 'settings' => 'sites#settings',:as=>'settings'
      post 'options' => 'sites#options',:as=>'options'
    end
    root :to => 'sites#index',as: "site_root"
  end
  resources :stores,:path=>"shop" do
    collection do
      get 'top'
      get 'recent'
      get 'jinhuangguan'
      get 'huangguan'
      get 'dengji'
      post 'find'
      get 'tag'
      get "submit"
    end
    member do
      get 'convert'
      get 'flush'
      get 'items'
      put 'patch'
    end
  end
  resources :tags do
    collection do 
      post "preview"
      get 'auto_complete'
    end
  end

  resources :cats do
    collection do
      get 'manage'
      get 'tree'
      get 'preview'
      post 'update_store'
      post 'remove_all'
      post 'add'
      post 'search'
    end
    resources :stores,:controller=>'cat_stores'
  end
  resources :links,:path=>'snips'
  get '/links'=>'links#links',:as=>'partners'

  get '/to/:id' => 'topics#go',:as=>'go',:constraints=>{:id=>/[\w\d\.\_\%\-]+/}
  get '/taobao-:id'=>'cats#show',:as=>'tbcat'
  get '/t/:id'=>'home#page',:as=>'page'
  get '/link/:nid'=>"home#item_go",:as=>'item_go'
  get '/itemlink/:id/:position'=>"home#shopitem_go",:as=>'shopitem_go'
  get '/tracklink/:id'=>"home#store_go",:as=>'store_go'
  get '/ad/:id'=>'home#ad',:as=>'ad'
  get '/frame/:id'=>'home#frame',:as=>'frame'
  resources :tbpages
  resources :cities,:only=>"index"
  resources :categories do 
    collection do
      get :admin
    end
  end
  get "syncs/:type/new" => "syncs#new", :as => :sync_new
  get "syncs/:type/callback" => "syncs#callback", :as => :sync_callback
  root :to => "home#welcome"
  get '/flush' => 'home#flush',:as=>'flush'
  get '/search' => 'home#search',:as=>'search'
  get '/searched' => 'home#searched',:as=>'searched'
  get '/status' => 'home#status'
  get '/reports' => 'home#reports'
  get '/zhuan' => 'home#zhuan'
  get '/fenlei/:id' => 'tbpages#fenlei',:as=>"fenlei"
  devise_for :users,controllers: {registrations: "registrations"}
  resources :users, :only => [:show, :index]
  #mount Resque::Server, :at => "/resque"
  resque_constraint = lambda do |request|
    Rails.env.development? or 
    (request.env['warden'].authenticate? and
      request.env['warden'].user.has_role?(:admin))
  end
  constraints resque_constraint do
    mount Resque::Server.new, :at => "/resque"
  end
  #get "/*id" => 'pages#show', as: :page, format: false
  #get '/(topics|mai|start|browse)/:any'=>"home#deleted"
  #get "/:action/:any" => "home#deleted",:constraints=>{:action=>/topics|mai|start|browse/}
end
