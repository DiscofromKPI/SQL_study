USE TASK
--1 task-->
WITH number AS (
    SELECT WorkerPositionID, COUNT (*) AS CountOfWorkers FROM workerProject
    GROUP BY WorkerPositionID
)
SELECT ID, Name, CountOfWorkers FROM workerPos JOIN number ON Id = WorkerPositionID;

--2task

WITH EXCEPTION AS(
    select ID from workerPos
    except 
    select distinct WorkerPositionID from workerProject
)
select p1.ID, p1.Name from workerPos p1 join EXCEPTION ex on p1.ID = ex.ID;

--3task
Select ProjectID, WorkerPositionID, COUNT(*) as Num
    from workerProject
    group by ProjectID, WorkerPositionID;

--4task
WITH NUM as (
    select projectID, count(projectID) as Counts
    from task
    group by projectID
    ),
    Num2 as (
    select projectID, count(distinct workerID) as Counts
    from task
    group by projectID)
select n1.projectID, CAST(n1.Counts as FLOAT)/n2.Counts as Counts from NUM n1 inner join Num2 n2 on n1.projectID = n2.projectID;

--5task
select ProjectId, Name, datediff(day, createDate, closedDate) as 'Duration of working' from project;

--6task
with MinNOTClosed as (
    select workerID, count(Status) as Counts from task
    where Status in(select status from task where status != 'closed')
    group by workerID),
     MinNum as ( select min(Counts) as MinValue from MinNOTClosed )
select ot.workerID, ot.Counts from MinNOTClosed ot inner join MinNum mn on ot.Counts = mn.MinValue;

--7task
with NOTClosed as (
    select workerID, count(Status) as Count from task
    where Status in(select status from task where status != 'closed') AND Deadline < GETDATE()
    group by workerID),
     MaxNum as ( select max(Count) as MaxValue from NOTClosed )
select nc.workerID, nc.Count from NOTClosed nc
                                       inner join MaxNum mn on nc.Count = mn.MaxValue;

--8task
UPDATE task
SET Deadline = dateadd(day, 5, Deadline)
WHERE Status IN (select status from task where status != 'closed');

--9task
select projectID, count(*) as Counts from task
where workerID is null OR status = 'opened'
group by projectID;

--10task
with AllTasksCount as (
    select projectID, count(*) as Allt from task
    group by projectID),
     ClosedTasksCount as (
         select projectID, count(Status) as ClosedCounts from task
         where status = 'closed'
         group by projectID),
     LastTasks as (
         select top 1 max(t.Deadline) as LastTaskClosed, c.projectID from task t
                                                                            inner join ClosedTasksCount c on c.projectID = t.projectID
                                                                            inner join AllTasksCount a on a.projectID = c.projectID
         where a.Allt - c.ClosedCounts = 0
         group by c.projectID
         order by max(t.Deadline))
update project
SET status = 'closed', closedDate = lt.LastTaskClosed
FROM project pr inner join LastTasks lt on pr.ProjectId = lt.projectID;

--11task
with NOTClosed as (
    select workerID, projectID, count(*) as Counts from task
    where Status = ALL(select status from task where status = 'closed')
    group by projectID, workerID)
select projectID, workerID, Name as 'worker name' from NOTClosed
                                                               inner join worker on workerID = ID
order by projectID, workerID;

--12task
DECLARE @freeEmp INT = (
    SELECT TOP 1 workerID FROM task
    WHERE ProjectId =
          (SELECT ProjectId FROM project WHERE Name = 'firstproject')
    GROUP BY workerID
    ORDER BY COUNT (*) ASC
)
