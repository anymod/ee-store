angular.module 'ee-builder-live-button', []

angular.module('ee-builder-live-button').directive "eeBuilderLiveButton", ($state, $stateParams) ->
  templateUrl: 'ee-shared/components/ee-builder-live-button.html'
  restrict: 'E'
  scope:
    user:     '='
    message:  '@'
    hiddenXs: '@'
    btnClass: '@'
  link: (scope, ele, attrs) ->
    scope.root = if scope.user?.domain then 'http://' + scope.user.domain else 'https://' + scope.user?.username + '.eeosk.com'
    scope.path = '/'

    setButton = (toState, toParams) ->
      switch toState.name
        when 'products'       then scope.path += 'search'
        when 'productAdd'     then scope.path += 'products/' + toParams.id + '/'
        when 'collectionEdit' then scope.path += 'collections/' + toParams.id + '/'
        else ''
        # else scope.root = 'https://' + scope.user.username + '.eeosk.com'
      scope.target = scope.root + scope.path

    setButton $state.current, $stateParams

    scope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
      setButton toState, toParams

    return
