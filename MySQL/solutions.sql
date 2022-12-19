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


# ID 9924: Find libraries who haven't provided the email address in circulation year 2016 but their notice preference definition is set to email

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
