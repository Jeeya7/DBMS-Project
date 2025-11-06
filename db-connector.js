// Get an instance of mysql we can use in the app
require('dotenv').config();
let mysql = require('mysql2')
// Create a connection to the database
let connection = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
});

// Export it for use in our application
module.exports = connection;