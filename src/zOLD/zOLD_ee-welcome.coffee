module = angular.module 'ee-welcome', []

angular.module('ee-welcome').directive "eeWelcome", ($rootScope) ->
  templateUrl: 'components/ee-welcome.html'
  restrict: 'E'
  link: (scope) ->
    scope.closeWelcome = () ->
      $rootScope.welcome_1 = false
      scope.closed = true
    return
