-- Query1: Display all students who signed up after '2024-01-01' --
select * from students where signup_date > '2024-01-01' order by signup_date;

-- Query2: List all courses priced above 2000 --
select * from courses where price > 2000 order by price;

-- Query3: Show total no of students city-wise --
select city,count(*) as Total_students from students group by city;

-- Query4: Find the total number of enrollments per course
select c.Course_id, course_name,count(enrollment_id) as total_enrollments
from enrollments e
left join courses c
on c.course_id=e.course_id
group by c.course_id,course_name
order by total_enrollments desc;

-- Query5: Display student names along with courses they enrolled in --
select s.student_id,full_name,course_name from students s
join enrollments e
on s.student_id=e.student_id
join courses c
on c.course_id=e.course_id;

-- Query6: Find the total revenue generated from courses --
select sum(price) as Total_revenue from courses;

-- Query7: show total amount spent by each student --
select s.student_id,full_name,sum(price) as Total_amount_spent from students s
join enrollments e
on s.student_id=e.student_id
join courses c
on c.course_id=e.course_id
group by s.student_id,full_name;

-- Query8: List students who enrolled in paid courses(price>0) --
 select distinct s.student_id,full_name from students s
join enrollments e
on s.student_id=e.student_id
join courses c
on c.course_id=e.course_id
where price>0;

-- Query9: Find the average course price category-wise --
select category,round(avg(price),2) as Avg_course_price from 
courses group by category;

-- Query10: Show students who enrolled in more than one course --
select s.student_id,full_name,count(e.course_id) as course_count from students s
join enrollments e
on s.student_id=e.student_id
join courses c
on c.course_id=e.course_id
group by s.student_id,full_name
having count(e.course_id)>1
order by count(e.course_id);

-- Query11: Display courses with zero enrollments --
SELECT c.course_id,c.course_name
FROM courses c
LEFT JOIN enrollments e
ON c.course_id = e.course_id
WHERE e.course_id is null;

-- Query12: Find the students who never enrolled in any course--
SELECT s.student_id,full_name
FROM students s
LEFT JOIN enrollments e
ON s.student_id = e.student_id
WHERE e.student_id is null;

-- Query13: show highest priced course --
SELECT course_id,course_name,price
FROM courses
ORDER BY price DESC
LIMIT 1;

-- Query14: Count Total enrollments month-wise --
select date_format(enrollment_date,'%Y-%m') as month,
count(*) as total_enrollments
from enrollments group by month
order by month asc;

-- Query15: Display students with course completion above 80%--
select distinct s.student_id,full_name,completed_percent from students s
join enrollments e
on s.student_id=e.student_id
join course_progress cp
on cp.enrollment_id=e.enrollment_id
where completed_percent>80;

-- Query16: Find the total no of courses per category --
select category,count(course_id) as Total_courses
from courses group by category;

-- Query17: show students who enrolled but have 0% progress --
SELECT s.student_id,s.full_name AS student_name,c.course_name,cp.completed_percent
FROM enrollments e
JOIN students s
ON e.student_id = s.student_id
JOIN courses c
ON e.course_id = c.course_id
JOIN course_progress cp
ON e.enrollment_id = cp.enrollment_id
WHERE cp.completed_percent = 0;

-- Query18: List top 3 students who spent the highest total amount --
select s.student_id,full_name,sum(price) as Total_amount_spent from students s
join enrollments e
on s.student_id=e.student_id
join courses c
on c.course_id=e.course_id
group by s.student_id,full_name 
order by Total_amount_spent desc limit 3;

-- Query19: Display course-wise average completion percentage --
SELECT c.course_id,c.course_name,ROUND(AVG(cp.completed_percent), 2) AS avg_completion_percentage
FROM courses c
JOIN enrollments e
ON c.course_id = e.course_id
JOIN course_progress cp
ON e.enrollment_id = cp.enrollment_id
GROUP BY c.course_id,c.course_name
ORDER BY avg_completion_percentage DESC;

-- Query20: Show students who enrolled in courses costing more than 2000 --
SELECT DISTINCT s.student_id,s.full_name AS student_name,c.course_name,c.price
FROM students s
JOIN enrollments e
ON s.student_id = e.student_id
JOIN courses c
ON e.course_id = c.course_id
WHERE c.price > 2000
ORDER BY s.full_name;



