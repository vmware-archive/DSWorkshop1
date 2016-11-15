--Run the Quadratic Programming 

--CREATE LANGUAGE PLR;

-- The following PL/R function computes optimal prices over a 20-day horizon for a given flight route, date, and class. It takes as inputs, the a_array, b_array from a table of the form of pricing.input_for_QP, as well as c, the capacity of the flight route for that date and class. Your task in this exercise is to write R code within the PL/R function to compute the parameters needed by the 'solve.QP' function in the 'quadprog' package. Refer to the documentation on the 'quadprog' package on CRAN.

CREATE OR REPLACE FUNCTION pricing.r_solve_QP(a float8[], b float8[], c integer)
RETURNS float8[] AS 
$$
        
        ## Fill in the blanks here.
        ## The solve.QP routine implements the dual method of Goldfarb and Idnani (1982, 1983) 
        ## for solving quadratic programming problems of the form 
        ## min(-d^Tp + 1/2p^TDp) with the constraints A^Tp >= b0, where p is the vector of decision variables.
        
        ## The quadratic programming problem we are trying to solve is the following:
        ## min(-b^Tp + p^Tdiag(a)p) with the constraints (\sum_i{a_ip_i +n b_i} <= c, a_ip_i +n b_i >= 0 for all i). 
        ## Generate the Dmat, dvec, Amat, and bvec parameters to be used in the following R function call.

 	library(quadprog)
 	
        Dmat<- matrix(0,14,14)
	diag(Dmat) <- -2*a 
	dvec <- b 
	Amat <- matrix(0,14,15)
	Amat[,1] <- -a
	diag(Amat[,2:15]) <- a
	bvec  <- c(-c+sum(b),-b)
 
        qp<-solve.QP(Dmat,dvec,Amat,bvec=bvec)

return(qp$solution)
$$ 
LANGUAGE 'plr';



DROP TABLE IF EXISTS pricing.optimal_prices CASCADE;

CREATE TABLE pricing.optimal_prices
AS
SELECT
  routeid, Route_Origin, Route_Destination,
  "class",
  flight_date,
  CASE WHEN class='Economy' THEN pricing.r_solve_QP(a_array, b_array, 200)
          WHEN class='Business' THEN pricing.r_solve_QP(a_array, b_array, 15)
  	     ELSE pricing.r_solve_QP(a_array, b_array, 10) END as optimal_prices	
FROM pricing.input_for_qp
DISTRIBUTED BY (routeid);

-- Query returned successfully: 4316778 rows affected, 28154 ms execution time.
