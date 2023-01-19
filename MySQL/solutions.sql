########################
# Difficulty level: Easy
########################



# ID 10087: Find all posts which were reacted to with a heart

SELECT DISTINCT fp.* 
FROM facebook_reactions AS fr 
INNER JOIN facebook_posts AS fp
    ON fr.post_id = fp.post_id
WHERE reaction = 'heart'


# ID 9917: Average Salaries

SELECT department,
    first_name,
    salary,
    AVG(salary) OVER(PARTITION BY department)
FROM employee


# ID 9653: Count the number of user events performed by MacBookPro users

SELECT DISTINCT event_name,
    COUNT(*) OVER(PARTITION BY event_name) AS event_count
FROM playbook_events
WHERE device = 'macbook pro'
ORDER BY event_count DESC


# ID 9913: Order Details

SELECT first_name, order_date, order_details, total_order_cost
FROM customers c
INNER JOIN orders o
    ON c.id = o.cust_id
WHERE first_name IN ('Jill', 'Eva')
ORDER BY c.id ASC


# ID 10176: Bikes Last Used

SELECT bike_number, MAX(end_time) AS date_last_use
FROM dc_bikeshare_q1_2012
GROUP BY bike_number
ORDER BY date_last_use DESC


# ID 10003: Lyft Driver Wages

SELECT *
FROM lyft_drivers
WHERE yearly_salary <= 30000 OR yearly_salary >= 70000


# ID 9663: Find the most profitable company in the financial sector of the entire world along with its continent

SELECT company, continent, MAX(profits) AS profits
FROM forbes_global_2010_2014
WHERE sector = 'Financials'


# ID 9972: Find the base pay for Police Captains

SELECT employeename, basepay
FROM sf_public_salaries 
WHERE jobtitle = 'CAPTAIN III (POLICE DEPARTMENT)'


# ID 10061: Popularity of Hack

SELECT location, SUM(popularity)/COUNT(*) AS average_popularity
FROM facebook_employees AS fe
INNER JOIN facebook_hack_survey AS fhs
    ON fe.id = fhs.employee_id
GROUP BY location


# ID 10299: Finding Updated Records

SELECT id, first_name, last_name, department_id, MAX(salary) AS current_salary
FROM ms_employee_salary
GROUP BY id
ORDER BY id ASC


# ID 10308: Salaries Differences

SELECT 
ABS(
    (SELECT MAX(salary)
    FROM db_employee
    WHERE department_id = (SELECT id FROM db_dept WHERE department = 'marketing'))
-
    (SELECT MAX(salary)
    FROM db_employee
    WHERE department_id = (SELECT id FROM db_dept WHERE department = 'engineering'))
) AS diff_salaries


# ID 9688: Churro Activity Date

SELECT activity_date, pe_description
FROM los_angeles_restaurant_health_inspections
WHERE facility_name = 'STREET CHURROS' AND score < 95


# ID 9891: Customer Details

SELECT first_name, last_name, city, order_details
FROM customers c
LEFT JOIN orders o
    ON c.id = o.cust_id
ORDER BY first_name, order_details ASC


# ID 9924: Find libraries who havent provided the email address in circulation year 2016 but their notice preference definition is set to email

SELECT DISTINCT home_library_code 
FROM library_usage
WHERE notice_preference_definition = 'email' 
    AND circulation_active_year = 2016 
    AND provided_email_address = 0


# ID 9992: Find how many times each artist appeared on the Spotify ranking list

SELECT artist, COUNT(*) AS number_of_occurrences
FROM spotify_worldwide_daily_song_ranking
GROUP BY artist
ORDER BY number_of_occurrences DESC


# ID 10128: Count the number of movies that Abigail Breslin nominated for oscar

SELECT COUNT(*) AS Count 
FROM oscar_nominees 
WHERE nominee = 'Abigail Breslin'


# ID 9622: Number Of Bathrooms And Bedrooms

SELECT city, property_type, AVG(bathrooms), AVG(bedrooms) from airbnb_search_details
GROUP BY city, property_type



##########################
# Difficulty level: Medium
##########################



# ID 10156: Number Of Units Per Nationality

SELECT nationality, COUNT(DISTINCT unit_id) AS num_of_apartments
FROM airbnb_hosts ah
INNER JOIN airbnb_units au
    ON ah.host_id = au.host_id
WHERE unit_type = 'Apartment' AND age < 30
GROUP BY nationality
ORDER BY COUNT(*) DESC


# ID 9897: Highest Salary In Department

WITH cte AS
(
    SELECT department, MAX(salary) AS max_salary
    FROM employee
    GROUP BY department
)
SELECT employee.department, first_name AS employee_name, salary
FROM employee
INNER JOIN cte
    ON employee.department = cte.department AND employee.salary = cte.max_salary
    

# ID 10353: Workers With The Highest Salaries

SELECT worker_title
FROM worker
INNER JOIN title
    ON worker.worker_id = title.worker_ref_id
WHERE salary = (select MAX(salary) from worker)


# ID 9915: Highest Cost Orders

SELECT first_name, MAX(total_daily_cost) AS total_daily_cost, order_date AS date
FROM
    (SELECT first_name, order_date, total_order_cost, SUM(total_order_cost) AS total_daily_cost
    FROM orders
    INNER JOIN customers
        ON orders.cust_id = customers.id
    WHERE order_date BETWEEN '2019-02-01' AND '2019-05-01'
    GROUP BY order_date, cust_id) AS a


# ID 10352: Users By Average Session Time

WITH start_time AS
(
    SELECT 
        user_id, 
        DATE(timestamp) AS date, 
        MAX(timestamp) AS last_page_load
    FROM facebook_web_log
    WHERE action = 'page_load'
    GROUP BY 1, 2
), 
end_time AS
(
    SELECT 
        user_id, 
        DATE(timestamp) AS date, 
        MIN(timestamp) AS first_page_exit
    FROM facebook_web_log
    WHERE action = 'page_exit'
    GROUP BY 1, 2
)

SELECT
    st.user_id,
    st.date,
    first_page_exit,
    last_page_load,
    AVG(TIMESTAMPDIFF(SECOND, last_page_load, first_page_exit)) AS avg_session_time
FROM start_time st
INNER JOIN end_time et
    ON st.user_id = et.user_id AND st.date = et.date
GROUP BY user_id


# ID 10078: Find matching hosts and guests in a way that they are both of the same gender and nationality

SELECT 
    DISTINCT host_id,
    guest_id
FROM airbnb_hosts AS ah
INNER JOIN airbnb_guests AS ag
    ON ah.nationality = ag.nationality
        AND ah.gender = ag.gender

    
# ID 9781: Find the rate of processed tickets for each type

SELECT 
    type,
    (SUM(processed) / COUNT(processed)) AS processed_tickets_rate
FROM facebook_complaints
GROUP BY type
    
    
# ID 10026: Find all wineries which produce wines by possessing aromas of plum, cherry, rose, or hazelnut

SELECT DISTINCT winery
FROM winemag_p1
WHERE LOWER(description) REGEXP '(plum|cherry|rose|hazelnut)[^a-z]'

    
# ID 10354: Most Profitable Companies

SELECT company, profits
FROM forbes_global_2010_2014
ORDER BY profits DESC
LIMIT 3
    
    
# ID 9650: Find the top 10 ranked songs in 2010

SELECT DISTINCT song_name, year_rank, group_name
FROM billboard_top_100_year_end
WHERE year = '2010'
LIMIT 10
    
    
# ID 9905: Highest Target Under Manager

SELECT first_name, target
FROM salesforce_employees
WHERE manager_id = 13
    AND target = 
        (SELECT MAX(target) 
        FROM salesforce_employees
        WHERE manager_id = 13)
    
    
# ID 9942: Largest Olympics

SELECT games, COUNT(DISTINCT id) AS number_of_athletes 
FROM olympics_athletes_events 
GROUP BY games 
ORDER BY 2 DESC 
LIMIT 1
   
    
# ID 9991: Top Ranked Songs

SELECT trackname, COUNT(*) AS times_at_top
FROM spotify_worldwide_daily_song_ranking
WHERE position = 1
GROUP BY trackname
ORDER BY 2 DESC
    
    
# ID 9726: Classify Business Type

SELECT DISTINCT business_name, 
    CASE
        WHEN business_name LIKE '%School%' THEN 'school'
        WHEN business_name LIKE '%cafe%'
            OR business_name LIKE '%café%'
            OR business_name LIKE '%coffee%' THEN 'cafe'
        WHEN business_name LIKE '%restaurant%' THEN 'restaurant'
        ELSE 'other'
        END AS classification
FROM sf_restaurant_health_violations
    
    
# ID 10060: Top Cool Votes

SELECT business_name, review_text
FROM yelp_reviews
WHERE cool = 
    (select max(cool) from yelp_reviews)
   
    
# ID 10048: Top Businesses With Most Reviews

SELECT name AS business_name, review_count 
FROM yelp_business 
ORDER BY review_count DESC 
LIMIT 5
    
    
# ID 9782: Customer Revenue In March

SELECT cust_id AS customer_id, SUM(total_order_cost) AS revenue
FROM orders 
WHERE month(order_date) = 3 
    AND year(order_date) = 2019
GROUP BY cust_id
ORDER BY 2 DESC
    
    
# ID 10322: Finding User Purchases

SELECT user_id
FROM
    (SELECT *,
        DATEDIFF(created_at, LAG(created_at, 1) OVER(PARTITION BY user_id ORDER BY created_at)) AS days_diff
    FROM amazon_transactions) AS temp
GROUP BY user_id
HAVING MIN(days_diff) <= 7 
    AND MIN(days_diff) IS NOT NULL


# ID 10077: Income By Title and Gender

SELECT employee_title, sex AS gender, AVG(salary + total_bonus) AS avg_total_compensation
FROM sf_employee
INNER JOIN
        (SELECT worker_ref_id, SUM(bonus) total_bonus
        FROM sf_bonus
        GROUP BY 1) AS bonus_table
    ON sf_employee.id = bonus_table.worker_ref_id
GROUP BY 1, 2


# ID 10049: Reviews of Categories

WITH numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT 2 AS n
    UNION ALL
    SELECT 3 AS n
    UNION ALL
    SELECT 4 AS n
    UNION ALL
    SELECT 5 AS n
    UNION ALL
    SELECT 6 AS n
    UNION ALL
    SELECT 7 AS n
    UNION ALL
    SELECT 8 AS n
    UNION ALL
    SELECT 9 AS n
    UNION ALL
    SELECT 10 AS n
    UNION ALL
    SELECT 11 AS n
    UNION ALL
    SELECT 12 AS n
)

SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(t1.categories, ';', t2.n), ';', -1) AS category, SUM(t1.review_count) AS review_count
FROM yelp_business t1
JOIN
numbers t2
ON LENGTH(t1.categories) - LENGTH(REPLACE(t1.categories, ';', '')) >= t2.n-1
GROUP BY 1
ORDER BY 2 DESC


# ID 9728: Number of violations

SELECT YEAR(SUBSTRING_INDEX(inspection_date, "T", 1)) AS year,
    COUNT(violation_id) AS count
FROM sf_restaurant_health_violations
WHERE business_name = 'Roxanne Cafe'
GROUP BY 1
ORDER BY 1 ASC


# ID 10159: Ranking Most Active Guests

SELECT DENSE_RANK() OVER(ORDER BY SUM(n_messages) DESC) AS rnk,
    id_guest,
    SUM(n_messages) AS total_messages
FROM airbnb_contacts
GROUP BY id_guest
ORDER BY 3 DESC


# ID 9894: Employee and Manager Salaries

WITH cte AS (
    SELECT e1.*, e2.salary AS manager_salary
    FROM employee e1
    INNER JOIN employee e2
        ON e1.manager_id = e2.id
)

SELECT first_name, salary
FROM cte
WHERE salary > manager_salary



########################
# Difficulty level: *Hard*
########################



# ID 10319: Monthly Percentage Difference






