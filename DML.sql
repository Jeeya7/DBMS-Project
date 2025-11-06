----------------------------------
-- Departments Table Operations --
----------------------------------

-- Get all departments
SELECT * FROM Departments;

-- Insert a new department
INSERT INTO Departments (departmentName)
VALUES
    (@departmentName);

-- Update a department's name
UPDATE Departments
SET departmentName = @newDepartmentName
WHERE departmentId = @departmentId;

-- Delete a department
DELETE FROM Departments
WHERE departmentId = @departmentId;

--------------------------------
-- Students Table Operations --
--------------------------------

-- Get all students
SELECT * FROM Students;

-- Insert a new student
INSERT INTO Students (firstName, lastName, email, Departments_departmentId)
VALUES
    (@firstName, @lastName, @email, @departmentId);

-- Update a student's information
UPDATE Students
SET firstName = @newFirstName,
    lastName = @newLastName,
    email = @newEmail,
    Departments_departmentId = @newDepartmentId
WHERE studentId = @studentId;

-- Delete a student
DELETE FROM Students
WHERE studentId = @studentId;

--------------------------------
-- Locations Table Operations --
--------------------------------

-- Get all locations
SELECT * FROM Locations;

-- Insert a new location
INSERT INTO Locations (locationName, address, capacity)
VALUES
    (@locationName, @address, @capacity);

-- Update a location's information
UPDATE Locations
SET locationName = @newLocationName,
    address = @newAddress,
    capacity = @newCapacity
WHERE locationId = @locationId;

-- Delete a location
DELETE FROM Locations
WHERE locationId = @locationId;

------------------------------
-- Events Table Operations --
------------------------------
-- Get all events
SELECT * FROM Events;
-- Insert a new event
INSERT INTO Events (eventName, eventDate, startTime, expectedAttendance, Locations_locationId)
VALUES
    (@eventName, @eventDate, @startTime, @expectedAttendance, @locationId);

-- Update an event's information
UPDATE Events
SET eventName = @newEventName,
    eventDate = @newEventDate,
    startTime = @newStartTime,  
    expectedAttendance = @newExpectedAttendance,
    Locations_locationId = @newLocationId
WHERE eventId = @eventId;

-- Delete an event
DELETE FROM Events
WHERE eventId = @eventId;

---------------------------------------------
-- Departments_has_Events (many-to-many) --
---------------------------------------------

-- Get all department-event associations
SELECT * FROM Departments_has_Events;

-- Insert a new department-event association
INSERT INTO Departments_has_Events (Departments_departmentId, Events_eventId)
VALUES
    (@departmentId, @eventId);

-- Delete a department-event association
DELETE FROM Departments_has_Events
WHERE Departments_departmentId = @departmentId AND Events_eventId = @eventId;

------------------------------------------
-- Events_has_Students (many-to-many) --
------------------------------------------

-- Get all event-student associations
SELECT * FROM Events_has_Students;

-- Insert a new event-student association
INSERT INTO Events_has_Students (Events_eventId, Students_studentId)
VALUES
    (@eventId, @studentId);

-- Delete an event-student association
DELETE FROM Events_has_Students
WHERE Events_eventId = @eventId AND Students_studentId = @studentId;

