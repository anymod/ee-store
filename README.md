ee-front
===

### Installation

`npm install`

`bower install`

### Locations

env | ee-front | ee-back
:---------------------|:------------------------|:-----------------------
test (e2e)            | `http://localhost:3333` | `http://localhost:5555`
test (api)            | -                       | `http://localhost:5444`
development (builder) | `http://localhost:3000` | `http://localhost:5000`
development (store)   | `http://*.localhost:4000` | `http://localhost:5000`
production (builder)  | `https://eeosk.com`     | `https://api.eeosk.com`
production (store)    | `https://*.eeosk.com`   | `https://api.eeosk.com`

### Testing

e2e       | env  | runner
:---------|:-----|:-------------
ee-front  | test | `gulp test (--grep=<filter>)` runs web server and e2e tests continuously with protractor; `webdriver-manager start` to initialize selenium
ee-back   | test | `gulp test` runs api server (not tests) in test environment
eeosk.com | production | `gulp test-live` will run e2e tests on live site

api       | env  | runner
:---------|:-----|:-------------
ee-back   | test | `gulp watch-mocha` runs api server and tests continuously with mocha

### Development

dev       | env         | runner
:---------|:------------|:-------------
ee-front  | development | `gulp dev` runs builder server in development environment
ee-front  | development | `gulp dev-store` runs store server in development environment
ee-back   | development | `gulp dev` runs api server in development environment

### Production

prod     | task    | runner
:--------|:--------|:------------
ee-front | compile & test | `gulp prod-test` compiles app into `/dist` & runs e2e tests w test api server
ee-front | compile | `gulp prod` compiles app into `/dist`, ready for deployment
ee-back  | -       | push directly to target if tests pass


### Other

## Workflow & pricing definition

https://docs.google.com/a/eeosk.com/drawings/d/11vSU7glwutO6zhEx5_f4zXxlCpFQD_LGjVchKy11-J0/edit?usp=sharing
