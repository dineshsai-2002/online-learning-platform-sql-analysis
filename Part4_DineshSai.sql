-- Query1: categorize courses as cheap, Medium, or premium based on price --
SELECT course_id,course_name,price,
CASE
	WHEN price < 1000 THEN 'Cheap'
	WHEN price BETWEEN 1000 AND 3000 THEN 'Medium'
	ELSE 'Premium'
END AS price_category
FROM courses;

-- Query2: Label students as new or old based on signup date ---
SELECT student_id,full_name AS student_name,signup_date,
CASE
WHEN signup_date >= '2024-06-01' THEN 'New'
ELSE 'Old'
END AS student_category
FROM students;

-- Query3: Classify instructors based on experience (years since joining) --
SELECT
    instructor_id,
    instructor_name,
    join_date,
    TIMESTAMPDIFF(YEAR, join_date, CURDATE()) AS experience_years,
    CASE
        WHEN TIMESTAMPDIFF(YEAR, join_date, CURDATE()) < 2 THEN 'Junior'
        WHEN TIMESTAMPDIFF(YEAR, join_date, CURDATE()) BETWEEN 2 AND 5 THEN 'Mid-Level'
        ELSE 'Senior'
    END AS experience_category
FROM instructors;

-- Query4: Find total enrollments year-wise --
SELECT
    YEAR(enrollment_date) AS enrollment_year,
    COUNT(enrollment_id) AS total_enrollments
FROM enrollments
GROUP BY YEAR(enrollment_date)
ORDER BY enrollment_year;

-- Query5: Show month-wise course enrollments --
SELECT
    DATE_FORMAT(enrollment_date, '%Y-%m') AS enrollment_month,
    COUNT(enrollment_id) AS total_enrollments
FROM enrollments
GROUP BY DATE_FORMAT(enrollment_date, '%Y-%m')
ORDER BY enrollment_month;

-- Query6: Identify inactive students (no enrollments) --
SELECT
    s.student_id,
    s.full_name AS student_name
FROM students s
LEFT JOIN enrollments e
    ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

-- Query7: classify course completion status --
SELECT s.student_id,s.full_name AS student_name,c.course_name,cp.completed_percent,
CASE
	WHEN cp.completed_percent = 0 THEN 'Not Started'
	WHEN cp.completed_percent BETWEEN 1 AND 99 THEN 'In Progress'
	WHEN cp.completed_percent = 100 THEN 'Completed'
END AS completion_status
FROM enrollments e
JOIN students s
ON e.student_id = s.student_id
JOIN courses c
ON e.course_id = c.course_id
JOIN course_progress cp
ON e.enrollment_id = cp.enrollment_id;

-- Query8: Find course enrolled in during the last 6 months --
SELECT DISTINCT
    c.course_id,
    c.course_name,
    enrollment_date
FROM enrollments e
JOIN courses c
    ON e.course_id = c.course_id
WHERE e.enrollment_date >= CURDATE() - INTERVAL 6 MONTH;

-- Query9: Show students with total courses enrolled --
SELECT
    s.student_id,
    s.full_name AS student_name,
    COUNT(e.course_id) AS total_courses_enrolled
FROM students s
JOIN enrollments e
    ON s.student_id = e.student_id
GROUP BY
    s.student_id,
    s.full_name
ORDER BY total_courses_enrolled DESC;

-- Query10: Identify high-value students based on total course value --
WITH student_spending AS (
    SELECT
        s.student_id,
        s.full_name AS student_name,
        SUM(c.price) AS total_course_value
    FROM students s
    JOIN enrollments e
        ON s.student_id = e.student_id
    JOIN courses c
        ON e.course_id = c.course_id
    GROUP BY
        s.student_id,
        s.full_name
)
SELECT
    student_id,
    student_name,
    total_course_value
FROM student_spending
WHERE total_course_value > (
    SELECT AVG(total_course_value)
    FROM student_spending
)
ORDER BY total_course_value DESC;

-- Query11: Display courses and their demand level --
SELECT
    c.course_id,
    c.course_name,
    COUNT(e.enrollment_id) AS enrollment_count,
    CASE
        WHEN COUNT(e.enrollment_id) < 10 THEN 'Low Demand'
        WHEN COUNT(e.enrollment_id) BETWEEN 10 AND 30 THEN 'Medium Demand'
        ELSE 'High Demand'
    END AS demand_level
FROM courses c
LEFT JOIN enrollments e
ON c.course_id = e.course_id
GROUP BY c.course_id,c.course_name
ORDER BY enrollment_count DESC;

-- Query12: Find average completion percentage month-wise --
SELECT
    DATE_FORMAT(e.enrollment_date, '%Y-%m') AS enrollment_month,
    ROUND(AVG(cp.completed_percent), 2) AS avg_completion_percentage
FROM enrollments e
JOIN course_progress cp
    ON e.enrollment_id = cp.enrollment_id
GROUP BY
    DATE_FORMAT(e.enrollment_date, '%Y-%m')
ORDER BY enrollment_month;

-- Query13: Identify students who enrolled but did not start learning --
SELECT DISTINCT
    s.student_id,
    s.full_name AS student_name
FROM students s
JOIN enrollments e
    ON s.student_id = e.student_id
JOIN course_progress cp
    ON e.enrollment_id = cp.enrollment_id
WHERE cp.completed_percent = 0;

-- Query15: Find the busiest enrollment date --
SELECT
    enrollment_date,
    COUNT(enrollment_id) AS total_enrollments
FROM enrollments
GROUP BY enrollment_date
ORDER BY total_enrollments DESC
LIMIT 1;

-- Query16: Rank students based on total course value ( basic ranking logic) --
SELECT
    student_id,
    student_name,
    total_course_value,
    RANK() OVER (ORDER BY total_course_value DESC) AS student_rank
FROM (
    SELECT
        s.student_id,
        s.full_name AS student_name,
        SUM(c.price) AS total_course_value
    FROM students s
    JOIN enrollments e
        ON s.student_id = e.student_id
    JOIN courses c
        ON e.course_id = c.course_id
    GROUP BY
        s.student_id,
        s.full_name
) t
ORDER BY student_rank;

-- Query17: Identify courses with poor engagement ( avg compensation < 40%) --
SELECT
    c.course_id,
    c.course_name,
    ROUND(AVG(cp.completed_percent), 2) AS avg_completion
FROM courses c
JOIN enrollments e
    ON c.course_id = e.course_id
JOIN course_progress cp
    ON e.enrollment_id = cp.enrollment_id
GROUP BY
    c.course_id,
    c.course_name
HAVING AVG(cp.completed_percent) < 40;

-- Query18: Label students as Active or Inactive learners --
SELECT
    s.student_id,
    s.full_name AS student_name,
    CASE
        WHEN MAX(cp.completed_percent) > 0 THEN 'Active'
        ELSE 'Inactive'
    END AS learner_status
FROM students s
JOIN enrollments e
    ON s.student_id = e.student_id
LEFT JOIN course_progress cp
    ON e.enrollment_id = cp.enrollment_id
GROUP BY
    s.student_id,
    s.full_name;

-- Query19: Find students who enrolled but dropped out early (<30% completion) --
SELECT
    s.student_id,
    s.full_name AS student_name
FROM students s
JOIN enrollments e
    ON s.student_id = e.student_id
JOIN course_progress cp
    ON e.enrollment_id = cp.enrollment_id
GROUP BY
    s.student_id,
    s.full_name
HAVING MAX(cp.completed_percent) < 30;

-- Query20: Businees insights : Identify top 3 most enrolled courses --
SELECT
    c.course_id,
    c.course_name,
    COUNT(e.enrollment_id) AS total_enrollments
FROM courses c
JOIN enrollments e
    ON c.course_id = e.course_id
GROUP BY
    c.course_id,
    c.course_name
ORDER BY total_enrollments DESC
LIMIT 3;








    






