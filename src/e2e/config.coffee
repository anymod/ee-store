process.env.NODE_ENV = 'test'
chai            = require 'chai'
should          = chai.should()
chaiAsPromised  = require 'chai-as-promised'
chai.use chaiAsPromised

Object.defineProperty(
  protractor.promise.Promise.prototype,
  'should',
  Object.getOwnPropertyDescriptor(Object.prototype, 'should')
)
