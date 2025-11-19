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

// DEBUG: log every request and health endpoint
app.use((req, res, next) => {
  console.log(new Date().toISOString(), req.method, req.originalUrl);
  next();
});

app.get('/ping', (req, res) => res.send('ok'));

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

/*******************************
 * READ ROUTES
 * *****************************/

app.get('/students', (req, res) => {
  const sql = 'SELECT * FROM Students;';
  const departmentsSql = 'SELECT * FROM Departments;';
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
    executor.query(departmentsSql, (deptError, deptResults) => {
      if (deptError) {
        console.error('DB error fetching departments:', deptError);
        return res.status(500).render('students', { students: results, departments: [], error: deptError.message });
      }
      res.render('students', { students: results, departments: deptResults });
    });
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
  const getEvents = 'SELECT * FROM Events;';
  const getLocations = 'SELECT * FROM Locations;';

  const executor = (db && db.pool && typeof db.pool.query === 'function') ? db.pool : db;

  if (!executor || typeof executor.query !== 'function') {
    console.error('DB executor not found on db-connector export:', Object.keys(db || {}));
    return res.status(500).render('events', { events: [], locations: [], error: 'Database not configured' });
  }

  // Fetch both events and locations
  executor.query(getEvents, (errEvents, eventResults) => {
    if (errEvents) {
      console.error(' Error fetching events:', errEvents);
      return res.status(500).render('events', { events: [], locations: [], error: errEvents.message });
    }

    executor.query(getLocations, (errLocations, locationResults) => {
      if (errLocations) {
        console.error(' Error fetching locations:', errLocations);
        return res.status(500).render('events', { events: eventResults, locations: [], error: errLocations.message });
      }

      // Send both datasets to the view
      res.render('events', { events: eventResults, locations: locationResults });
    });
  });
});

app.get('/locations', (req, res) => {
  const sql = 'SELECT * FROM Locations;';

  // support both exports: db.pool.query(...) or db.query(...)
  const executor = (db && db.pool && typeof db.pool.query === 'function') ? db.pool : db;

  if (!executor || typeof executor.query !== 'function') {
    console.error('DB executor not found on db-connector export:', Object.keys(db || {}));
    return res.status(500).render('locations', { locations: [], error: 'Database not configured' });
  }

  executor.query(sql, (error, results) => {
    if (error) {
      console.error('DB error fetching locations:', error);
      return res.status(500).render('locations', { locations: [], error: error.message });
    }
    res.render('locations', { locations: results });
  });
});

app.get('/event-attendance', (req, res) => {
  const linksSql = `CALL GetEventsAttendance();`;

  const getEvents = 'SELECT eventId, eventName FROM Events;';
  const getStudents = 'SELECT studentId, firstName, lastName FROM Students;';

  const executor = db.pool || db;

  executor.query(linksSql, (errLinks, linkResults) => {
    if (errLinks) return res.status(500).send(errLinks.message);

    executor.query(getEvents, (errEvents, eventResults) => {
      if (errEvents) return res.status(500).send(errEvents.message);

      executor.query(getStudents, (errStudents, studentResults) => {
        if (errStudents) return res.status(500).send(errStudents.message);

        res.render('events-with-students', {
          eventStudentLinks: linkResults[0], // For the main table
          eventsList: eventResults,       // For the event dropdown
          studentsList: studentResults    // For the student dropdown
        });
      });
    });
  });
});

app.get('/departments-events', (req, res) => {
  const sql = `CALL GetDepartmentsEvents(); `;
  const Eventssql = 'SELECT * FROM Events;';  
  const Departmentssql = 'SELECT * FROM Departments;';
  const executor = (db && db.pool && typeof db.pool.query === 'function') ? db.pool : db;

  if (!executor || typeof executor.query !== 'function') {
    console.error('DB executor not found on db-connector export:', Object.keys(db || {}));
    return res.status(500).render('departments-with-events', { events: [], error: 'Database not configured' });
  }

  executor.query(sql, (error, results) => {
    if (error) {
      console.error('DB error fetching department events:', error);
      return res.status(500).render('departments-with-events', { eventsDepartments: [], error: error.message });
    }
    console.log('Departments-Events Results:', results); // Debugging line to log results
    executor.query(Eventssql, (eventError, eventResults) => {
      if (eventError) {
        console.error('DB error fetching events:', eventError);
        return res.status(500).render('departments-with-events', {
          eventsDepartments: results[0],
          eventsList: [],
          departmentsList: [],
          error: eventError.message
        });
      }
      executor.query(Departmentssql, (deptError, deptResults) => {
        if (deptError) {
          console.error('DB error fetching departments:', deptError);
          return res.status(500).render('departments-with-events', {
            eventsDepartments: results[0],
            eventsList: eventResults,
            departmentsList: [],
            error: deptError.message
          });
        }
        res.render('departments-with-events', {
          eventsDepartments: results[0],
          eventsList: eventResults,
          departmentsList: deptResults
        });
      });
    });
  });
});


app.get('/events', (req, res) => {
  const getEvents = 'SELECT * FROM Events;';
  const getLocations = 'SELECT * FROM Locations;';

  const executor = (db && db.pool && typeof db.pool.query === 'function') ? db.pool : db;

  if (!executor || typeof executor.query !== 'function') {
    console.error('DB executor not found on db-connector export:', Object.keys(db || {}));
    return res.status(500).render('events', { events: [], locations: [], error: 'Database not configured' });
  }

  // Fetch both events and locations
  executor.query(getEvents, (errEvents, eventResults) => {
    if (errEvents) {
      console.error(' Error fetching events:', errEvents);
      return res.status(500).render('events', { events: [], locations: [], error: errEvents.message });
    }

    executor.query(getLocations, (errLocations, locationResults) => {
      if (errLocations) {
        console.error(' Error fetching locations:', errLocations);
        return res.status(500).render('events', { events: eventResults, locations: [], error: errLocations.message });
      }

      // Send both datasets to the view
      res.render('events', { events: eventResults, locations: locationResults });
    });
  });
});

/*******************************
 * Insert ROUTES
 * *****************************/
 
app.post('/add-event', (req, res) => {
  const { eventName, eventDate, startTime, expectedAttendance, locationId } = req.body;

  const sql = `CALL InsertEvent(?, ?, ?, ?, ?)`;

  const params = [eventName, eventDate, startTime, expectedAttendance, locationId];

  const executor = (db && db.pool && typeof db.pool.query === 'function') ? db.pool : db;

  executor.query(sql, params, (err, result) => {
    if (err) {
      console.error(' Error adding new event:', err);
      return res.status(500).send('Database insert failed.');
    }

    console.log(` Event "${eventName}" added successfully!`);
    res.redirect('/events'); // reload the Events page
  });
});

app.post('/add-student', (req, res) => {
  const { firstName, lastName, email, departmentId } = req.body;
  const sql = `CALL InsertStudent(?, ?, ?, ?)`;
  const params = [firstName, lastName, email, parseInt(departmentId, 10)];

  const executor = (db && db.pool && typeof db.pool.query === 'function') ? db.pool : db;
  executor.query(sql, params, (err) => {
    if (err) {
      console.error('Error adding new student:', err);
      return res.status(500).send('Database insert failed.');
    }

    console.log(`Student "${firstName} ${lastName}" added successfully!`);
    res.redirect('/students'); // reload the Students page
  });
});

app.post('/add-location', (req, res) => {
  const { locationName, address, capacity } = req.body;
  const sql = `CALL InsertLocation(?, ?, ?)`;
  const params = [locationName, address, parseInt(capacity, 10)];

  const executor = (db && db.pool && typeof db.pool.query === 'function') ? db.pool : db;
  executor.query(sql, params, (err) => {
    if (err) {
      console.error('Error adding new location:', err);
      return res.status(500).send('Database insert failed.');
    }

    console.log(`Location "${locationName}" added successfully!`);
    res.redirect('/locations'); // reload the Locations page
  });
});


app.post('/add-department', (req, res) => {
  const { departmentName } = req.body;
  const sql = `CALL InsertDepartment(?)`;
  const params = [departmentName];   // <-- YOU NEED THIS

  const executor = (db && db.pool && typeof db.pool.query === 'function') ? db.pool : db;

  executor.query(sql, params, (err) => {
    if (err) {
      console.error('Error adding new department:', err);
      return res.status(500).send('Database insert failed.');
    }

    console.log(`Department "${departmentName}" added successfully!`);
    res.redirect('/departments');
  });
});


app.post('/add-departments-events', (req, res) => {
  const { departmentId, eventId } = req.body;
  const sql = `CALL InsertDepartmentsHasEvents(?, ?)`; 
  const params = [parseInt(departmentId, 10), parseInt(eventId, 10)];
  
  const executor = (db && db.pool && typeof db.pool.query === 'function') ? db.pool : db;
  executor.query(sql, params, (err) => {
    if (err) {
      console.error('Error adding new department-event association:', err);
      return res.status(500).send('Database insert failed.');
    }
    console.log(`Department-Event association (Department ID: ${departmentId}, Event ID: ${eventId}) added successfully!`);
    res.redirect('/departments-events'); // reload the Departments-Events page
  });
});

/*******************************
 * Update ROUTES
 *******************************/

app.post('/update-event', (req, res) => {
  const { eventId, eventName, eventDate, startTime, expectedAttendance, locationId } = req.body;

  const sql = `CALL UpdateEvent(?, ?, ?, ?, ?, ?)`;

  const params = [parseInt(eventId, 10), eventName, eventDate, startTime, expectedAttendance, parseInt(locationId, 10)];

  console.log('Update Event Params:', params); // Debugging line to log parameters

  const executor = (db && db.pool && typeof db.pool.query === 'function') ? db.pool : db;

  executor.query(sql, params, (err) => {
    if (err) {
      console.error('Error updating event:', err);
      return res.status(500).send('Database update failed.');
    }

    console.log(`Event ${eventId} updated successfully!`);
    res.redirect('/events'); // refresh the events page
  });
});


app.post('/update-student', (req, res) => {
  const { studentId, firstName, lastName, email, departmentId } = req.body;

  const sql = 'CALL UpdateStudent(?, ?, ?, ?, ?)';
  const params = [parseInt(studentId, 10), firstName, lastName, email, parseInt(departmentId, 10)];

  const executor = (db && db.pool && typeof db.pool.query === 'function') ? db.pool : db;

  executor.query(sql, params, (err) => {
    if (err) {
      console.error('Error updating student:', err);
      return res.status(500).send('Database update failed.');
    }

    console.log(`Student ${studentId} updated successfully!`);
    res.redirect('/students'); // refresh the students page
  });
});


app.post('/update-location', (req, res) => {
  const { locationId, locationName, address, capacity } = req.body;

  const sql = `CALL UpdateLocation(?, ?, ?, ?)`;
  const params = [parseInt(locationId, 10), locationName, address, parseInt(capacity, 10)];

  console.log('Update Location Params:', params); // Debugging line to log parameters

  const executor = (db && db.pool && typeof db.pool.query === 'function') ? db.pool : db;

  executor.query(sql, params, (err) => {
    if (err) {
      console.error('Error updating location:', err);
      return res.status(500).send('Database update failed.');
    }

    console.log(`Location ${locationId} updated successfully!`);
    res.redirect('/locations'); // refresh the locations page
  });
});


app.post('/update-department', (req, res) => {
  const { departmentId, departmentName } = req.body;
  const sql = `CALL UpdateDepartment(?, ?)`; // your stored procedure
  const params = [parseInt(departmentId, 10), departmentName];

  const executor = (db && db.pool && typeof db.pool.query === 'function') ? db.pool : db;

  executor.query(sql, params, (err) => {
    if (err) {
      console.error('Error updating department:', err);
      return res.status(500).send('Database update failed.');
    }

    console.log(`Department ${departmentId} updated successfully!`);
    res.redirect('/departments'); // refresh the Departments page
  });
});


/********************************
 * DELETE ROUTES
 ********************************/

app.post('/delete-department', (req, res) => {
  const { departmentId } = req.body;
  const sql = 'CALL DeleteDepartment(?)';
  const params = [parseInt(departmentId, 10)];
  const executor = (db && db.pool && typeof db.pool.query === 'function') ? db.pool : db;
  executor.query(sql, params, (err) => {
    if (err) {
      console.error('Error deleting department:', err);
      return res.status(500).send('Database delete failed.');
    }
    console.log(`Department ${departmentId} deleted successfully!`);
    res.redirect('/departments');
  });
});

app.post('/delete-student', (req, res) => {
  const { studentId } = req.body;

  const sql = 'CALL DeleteStudent(?)';
  const params = [parseInt(studentId, 10)];
  const executor = (db && db.pool && typeof db.pool.query === 'function') ? db.pool : db;
  executor.query(sql, params, (err) => {
    if (err) {
      console.error('Error deleting student:', err);
      return res.status(500).send('Database delete failed.');
    }
    console.log(`Student ${studentId} deleted successfully!`);
    res.redirect('/students');
  });
});

app.post('/delete-location', (req, res) => {
  const { locationId } = req.body;
  const sql = 'CALL DeleteLocation(?)';
  const params = [parseInt(locationId, 10)];
  const executor = (db && db.pool && typeof db.pool.query === 'function') ?
    db.pool : db;
  executor.query(sql, params, (err) => {
    if (err) {
      console.error('Error deleting location:', err);
      return res.status(500).send('Database delete failed.');
    }
    console.log(`Location ${locationId} deleted successfully!`);
    res.redirect('/locations');
  });
});

app.post('/delete-event-student', (req, res) => {
  const { eventId, studentId } = req.body;
  const sql = 'CALL DeleteEventHasStudent(?, ?)';
  const params = [parseInt(eventId, 10), parseInt(studentId, 10)];
  const executor = (db && db.pool && typeof db.pool.query === 'function') ?
    db.pool : db;
  executor.query(sql, params, (err) => {
    if (err) {
      console.error('Error deleting event-student association:', err);
      return res.status(500).send('Database delete failed.');
    }
    console.log(`Event-Student association (Event ID: ${eventId}, Student ID: ${studentId}) deleted successfully!`);
    res.redirect('/event-attendance');;
  });
});

app.post('/delete-department-event', (req, res) => {
  const { departmentId, eventId } = req.body;
  const sql = 'CALL DeleteDepartmentHasEvent(?, ?)';
  const params = [parseInt(departmentId, 10), parseInt(eventId, 10)];
  const executor = (db && db.pool && typeof db.pool.query === 'function') ?
    db.pool : db;
  executor.query(sql, params, (err) => {
    if (err) {
      console.error('Error deleting department-event association:', err);
      return res.status(500).send('Database delete failed.');
    }
    console.log(`Department-Event association (Department ID: ${departmentId}, Event ID: ${eventId}) deleted successfully!`);
    res.redirect('/departments-events');;
  });
}); 

app.post('/delete-event', (req, res) => {
  const { eventId } = req.body;
  const sql = 'CALL DeleteEvent(?)';
  const params = [parseInt(eventId, 10)];
  const executor = (db && db.pool && typeof db.pool.query === 'function') ?
    db.pool : db;
  executor.query(sql, params, (err) => {
    if (err) {
      console.error('Error deleting event:', err);
      return res.status(500).send('Database delete failed.');
    }
    console.log(`Event ${eventId} deleted successfully!`);
    res.redirect('/events');
  });
});


/********
 * M:M Events-Students Relationship
 * 
 */
app.post('/add-event-student', (req, res) => {
  const { eventId, studentId } = req.body;
  const sql = 'CALL InsertEventsHasStudents(?, ?)';
  const params = [parseInt(eventId, 10), parseInt(studentId, 10)];

  const executor = db.pool || db;

  executor.query(sql, params, (err) => {
    if (err) {
      console.error('Error adding new event-student association:', err);
      return res.status(500).send('Database insert failed.');
    }
    console.log(`Event-Student association (Event ID: ${eventId}, Student ID: ${studentId}) added successfully!`);
    res.redirect('/event-attendance');
  });
});


/**
 * RESET DATABASE ROUTE
 */
app.post('/reset-database', (req, res) => {
  const sql = 'CALL sp_reset_rocket_event_mgt();';

  const executor = db.pool || db;

  executor.query(sql, (err) => {
    if (err) {
      console.error("RESET FAILED:", err);
      return res.status(500).send("Reset failed.");
    }

    console.log("DATABASE RESET COMPLETED.");

    const redirectPage = req.body.redirectTo || '/';
    res.redirect(redirectPage);
  });
});



/*
    LISTENER
*/

app.listen(PORT, function () {            // This is the basic syntax for what is called the 'listener' which receives incoming requests on the specified PORT.
  console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.')
});