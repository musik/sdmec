# -*- encoding : utf-8 -*-
Tb::Application.routes.draw do
  resources :comments,:except=>[:new]

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  scope ':deleted',:deleted=>/topics|mai|start|browse|categories/ do
    match '(:id)'=>'home#deleted'
  end
  match '/xtao' => 'home#xtao'
  constraints(Subdomain) do
    match '/t/:id'=>'city/home#page',:as=>'page'
    get '/shop'=>"stores#city",:as=>"shops_city"
    get '/:id'=>"cats#city",:as=>"cat_city"
    root :to => 'home#city'
  end
  resources :stores,:path=>"shop",:only=>[:show,:index] do
    collection do
      get 'top'
      get 'jinhuangguan'
      get 'huangguan'
      get 'dengji'
    end
    member do
      get 'convert'
    end
  end

  resources :cats do
    collection do
      get 'manage'
      get 'tree'
    end
  end
  resources :links

  match '/to/:id' => 'topics#go',:as=>'go',:constraints=>{:id=>/[\w\d\.\_\%\-]+/}
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
  root :to => "home#index"
  match '/flush' => 'home#flush',:as=>'flush'
  match '/search' => 'home#search',:as=>'search'
  match '/searched' => 'home#searched',:as=>'searched'
  match '/status' => 'home#status'
  match '/zhuan' => 'home#zhuan'
  devise_for :users
  resources :users, :only => [:show, :index]
  #match '/(topics|mai|start|browse)/:any'=>"home#deleted"
  #match "/:action/:any" => "home#deleted",:constraints=>{:action=>/topics|mai|start|browse/}
end
