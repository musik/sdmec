//= require jquery
//= require jquery_ujs
//= require angular
function CatStores($scope,$http) {
  $http.get('/cats/'+ cat_id + '/stores.json').success(function(data){
    $scope.results =  data;
    $scope.ids = []
    for(i in data){
      $scope.ids.push(data.id)
    }
  })
  $scope.InhomeChange = function(store){
    $http.post('/cats/update_store.js',{id: store.id,store: {inhome: store.inhome ? null : 1}})
  }
  $scope.save = function(store){
    store.position = Number(store.position)
    $http.post('/cats/update_store.js',{id: store.id,store: {position: store.position,short: store.short,click_url: store.click_url}})
  }
  $scope.addShop = function(){
    $http.post('/cats/add.json',
        {cat_id: cat_id,
          shop_url: $scope.shop_url}).success(function(data){
      if($scope.ids.indexOf(data.id) == -1){
        $scope.results.push(data)
        $scope.ids.push(data.id)
      }
    })
      $scope.shop_url = ""
  }
}
