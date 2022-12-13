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
