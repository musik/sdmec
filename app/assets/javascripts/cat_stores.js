//= require jquery
//= require jquery_ujs
//= require angular
function CatStores($scope,$http) {
  $http.get('/cats/'+ cat_id + '/stores.json').success(function(data){
    $scope.results =  data;
  })
  $scope.InhomeChange = function(store){
    $http.post('/cats/update_store.js',{id: store.id,store: {inhome: store.inhome ? null : 1}})
  }
  $scope.PositionChange = function(store){
    store.position = Number(store.position)
    $http.post('/cats/update_store.js',{id: store.id,store: {position: store.position}})
  }
}
