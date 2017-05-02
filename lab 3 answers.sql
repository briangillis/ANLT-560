/*	LAB 3

Tougher Questions

These require some additional reading.



*/

# 1.	Find the maximum and minimum enrollment across all sections, considering only sections that had some enrollment, 
#		don't worry about those that had no students taking that section
use university;
select 
  max(enrollment) as max_enrollment,
  min(enrollment) as min_enrollment
from (select 
	  course_id,
	  sec_id,
      semester,
	  count(distinct ID) as enrollment
	from takes
	group by
	  course_id,
	  sec_id,
      semester) as x


# 2.	Find all sections that had the maximum enrollment (along with the enrollment), using a subquery.

select 
  a.course_id,
  a.sec_id,
  a.semester,
  count(distinct ID) as enrollment,
  y.max_enrollment
from takes as a
cross join (
	select 
	  max(enrollment) as max_enrollment,
	  min(enrollment) as min_enrollment
	from (select 
		  course_id,
		  sec_id,
          semester,
		  count(distinct ID) as enrollment
		from takes
		group by
		  course_id,
		  sec_id,
          semester) as x) as y 
group by 
  a.course_id,
  a.sec_id,
  a.semester
Having
  count(distinct a.ID) = y.max_enrollment
  
# 3.	Find all courses whose identifier starts with the string "CS-1"

select course_id, title
from course
where
  course_id like 'CS-1%'
  
# 4.	Insert each instructor as a student, with tot_creds = 0, in the same department

insert into student values ('10101','Srinivasan','Comp. Sci.',0);
insert into student values ('12121','Wu','Finance',0);
insert into student values ('15151','Mozart','Music',0);
insert into student values ('22222','Einstein','Physics',0);
insert into student values ('23232','Brian','Physics',0);
insert into student values ('32343','El Said','History',0);
insert into student values ('33456','Gold','Physics',0);
insert into student values ('45565','Katz','Comp. Sci.',0);
insert into student values ('58583','Califieri','History',0);
insert into student values ('76543','Singh','Finance',0);
insert into student values ('76766','Crick','Biology',0);
insert into student values ('83821','Brandt','Comp. Sci.',0);
insert into student values ('98345','Kim','Elec. Eng.',0);

select *
from student

# 5.	Now delete all the newly added "students" above (note: already existing students who happened to have tot_creds = 0 should not get deleted)

delete student from student left outer join instructor on student.ID = instructor.ID 
	where instructor.ID is not null
    
# 6.	Some of you may have noticed that the tot_creds value for students did not match the credits from courses they have taken. 
#       Write and execute query to update tot_creds based on the credits passed, to bring the database back to consistency. 
#       (This query is provided in the book/slides.)


update student
Left Join (select 
	  ID,
	  sum(b.credits) as total_credits_calc
	from takes as a
	left outer join course as b on
	  b.course_id = a.course_id
	group by
	  ID) as x on 
      student.ID = x.ID
set tot_cred = total_credits_calc
where
  x.ID = student.id
  
# view the results:  select * from student

# 7.	Update the salary of each instructor to 10000 times the number of course sections they have taught.

update instructor
left join (
	select 
	  ID,
	  count(distinct course_id, sec_id) * 1000 as salary_calc
	from teaches
	group by
	  ID) as x on x.ID = instructor.id
set salary = coalesce(salary_calc,0);

# view results: select * from instructor


##-------------------------------------------------------------------
#                             Tougher Questions
##-------------------------------------------------------------------

#  1.	As in Q1, but now also include sections with no students taking them;
#       the enrollment for such sections should be treated as 0. 
#       Do this using a scalar subquery.

use university;
select 
  max(enrollment) as max_enrollment,
  min(enrollment) as min_enrollment
from (select 
	  a.course_id,
	  a.sec_id,
	  coalesce(count(distinct ID),0) as enrollment
	from section as a
    left outer join takes as b on
      b.course_id = a.course_id and
      b.sec_id = a.sec_id
	group by
	  a.course_id,
	  a.sec_id) as x
      
# 2.	Find instructors who have taught all the above courses using the "not exists ... except ..." structure

select *
from instructor




  