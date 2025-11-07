/*
    SETUP
*/

// Express Server
const express = require('express');  // We are using the express library for the web server
const app = express();               // We need to instantiate an express object to interact with the server in our code
const PORT = process.env.PORT || 1738;                   // Set a port number
const path = require('path');
// Database connection
const db = require('./db-connector');

// Configure handlebars
// Handlebars Setup
const { engine } = require('express-handlebars');

app.engine('hbs', engine({
  extname: '.hbs',
  defaultLayout: 'main',
  layoutsDir: path.join(__dirname, 'views/layouts'),
  partialsDir: path.join(__dirname, 'views/partials')
}));

app.set('view engine', 'hbs');
app.set('views', path.join(__dirname, 'views'));


app.use(express.static(path.join(__dirname, 'public'), { index: false }));
app.use(express.urlencoded({ extended: true }));

// expose common template values to all views
app.use((req, res, next) => {
  res.locals.year = new Date().getFullYear();
  res.locals.user = req.user || null;
  next();
});

// Link page to URLs
app.get('/', (req, res) => {
  res.render('home', {
    title: 'Rocket Event Management',
    layout: 'main'    // explicitly use views/layouts/main.hbs
  });
});

// UI PAGES FOR EACH TABLE
app.get('/students', (req, res) => {
  const sql = 'SELECT * FROM Students;';

  // support both exports: db.pool.query(...) or db.query(...)
  const executor = (db && db.pool && typeof db.pool.query === 'function') ? db.pool : db;

  if (!executor || typeof executor.query !== 'function') {
    console.error('DB executor not found on db-connector export:', Object.keys(db || {}));
    return res.status(500).render('students', { students: [], error: 'Database not configured' });
  }

  executor.query(sql, (error, results) => {
    if (error) {
      console.error('DB error fetching students:', error); // <-- full error in server console
      return res.status(500).render('students', { students: [], error: error.message });
    }
    res.render('students', { students: results });
  });
});

app.get('/departments', (req, res) => {
  const sql = 'SELECT * FROM Departments;';
  const executor = (db && db.pool && typeof db.pool.query === 'function') ? db.pool : db;

  if (!executor || typeof executor.query !== 'function') {
    console.error('DB executor not found on db-connector export:', Object.keys(db || {}));
    return res.status(500).render('departments', { departments: [], error: 'Database not configured' });
  }

  executor.query(sql, (error, results) => {
    if (error) {
      console.error('DB error fetching departments:', error);
      return res.status(500).render('departments', { departments: [], error: error.message });
    }
    res.render('departments', { departments: results });
  });
});

app.get('/events', (req, res) => {

  const sql = 'SELECT * FROM Events;';

  // support both exports: db.pool.query(...) or db.query(...)
  const executor = (db && db.pool && typeof db.pool.query === 'function') ? db.pool : db;

  if (!executor || typeof executor.query !== 'function') {
    console.error('DB executor not found on db-connector export:', Object.keys(db || {}));
    return res.status(500).render('events', { events: [], error: 'Database not configured' });
  }

  executor.query(sql, (error, results) => {
    if (error) {
      console.error('DB error fetching events:', error);
      return res.status(500).render('events', { events: [], error: error.message });
    }
    res.render('events', { events: results });
  });
});

app.get('/locations', (req, res) => {
  
}
  
  res.render('locations'));
app.get('/event-attendance', (req, res) => res.render('events-with-students'));
app.get('/department-events', (req, res) => res.render('departments-with-students'));


/*
    LISTENER
*/

app.listen(PORT, function () {            // This is the basic syntax for what is called the 'listener' which receives incoming requests on the specified PORT.
  console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.')
});