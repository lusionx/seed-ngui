app = angular.module 'app'

app.factory 'dUser', (CONFIG) ->
  query:
    method: 'GET'
    isArray: yes
  get:
    method: 'GET'
    isArray: no
  $resource CONFIG.apiRoot + '/users/:id', {}, acts
