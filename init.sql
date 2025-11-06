SET FOREIGN_KEY_CHECKS = 0;

SET AUTOCOMMIT = 0;

/* 
Drop all tables if they exist to reset the database 
*/
DROP TABLE IF EXISTS Events_has_Students;
DROP TABLE IF EXISTS Departments_has_Events;
DROP TABLE IF EXISTS Events;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Locations;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE Locations (
    locationId INT AUTO_INCREMENT PRIMARY KEY,
    locationName VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    capacity INT NOT NULL
);

CREATE TABLE Departments (
    departmentId INT AUTO_INCREMENT PRIMARY KEY,
    departmentName VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Students (
    studentId INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    Departments_departmentId INT NOT NULL,
    CONSTRAINT fk_students_department FOREIGN KEY (Departments_departmentId) REFERENCES Departments(departmentId)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Events (
    eventId INT AUTO_INCREMENT PRIMARY KEY,
    eventName VARCHAR(255) NOT NULL,
    eventDate DATE NOT NULL,
    startTime TIME NOT NULL,
    expectedAttendance INT,
    Locations_locationId INT NOT NULL,
    CONSTRAINT fk_events_location FOREIGN KEY (Locations_locationId) REFERENCES Locations(locationId)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Events_has_Students (
    Events_eventId INT,
    Students_studentId INT,
    PRIMARY KEY (Events_eventId, Students_studentId),
    CONSTRAINT fk_ehs_event FOREIGN KEY (Events_eventId) REFERENCES Events(eventId)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ehs_student FOREIGN KEY (Students_studentId) REFERENCES Students(studentId)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Departments_has_Events (
    Departments_departmentId INT,
    Events_eventId INT,
    PRIMARY KEY (Departments_departmentId, Events_eventId),
    CONSTRAINT fk_dhe_department FOREIGN KEY (Departments_departmentId) REFERENCES Departments(departmentId)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_dhe_event FOREIGN KEY (Events_eventId) REFERENCES Events(eventId)
        ON DELETE CASCADE ON UPDATE CASCADE
);


INSERT INTO Locations (locationName, address, capacity) 
VALUES
    ('CH2M HILL Alumni Center', '725 SW 26th St, Corvallis, OR 97331', 500),
    ('The LaSells Stewart Center', '875 SW 26th St, Corvallis, OR 97331', 200),
    ('Memorial Union', '2501 SW Jefferson Way, Corvallis, OR 97331', 300);

INSERT INTO Departments (departmentName)
VALUES
    ('Computer Science'),
    ('Business Administration'),
    ('Geography');

INSERT INTO Students (firstName, lastName, email, Departments_departmentId)
VALUES
    ('Jiya', 'Pradhan', 'jiya.pradhan@example.com', 1),
    ('Faith', 'Nambasa', 'faith.nambasa@example.com', 1),
    ('Business', 'Student', 'business.student@example.com', 2),
    ('Charlie', 'Brown', 'charlie.brown@example.com', 3);

INSERT INTO Events (eventName, eventDate, startTime, expectedAttendance, Locations_locationId)
VALUES
    ('Tech Talk', '2024-10-15', '10:00:00', 150, 1),
    ('CS & Business Administration Internship Opportunity', '2024-11-20', '14:00:00', 100, 2),
    ('Business Seminar', '2024-12-05', '09:00:00', 200, 3),
    ('Geography Field Trip', '2024-10-25', '08:00:00', 80, 2); 

INSERT INTO Departments_has_Events (Departments_departmentId, Events_eventId)
VALUES
    (1, 1),
    (1, 2), 
    (2, 2),
    (3, 4),
    (2, 3);

INSERT INTO Events_has_Students (Events_eventId, Students_studentId)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 1),
    (1, 2);

COMMIT;

SET AUTOCOMMIT = 1;