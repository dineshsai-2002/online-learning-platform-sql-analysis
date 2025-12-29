-- Query1: Find students who enrolled in exactly one course --
SELECT s.student_id,s.full_name AS student_name,COUNT(e.course_id) AS total_courses
FROM students s
JOIN enrollments e
ON s.student_id = e.student_id
GROUP BY s.student_id,s.full_name
HAVING COUNT(e.course_id) = 1;

-- Query2: List courses price below the averahe course price --
select * from courses where price <
(select avg(price) as avg_price from courses);

-- Query3: Find students whose first enrollment was after '2024-06-01' --
SELECT s.student_id,s.full_name AS student_name,MIN(e.enrollment_date) AS first_enrollment_date
FROM students s
JOIN enrollments e
ON s.student_id = e.student_id
GROUP BY s.student_id,s.full_name
HAVING MIN(e.enrollment_date) > '2024-06-01';

-- Query4: Show students who completed at least one course fully--
SELECT DISTINCT s.student_id,s.full_name AS student_name
FROM students s
JOIN enrollments e
ON s.student_id = e.student_id
JOIN course_progress cp
ON e.enrollment_id = cp.enrollment_id
WHERE cp.completed_percent = 100;

-- Query5: Find the cheapest course in each category --
SELECT c.category,c.course_name,c.price
FROM courses c
WHERE c.price = (
    SELECT MIN(c2.price)
    FROM courses c2
    WHERE c2.category = c.category
);

-- Query6: Display students whose highest course price is above 3000 --
SELECT s.student_id, s.full_name AS student_name, MAX(c.price) AS highest_course_price
FROM students s
JOIN enrollments e
ON s.student_id = e.student_id
JOIN courses c
ON e.course_id = c.course_id
GROUP BY s.student_id,s.full_name
HAVING MAX(c.price) > 3000;

-- Query7: Show courses whose enrollment count is below average --
WITH course_enrollments AS (
    SELECT
        c.course_id,
        c.course_name,
        COUNT(e.enrollment_id) AS enrollment_count
    FROM courses c
    LEFT JOIN enrollments e
        ON c.course_id = e.course_id
    GROUP BY c.course_id, c.course_name
)
SELECT *
FROM course_enrollments
WHERE enrollment_count < (
    SELECT AVG(enrollment_count)
    FROM course_enrollments
)
order by enrollment_count desc;

-- Query8: Find students enrolled in at least 2 different categrories --
SELECT
    s.student_id,
    s.full_name AS student_name,
    COUNT(DISTINCT c.category) AS category_count
FROM students s
JOIN enrollments e
    ON s.student_id = e.student_id
JOIN courses c
    ON e.course_id = c.course_id
GROUP BY
    s.student_id,
    s.full_name
HAVING COUNT(DISTINCT c.category) >= 2
order by category_count;

-- Query9: List courses where no student has completed more than 50% --
SELECT c.course_id,c.course_name
FROM courses c
JOIN enrollments e
ON c.course_id = e.course_id
JOIN course_progress cp
ON e.enrollment_id = cp.enrollment_id
GROUP BY c.course_id,c.course_name
HAVING MAX(cp.completed_percent) <= 50;

-- Query10: Find students whose total spending is below average --
WITH student_spending AS (
    SELECT
        s.student_id,
        s.full_name,
        SUM(c.price) AS total_spent
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN courses c ON e.course_id = c.course_id
    GROUP BY s.student_id, s.full_name
)
SELECT *
FROM student_spending
WHERE total_spent < (
    SELECT AVG(total_spent)
    FROM student_spending
);

-- Query11: Show students who enrolled but never completed any course --
SELECT s.student_id,s.full_name AS student_name,max(completed_percent)
FROM students s
JOIN enrollments e
ON s.student_id = e.student_id
JOIN course_progress cp
ON e.enrollment_id = cp.enrollment_id
GROUP BY s.student_id,s.full_name
HAVING MAX(completed_percent) < 100;

-- Query12: Find categories with more than 3 courses --
SELECT
    category,
    COUNT(course_id) AS total_courses
FROM courses
GROUP BY category
HAVING COUNT(course_id) > 3;

-- Query13: Show students whose average completion is above overall average --
WITH student_completion AS (
    SELECT
        s.student_id,
        s.full_name,
        Round(AVG(cp.completed_percent),2) AS avg_completion
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN course_progress cp ON e.enrollment_id = cp.enrollment_id
    GROUP BY s.student_id, s.full_name
)
SELECT *
FROM student_completion
WHERE avg_completion > (
    SELECT AVG(avg_completion)
    FROM student_completion
);

-- Query14: Find students enrolled in the least expensive course --
SELECT DISTINCT
    s.student_id,
    s.full_name AS student_name,
    c.course_name,
    c.price
FROM students s
JOIN enrollments e
    ON s.student_id = e.student_id
JOIN courses c
    ON e.course_id = c.course_id
WHERE c.price = (
    SELECT MIN(price)
    FROM courses
);

-- Query15: Find courses whose price is lower than the average pice of their own category --
SELECT
    c.course_id,
    c.course_name,
    c.category,
    c.price
FROM courses c
WHERE c.price < (
    SELECT AVG(c2.price)
    FROM courses c2
    WHERE c2.category = c.category
);

-- Query16: Find students who enrolled only in free courses --
SELECT
    s.student_id,
    s.full_name AS student_name
FROM students s
JOIN enrollments e
    ON s.student_id = e.student_id
JOIN courses c
    ON e.course_id = c.course_id
GROUP BY
    s.student_id,
    s.full_name
HAVING MAX(c.price) = 0;

-- Query17: show courses where maximum completion <70% --
SELECT
    c.course_id,
    c.course_name
FROM courses c
JOIN enrollments e
    ON c.course_id = e.course_id
JOIN course_progress cp
    ON e.enrollment_id = cp.enrollment_id
GROUP BY
    c.course_id,
    c.course_name
HAVING MAX(cp.completed_percent) < 70;


-- Query18: Find students who enrolled in the second most expensive course --
SELECT DISTINCT
    s.student_id,
    s.full_name AS student_name,
    c.course_name,
    c.price
FROM students s
JOIN enrollments e
    ON s.student_id = e.student_id
JOIN courses c
    ON e.course_id = c.course_id
WHERE c.price = (
    SELECT DISTINCT price
    FROM courses
    ORDER BY price DESC
    LIMIT 1 OFFSET 1
);

-- Query19: Display courses with enrollments greater than median --
SELECT
    course_id,
    course_name,
    enrollment_count
FROM (
    SELECT
        c.course_id,
        c.course_name,
        COUNT(e.enrollment_id) AS enrollment_count,
        PERCENT_RANK() OVER (ORDER BY COUNT(e.enrollment_id)) AS pr
    FROM courses c
    LEFT JOIN enrollments e ON c.course_id = e.course_id
    GROUP BY c.course_id, c.course_name
) x
WHERE pr > 0.5;

-- Query20: Find students who completed exactly one course --
SELECT
    s.student_id,
    s.full_name AS student_name
FROM students s
JOIN enrollments e
    ON s.student_id = e.student_id
JOIN course_progress cp
    ON e.enrollment_id = cp.enrollment_id
WHERE cp.completed_percent = 100
GROUP BY
    s.student_id,
    s.full_name
HAVING COUNT(*) = 1;







 





