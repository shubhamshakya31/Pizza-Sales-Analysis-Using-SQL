sql 1st pizza

-- Q.1 Total number of orders placed

SELECT 
    COUNT(*) AS total_orders
FROM
    orders;



-- Q.2 Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS Total_Revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;



-- Q.3  Identify the highest-priced pizza.

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;



-- Q.4Identify the most common pizza size ordered.

SELECT 
    pizzas.size, COUNT(pizzas.size) as order_count
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizzas.size
ORDER BY COUNT(pizzas.size) DESC;



-- Q.5 List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pizza_types.name, SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;



-- Q.6 Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC;



-- Q.7Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) as hour, COUNT(order_id) as order_count
FROM
    orders
GROUP BY HOUR(order_time);



-- Q.8 Join relevant tables to find the category-wise distribution of pizzas.

select * from pizza_types;

SELECT 
    category, COUNT(name) AS number_of_pizza
FROM
    pizza_types
GROUP BY category
ORDER BY number_of_pizza DESC;



-- Q.9 Group the orders by date and calculate the average number of pizzas ordered per day.

select * from orders;
select * from order_details;

select round(avg(quantity),2) from
(SELECT 
    orders.order_date AS date,
    sum(order_details.quantity) as quantity
FROM
    orders
        JOIN
    order_details ON orders.order_id = order_details.order_id
GROUP BY date) as order_quantity;



-- Q.10 Determine the top 3 most ordered pizza types based on revenue.

select *from pizzas;
select * from pizza_types;
select * from order_details;


SELECT 
    pizza_types.name AS name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;




-- Q.11 Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pizza_types.category AS name,
    ROUND((SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2) AS Total_Revenue
                FROM
                    order_details
                        JOIN
                    pizzas ON order_details.pizza_id = pizzas.pizza_id)) * 100,
            2) AS perc
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY perc DESC;




-- Q.12 Analyze the cumulative revenue generated over time.

select * from orders;

select order_date,
sum(revenue) over(order by order_date) as cum_revenue from
(select orders.order_date, sum(pizzas.price * order_details.quantity) as revenue from order_details 
join pizzas on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = order_details.order_id
group by orders.order_date) as sales;




-- Q.13 Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select category,name,revenue from 
(select category,name,revenue,
rank() over(partition by category order by revenue desc) as rn
 from

(select pizza_types.category, pizza_types.name,
sum((order_details.quantity) * pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as a) as b
where rn <=3;
