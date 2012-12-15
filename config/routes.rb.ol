# -*- encoding : utf-8 -*-
Tb::Application.routes.draw do
  
  

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :stores,:path=>"shop",:only=>[:show,:index]
  
  #resources :huatis,:path=>"topics" do
  #  collection do
  #    get 'manage'
  #    get 'popular'
  #    get 'search'
  #    get 'auto_complete'
  #  end
  #  member do
  #    post 'visit'
  #    post 'fetch'
  #  end
  #end
  #post "/topics/load_data"=>"huatis#load_data"
  #match 'browse/other/:acr'=>'huatis#browse',:as=>'browse_huatis'

  resources :cats do
    collection do
      get 'manage'
      get 'tree'
    end
  end

  resources :links

  match '/to/:id' => 'topics#go',:as=>'go',:constraints=>{:id=>/[\w\d\.\_\%\-]+/}
  match '/(topics|mai|start|browse)/:any'=>"home#deleted"
  constraints(Subdomain) do
    match '/t/:id'=>'city/home#page',:as=>'page'
    match '/(topics|mai|start|browse)/:any'=>"home#deleted"
    #match '/mai/auto_complete'=>'topics#auto_complete',:as=>'topics_auto_complete'
    # match '/city/visit'=>'city/topics#city_visit'
    # match '/mai/search'=>'city/topics#search',:as=>'topics_search'
    #resources :topics,:path=>'mai',:controller=>'city/topics' do
    #  member do
    #    get 'page/:page', :action => :show
    #  end
    #  collection do
    #    get 'page/:page', :action => :index
    #    get 'search'
    #    post 'city_visit'
    #    get 'popular'
    #  end
    #end
    # match 'mai(/page/:page)'=>'city/topics#index',:as=>'topics'
    # match 'mai/:id(/page/:page)'=>'city/topics#show',:as=>'topic'
    #match 'start/:i(/page/:page)'=>'city/topics#browse',:as=>'browse_topics'
    get '/:id'=>"cats#city",:as=>"cat_city"
    root :to => 'home#city'
  end
  match '/taobao-:id'=>'cats#show',:as=>'tbcat'
  match '/t/:id'=>'home#page',:as=>'page'
  match '/link/:nid'=>"home#item_go",:as=>'item_go'
  match '/tracklink/:id'=>"home#store_go",:as=>'store_go'
  match '/ad/:id'=>'home#ad',:as=>'ad'
  resources :tbpages
  resources :cities,:only=>"index"
  resources :categories do 
    collection do
      get :admin
    end
  end
  match "syncs/:type/new" => "syncs#new", :as => :sync_new
  match "syncs/:type/callback" => "syncs#callback", :as => :sync_callback
  #resources :topics,:path=>'mai' do
  #  member do
  #    get 'page/:page', :action => :show
  #    post 'visit'
  #    get 'publish'
  #  end
  #  collection do
  #    get 'page/:page', :action => :index
  #    get 'auto_complete'
  #    get 'search'
  #    get 'popular'
  #    get 'manage'
  #  end
  #end

  #match 'start/:i(/page/:page)'=>'topics#browse',:as=>'browse_topics'


  # authenticated :user do
    # root :to => 'topics#index'
  # end
  root :to => "home#index"
  match '/flush' => 'home#flush',:as=>'flush'
  devise_for :users
  resources :users, :only => [:show, :index]
end
