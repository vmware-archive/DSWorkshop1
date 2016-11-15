SET client_min_messages TO error;

/********************************
Run Linear Regressions:

pricing.flight_history is your source_table.
pricing.model_results is your out_table.
Sales is the dependent variable.
The independent variables are:
Price, 
Price_Comp1, 
Price_Comp2, 
Price_Comp3, 
Price_Comp4, 
Flight_Month, 
6 different indicator variables (0 or 1) to denote whether Flight_Weekday = 2,3,4,5,6 or 7,
Holiday_Indicator,
(Current date - flight date).
Also, remember to add an intercept term at the beginning of the array.

There are 5 columns to group by: routeid, origin, destination, class, days_to_flight.

Enter your query below.

*********************************/
SET client_min_messages TO error;

DROP TABLE IF EXISTS pricing.model_results CASCADE;
DROP TABLE IF EXISTS pricing.model_results_summary CASCADE;

-- You can choose to analyze the pricing.flight_history table if you want.

SELECT madlib.linregr_train( 'pricing.flight_history',
                             'pricing.model_results',
                             'Sales',
                             'ARRAY[
                                                        -- intercept
                                                                1,      
                                                        --prices
                                                                Price,  
                                                                Price_Comp1, 
                                                                Price_Comp2, 
                                                                Price_Comp3, 
                                                                Price_Comp4,
                                                        --seasonality
                                                                Flight_Month,                            
                                                                CASE WHEN Flight_Weekday=2 THEN 1 ELSE 0 END,
                                                                CASE WHEN Flight_Weekday=3 THEN 1 ELSE 0 END, 
                                                                CASE WHEN Flight_Weekday=4 THEN 1 ELSE 0 END, 
                                                                CASE WHEN Flight_Weekday=5 THEN 1 ELSE 0 END, 
                                                                CASE WHEN Flight_Weekday=6 THEN 1 ELSE 0 END, 
                                                                CASE WHEN Flight_Weekday=7 THEN 1 ELSE 0 END, 
                                                                Holiday_Indicator,
                                                        --trend
                                                                CURRENT_DATE-flight_date
                                                        ]',
                             'routeid, origin, destination, class, days_to_flight' -- group by columns
                           );
