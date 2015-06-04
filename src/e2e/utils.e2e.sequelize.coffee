process.env.NODE_ENV = 'test'
Sequelize = require 'sequelize'

# Sequelize
sequelize = new Sequelize 'ee_db_test', 'tyler', null, {
  host: 'localhost',
  port: 5432,
  dialect: 'postgres'
}

sequelize
  .authenticate()
  .complete (err) ->
    message = if !!err then 'Unable to connect to the database: ' + err else 'Database connection has been established successfully.'
    console.log message

module.exports = sequelize
