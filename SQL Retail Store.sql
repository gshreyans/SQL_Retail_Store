use POS

--DATA PREPARATION AND UNDERSTANDING

--Q1

select 'Customer Table' 
as [Table Name], 
count(*) as [Count of Rows] 
from 
Customers
union all
select 'Transaction Table',
count(*) 
from 
Transactions
union all
select 'Product Table',
count(*) 
from 
[Product info]

--Q2

select count(*) 
as [Total Transactions] 
from 
Transactions
where 
Qty<0
 
--Q3

select convert(date,tran_date,105) 
as [Transaction Date],
convert(date,DOB,105) as DOB 
from 
Transactions
left join
Customers
on 
customer_Id=cust_id

--Q4

select datediff(year,min(convert(date,tran_date,105)),
max(convert(date,tran_date,105))) 
as [Years],
datediff(MONTH,min(convert(date,tran_date,105)),
max(convert(date,tran_date,105))) 
as [Months],
datediff(day,min(convert(date,tran_date,105)),
max(convert(date,tran_date,105))) 
as [Days] 
from Transactions

--Q5

select prod_cat 
from [Product info]
where 
prod_subcat ='DIY'

--DATA ANALYSIS

--Q1

select top 1 count(transaction_id) 
as [Count], 
Store_type 
from Transactions
group by
Store_type
order by
[Count]
desc

--Q2

select Gender,
count(Gender) 
as [Count] from Customers 
group by
Gender
order by
[Count]

--Q3

select Top 1 city_code,
count(city_code) 
as [Count]
from Customers 
group by
city_code
order by
[Count]
desc

--Q4

select prod_cat,
count(prod_sub_cat_code) 
as [Sub_cat_count] 
from [Product info]
where
prod_cat='Books'
group by
prod_cat

--Q5

select [Sum] 
as [Max_Qty_ordered] 
from ( 
select top 1  transaction_id, 
sum(cast(qty as float)) 
as [Sum] 
from Transactions
group by
transaction_id
order by
[Sum] 
desc
) 
TT

--Q6

select prod_cat,sum(cast(total_amt as float)) 
as [Combined Revenue] 
from Transactions T1
left join 
[Product info] T2
on 
T1.prod_cat_code=T2.prod_cat_code
and 
T1.prod_subcat_code=T2.prod_sub_cat_code
where 
prod_cat in ('Electronics', 'Books')
group by
prod_cat

--Q7

select count(cust_id) 
as [Count >10]  
from (
select cust_id, 
count(transaction_id) 
as [Count] 
from Transactions
where 
qty>0
group by
cust_id
having
count(transaction_id)>10
) 
TT

--Q8

select sum(cast(total_amt as float)) 
as [Combined Revenue]
from Transactions T1
left join 
[Product info] T2
on 
T1.prod_cat_code=T2.prod_cat_code
and 
T1.prod_subcat_code=T2.prod_sub_cat_code
where 
prod_cat in ('Electronics', 'Clothing')
and 
Store_type='Flagship store'

--Q9

select T3.prod_subcat,
sum(cast(Total_amt as float)) 
as [Combined Revenue] 
from Transactions T1 
left join Customers T2
on cust_id=customer_Id
left join
[Product info] T3
on T1.prod_cat_code=T3.prod_cat_code
and
T1.prod_subcat_code=T3.prod_sub_cat_code
where 
prod_cat='Electronics' 
and
Gender='M'
group by
T3.prod_subcat
order by
[Combined Revenue]

--Q10

select Top 5 TT1.Prod_subcat,[Sales_Percent],[Return_Percent] 
from (
select prod_subcat, 
sum(Sales) 
as [Sales_Percent] 
from (
select prod_subcat,
(cast(total_amt as float)/ (select sum(cast(total_amt as float)) from Transactions
where qty>0))*100 
as [Sales]
from Transactions T1 
left join
[Product info] T2
on T1.prod_cat_code=T2.prod_cat_code
and
T1.prod_subcat_code=T2.prod_sub_cat_code
where 
qty>0
) 
TT
group by
prod_subcat
) 
TT1
left join(
select prod_subcat, 
sum([Return]) 
as [Return_Percent] 
from (
select prod_subcat,
(cast(Qty as float)/ (select sum(cast(Qty as float)) from Transactions
where Qty<0))*100 
as [Return]
from Transactions T1 
left join
[Product info] T2
on T1.prod_cat_code=T2.prod_cat_code
and
T1.prod_subcat_code=T2.prod_sub_cat_code
where 
qty<0
) 
TT
group by
prod_subcat
) 
TT2
on 
TT1.prod_subcat=TT2.prod_subcat
order by
Sales_Percent
desc

--Q11

select sum(cast (total_amt as float)) 
as [Revenue] 
from (
select *,
datediff(year,convert(date,DOB,105),convert(date,getdate(),105)) 
as [Age],
datediff(
day,convert(date,tran_date,105),(
select max(convert(date,tran_date,105)) from Transactions
)
) 
as [Last 30 Days] 
from Transactions
left join 
Customers
on cust_id=customer_Id
where 
datediff(year,convert(date,DOB,105),convert(date,getdate(),105)) between 25 and 35
and 
(datediff(
day,convert(date,tran_date,105),(
select max(convert(date,tran_date,105)) from Transactions
)
) 
 <=30
 )
 ) 
 TT

--Q12

select top 1 prod_cat, sum(cast(abs(qty) as float))as [Qty] from (
select prod_cat,tran_date,qty,total_amt, datediff(month,convert(date,tran_date,105),(
select max(convert(date,tran_date,105)) from Transactions
)) as [Months] from Transactions T1
left join
[Product info] T2
on T1.prod_cat_code=T2.prod_cat_code 
and
T1.prod_subcat_code=T2.prod_sub_cat_code
where
qty<0
and
datediff(month,convert(date,tran_date,105),(
select max(convert(date,tran_date,105)) from Transactions
)) <=3
) TT1
 group by
 prod_cat
order by
Qty
desc

--Q13

select * from (
select top 1 Store_type, sum(cast(total_amt as float)) as [Sales Amt] from Transactions
where qty>0
group by
Store_type
order by
[Sales Amt]
desc
) TT1
left join
(
select top 1 Store_type, sum(cast(qty as float)) as [Qty] from Transactions
where qty>0
group by
Store_type
order by
[Qty]
desc
 ) TT2
on TT1.Store_type=TT2.Store_type

--Q14

select prod_cat, 
avg(cast(total_amt as float)) 
as [Category Revenue],
(select avg(cast(total_amt as float)) from Transactions)
as [Overall Revenue] 
from Transactions T1
left join
[Product info] T2
on T1.prod_cat_code=T2.prod_cat_code
and 
T1.prod_subcat_code=T2.prod_sub_cat_code
group by
prod_cat
having
avg(cast(total_amt as float))>(select avg(cast(total_amt as float)) from Transactions)

--Q15

select prod_cat,prod_subcat,
sum(cast(total_amt as float)) 
as [Total_Revenue],
avg(cast(total_amt as float)) 
as [Average] 
from 
Transactions T1 left join
[Product info] T2
on 
T1.prod_cat_code=T2.prod_cat_code
and 
T1.prod_subcat_code=T2.prod_sub_cat_code
where 
prod_cat in 
(
select Top 5 prod_cat
from 
Transactions T1 left join
[Product info] T2
on 
T1.prod_cat_code=T2.prod_cat_code
and 
T1.prod_subcat_code=T2.prod_sub_cat_code
where 
qty>0
group by
prod_cat
order by
sum(cast(qty as float))
desc
)

group by
prod_cat,prod_subcat
