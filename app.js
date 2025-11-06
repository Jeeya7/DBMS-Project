/*
    SETUP
*/

// Express Server
const express = require('express');  // We are using the express library for the web server
const app = express();               // We need to instantiate an express object to interact with the server in our code
const PORT = process.env.port || 2222;                   // Set a port number
const path = require('path');
// Database connection
const db = require('./db-connector');

// Configure handlebars
app.set('view engine', 'hbs');
app.set('views', path.join(__dirname, 'views'));

app.use(express.static(path.join(__dirname, 'public')));
app.use(express.urlencoded({ extended: true }));


// Link page to URLs
app.get('/', (req, res) => {
    res.render('index', {
        title: 'Rocket Event Management',
        pages: [
            { url: '/students', name: 'Browse Students' },
            { url: '/departments', name: 'Browse Departments' },
            { url: '/events', name: 'Browse Events' },
            { url: '/locations', name: 'Browse Locations' },
            { url: '/departments-with-students', name: 'Departments with Students' },
            { url: '/events-with-students', name: 'Events with Students' }
        ]
    });
});


/*
    LISTENER
*/

app.listen(PORT, function(){            // This is the basic syntax for what is called the 'listener' which receives incoming requests on the specified PORT.
    console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.')
});