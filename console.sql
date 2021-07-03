CREATE DATABASE TASK
GO
USE TASK
CREATE TABLE project(
    ProjectID INT PRIMARY KEY NOT NULL IDENTITY,
    Name varchar(255),
    createDate date,
    closedDate date,
    status varchar(255)
    CONSTRAINT ch_status CHECK (status IN ('opened', 'closed'))
)
CREATE TABLE worker(
    ID INT PRIMARY KEY NOT NULL IDENTITY,
    Name varchar(255)
)
CREATE TABLE task(
    ID int PRIMARY KEY NOT NULL IDENTITY,
    status varchar(255)
    CONSTRAINT ch_statust CHECK (status IN ('opened', 'closed', 'done', 'need fixes')),
    statusDate date,
    deadline date,
    workerID int FOREIGN KEY REFERENCES worker(ID),
    projectID int FOREIGN KEY REFERENCES project(ProjectID)
)
CREATE TABLE workerPos(
    ID INT PRIMARY KEY NOT NULL IDENTITY,
    Name varchar(255)
)
CREATE TABLE workerProject(
    ProjectID INT FOREIGN KEY REFERENCES project(ProjectID),
    WorkerID INT FOREIGN KEY REFERENCES worker(ID),
    WorkerPositionID INT FOREIGN KEY REFERENCES workerPos(ID),
    PRIMARY KEY (ProjectID, WorkerID, WorkerPositionID)
)
INSERT project VALUES ('firstproject', '01.01.2000', '02.02.2000', 'opened')
INSERT project VALUES ('second', '01.01.2015', '02.02.2016', 'opened')
INSERT project VALUES ('third', '01.01.1999', '02.02.2000', 'closed')
INSERT project VALUES ('fourth', '01.01.1998', '02.02.1999', 'closed')

INSERT worker VALUES ('Bob')
INSERT worker VALUES ('John')
INSERT worker VALUES ('Vasya')
INSERT worker VALUES ('Nick')
INSERT worker Values ('Bohdan')
INSERT task VALUES ('opened', '01.01.2000', '01.01.2022',  1, 1)
INSERT task VALUES ('need fixes', '01.01.1998', '02.02.2021',1, 3)
INSERT task VALUES ('done', '01.01.2004','02.04.2011' ,3, 1)
INSERT task VALUES ('closed', '01.01.2005','02.02.2021',2, 3)

INSERT task VALUES ('opened', '02.12.2020','01.01.2021',5, 4)
INSERT task VALUES ('done', '11.11.2020','05.05.2021',4, 4)
INSERT task VALUES ('closed', '11.10.2020','10.01.2022',2, 2)
INSERT workerPos VALUES ('Manager')
INSERT workerPos VALUES ('Junior')
INSERT workerPos VALUES ('Boss')
INSERT workerPos VALUES ('Tester')
INSERT workerPos VALUES ('TeamLead')
INSERT workerPos VALUES ('Cleaner')
INSERT workerPos VALUES ('Cook')
INSERT workerProject VALUES (1, 1, 1)
INSERT workerProject VALUES (1, 2, 2)
INSERT workerProject VALUES (2, 3, 3)

INSERT workerProject VALUES (2, 2, 2)
INSERT workerProject VALUES (3, 4, 5)
INSERT workerProject VALUES (2, 4, 5)
