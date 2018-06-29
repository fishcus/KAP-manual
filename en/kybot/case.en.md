## Analysis of KyBot Case
There is a case that an e-commerce company runs Kyligence Enterprise on over 21 nodes, they want to diagnose the health situation of their cluster and receive some advice on how to optimize the design of the Cube.
Based on analyzation of a 5-day diagnosis package, which includes 98 Cubes and more than 7000 queries, KyBot locates the bottleneck of the queries and provides with prioritization scheme.


### Overall situation

- *98* Cubes with total size of *871GB* and the expansion rate is quite low

- Over *86%* of queries are completed within *1 second*, *98%* queries are completed within 5 seconds, thus the average query performance is pretty great.

- The median duration of building a cube is *below 15 mins*, which is within normal range.


![](images/01-1.png)


### Analysis on SQL Execution 
The SQL statement is as follow,

 ```
SELECT CATEGORY_LV1
	,sum(order_amt) AS order_amt
	,sum(payment_amt) AS payment_amt
	,sum(discount_amt) AS discount_amt
	,sum(shipping_fee) AS shipping_fee
	,sum(tax_amt) astax_amt
	,sum(coupon_amt) AS coupon_amt
	,count(DISTINCT CUSTOMER_ID) AS uv
	,count(DISTINCT SHIPPING_AGT_ID) AS shipping_agt
	,count(DISTINCT province_id) AS province
FROM t_sales_order
WHERE PART_DT > ’20160901’
	AND PART_DT < ’20161001’
GROUP BY CATEGORY_LV1
ORDER BY CATEGORY_LV1
 ```
 

-  Analysis on Matching Degree of Cube Index

As shown in the SQL execution process diagram, 8 dimensions indicate that 8 dimensions within a Cube are involved in the SQL execution, `PART_DT` is the effective filtering dimension, and `CATEGORY_LV1` is the effective aggregation group dimension, and the other 6 dimensions are involved in the SQL execution because they are in mandatory aggregation group. 

The overall matching degree is 25%, which is quite low. It is suggested to cancel the unnecessary mandatory aggregation group or use other dimension groups instead.

The filtering dimension `PART_DT` is at the end of the index combination, and the front dimensions have ultra high cardinality, that will cost a lot of time on filtering and decrease the efficiency of SQL execution. It is suggested to update the dimensions' rankings.

![Snapshot of SQL execution process page](images/02-1.png)

-  Analysis on SQL Execution Lifecycle 

As shown in the SQL execution lifecycle diagram, the blue bar refers to the parallel querying part among multiple storage nodes while the green part refers to the execution part on query nodes.

It is evident that the green bar is longer than blue bar, thus the bottleneck is on query nodes. It is suggested to reduce data post aggregation or enhance the query nodes' performance.

![](images/03-1.png)

### Optimization Operation

1. Cancel the former `Mandatory aggregation group` .

2. Add a `Hierarchy aggregation group`, including `CATEGORY_LV1` and `CATEGORY_LV2`.

3. Add a `Joint aggregation group`, including `SELLER_ID` and `SHOP_NAME`.

### Optimization Result
SQL statement hits a more matchable Cuboid, increasing query efficiency a lot, and query nodes' runtime reduces to 0.4s. 

### Customer Feedback
Based on KyBot’s analysis, we optimized the cube correspondingly and increased query nodes' memory. 

Through comparison test, it is evident that the query efficiency is significantly improved. We will continue to optimize cubes based on further analysis.