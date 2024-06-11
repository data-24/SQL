

/*---------------------------------------------------query1--------------------*/


create database challenge_thirtydays
use challenge_thirtydays
DROP TABLE IF EXISTS brands;
CREATE TABLE brands 
(
    brand1      VARCHAR(20),
    brand2      VARCHAR(20),
    year        INT,
    custom1     INT,
    custom2     INT,
    custom3     INT,
    custom4     INT
);
INSERT INTO brands VALUES ('apple', 'samsung', 2020, 1, 2, 1, 2);
INSERT INTO brands VALUES ('samsung', 'apple', 2020, 1, 2, 1, 2);
INSERT INTO brands VALUES ('apple', 'samsung', 2021, 1, 2, 5, 3);
INSERT INTO brands VALUES ('samsung', 'apple', 2021, 5, 3, 1, 2);
INSERT INTO brands VALUES ('google', NULL, 2020, 5, 9, NULL, NULL);
INSERT INTO brands VALUES ('oneplus', 'nothing', 2020, 5, 9, 6, 3);

SELECT * FROM brands;

with cte as
(
select *
,concat(brand1,brand2,year) as pair_id
,case when brand1<brand2 then concat(brand1,brand2,year)
else concat(brand2,brand1,year) end as pair
from brands),
cte_rn as
(
select * ,
row_number()over(partition by pair order by pair) as rn
from cte
)
select * from cte_rn where rn=1 or (custom1<>custom3 and custom2<>custom4)

------------------------------------------------------------------------------------

with cte as
(
select *
,case when brand1<brand2 then concat(brand1,brand2,year)
else concat(brand2,brand1,year) end as pair
from brands),
cte_rn as
(
select * ,
row_number()over(partition by pair order by pair) as rn
from cte
)
select * from cte_rn where rn=1 or (custom1<>custom3 and custom2<>custom4)


/*-----------query2----------------------------------*/

drop table if exists mountain_huts;
create table mountain_huts 
(
	id 			integer not null unique,
	name 		varchar(40) not null unique,
	altitude 	integer not null
);
insert into mountain_huts values (1, 'Dakonat', 1900);
insert into mountain_huts values (2, 'Natisa', 2100);
insert into mountain_huts values (3, 'Gajantut', 1600);
insert into mountain_huts values (4, 'Rifat', 782);
insert into mountain_huts values (5, 'Tupur', 1370);

drop table if exists trails;
create table trails 
(
	hut1 		integer not null,
	hut2 		integer not null
);
insert into trails values (1, 3);
insert into trails values (3, 2);
insert into trails values (3, 5);
insert into trails values (4, 5);
insert into trails values (1, 5);

select * from mountain_huts;
select * from trails;

with cte as
(
select t1.hut1 as starthutid ,m1.name as startname,m1.altitude as startaltitude,t1.hut2 as endhut
from mountain_huts m1
join trails t1 on m1.id=t1.hut1),

cte2 as
(
select t2.*,m2.name as endhutname,m2.altitude as endhutaltitude
,case when startaltitude> m2.altitude then 1 else 0 end as altitude_flag
from cte t2
join mountain_huts m2 on m2.id=t2.endhut
),
ctefinal as 
(
select case when altitude_flag=1  then starthutid else endhut end as start_hut
,case when altitude_flag=1 then startname else  endhutname  end as start_hut_name
,case when altitude_flag=1  then endhut  else starthutid end as end_hut
,case when altitude_flag=1 then endhutname else  startname end as end_hut_name
from cte2
)
select  c1.start_hut_name ,c1.end_hut_name as middlename,c2.end_hut_name
from ctefinal c1
join ctefinal c2 on c1.end_hut=c2.start_hut


--------------------------------------------------------------------------------------------------------------------
with cte_trails1 as
		(select t1.hut1 as start_hut, h1.name as start_hut_name
		 ,h1.altitude as start_hut_altitude, t1.hut2 as end_hut
		from mountain_huts h1
		join trails t1 on t1.hut1 = h1.id),
	cte_trails2 as
		(select t2.*, h2.name as end_hut_name, h2.altitude as end_hut_altitude
		, case when start_hut_altitude > h2.altitude then 1 else 0 end as altitude_flag
		from cte_trails1 t2
		join mountain_huts h2 on h2.id = t2.end_hut),
	cte_final as
		(select case when altitude_flag = 1 then start_hut else end_hut end as start_hut
		, case when altitude_flag = 1 then start_hut_name else end_hut_name end as start_hut_name
		, case when altitude_flag = 1 then end_hut else start_hut end as end_hut
		, case when altitude_flag = 1 then end_hut_name else start_hut_name end as end_hut_name
		from cte_trails2)
select c1.start_hut_name as startpt
, c1.end_hut_name as middlept
, c2.end_hut_name as endpt
from cte_final c1
join cte_final c2 on c1.end_hut = c2.start_hut;

-----------------------------------------------------------------------------------query5-------------------------------------
drop table if exists salary;
create table salary
(
	emp_id		int,
	emp_name	varchar(30),
	base_salary	int
);
insert into salary values(1, 'Rohan', 5000);
insert into salary values(2, 'Alex', 6000);
insert into salary values(3, 'Maryam', 7000);


drop table if exists income;
create table income
(
	id			int,
	income		varchar(20),
	percentage	int
);
insert into income values(1,'Basic', 100);
insert into income values(2,'Allowance', 4);
insert into income values(3,'Others', 6);


drop table if exists deduction;
create table deduction
(
	id			int,
	deduction	varchar(20),
	percentage	int
);
insert into deduction values(1,'Insurance', 5);
insert into deduction values(2,'Health', 6);
insert into deduction values(3,'House', 4);


drop table if exists emp_transaction;
create table emp_transaction
(
	emp_id		int,
	emp_name	varchar(50),
	trns_type	varchar(20),
	amount		numeric
);
insert into emp_transaction
select s.emp_id, s.emp_name, x.trns_type
, case when x.trns_type = 'Basic' then round(base_salary * (cast(x.percentage as decimal)/100),2)
	   when x.trns_type = 'Allowance' then round(base_salary * (cast(x.percentage as decimal)/100),2)
	   when x.trns_type = 'Others' then round(base_salary * (cast(x.percentage as decimal)/100),2)
	   when x.trns_type = 'Insurance' then round(base_salary * (cast(x.percentage as decimal)/100),2)
	   when x.trns_type = 'Health' then round(base_salary * (cast(x.percentage as decimal)/100),2)
	   when x.trns_type = 'House' then round(base_salary * (cast(x.percentage as decimal)/100),2) end as amount	   
from salary s
cross join (select income as trns_type, percentage from income
			union
			select deduction as trns_type, percentage from deduction) x;



select Employee
, Basic, Allowance, Others
, (Basic + Allowance + Others) as Gross
, Insurance, Health, House
, (Insurance + Health + House) as Total_Deductions
, ((Basic + Allowance + Others) - (Insurance + Health + House)) as Net_Pay
from 
    (
        select t.emp_name as Employee, t.trns_type, t.amount
        from emp_transaction t
        
    ) b
pivot 
    (
        sum(amount)
        for trns_type in ([Allowance],[Basic],[Health],[House],[Insurance],[Others])
    ) p;


select * from salary;
select * from income;
select * from deduction;
select * from emp_transaction;

---------------------------------my sol-----------------------------------------

with emp_transaction as
(
select s.emp_id, s.emp_name, x.trns_type,s.base_salary,
 case when x.trns_type = 'Basic' then round(base_salary * (x.percentage /100),2)
	   when x.trns_type = 'Allowance' then round(base_salary * (x.percentage /100),2)
	   when x.trns_type = 'Others' then round(base_salary * (x.percentage /100),2)
	   when x.trns_type = 'Insurance' then round(base_salary * (x.percentage /100),2)
	   when x.trns_type = 'Health' then round(base_salary * (x.percentage /100),2)
	   when x.trns_type = 'House' then round(base_salary * (x.percentage /100),2)

 end as amount
from salary s
cross join 
(
select income as trns_type, percentage  from  income 
union all 
select   deduction as trns_type, percentage  from deduction) x
order by 3)


select 
emp_name as Employee
,Basic
,Allowance
,Others
,(Allowance+Basic+Health) as Gross
,Insurance
,Health
,House
,(Insurance+Health+House) as Total_Deduction
, (Allowance+Basic+Health)-(Insurance+Health+House) as Net_Pay
from
(
SELECT
    emp_name,
    SUM(CASE WHEN trns_type = 'Basic' THEN amount ELSE 0 END) AS Basic ,
    SUM(CASE WHEN trns_type = 'Allowance' THEN amount ELSE 0 END) AS Allowance,
    SUM(CASE WHEN trns_type = 'Others' THEN amount ELSE 0 END) AS Others,
   
    SUM(CASE WHEN trns_type = 'Insurance' THEN amount ELSE 0 END) AS Insurance,
    SUM(CASE WHEN trns_type = 'Health' THEN amount ELSE 0 END) AS Health,
      SUM(CASE WHEN trns_type = 'House' THEN amount ELSE 0 END) AS House
FROM
   emp_transaction
GROUP BY
    emp_name) x


------------------------------Query6------------------------------------
drop table if exists  student_tests;
create table student_tests
(
	test_id		int,
	marks		int
);
insert into student_tests values(100, 55);
insert into student_tests values(101, 55);
insert into student_tests values(102, 60);
insert into student_tests values(103, 58);
insert into student_tests values(104, 40);
insert into student_tests values(105, 50);

select * from student_tests;

select test_id,marks from 
(
select *,
lag(marks,1,0) over(order by test_id) as prev_test_mark
 from student_tests) x
 where marks>prev_test_mark
 
 select *
from (select *, lag(marks,1,marks) over(order by test_id) as prev_test_mark
	from student_tests) x
where x.marks > prev_test_mark;

-----------------------------Query 7----------------------------------
drop table if exists Day_Indicator;
create table Day_Indicator
(
	Product_ID 		varchar(10),	
	Day_Indicator 	varchar(7),
	Dates			date
);


INSERT INTO Day_Indicator VALUES ('AP755', '1010101', '2024-03-04');
INSERT INTO Day_Indicator VALUES ('AP755', '1010101', '2024-03-05');
INSERT INTO Day_Indicator VALUES ('AP755', '1010101', '2024-03-06');
INSERT INTO Day_Indicator VALUES ('AP755', '1010101', '2024-03-07');
INSERT INTO Day_Indicator VALUES ('AP755', '1010101', '2024-03-08');
INSERT INTO Day_Indicator VALUES ('AP755', '1010101', '2024-03-09');
INSERT INTO Day_Indicator VALUES ('AP755', '1010101', '2024-03-10');
INSERT INTO Day_Indicator VALUES ('XQ802', '1000110', '2024-03-04');
INSERT INTO Day_Indicator VALUES ('XQ802', '1000110', '2024-03-05');
INSERT INTO Day_Indicator VALUES ('XQ802', '1000110', '2024-03-06');
INSERT INTO Day_Indicator VALUES ('XQ802', '1000110', '2024-03-07');
INSERT INTO Day_Indicator VALUES ('XQ802', '1000110', '2024-03-08');
INSERT INTO Day_Indicator VALUES ('XQ802', '1000110', '2024-03-09');
INSERT INTO Day_Indicator VALUES ('XQ802', '1000110', '2024-03-10');


select * from Day_Indicator;

select product_id,day_indicator,dates
from
(
select product_id, day_indicator, dates ,dayofweek(dates),((dayofweek(dates)+5)%7+1)
,case when substring( day_indicator,((dayofweek(dates)+5)%7+1),1)=1 then 'Include' else 'Exclude' end as flag
 from Day_Indicator)x
 where  flag='Include'
 
 -------------------------------
 select *
from (
	select * 
	, case when substring(day_indicator,(((datepart(dw, dates) + 5)%7) + 1),1) = '1' 
				then 'Include' else 'Exlcude' end as flag
	from Day_Indicator) x
where flag='Include';
 








----------------------------------------------------------query 13---------------------------------------------------
drop table if exists employee_managers;
create table employee_managers
(
	id			int,
	name		varchar(20),
	manager 	int
);
insert into employee_managers values (1, 'Sundar', null);
insert into employee_managers values (2, 'Kent', 1);
insert into employee_managers values (3, 'Ruth', 1);
insert into employee_managers values (4, 'Alison', 1);
insert into employee_managers values (5, 'Clay', 2);
insert into employee_managers values (6, 'Ana', 2);
insert into employee_managers values (7, 'Philipp', 3);
insert into employee_managers values (8, 'Prabhakar', 4);
insert into employee_managers values (9, 'Hiroshi', 4);
insert into employee_managers values (10, 'Jeff', 4);
insert into employee_managers values (11, 'Thomas', 1);
insert into employee_managers values (12, 'John', 15);
insert into employee_managers values (13, 'Susan', 15);
insert into employee_managers values (14, 'Lorraine', 15);
insert into employee_managers values (15, 'Larry', 1);

select * from employee_managers

select mng.name as manager,count(emp.name) as no_of_emp
from 
employee_managers emp
join employee_managers mng
on emp.manager=mng.id
group by mng.name order by count(emp.name) desc

-----------------------------------------------------Query 14-------------------------------------
drop table if exists invoice;
create table invoice
(
	serial_no		int,
	invoice_date	date
);
INSERT INTO invoice VALUES (330115, STR_TO_DATE('01-Mar-2024', '%d-%b-%Y'));
insert into invoice values (330120, STR_TO_DATE('01-Mar-2024','%d-%b-%Y'));
insert into invoice values (330121, STR_TO_DATE('01-Mar-2024','%d-%b-%Y'));
insert into invoice values (330122, STR_TO_DATE('02-Mar-2024','%d-%b-%Y'));
insert into invoice values (330125, STR_TO_DATE('02-Mar-2024','%d-%b-%Y'));

select serial_no  from invoice;

with recursive cte as 
(
select min(serial_no) n  from invoice
union 
select n+1 as n from cte
where n<(select max(serial_no) from invoice)
)
select n as missing_serial_no from cte
except
select serial_no  from invoice;
--------------------------------------------------------------------------------------------------query 11------------------------
drop table if exists hotel_ratings;
create table hotel_ratings
(
	hotel 		varchar(30),
	year		int,
	rating 		decimal
);
insert into hotel_ratings values('Radisson Blu', 2020, 4.8);
insert into hotel_ratings values('Radisson Blu', 2021, 3.5);
insert into hotel_ratings values('Radisson Blu', 2022, 3.2);
insert into hotel_ratings values('Radisson Blu', 2023, 3.8);
insert into hotel_ratings values('InterContinental', 2020, 4.2);
insert into hotel_ratings values('InterContinental', 2021, 4.5);
insert into hotel_ratings values('InterContinental', 2022, 1.5);
insert into hotel_ratings values('InterContinental', 2023, 3.8);

select * from hotel_ratings;

with cte as
(
select *,round(avg(rating) over (partition by hotel order by year range between unbounded preceding and unbounded following),2)as avg_rating
from hotel_ratings ),
cte_rnk as 
(select *,(avg_rating -rating ) as ouliiers,rank()over (partition by hotel order by avg_rating -rating) from cte)
select * from cte_rnk

with cte as 
(
select *,round(avg(rating) over (partition by hotel order by year range  between unbounded preceding and unbounded following),2) as avg_rating from hotel_ratings),
rnk_cte as
(select * ,abs(avg_rating-rating) as outliers,rank()over(partition by hotel order by abs(avg_rating-rating)desc)rnk 
from cte)
select * from rnk_cte where rnk>1


with cte as
		(select *, round(avg(rating) over(partition by hotel order by year
									range between unbounded preceding and unbounded following)
						,2) as avg_rating
		from hotel_ratings),
	cte_rnk as
		(select *,abs(avg_rating-rating)
		, rank() over(partition by hotel order by abs(avg_rating-rating) desc ) rnk
		from cte)
select hotel, year, rating
from cte_rnk
where rnk > 1
order by hotel,year ;


--------------------------------------------query 10---------------------
drop table if exists auto_repair;
create table auto_repair
(
	client			varchar(20),
	auto			varchar(20),
	repair_date		int,
	indicator		varchar(20),
	value			varchar(20)
);
insert into auto_repair values('c1','a1',2022,'level','good');
insert into auto_repair values('c1','a1',2022,'velocity','90');
insert into auto_repair values('c1','a1',2023,'level','regular');
insert into auto_repair values('c1','a1',2023,'velocity','80');
insert into auto_repair values('c1','a1',2024,'level','wrong');
insert into auto_repair values('c1','a1',2024,'velocity','70');
insert into auto_repair values('c2','a1',2022,'level','good');
insert into auto_repair values('c2','a1',2022,'velocity','90');
insert into auto_repair values('c2','a1',2023,'level','wrong');
insert into auto_repair values('c2','a1',2023,'velocity','50');
insert into auto_repair values('c2','a2',2024,'level','good');
insert into auto_repair values('c2','a2',2024,'velocity','80');

select * from auto_repair;

with cte as(
select v.value as velocity,l.value as level  from auto_repair v
join  
auto_repair l on  v.auto=l.auto and v.repair_date=l.repair_date and l.client=v.client
 where l.indicator='level' and v.indicator='velocity'
   )
select velocity, 
    count(case when level ='good' then 1 end )as good,
    count(case when level ='wrong' then 1 end )as wrong,
    count(case when level ='regular' then 1 end )as regular
     from cte
 group by velocity




SELECT 
    velocity,
    COUNT(CASE WHEN level = 'good' THEN 1 END) AS good,
    COUNT(CASE WHEN level = 'wrong' THEN 1 END) AS wrong,
    COUNT(CASE WHEN level = 'regular' THEN 1 END) AS regular
FROM 
    (SELECT 
        v.value AS velocity, 
        l.value AS level
    FROM 
        auto_repair l
    JOIN 
        auto_repair v ON v.auto = l.auto 
                     AND v.repair_date = l.repair_date 
                     AND l.client = v.client
    WHERE 
        l.indicator = 'level'
        AND v.indicator = 'velocity'
    ) AS subquery
GROUP BY 
    velocity;







select *
from 
    (
        select v.value velocity, l.value level,count(1) as count
        from auto_repair l
        join auto_repair v on v.auto=l.auto and v.repair_date=l.repair_date and l.client=v.client
        where l.indicator='level'
        and v.indicator='velocity'
        group by v.value,l.value
    ) bq
pivot 
    (
        count(level)
        for level in ([good],[wrong],[regular])
    ) pq;


--------query 9------------------------------
drop TABLE if exists orders;
CREATE TABLE orders 
(
	customer_id 	INT,
	dates 			DATE,
	product_id 		INT
);
INSERT INTO orders VALUES
(1, '2024-02-18', 101),
(1, '2024-02-18', 102),
(1, '2024-02-19', 101),
(1, '2024-02-19', 103),
(2, '2024-02-18', 104),
(2, '2024-02-18', 105),
(2, '2024-02-19', 101),
(2, '2024-02-19', 106); 
select dates, cast(product_id as varchar) as products 
from orders
union
select dates, string_agg(cast(product_id as varchar),',') as products
from orders
group by customer_id, dates
order by dates, products;

select * from orders;
select dates,product_id as  products from orders
union 
SELECT dates, GROUP_CONCAT(product_id) AS products
FROM orders
GROUP BY customer_id, dates;
order by dates,product_id

use challenge_thirtydays

------------------------------------------------------------------------------query 8---------------------------------------------------
drop table if exists job_skills;
create table job_skills
(
	row_id		int,
	job_role	varchar(20),
	skills		varchar(20)
);
insert into job_skills values (1, 'Data Engineer', 'SQL');
insert into job_skills values (2, null, 'Python');
insert into job_skills values (3, null, 'AWS');
insert into job_skills values (4, null, 'Snowflake');
insert into job_skills values (5, null, 'Apache Spark');
insert into job_skills values (6, 'Web Developer', 'Java');
insert into job_skills values (7, null, 'HTML');
insert into job_skills values (8, null, 'CSS');
insert into job_skills values (9, 'Data Scientist', 'Python');
insert into job_skills values (10, null, 'Machine Learning');
insert into job_skills values (11, null, 'Deep Learning');
insert into job_skills values (12, null, 'Tableau');

select * from job_skills;

with cte as 
	(
    select *
	, sum(case when job_role is null then 0 else 1 end) over(order by row_id) as segment
	from job_skills
    )
select row_id
, first_value(job_role) over(partition by segment order by row_id) as job_role
, skills
from cte;



-- Solution 2 - WITHOUT Using Window function
with recursive cte as
	(select row_id, job_role, skills 
	 from job_skills where row_id=1
	 union all
	 select e.row_id, case when e.job_role is null then cte.job_role else e.job_role end as job_role
	 , e.skills
	 from job_skills e
	 join cte on e.row_id = cte.row_id + 1
	)
select * from cte;



----------------------
-----------------first solution-------------------
with cte as 
		(select *,
		sum(case when job_role is null then 0 else 1 end ) over(order by row_id) as segment
		from job_skills
		)
select  row_id,
first_value(job_role)over(partition by segment order by row_id) as job_role,skills
 from  cte
 
 
 ---------------------recurssive cte------------------
 
 
 select * from job_skills
 
 with recursive cte as 
    (
    select row_id,job_role,skills from job_skills where  row_id=1
    union all
    select e.row_id,case when e.job_role is null then cte.job_role else e.job_role end as job_role,e.skills
    from 
    job_skills e 
    join cte c on e.row_id=cte.row_id+1
    )
    select * from cte
    
    
    

with recursive cte as
	(
        select row_id, job_role, skills 
		 from job_skills where row_id=1
		 union all
		 select e.row_id,case when e.job_role is null then cte.job_role else e.job_role end as job_role
		 , e.skills
		 from job_skills e
		 join cte on e.row_id=cte.row_id + 1
	)
select * from cte
    
    
    -----------------------------question 13-------------------------------------
    
drop table if exists employee_managers;
create table employee_managers
(
	id			int,
	name		varchar(20),
	manager 	int
);
insert into employee_managers values (1, 'Sundar', null);
insert into employee_managers values (2, 'Kent', 1);
insert into employee_managers values (3, 'Ruth', 1);
insert into employee_managers values (4, 'Alison', 1);
insert into employee_managers values (5, 'Clay', 2);
insert into employee_managers values (6, 'Ana', 2);
insert into employee_managers values (7, 'Philipp', 3);
insert into employee_managers values (8, 'Prabhakar', 4);
insert into employee_managers values (9, 'Hiroshi', 4);
insert into employee_managers values (10, 'Jeff', 4);
insert into employee_managers values (11, 'Thomas', 1);
insert into employee_managers values (12, 'John', 15);
insert into employee_managers values (13, 'Susan', 15);
insert into employee_managers values (14, 'Lorraine', 15);
insert into employee_managers values (15, 'Larry', 1);

select * from employee_managers;


select man.name,count(emp.name)
from employee_managers emp
join employee_managers man on emp.manager=man.id
group by man.name
order by count(emp.name) desc


    
    
    select mng.name as manager, count(emp.name) as employee
from employee_managers emp
join employee_managers mng on emp.manager = mng.id
group by mng.name
order by employee desc;


--------------------------------query14 ------------------

drop table if exists invoice;
create table invoice
(
	serial_no		int,
	invoice_date	date
);
insert into invoice values (330115, STR_TO_DATE('01-Mar-2024','%d-%b-%Y'));   STR_TO_DATE('01-Mar-2024', '%d-%b-%Y')
insert into invoice values (330120, STR_TO_DATE('01-Mar-2024','%d-%b-%Y'));
insert into invoice values (330121, STR_TO_DATE('01-Mar-2024','%d-%b-%Y'));
insert into invoice values (330122, STR_TO_DATE('02-Mar-2024','%d-%b-%Y'));
insert into invoice values (330125, STR_TO_DATE('02-Mar-2024','%d-%b-%Y'));

select * from invoice;
with recursive cte as
(
select min(serial_no) as n from invoice 
union 
select (n+1) from cte
where n<(select max(serial_no) from invoice)
)
select n as missing_serial from cte
except 
select serial_no from invoice
order by 1;


-- Solution 2:
with recursive cte as
	(select min(serial_no) as n from invoice 
	union
	select n+1 as n
	from cte 
	where n < (select max(serial_no) from invoice)
	 )
select n as missing_serial_no from cte	 
except 
select serial_no from invoice
order by 1;
    -------------------------------query 3--------------------------
    DROP TABLE IF EXISTS FOOTER;
CREATE TABLE FOOTER 
(
	id 			INT PRIMARY KEY,
	car 		VARCHAR(20), 
	length 		INT, 
	width 		INT, 
	height 		INT
);

INSERT INTO FOOTER VALUES (1, 'Hyundai Tucson', 15, 6, NULL);
INSERT INTO FOOTER VALUES (2, NULL, NULL, NULL, 20);
INSERT INTO FOOTER VALUES (3, NULL, 12, 8, 15);
INSERT INTO FOOTER VALUES (4, 'Toyota Rav4', NULL, 15, NULL);
INSERT INTO FOOTER VALUES (5, 'Kia Sportage', NULL, NULL, 18); 

SELECT * FROM FOOTER;

select *
from (  select car from footer where car is not null order by id desc limit 1) car
cross join( select length from footer where length is not null order by id desc limit 1  ) lenght
cross join (select width from footer where width is not null order by id desc limit 1) width
cross join(select height from footer where height is not null order by id desc limit 1) height
---sol1-----------------------------------------
select *
from (SELECT car FROM FOOTER where car is not null order by id desc limit 1) car
cross join (SELECT length FROM FOOTER where length is not null order by id desc limit 1) length
cross join (SELECT width FROM FOOTER where width is not null order by id desc limit 1) width
cross join (SELECT height FROM FOOTER where height is not null order by id desc limit 1) height;


    -----------sol 2--------------------
    
    with cte as
    (
      select *
      ,sum(case when car is null then 0 else 1 end) over(order by id) as car_segment
      ,sum(case when length is null then 0 else 1 end) over(order by id) as length_segment
      ,sum(case when width is null then 0 else 1 end) over(order by id) as width_segment
      ,sum(case when height is null then 0 else 1 end) over(order by id) as height_segment
      from footer
    )
    select 
    first_value(car)over(partition by car_segment order by id) as new_car
    ,first_value(length)over(partition by length_segment order by id) as new_length
    ,first_value(width)over(partition by width_segment order by id)as new_width
    ,first_value(height)over(partition by height_segment order by id) as new_height
    from cte
    order by id desc limit 1
 ----------------------------------------------------------------------   
    with cte as
	(select *
	, sum(case when car is null then 0 else 1 end) over(order by id) as car_segment
	, sum(case when length is null then 0 else 1 end) over(order by id) as length_segment
	, sum(case when width is null then 0 else 1 end) over(order by id) as width_segment
	, sum(case when height is null then 0 else 1 end) over(order by id) as height_segment
	from footer)
select 
  first_value(car) over(partition by car_segment order by id) as new_car
, first_value(length) over(partition by length_segment order by id) as new_length 
, first_value(width) over(partition by width_segment order by id) as new_width
, first_value(height) over(partition by height_segment order by id) as new_height
from cte 
order by id desc
limit 1;
----------------------------query 4------------------------------
drop table if exists Q4_data;
create table Q4_data
(
	id			int,
	name		varchar(20),
	location	varchar(20)
);
insert into Q4_data values(1,null,null);
insert into Q4_data values(2,'David',null);
insert into Q4_data values(3,null,'London');
insert into Q4_data values(4,null,null);
insert into Q4_data values(5,'David',null);

select * from Q4_data;



select max(id),max(name),max(location)from Q4_data

select min(id),max(name),max(location)from Q4_data



select max(id) as id
, min(name) as name
, min(location) as location
from Q4_data;
    
    ----------query 17----------------------------
    
drop table if exists user_login;
create table user_login
(
	user_id		int,
	login_date	date
);

INSERT INTO user_login VALUES(1, STR_TO_DATE('01/03/2024','%d/%m/%Y'));



insert into user_login values(1, STR_TO_DATE('02/03/2024','%d/%m/%Y'));
insert into user_login values(1,STR_TO_DATE('03/03/2024','%d/%m/%Y'));
insert into user_login values(1, STR_TO_DATE('04/03/2024','%d/%m/%Y'));
insert into user_login values(1, str_to_date('06/03/2024','%d/%m/%Y'));
insert into user_login values(1, str_to_date('10/03/2024','%d/%m/%Y'));
insert into user_login values(1, STR_TO_DATE('11/03/2024','%d/%m/%Y'));
insert into user_login values(1,STR_TO_DATE ('12/03/2024','%d/%m/%Y'));
insert into user_login values(1, STR_TO_DATE('13/03/2024','%d/%m/%Y'));
insert into user_login values(1, STR_TO_DATE('14/03/2024','%d/%m/%Y'));
insert into user_login values(1, STR_TO_DATE('20/03/2024','%d/%m/%Y'));
insert into user_login values(1, STR_TO_DATE('25/03/2024','%d/%m/%Y'));
insert into user_login values(1, STR_TO_DATE('26/03/2024','%d/%m/%Y'));
insert into user_login values(1, STR_TO_DATE('27/03/2024','%d/%m/%Y'));
insert into user_login values(1,STR_TO_DATE ('28/03/2024','%d/%m/%Y'));
insert into user_login values(1, STR_TO_DATE('29/03/2024','%d/%m/%Y'));
insert into user_login values(1, STR_TO_DATE('30/03/2024','%d/%m/%Y'));
insert into user_login values(2,STR_TO_DATE ('01/03/2024','%d/%m/%Y'));
insert into user_login values(2, STR_TO_DATE('02/03/2024','%d/%m/%Y'));
insert into user_login values(2, STR_TO_DATE('03/03/2024','%d/%m/%Y'));
insert into user_login values(2,STR_TO_DATE('04/03/2024','%d/%m/%Y'));
insert into user_login values(3,STR_TO_DATE('01/03/2024','%d/%m/%Y'));
insert into user_login values(3,STR_TO_DATE('02/03/2024','%d/%m/%Y'));
insert into user_login values(3, STR_TO_DATE('03/03/2024','%d/%m/%Y'));
insert into user_login values(3,STR_TO_DATE('04/03/2024','%d/%m/%Y'));
insert into user_login values(3, STR_TO_DATE('04/03/2024','%d/%m/%Y'));
insert into user_login values(3,STR_TO_DATE('04/03/2024','%d/%m/%Y'));
insert into user_login values(3,STR_TO_DATE('05/03/2024','%d/%m/%Y'));
insert into user_login values(4, STR_TO_DATE('01/03/2024','%d/%m/%Y'));
insert into user_login values(4,STR_TO_DATE('02/03/2024','%d/%m/%Y'));
insert into user_login values(4, STR_TO_DATE('03/03/2024','%d/%m/%Y'));
insert into user_login values(4,STR_TO_DATE('04/03/2024','%d/%m/%Y'));
insert into user_login values(4, STR_TO_DATE('04/03/2024','%d/%m/%Y'));


select * from user_login;
select * ,dense_rank()over(partition by user_id order by user_id,login_date)as date_group from user_login
	, dateadd(day, -dense_rank() over(partition by user_id order by user_id,login_date), login_date) as date_group
    from user_login
    
    
    -----query 19-------------------------------
    use challenge_thirtydays
    -- Given table showcases details of pizza delivery order for the year of 2023.
-- If an order is delayed then the whole order is given for free. Any order that takes 30 minutes more than the expected time is considered as delayed order. 
-- Identify the percentage of delayed order for each month and also display the total no of free pizzas given each month.

DROP TABLE IF EXISTS pizza_delivery;
CREATE TABLE pizza_delivery 
(
	order_id 			INT,
	order_time 			TIMESTAMP,
	expected_delivery 	TIMESTAMP,
	actual_delivery 	TIMESTAMP,
	no_of_pizzas 		INT,
	price 				DECIMAL
);


-- Data to this table can be found in CSV File

select * from pizza_delivery;

select 
DATE_FORMAT(order_time, '%b-%Y') as date

,round((sum(case when TIMESTAMPDIFF(MINUTE, order_time, actual_delivery) >30 then 1 else 0 end )/count(1))*100,2) as percentage
 ,sum(case when TIMESTAMPDIFF(MINUTE, order_time, actual_delivery) >30 then no_of_pizzas else 0 end )as free_pizzas
 from pizza_delivery 
 where actual_delivery is not null
 group by DATE_FORMAT(order_time, '%b-%Y')
 ORDER BY MONTH(STR_TO_DATE(DATE_FORMAT(order_time, '%b-%Y'), '%b-%Y'))
;





SELECT 
    DATE_FORMAT(order_time, '%Y-%m') AS date,
    ROUND((SUM(CASE WHEN TIMESTAMPDIFF(MINUTE, order_time, actual_delivery) > 30 THEN 1 ELSE 0 END) / COUNT(1)) * 100, 2) AS percentage,
    SUM(CASE WHEN TIMESTAMPDIFF(MINUTE, order_time, actual_delivery) > 30 THEN no_of_pizzas ELSE 0 END) AS free_pizzas
FROM 
    pizza_delivery 
WHERE 
    actual_delivery 
GROUP BY 
    DATE_FORMAT(order_time, '%Y-%m')
ORDER BY 
    DATE_FORMAT(order_time, '%Y-%m');

use challenge_thirtydays

-- Find the median ages of countries

drop table if exists people;
create table people
(
	id			int,
	country		varchar(20),
	age			int
);
insert into people values(1 ,'Poland',10 );
insert into people values(2 ,'Poland',5  );
insert into people values(3 ,'Poland',34   );
insert into people values(4 ,'Poland',56);
insert into people values(5 ,'Poland',45  );
insert into people values(6 ,'Poland',60  );
insert into people values(7 ,'India',18   );
insert into people values(8 ,'India',15   );
insert into people values(9 ,'India',33 );
insert into people values(10,'India',38 );
insert into people values(11,'India',40 );
insert into people values(12,'India',50  );
insert into people values(13,'USA',20 );
insert into people values(14,'USA',23 );
insert into people values(15,'USA',32 );
insert into people values(16,'USA',54 );
insert into people values(17,'USA',55  );
insert into people values(18,'Japan',65  );
insert into people values(19,'Japan',6  );
insert into people values(20,'Japan',58  );
insert into people values(21,'Germany',54  );
insert into people values(22,'Germany',6  );
insert into people values(23,'Malaysia',44  );

select * from people;

select id,country,age from
(
select *,row_number()over(partition by country order by age) as rnk 
,count(id)over(partition by country  order by age range between unbounded preceding and unbounded following) as number
from people)
x
where rnk >=number/2 and rnk<=number/2 +1
---------------------------query 15------------------------
DROP TABLE IF EXISTS Friends;

CREATE TABLE Friends
(
	Friend1 	VARCHAR(10),
	Friend2 	VARCHAR(10)
);
INSERT INTO Friends VALUES ('Jason','Mary');
INSERT INTO Friends VALUES ('Mike','Mary');
INSERT INTO Friends VALUES ('Mike','Jason');
INSERT INTO Friends VALUES ('Susan','Jason');
INSERT INTO Friends VALUES ('John','Mary');
INSERT INTO Friends VALUES ('Susan','Mary');

select * from Friends;

with all_friends as
(
select friend1,friend2 from friends
union all
select friend2,friend1 from friends
)
select  distinct f.* 
,count(af.friend2) over(partition by f.friend1,f.friend2 order by  f.friend1,f.friend2 
range between unbounded preceding and unbounded following) as mutualfrnds
from friends f
left join all_friends af on f.friend1=af.friend1    ----(friends of jason)
 and af.friend2 in(select af2.friend2 from all_friends af2 where af2.friend1=f.friend2)  ---(friends of marry)
order by 1


-----query 28-----
-- Find length of comma seperated values in items field
use challenge_thirtydays
drop table if exists item;
create table item
(
	id		int,
	items	varchar(50)
);
insert into item values(1, '22,122,1022');
insert into item values(2, ',6,0,9999');
insert into item values(3, '100,2000,2');
insert into item values(4, '4,44,444,4444');

select * from item;

SELECT 
    id, 
    GROUP_CONCAT(CHAR_LENGTH(value)) AS lengths
FROM 
    item
CROSS JOIN 
    (
        SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(items, ',', numbers.n), ',', -1)) AS value
        FROM item
        CROSS JOIN (
            SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
            -- Add more SELECT statements if you expect more than 4 values per item
        ) AS numbers
        WHERE numbers.n <= LENGTH(items) - LENGTH(REPLACE(items, ',', '')) + 1
    ) AS split_values
GROUP BY 
    id;

select id,strinf_agg(len(value),',') as lengths
from item
cross apply string_split(items,',')
group by id

--------------------------------------------------question 29-----------------
use challenge_thirtydays
PROBLEM STATEMENT: Given table provides login and logoff details of one user.
Generate a report to reqpresent the different periods (in mins) when user was logged in.
*/
drop table if exists login_details;
create table login_details
(
	times	time,
	status	varchar(3)
);
insert into login_details values('10:00:00', 'on');
insert into login_details values('10:01:00', 'on');
insert into login_details values('10:02:00', 'on');
insert into login_details values('10:03:00', 'off');
insert into login_details values('10:04:00', 'on');
insert into login_details values('10:05:00', 'on');
insert into login_details values('10:06:00', 'off');
insert into login_details values('10:07:00', 'off');
insert into login_details values('10:08:00', 'off');
insert into login_details values('10:09:00', 'on');
insert into login_details values('10:10:00', 'on');
insert into login_details values('10:11:00', 'on');
insert into login_details values('10:12:00', 'on');
insert into login_details values('10:13:00', 'off');
insert into login_details values('10:14:00', 'off');
insert into login_details values('10:15:00', 'on');
insert into login_details values('10:16:00', 'off');
insert into login_details values('10:17:00', 'off');

select * from login_details;

with cte as
(
 select * ,row_number()over()  as rnk
 from login_details
 )
 

----------------------------question 30-----------------------------

use challenge_thirtydays

/*
PROBLEM STATEMENT: Given tables represent the marks scored by engineering students.
Create a report to display the following results for each student.
  - Student_id, Student name
  - Total Percentage of all marks
  - Failed subjects (must be comma seperated values in case of multiple failed subjects)
  - Result (if percentage >= 70% then 'First Class', if >= 50% & <=70% then 'Second class', if <=50% then 'Third class' else 'Fail'.
  			The result should be Fail if a students fails in any subject irrespective of the percentage marks)
	
	*** The sequence of subjects in student_marks table match with the sequential id from subjects table.
	*** Students have the option to choose either 4 or 5 subjects only.
*/

drop table if exists student_marks;
drop table if exists students;
drop table if exists subjects;

create table students
(
	roll_no		varchar(20) primary key,
	name		varchar(30)		
);
insert into students values('2GR5CS011', 'Maryam');
insert into students values('2GR5CS012', 'Rose');
insert into students values('2GR5CS013', 'Alice');
insert into students values('2GR5CS014', 'Lilly');
insert into students values('2GR5CS015', 'Anna');
insert into students values('2GR5CS016', 'Zoya');


create table student_marks
(
	student_id		varchar(20) primary key references students(roll_no),
	subject1		int,
	subject2		int,
	subject3		int,
	subject4		int,
	subject5		int,
	subject6		int
);
insert into student_marks values('2GR5CS011', 75, NULL, 56, 69, 82, NULL);
insert into student_marks values('2GR5CS012', 57, 46, 32, 30, NULL, NULL);
insert into student_marks values('2GR5CS013', 40, 52, 56, NULL, 31, 40);
insert into student_marks values('2GR5CS014', 65, 73, NULL, 81, 33, 41);
insert into student_marks values('2GR5CS015', 98, NULL, 94, NULL, 90, 20);
insert into student_marks values('2GR5CS016', NULL, 98, 98, 81, 84, 89);


create table subjects
(
	id				varchar(20) primary key,
	name			varchar(30),
	pass_marks  	int check (pass_marks>=30)
);
insert into subjects values('S1', 'Mathematics', 40);
insert into subjects values('S2', 'Algorithms', 35);
insert into subjects values('S3', 'Computer Networks', 35);
insert into subjects values('S4', 'Data Structure', 40);
insert into subjects values('S5', 'Artificial Intelligence', 30);
insert into subjects values('S6', 'Object Oriented Programming', 35);


select * from students;
select * from student_marks;
select * from subjects;


select student_id,s.name,column1 as subject_code,column2 as marks
from student_marks sm
cross join lateral (values('subject1',subject1),('subject2',subject2),('subject3',subject3),('subject4',subject4),('subject5',subject5),
('subject6',subject6))x
join students s on s.roll_no=sm.student_id
where column2 is not null



with cte as
(
SELECT student_id, 'subject1' AS subject_code, subject1 AS marks FROM student_marks
UNION
SELECT student_id, 'subject2' AS subject_code, subject2 AS marks FROM student_marks
UNION
SELECT student_id, 'subject3' AS subject_code, subject3 AS marks FROM student_marks
UNION
SELECT student_id, 'subject4' AS subject_code, subject4 AS marks FROM student_marks
UNION
SELECT student_id, 'subject5' AS subject_code, subject5 AS marks FROM student_marks
UNION
SELECT student_id, 'subject6' AS subject_code, subject6 AS marks FROM student_marks
),
cte_st as
(
		select  *
		from cte
		join students s on s.roll_no=cte.student_id
		where cte.marks is not null
),
cte_final as
(
select student_id,name,subject_code,marks
from cte_st
),
cte_sub as 
(
select subject_code,subject_name,pass_marks  from
(
		SELECT row_number() over (order by ordinal_position ) as rnk,column_name as subject_code
		 FROM information_schema.columns  WHERE
		 TABLE_SCHEMA = 'challenge_thirtydays'
		 and table_name='student_marks'
		 and column_name like'subject%'
         )a
join (
		SELECT row_number() over (order by id ) as rnk,name as subject_name,pass_marks
		 FROM subjects
         ) b on b.rnk=a.rnk),
         
cte_agg as
   (
select student_id,name
,round(avg(marks),2) as percentage_marks
, GROUP_CONCAT(CASE WHEN marks > pass_marks THEN NULL ELSE subject_name END SEPARATOR ' ') AS failed_subject
 from cte_final fn
join cte_sub sb on sb.subject_code=fn.subject_code
group by student_id,name
)
select student_id,name, percentage_marks,coalesce( failed_subject,'-')
,case when failed_subject is not null then'failed'
 when percentage_marks >70 then 'first_class'
 when percentage_marks between 50 and 70  then 'second_class'
 when percentage_marks <50 then 'third_class' end as result
 from cte_agg


------------query 29----------------------------
/*
PROBLEM STATEMENT: Given table provides login and logoff details of one user.
Generate a report to reqpresent the different periods (in mins) when user was logged in.
*/
drop table if exists login_details;
create table login_details
(
	times	time,
	status	varchar(3)
);
insert into login_details values('10:00:00', 'on');
insert into login_details values('10:01:00', 'on');
insert into login_details values('10:02:00', 'on');
insert into login_details values('10:03:00', 'off');
insert into login_details values('10:04:00', 'on');
insert into login_details values('10:05:00', 'on');
insert into login_details values('10:06:00', 'off');
insert into login_details values('10:07:00', 'off');
insert into login_details values('10:08:00', 'off');
insert into login_details values('10:09:00', 'on');
insert into login_details values('10:10:00', 'on');
insert into login_details values('10:11:00', 'on');
insert into login_details values('10:12:00', 'on');
insert into login_details values('10:13:00', 'off');
insert into login_details values('10:14:00', 'off');
insert into login_details values('10:15:00', 'on');
insert into login_details values('10:16:00', 'off');
insert into login_details values('10:17:00', 'off');

select * from login_details;

with cte as
(
	select *
	
	,rn-row_number()over(order by times) as grp
	from 
	(
		select *,
		row_number()over(order by times) as rn
		from login_details
	) x
	where status ='on'
),
cte_grp as
(
select distinct
first_value(times)over(partition by grp order by grp,times)as log_on
,last_value(times)over(partition by grp order by grp,times range between unbounded preceding and unbounded following)as last_log_on
 from cte),
 cte_final as
 (
 select log_on ,lead(times) over(order by times) as log_off
 from login_details l
 left join cte_grp ct on l.times=ct.last_log_on
 )
 select *,
 TIMESTAMPDIFF(MINUTE, log_on,log_off) AS duration
 from cte_final
 where log_on is not null
 
 
 
  
 
 
 
 
 
 WITH cte AS (
    SELECT *,
           rn - ROW_NUMBER() OVER (ORDER BY times) AS grp
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (ORDER BY times) AS rn
        FROM login_details
    ) x
    WHERE status = 'on'
),
cte_grp AS (
    SELECT DISTINCT
           FIRST_VALUE(times) OVER (PARTITION BY grp ORDER BY grp, times) AS log_on,
           LAST_VALUE(times) OVER (PARTITION BY grp ORDER BY grp, times RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_log_on
    FROM cte
),
cte_final AS (
    SELECT log_on, LEAD(times) OVER (ORDER BY times) AS log_off
    FROM login_details l
    LEFT JOIN cte_grp ct ON l.times = ct.last_log_on
)
SELECT *
,
      TIMESTAMPDIFF(MINUTE, log_on, log_off) AS duration
FROM cte_final
WHERE log_on IS NOT NULL;

 
 
 
 
 
 
 
 
 
 
