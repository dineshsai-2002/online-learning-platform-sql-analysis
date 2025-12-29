-- Query1: List all students from the students table --
SELECT * FROM students;

-- Query2: Display only student_id, Full_name, and city of all students --

SELECT student_id, full_name, city from students;

-- Query3: Fetch the first 15 students based on student_id (ascending order) --
SELECT * from students order by student_id limit 15;

-- Query4: Show all courses whose price is greater than 1000 --
select * from courses where price > 1000 order by price;

-- Query5: Display all courses belonging to the category "AI"
select * from courses where category ='AI';

-- Query6: List all distinct cities from where students come --
select distinct city from students;

-- Query7: Show top 10 most expensive courses (highest price first)
select * from courses order by price desc limit 10;

-- Query8: Show students whose name starts with the letter "A" --
Select * from students where full_name like "a%";

-- Query9: Fetch courses whose category contains the word "data" --
select * from courses where category like "%data%";

-- Query10: Find the Total number of students present in the platform --
select count(student_id) from students;

-- Query11: Count the total number of courses in each category --
select category,count(*) as Total_Courses from courses group by category;

-- Query12: Display the instructor who joined in the year 2024 --
select * from instructors where year(join_date) = 2024;

-- Query13: Show all enrollments made on the date '2024-08-01' --
select * from enrollments where enrollment_date='2024-08-01';

-- Query14: Show students who are not from mumbai --
select * from students where city!="mumbai"; 

-- Query15: Display the 5 cheapest courses (price in ascending order) --
select * from courses order by price limit 5;

-- Query16: Display the course names along with the length of each course name --
select course_name,length(course_name) as course_length from courses;

-- Query17: Show students who signed up after '2023-01-01' --
select * from students where signup_date > '2023-01-01' order by signup_date;

-- Query18: Show all courses with price =999 --
Select * from courses where price = 999;

-- Query19: List the latest 20 enrollments (Based on enroll_date) --
select * from enrollments order by enrollment_date desc limit 20;

-- Query20: Show students emails sorted alphabetically --
select email from students order by email;