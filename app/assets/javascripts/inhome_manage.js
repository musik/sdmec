//= require jquery
//= require jquery_ujs
//= require angular
function InhomeCtrl($scope,$http) {
  $http.get('/cats/preview.json').success(function(data){
    $scope.results =  data;
  })
  $scope.addShop = function(){
    $http.post('/cats/add.json',
        {cat_id: $scope.store_cat_id,
          shop_url: $scope.shop_url}).success(function(data){
      $scope.results[data.cat_id][1].push(data) 
      data.edit = true
    })
      $scope.shop_url = ""
  }
  $scope.edit = function(store){
    store.edit = true
    $scope.store = store
  }
  $scope.save = function(){
    $scope.store.edit = false
    $http.post('/cats/update_store.js',{id: $scope.store.id,store: {short: $scope.store.short,click_url: $scope.store.click_url}})
  }
  $scope.remove = function(){
    $http.delete('/cats/' + String($scope.store.cat_id)+ '/stores/'+ String($scope.store.id) + '.js').success(function(data){
      $scope.store.removed = true
    })
  }
  $scope.removeAll = function(){
    $http.post('/cats/remove_all').success(function(){
      for (i in $scope.results){
        $scope.results[i][1] = []
      }
    })
  }
}
var App = angular.module('Sdmec',[]);
App.controller('InhomeCtrl',['$scope','$http',InhomeCtrl])
