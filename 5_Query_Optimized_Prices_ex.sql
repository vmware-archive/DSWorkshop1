-- Show one route
-- You may need to find a route, class, and date to insert into the WHERE
-- clause below

select * from pricing.optimal_prices order by random() limit 5;

-- the code below is just an example, there may not be any data for this particular
-- example because we "generated" the data rather than using the real customer
-- data for this exercise.

\x off

SELECT Route_Origin, Route_Destination, class, flight_date, unnest(array[1,2,3,4,5,6,7,8,9,10,11,12,13,14]) as days_to_flight,
unnest(optimal_prices) as optimal_pricing
FROM pricing.optimal_prices
WHERE flight_date='2012-01-06' and routeid=10292 and class='First-Class' 
;
