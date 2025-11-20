----------------------------------------------------------------------
-- Procedure and Function definitions for Rocket Event Management 
-- Exported From PhpMyAdmin 
----------------------------------------------------------------------
DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `DeleteDepartment`(IN `p_departmentId` INT)
BEGIN
	DELETE FROM Departments
    WHERE Departments.departmentId = p_departmentId;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `DeleteDepartmentHasEvent`(IN `p_Departments_departmentId` INT, IN `p_Events_eventId` INT)
BEGIN
	DELETE FROM Departments_has_Events
    WHERE Departments_has_Events.Departments_departmentId = p_Departments_departmentId AND Departments_has_Events.Events_eventId = p_Events_eventId;    
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `DeleteEvent`(IN `p_eventId` INT)
BEGIN
    DELETE FROM Events
    WHERE Events.eventId = p_eventId;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `DeleteEventHasStudent`(IN `p_Events_eventId` INT, IN `p_Students_studentId` INT)
BEGIN
	DELETE FROM Events_has_Students
    WHERE Events_has_Students.Events_eventId = p_Events_eventId AND Events_has_Students.Students_studentId = p_Students_studentId;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `DeleteLocation`(IN `p_locationId` INT)
BEGIN
	DELETE FROM Locations
    WHERE Locations.locationId = p_locationId;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `DeleteStudent`(IN `p_studentId` INT)
BEGIN
	DELETE FROM Students
    WHERE Students.studentId = p_studentId;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `GetDepartmentsEvents`()
BEGIN
	SELECT Departments.departmentId, Departments.departmentName, Events.eventId, Events.eventName
    FROM Events
    JOIN Departments_has_Events ON Departments_has_Events.Events_eventId = Events.eventId
    JOIN Departments ON Departments_has_Events.Departments_departmentId = Departments.departmentId;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `GetEventsAttendance`()
BEGIN
    SELECT 
          e.eventId,
          e.eventName,
          s.studentId,
          CONCAT(s.firstName, ' ', s.lastName) AS studentName
        FROM Events_has_Students es
        JOIN Events e ON e.eventId = es.Events_eventId
        JOIN Students s ON s.studentId = es.Students_studentId;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `InsertDepartment`(IN `p_departmentName` VARCHAR(255))
BEGIN
	INSERT INTO Departments (Departments.departmentName)
    VALUES (p_departmentName);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `InsertDepartmentsHasEvents`(IN `p_Departments_departmentId` INT, IN `p_Events_eventId` INT)
BEGIN
	INSERT INTO Departments_has_Events (Departments_has_Events.Departments_departmentId, Departments_has_Events.Events_eventId)
    VALUES (p_Departments_departmentId, p_Events_eventId);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `InsertEvent`(IN `p_eventName` VARCHAR(255), IN `p_eventDate` DATE, IN `p_startTime` TIME, IN `p_expectedAttendance` INT, IN `p_Locations_locationId` INT)
BEGIN
	INSERT INTO Events (Events.eventName, Events.eventDate, Events.startTime, Events.expectedAttendance, Events.Locations_locationId)
    VALUES (p_eventName, p_eventDate, p_startTime, p_expectedAttendance, p_Locations_locationId); 
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `InsertEventsHasStudents`(IN `p_Events_eventId` INT, IN `p_Students_studentId` INT)
BEGIN
	INSERT INTO Events_has_Students (Events_has_Students.Events_eventId, Events_has_Students.Students_studentId)
    VALUES (p_Events_eventId, p_Students_studentId);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `InsertLocation`(IN `p_locationName` VARCHAR(255), IN `p_address` VARCHAR(255), IN `p_capacity` INT)
BEGIN
	INSERT INTO Locations (Locations.locationName, Locations.address, Locations.capacity)
    VALUES (p_locationName, p_address, p_capacity); 
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `InsertStudent`(IN `p_firstName` VARCHAR(100), IN `p_lastName` VARCHAR(100), IN `p_email` VARCHAR(255), IN `p_Departments_departmentId` INT)
BEGIN
	INSERT INTO Students (Students.firstName, Students.lastName, Students.email, Students.Departments_departmentId)
    VALUES (p_firstName, p_lastName, p_email, p_Departments_departmentId);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `UpdateDepartment`(IN `p_departmentId` INT, IN `p_departmentName` VARCHAR(255))
BEGIN
    UPDATE Departments
    SET Departments.departmentName = p_departmentName
    WHERE Departments.departmentId = p_departmentId;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `UpdateEvent`(IN `p_eventId` INT, IN `p_newEventName` VARCHAR(255), IN `p_newEventDate` DATE, IN `p_newStartTime` TIME, IN `p_newExpectedAttendance` INT, IN `p_newLocations_locationId` INT)
BEGIN
  UPDATE Events
  SET eventName = p_newEventName,
      eventDate = p_newEventDate,
      startTime = p_newStartTime,
      expectedAttendance = p_newExpectedAttendance,
      Locations_locationId = p_newLocations_locationId
  WHERE eventId = p_eventId;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `UpdateLocation`(IN `p_locationId` INT, IN `p_locationName` VARCHAR(255), IN `p_address` VARCHAR(255), IN `p_capacity` INT)
BEGIN
	UPDATE Locations
    SET Locations.locationName = p_locationName,
    	Locations.address = p_address,
        Locations.capacity = p_capacity
    WHERE Locations.locationId = p_locationId;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `UpdateStudent`(IN `p_studentId` INT, IN `p_firstName` VARCHAR(100), IN `p_lastName` VARCHAR(100), IN `p_email` VARCHAR(255), IN `p_Departments_departmentId` INT)
BEGIN
	UPDATE Students
    SET Students.firstName = p_firstName,
    	Students.lastName = p_lastName,
        Students.email = p_email,
        Students.Departments_departmentId = p_Departments_departmentId
    WHERE Students.studentId = p_studentId;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` FUNCTION `func_cert_count`(cert_title VARCHAR(255)) RETURNS int(11)
    READS SQL DATA
BEGIN
    DECLARE cert_count INT;

    
    SELECT COUNT(*) INTO cert_count
    FROM bsg_cert_people cp
    JOIN bsg_cert c ON cp.cid = c.id
    GROUP BY c.title
    HAVING c.title = cert_title;
    
    UPDATE diag_function_cert_use SET used = used + 1;
    RETURN cert_count;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `sp_add_person_certification`(
    IN person_id INT,
    IN cert_id INT
)
BEGIN
    DECLARE cert_exists INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        
        ROLLBACK;
        
        SELECT -99 AS cert_count;
    END;

    
    START TRANSACTION;

    
    SELECT COUNT(*) INTO cert_exists FROM bsg_cert WHERE id = cert_id;
    IF cert_exists = 0 THEN
    
        
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Certification does not exist';

    ELSE
        
        INSERT INTO bsg_cert_people (cid, pid) VALUES (cert_id, person_id);

        
        COMMIT;

        
        SELECT func_cert_count((SELECT title FROM bsg_cert WHERE id = cert_id)) AS cert_count;
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `sp_delete_cert_person_update_total`(
    IN input_cid INT,
    IN input_pid INT
)
BEGIN
    
    DECLARE rows_affected INT;
    
    DELETE FROM bsg_cert_people WHERE cid = input_cid AND pid = input_pid;
    
    
    SET rows_affected = ROW_COUNT();
    
    
    IF rows_affected > 0 THEN
        CALL sp_update_cert_count_totals();
        
        SELECT 'cert deleted and cert count total updated' AS message;
    ELSE
        
        SELECT 'Delete error!' AS message;
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `sp_insert_person`(
    IN fname VARCHAR(255),
    IN lname VARCHAR(255),
    IN age INT,
    IN homeworld INT,
    IN cert_id INT,
    OUT person_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        
        SET person_id = -99;
        ROLLBACK;
    END;

    START TRANSACTION;
    
    
    INSERT INTO bsg_people (fname, lname, age, homeworld)
    VALUES (fname, lname, age, homeworld);
    
    SET person_id = LAST_INSERT_ID();
    
    
    INSERT INTO bsg_cert_people (pid, cid)
    VALUES (person_id, cert_id);
    
    COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `sp_modify_cert_table`()
BEGIN
    
    ALTER TABLE bsg_cert ADD COLUMN cert_total INT DEFAULT 0;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `sp_query1`(IN timeNow VARCHAR(4), OUT greeting VARCHAR(50))
BEGIN
    DECLARE current_hour INT;
    DECLARE formatted_time TIME;
    
    
    IF LENGTH(timeNow) != 4 OR timeNow NOT REGEXP '^[0-2][0-9][0-5][0-9]$' THEN
        SET greeting = 'Invalid time format. Please use HHMM.';
    ELSE

        
            SET formatted_time = STR_TO_DATE(timeNow, '%H%i');
            SET current_hour = HOUR(formatted_time);
        
            IF current_hour < 0 OR current_hour > 24 THEN
                SET greeting = 'Invalid time format. Please use HHMM.';
            ELSEIF current_hour BETWEEN 6 AND 11 THEN
                SET greeting = 'Good morning';
            ELSEIF current_hour BETWEEN 12 AND 16 THEN
                SET greeting = 'Good afternoon';
            ELSEIF current_hour BETWEEN 17 AND 23 THEN
                SET greeting = 'Good night';
            ELSE 
                SET greeting = 'My it''s late, shouldn''t you be in bed?';
            END IF;

        
            


    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `sp_reset_rocket_event_mgt`()
BEGIN 
	SET FOREIGN_KEY_CHECKS = 0;
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


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `sp_update_cert_count_totals`()
BEGIN
    
    UPDATE bsg_cert c
    SET c.cert_total = (
        SELECT COUNT(*) FROM bsg_cert_people cp WHERE cp.cid = c.id
    );

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cs340_pradhanj`@`%` PROCEDURE `sp_update_person_homeworld`(
    IN person_id INT,
    IN myworld VARCHAR(255)
)
BEGIN
    DECLARE world_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Update error!' AS result;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    
    IF myworld IS NULL THEN
        UPDATE bsg_people SET homeworld = NULL WHERE id = person_id;
    ELSE
        
        IF myworld REGEXP '^[0-9]+$' THEN
            SET world_id = CAST(myworld AS UNSIGNED);
            
            
            
            IF EXISTS (SELECT 1 FROM bsg_planets WHERE id = world_id) THEN
                UPDATE bsg_people SET homeworld = world_id WHERE id = person_id;
            ELSE
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Planet ID does not exist';
            END IF;
        ELSE
            
            
            

            UPDATE bsg_people p
            JOIN bsg_planets pl on p.homeworld = pl.id
            SET p.homeworld = (
                SELECT id FROM bsg_planets WHERE name = myworld LIMIT 1
            )
            WHERE p.id = person_id;

        END IF;
    END IF;
    
    
    SELECT 
        p.fname,
        p.lname,
        CASE WHEN p.age IS NULL THEN 'NULL' ELSE CAST(p.age AS CHAR) END as age,
        CASE WHEN pl.name IS NULL THEN 'NULL' ELSE pl.name END as homeworld
    FROM bsg_people p
    LEFT JOIN bsg_planets pl ON p.homeworld = pl.id
    WHERE p.id = person_id;
    
    COMMIT;
END$$
DELIMITER ;
