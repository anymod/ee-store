scope = {}
controller = {}

describe 'loginCtrl', () ->

  beforeEach module('eeBuilder')
  beforeEach module('app.core')
  beforeEach module('builder.auth')

  beforeEach (done) ->
    inject ($controller, $cookies) ->
      controller = $controller 'loginCtrl', $scope: scope
      done()

  # it 'should check for token cookie', (done) ->
  #   scope.res.should.equal ''
  #   scope.email = 'foo'
  #   scope.password = 'bar'
  #   scope.authWithPassword()

describe 'logoutCtrl', () ->

  beforeEach module('eeBuilder')
  beforeEach module('app.core')
  beforeEach module('builder.auth')

  beforeEach (done) ->
    inject ($controller, $cookies, $location) ->
      $cookies.loginToken = 'Bearer foo.bar.baz'
      $location.path '/login'
      $controller 'logoutCtrl', $scope: scope
      done()

  it 'should remove the loginToken', () ->
    inject ($cookies) -> should.not.exist $cookies.loginToken

  it 'should redirect to "/"', () ->
    inject ($location) -> $location.path().should.equal '/'
