app = angular.module 'app', ['ngResource', 'ngSanitize', 'ui.router', 'angular.filter']

app.run (queryObj, localStorage, global) ->
