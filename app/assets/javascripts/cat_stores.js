//= require jquery
//= require jquery_ujs
//= require angular
var App = angular.module('Sdmec',[]);
App.controller('CatStores',['$scope','$http',function ($scope,$http) {
  $scope.shop_cat_id = cat_oid;
  $http.get('/cats/'+ cat_id + '/stores.json').success(function(data){
    $scope.results =  data;
    $scope.ids = [];
    for(i in data){
      $scope.ids.push(data[i].user_id)
    }
  })
  $scope.InhomeChange = function(store){
    $http.post('/cats/update_store.js',{id: store.id,store: {inhome: store.inhome ? null : 1}})
  }
  $scope.save = function(store){
    store.position = Number(store.position0);
    $http.post('/cats/update_store.js',{id: store.id,store: {position: store.position,short: store.short,click_url: store.click_url}});
  }
  $scope.search = function(){
    $http.post('/cats/search.js',{cat_id: $scope.shop_cat_id}).success(function(data){
      $scope.shops = [];
      for(i in data){
        if($scope.ids.indexOf(data[i].user_id) == -1){
          //$scope.shops[data[i].user_id] = data[i];
          $scope.shops.push(data[i]);
        }
      }
      $scope.searching = true;
    });
  }
  //$scope.search();
  $scope.addThis = function(shop){
    $scope.shop_url = shop.shop_url;
    $scope.addShop();
    shop.hide = true
  }
  $scope.addShop = function(){
    $http.post('/cats/add.json',
        {cat_id: cat_id,
          shop_url: $scope.shop_url}).success(function(data){
      if($scope.ids.indexOf(data.user_id) == -1){
        $scope.results.push(data);
        $scope.ids.push(data.user_id);
      }
    })
      $scope.shop_url = "";
  }
  $scope.remove = function(store){
    $http.delete('/cats/' + String(store.cat_id)+ '/stores/'+ String(store.id) + '.js').success(function(data){
      store.removed = true
    })
  }
}])
