DROP TABLE IF EXISTS pricing.input_for_QP CASCADE;

/*
Create a table pricing.input_for_QP from pricing.scoring, to be used for optmization.
It must include, and be grouped by routeID, Route_Origin, Route_Destination, class, flight_Date.
Also, 
an array of 'a' values ordered by days_to_flight. call it a_array.
an array of 'b' values ordered by days_to_flight. call it b_array.
Finally, the table should be distributed by routeID.
*/

-- You may want to analyze the pricing.scoring table
CREATE TABLE pricing.input_for_QP AS
SELECT routeID, Route_Origin, Route_Destination, class, flight_Date, 
array_agg(a order by days_to_flight) a_array, 
array_agg(b order by days_to_flight) b_array
FROM pricing.scoring
GROUP BY routeID, Route_Origin, Route_Destination, class, flight_Date
DISTRIBUTED BY (routeID);


-- Query returned successfully: 4316778 rows affected, 10463 ms execution time.
