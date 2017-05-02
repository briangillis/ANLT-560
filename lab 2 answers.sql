/*
				Lab 2

*/

#  1.	Find the names of all the instructors from Biology department
select name
from instructor
where
  dept_name = 'Biology';
  
# 2.	Find the names of courses in Computer science department which have 3 credits
select title
from course
where
  dept_name = 'Biology' and
  credits = 3;
  
# 3.	For the student with ID 12345 (or any other value), show all course_id and title of all courses registered for by the student.
select 
  a.course_id,
  b.title
from takes as a
left outer join course as b on
  b.course_id = a.course_id
where
  a.ID = 12345;
  
# 4.	As above, but show the total number of credits for such courses (taken by that student). Don't display the tot_creds value from the student table, you should use SQL aggregation on courses taken by the student.
select 
  sum(credits) as credits
from takes as a
left outer join course as b on
  b.course_id = a.course_id
where
  a.ID = 12345;
  
# 5.	As above, but display the total credits for each of the students, along with the ID of the student; 
#       don't bother about the name of the student. 
#       (Don't bother about students who have not registered for any course, they can be omitted)

select 
  a.ID,
  sum(credits) as credits
from takes as a
left outer join course as b on
  b.course_id = a.course_id
Group by
  a.ID;
  
# 6.	Find the names of all students who have taken any Comp. Sci. course ever (there should be no duplicate names)
select distinct
  c.name
from takes as a
inner join course as b on
  b.course_id = a.course_id and
  b.dept_name = 'Comp. Sci.'
left outer join student as c on
  c.ID = a.ID

# 7.	Display the IDs of all instructors who have never taught a course; interpret "taught" as "taught or is scheduled to teach")
select a.ID
from instructor as a 
left outer join teaches as b on
  b.ID = a.id
where
  b.id is null
  
# 8.	As above, but display the names of the instructors also, not just the IDs.
select a.ID, a.name
from instructor as a 
left outer join teaches as b on
  b.ID = a.id
where
  b.id is null
  
# 9.	You need to create a movie database. Create three tables, 
#			one for actors(AID, name), 
#			one for movies(MID, title) and 
#			one for actor_role(MID, AID, rolename). 
#       Use appropriate data types for each of the attributes, and add appropriate primary/foreign key constraints.

create database movie;
use movie;

Drop table if exists actors;
Create table actors (
	AID varchar(5),
    name varchar(30),
    primary key (AID));
   
Drop table if exists movies;   
Create table movies (
	MID varchar(5),
    title varchar(30),
    primary key (MID));

Drop table if exists actor_role;
Create table actor_role (
	MID varchar(5),
    AID varchar(5),
    rolename varchar(30),
    primary key (rolename),
    foreign key (MID) 
		references movies (MID)
        on delete cascade,
	foreign key (AID)
		references actors(AID)
        on delete cascade);
        

# 10.	Insert data to the above tables (approx 3 to 6 rows in each table), including data for actor "Charlie Chaplin", and for yourself (using your roll number as ID).
    
insert into actors values ('12345', 'Steve');
insert into actors values ('12346', 'Jane');
insert into actors values ('12347', 'Charlie Chaplin');
insert into actors values ('12348', 'Brian Gillis');
insert into movies values ('xxxxx', 'The Blob');
insert into movies values ('yyyyy', 'Some Zombies');
insert into movies values ('zzzzz', 'More Zombies');
insert into actor_role values ('xxxxx', '12345', 'Blob');
insert into actor_role values ('yyyyy', '12346', 'A Zombie');
insert into actor_role values ('zzzzz', '12346', 'Another Zombie');
insert into actor_role values ('zzzzz', '12347', 'Yet Another Zombies');
insert into actor_role values ('zzzzz', '12347', 'More Zombie');

select *
from actor_role

# 11.	Write a query to list all movies in which actor "Charlie Chaplin" has acted, along with the number of roles he had in that movie.
select 
  c.title,
  count(distinct b.rolename) as roles
from actors as a
left outer join actor_role as b on
  b.AID = a.AID
left outer join movies as c on
  c.MID = b.MID
Where
  a.name = 'Charlie Chaplin'
group by
  c.title;
  
# 12.	Write a query to list all actors who have not acted in any movie
select *
from actors as a
Where
  AID not in (select distinct AID from actor_role);

# 13.	List names of actors, along with titles of movies they have acted in. If they have not acted in any movie, show the movie title as null.
select distinct
  a.name,
  c.title
from actors as a
left outer join actor_role as b on
  b.AID = a.AID
left outer join movies as c on
  c.MID = b.MID



