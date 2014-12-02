# -*- encoding : utf-8 -*-
Tb::Application.routes.draw do
  resources :entries,path: "websites",
    :constraints => { :id => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/ } do
    post :check,on: :member
  end

  #resources :posts
  #resources :fenleis,path: "fenlei"


  #resources :sites
  resources :comments,:except=>[:new]

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  scope ':deleted',:deleted=>/topics|mai|start|browse|categories/ do
    match '(:id)'=>'home#deleted'
  end
  match '/xtao' => 'home#xtao'
  constraints(ToolsSubdomain) do
    match '/xiaoliang/:id'=>'tools#xiaoliang',:as=>'xiaoliang'
    root :to => 'tools#xiaoliang'
  end
  constraints(CitySubdomain) do
    match '/t/:id'=>'city/home#page',:as=>'page'
    get '/shop'=>"stores#city",:as=>"shops_city"
    get 'tags/auto_complete'=>"tags#auto_complete"
    get 'tags/:id'=>"tags#city",:as=>"city_tag"
    get '/:id'=>"cats#city",:as=>"cat_city"
    root :to => 'home#city'
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
      match 'settings' => 'sites#settings',:as=>'settings'
      match 'options' => 'sites#options',:as=>'options',:via=>'post'
    end
    root :to => 'sites#index'
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
  match '/links'=>'links#links',:as=>'partners'

  match '/to/:id' => 'topics#go',:as=>'go',:constraints=>{:id=>/[\w\d\.\_\%\-]+/}
  match '/taobao-:id'=>'cats#show',:as=>'tbcat'
  match '/t/:id'=>'home#page',:as=>'page'
  match '/link/:nid'=>"home#item_go",:as=>'item_go'
  match '/itemlink/:id/:position'=>"home#shopitem_go",:as=>'shopitem_go'
  match '/tracklink/:id'=>"home#store_go",:as=>'store_go'
  match '/ad/:id'=>'home#ad',:as=>'ad'
  match '/frame/:id'=>'home#frame',:as=>'frame'
  resources :tbpages
  resources :cities,:only=>"index"
  resources :categories do 
    collection do
      get :admin
    end
  end
  match "syncs/:type/new" => "syncs#new", :as => :sync_new
  match "syncs/:type/callback" => "syncs#callback", :as => :sync_callback
  root :to => "home#index"
  match '/flush' => 'home#flush',:as=>'flush'
  match '/search' => 'home#search',:as=>'search'
  match '/searched' => 'home#searched',:as=>'searched'
  match '/status' => 'home#status'
  match '/reports' => 'home#reports'
  match '/zhuan' => 'home#zhuan'
  match '/fenlei/:id' => 'tbpages#fenlei',:as=>"fenlei"
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
  get "/*id" => 'pages#show', as: :page, format: false
  #match '/(topics|mai|start|browse)/:any'=>"home#deleted"
  #match "/:action/:any" => "home#deleted",:constraints=>{:action=>/topics|mai|start|browse/}
end
