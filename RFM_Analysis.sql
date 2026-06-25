-- upload all the csv datset files --
-- step (1)create a view to append all 6 datasets using UNION ALL --
 create or replace table my-sqlproject-38244.sales.All_Sales as(
 select * from my-sqlproject-38244.sales.jan
 union all
 select * from my-sqlproject-38244.sales.feb
 union all 
 select * from my-sqlproject-38244.sales.mar it
 union all 
 select * from my-sqlproject-38244.sales.apr
 union all 
 select * from my-sqlproject-38244.sales.may
 union all 
 select * from my-sqlproject-38244.sales.jun  )
 -- view for all sales -- appended table --
 select * from `my-sqlproject-38244.sales.All_Sales`;
-- step (2)calculate receny, frequency, monetary , r,f,m ranks --
-- along with the most and the least bought product --
-- combine cte with view --to
select * from `my-sqlproject-38244.sales.cust_rank_data`

create or replace view `my-sqlproject-38244.sales.cust_rank_data` as  (
  with cte_1 as (
    select date('2025-07-01') as today 
    ), cte_2 as (
    select CustId ,max(order_date) as moi,date_diff((select today from cte_1),max(order_date),day) as recency,
    count(*)  as frequency,
    sum(orderPrice) as monetary from `my-sqlproject-38244.sales.All_Sales` group by CustId
    ), cte_3 as (
    select CustId,moi,recency,frequency,monetary,
    dense_rank() over(order by recency asc ) r_rank,
    dense_rank() over(order by frequency desc ) f_rank,
    dense_rank() over(order by monetary desc ) m_rank from cte_2
    ) ,cte_last as (
      select CustId, 
    ntile(10) over (order by r_rank desc ) r ,
    ntile(10) over (order by f_rank desc ) f ,
    ntile(10) over (order by m_rank desc ) m   from cte_3 
    )
     select CustId , r+f+m as Final_score , 
     case 
     when r+f+m >= 28 then 'Champions'
     when r+f+m >= 24 then 'Loyal VIPs'
     when r+f+m >= 20 then 'Potential Loyalist'
     when r+f+m >= 16 then 'Promising'
     when r+f+m >= 12 then 'Engaged'
     when r+f+m >= 8 then 'Requires Attention'
     when r+f+m >= 4 then 'At Risk'
     else 'Lost'
     End as Cust_Category  from cte_last 
        )



      select * from `my-sqlproject-38244.sales.cust_rank_data`

      ---step (3) 2nd view  related to most purchased product --
    
   
      select * from `my-sqlproject-38244.sales.All_Sales` 

     create or replace view    `my-sqlproject-38244.sales.Pro_info` as  (
      with cte_4 as (
      select CustId,Product_name,orderPrice,
      dense_rank() over (partition by CustId,product_name order by CustId) d_r from `my-sqlproject-38244.sales.All_Sales`
      ) ,cte_5 as
       (select *,count(d_r) over (partition by CustId,Product_name) as count_pro,
       sum(orderPrice) over (partition by CustId,Product_name ) Tot_spend
         from cte_4 ),cte_6 as (
       select distinct CustId ,Product_name ,count_pro,Tot_spend,
       dense_rank() over (partition by CustId order by count_pro desc,Tot_spend desc) rnk
       from cte_5  
         )
       select CustId,product_name,count_pro,Tot_spend from cte_6 where rnk = 1   )
       
       -----step (4) join both views -----
           create or replace view `my-sqlproject-38244.sales.final_view` as  (
       select rd.CustId,Final_score,product_name,count_pro,Tot_spend,Cust_Category from `my-sqlproject-38244.sales.cust_rank_data` as rd 
       inner join `my-sqlproject-38244.sales.Pro_info` as  pi
       on pi.CustId = rd.CustId
           )

   -- upload all the csv datset files --
-- step (1)create a view to append all 6 datasets using UNION ALL --
 create or replace table my-sqlproject-38244.sales.All_Sales as(
 select * from my-sqlproject-38244.sales.jan
 union all
 select * from my-sqlproject-38244.sales.feb
 union all 
 select * from my-sqlproject-38244.sales.mar 
 union all 
 select * from my-sqlproject-38244.sales.apr
 union all 
 select * from my-sqlproject-38244.sales.may
 union all 
 select * from my-sqlproject-38244.sales.jun  )
 -- view for all sales -- appended table --
 select * from `my-sqlproject-38244.sales.All_Sales`;
-- step (2)calculate receny, frequency, monetary , r,f,m ranks --
-- along with the most and the least bought product --
-- combine cte with view --to
select * from `my-sqlproject-38244.sales.cust_rank_data`

create or replace view `my-sqlproject-38244.sales.cust_rank_data` as  (
  with cte_1 as (
    select date('2025-07-01') as today 
    ), cte_2 as (
    select CustId ,max(order_date) as moi,date_diff((select today from cte_1),max(order_date),day) as recency,
    count(*)  as frequency,
    sum(orderPrice) as monetary from `my-sqlproject-38244.sales.All_Sales` group by CustId
    ), cte_3 as (
    select CustId,moi,recency,frequency,monetary,
    dense_rank() over(order by recency asc ) r_rank,
    dense_rank() over(order by frequency desc ) f_rank,
    dense_rank() over(order by monetary desc ) m_rank from cte_2
    ) ,cte_last as (
      select CustId, 
    ntile(10) over (order by r_rank desc ) r ,
    ntile(10) over (order by f_rank desc ) f ,
    ntile(10) over (order by m_rank desc ) m   from cte_3 
    )
     select CustId , r+f+m as Final_score , 
     case 
     when r+f+m >= 28 then 'Champions'
     when r+f+m >= 24 then 'Loyal VIPs'
     when r+f+m >= 20 then 'Potential Loyalist'
     when r+f+m >= 16 then 'Promising'
     when r+f+m >= 12 then 'Engaged'
     when r+f+m >= 8 then 'Requires Attention'
     when r+f+m >= 4 then 'At Risk'
     else 'Lost'
     End as Cust_Category  from cte_last 
        )



      select * from `my-sqlproject-38244.sales.cust_rank_data`

      ---step (3) 2nd view  related to most purchased product --
    
   
      select * from `my-sqlproject-38244.sales.All_Sales` 

     create or replace view    `my-sqlproject-38244.sales.Pro_info` as  (
      with cte_4 as (
      select CustId,Product_name,orderPrice,
      dense_rank() over (partition by CustId,product_name order by CustId) d_r from `my-sqlproject-38244.sales.All_Sales`
      ) ,cte_5 as
       (select *,count(d_r) over (partition by CustId,Product_name) as count_pro,
       sum(orderPrice) over (partition by CustId,Product_name ) Tot_spend
         from cte_4 ),cte_6 as (
       select distinct CustId ,Product_name ,count_pro,Tot_spend,
       dense_rank() over (partition by CustId order by count_pro desc,Tot_spend desc) rnk
       from cte_5  
         )
       select CustId,product_name,count_pro,Tot_spend from cte_6 where rnk = 1   )
       
       -----step (4) join both views -----
           create or replace view `my-sqlproject-38244.sales.final_view` as  (
       select rd.CustId,Final_score,product_name,count_pro,Tot_spend,Cust_Category from `my-sqlproject-38244.sales.cust_rank_data` as rd 
       inner join `my-sqlproject-38244.sales.Pro_info` as  pi
       on pi.CustId = rd.CustId
           )

      -- upload all the csv datset files --
-- step (1)create a view to append all 6 datasets using UNION ALL --
 create or replace table my-sqlproject-38244.sales.All_Sales as(
 select * from my-sqlproject-38244.sales.jan
 union all
 select * from my-sqlproject-38244.sales.feb
 union all 
 select * from my-sqlproject-38244.sales.mar it
 union all 
 select * from my-sqlproject-38244.sales.apr
 union all 
 select * from my-sqlproject-38244.sales.may
 union all 
 select * from my-sqlproject-38244.sales.jun  )
 -- view for all sales -- appended table --
 select * from `my-sqlproject-38244.sales.All_Sales`;
-- step (2)calculate receny, frequency, monetary , r,f,m ranks --
-- along with the most and the least bought product --
-- combine cte with view --to
select * from `my-sqlproject-38244.sales.cust_rank_data`

create or replace view `my-sqlproject-38244.sales.cust_rank_data` as  (
  with cte_1 as (
    select date('2025-07-01') as today 
    ), cte_2 as (
    select CustId ,max(order_date) as moi,date_diff((select today from cte_1),max(order_date),day) as recency,
    count(*)  as frequency,
    sum(orderPrice) as monetary from `my-sqlproject-38244.sales.All_Sales` group by CustId
    ), cte_3 as (
    select CustId,moi,recency,frequency,monetary,
    dense_rank() over(order by recency asc ) r_rank,
    dense_rank() over(order by frequency desc ) f_rank,
    dense_rank() over(order by monetary desc ) m_rank from cte_2
    ) ,cte_last as (
      select CustId, 
    ntile(10) over (order by r_rank desc ) r ,
    ntile(10) over (order by f_rank desc ) f ,
    ntile(10) over (order by m_rank desc ) m   from cte_3 
    )
     select CustId , r+f+m as Final_score , 
     case 
     when r+f+m >= 28 then 'Champions'
     when r+f+m >= 24 then 'Loyal VIPs'
     when r+f+m >= 20 then 'Potential Loyalist'
     when r+f+m >= 16 then 'Promising'
     when r+f+m >= 12 then 'Engaged'
     when r+f+m >= 8 then 'Requires Attention'
     when r+f+m >= 4 then 'At Risk'
     else 'Lost'
     End as Cust_Category  from cte_last 
        )



      select * from `my-sqlproject-38244.sales.cust_rank_data`

      ---step (3) 2nd view  related to most purchased product --
    
   
      select * from `my-sqlproject-38244.sales.All_Sales` 

     create or replace view    `my-sqlproject-38244.sales.Pro_info` as  (
      with cte_4 as (
      select CustId,Product_name,orderPrice,
      dense_rank() over (partition by CustId,product_name order by CustId) d_r from `my-sqlproject-38244.sales.All_Sales`
      ) ,cte_5 as
       (select *,count(d_r) over (partition by CustId,Product_name) as count_pro,
       sum(orderPrice) over (partition by CustId,Product_name ) Tot_spend
         from cte_4 ),cte_6 as (
       select distinct CustId ,Product_name ,count_pro,Tot_spend,
       dense_rank() over (partition by CustId order by count_pro desc,Tot_spend desc) rnk
       from cte_5  
         )
       select CustId,product_name,count_pro,Tot_spend from cte_6 where rnk = 1   )
       
       -----step (4) join both views -----
           create or replace view `my-sqlproject-38244.sales.final_view` as  (
       select rd.CustId,Final_score,product_name,count_pro,Tot_spend,Cust_Category from `my-sqlproject-38244.sales.cust_rank_data` as rd 
       inner join `my-sqlproject-38244.sales.Pro_info` as  pi
       on pi.CustId = rd.CustId
           )

           select * from `my-sqlproject-38244.sales.final_view`




    
    




   





























    
    




   

























