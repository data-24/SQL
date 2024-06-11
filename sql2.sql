use challenge_thirtydays

-----------------------------------------------------------------------------------------------Query 1 Remove Redundant Pair---------------------------------------
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
select * ,
case when brand1<brand2 then concat(brand1,brand2,year)
else concat(brand2,brand1,year) end as pair_id from brands
),
cte_rn as 
(select *
,row_number()over(partition by pair_id order by pair_id) rnk
 from 
cte
)
select * from cte_rn where  custom1<>custom3 and custom2<>custom4 or
rnk=1 
---------------------------------------Query21------------------
drop table if exists user_sessions;
create table user_sessions
(
	session_id				int,
	user_id					varchar(10),
	session_starttime		timestamp, -- In MSSQL replace timestamp with datetime2
	session_endtime			timestamp, -- In MSSQL replace timestamp with datetime2
	platform				varchar(20)
);
insert into user_sessions values(1	,'U1','2020-01-01 12:14:28','2020-01-01 12:16:08','Windows');
insert into user_sessions values(2	,'U1','2020-01-01 18:23:50','2020-01-01 18:24:00','Windows');
insert into user_sessions values(3	,'U1','2020-01-01 08:15:00','2020-01-01 08:20:00','IPhone');
insert into user_sessions values(4	,'U2','2020-01-01 10:53:10','2020-01-01 10:53:30','IPhone');
insert into user_sessions values(5	,'U2','2020-01-01 18:25:14','2020-01-01 18:27:53','IPhone');
insert into user_sessions values(6	,'U2','2020-01-01 11:28:13','2020-01-01 11:31:33','Windows');
insert into user_sessions values(7	,'U3','2020-01-01 06:46:20','2020-01-01 06:58:13','Android');
insert into user_sessions values(8	,'U3','2020-01-01 10:53:10','2020-01-01 10:53:50','Android');
insert into user_sessions values(9	,'U3','2020-01-01 13:13:13','2020-01-01 13:34:34','Windows');
insert into user_sessions values(10 ,'U4','2020-01-01 08:12:00','2020-01-01 12:23:11','Windows');
insert into user_sessions values(11 ,'U4','2020-01-01 21:54:03','2020-01-01 21:54:04','IPad');


drop table if exists post_views;
create table post_views
(
	session_id 		int,
	post_id			int,
	perc_viewed		float
);
insert into post_views values(1,1,2);
insert into post_views values(1,2,4);
insert into post_views values(1,3,1);
insert into post_views values(2,1,20);
insert into post_views values(2,2,10);
insert into post_views values(2,3,10);
insert into post_views values(2,4,21);
insert into post_views values(3,2,1);
insert into post_views values(3,4,1);
insert into post_views values(4,2,50);
insert into post_views values(4,3,10);
insert into post_views values(6,2,2);
insert into post_views values(8,2,5);
insert into post_views values(8,3,2.5);


select * from user_sessions;
select * from post_views;

with cte as
(
SELECT vv.*,
       TIMESTAMPDIFF(SECOND, ss.session_starttime, ss.session_endtime) AS total_seconds
FROM user_sessions ss 
JOIN post_views vv ON ss.session_id = vv.session_id)
select post_id,
sum((perc_viewed/100)*total_seconds)  as view_time
from cte 
group by post_id
having view_time>5

---------question 3-----------------------
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

select * from
(
select car from footer where car is not null order by id desc limit 1) car
cross join (select length from footer where length is not null order by id desc limit 1)length
cross join (select width from footer where width is not null order by id desc limit 1)width
cross join (select height from footer where height is not null order by id desc limit 1)footer
-----------------sol2 -----------------------------


with cte as
(select *,
sum(case when car is null then 0 else 1 end)over(order by id) as car_flag
,sum(case when length is null then 0 else 1 end )over(order by id)as length_flag
,sum(case when width is null then 0 else 1 end )over (order by id)as width_flag
,sum(case when height is null then 0 else 1 end)over(order by id) as height_flag
from footer
)
select 
first_value(car) over(partition by car_flag order by id) as car
,first_value(length) over(partition by length_flag order by id) as length
,first_value(width) over(partition by width_flag order by id) as width
,first_value(height) over(partition by height_flag order by id) as height
 from cte
 order by id desc
 limit 1

------------------------------Question 23-------------------------
drop table if exists buses;
create table buses
(
	bus_id			int unique,
	arrival_time	int,
	capacity		int
);

drop table if exists Passengers;
create table Passengers
(
	passenger_id	int unique,
	arrival_time	int
);

select * from buses;
select * from Passengers;



insert into buses values (1,2,1);
insert into buses values (2,4,10);
insert into buses values (3,7,2);

insert into Passengers values(11,1);
insert into Passengers values(12,1);
insert into Passengers values(13,5);
insert into Passengers values(14,6);
insert into Passengers values(15,7);



/* -- Optional datasets for verifying the solution
-- Dataset for Test case 2
insert into buses values (326,412,3);
insert into buses values (394,656,3);
insert into buses values (430,701,1);
insert into buses values (514,742,4);
insert into buses values (765,867,9);
insert into buses values (259,968,3);

insert into Passengers values(1145,84 );
insert into Passengers values(1466,146);
insert into Passengers values(1446,317);
insert into Passengers values(1092,420);
insert into Passengers values(678,486);
insert into Passengers values(1643,520);
insert into Passengers values(253,615);
insert into Passengers values(1106,656);
insert into Passengers values(1309,699);
insert into Passengers values(142,832);
insert into Passengers values(431,880);
insert into Passengers values(1405,963);
*/


/*
-- Dataset for Test case 3
insert into buses values (717,27 ,6 );
insert into buses values (54 ,102,4 );
insert into buses values (270,116,4 );
insert into buses values (337,209,9 );
insert into buses values (346,309,7 );
insert into buses values (16 ,467,9 );
insert into buses values (189,484,1 );
insert into buses values (29 ,550,10);
insert into buses values (771,627,1 );
insert into buses values (9  ,728,7 );
insert into buses values (274,797,9 );
insert into buses values (217,799,1 );
insert into buses values (531,840,5 );
insert into buses values (684,858,6 );
insert into buses values (479,928,2 );
insert into buses values (101,931,5 );

insert into Passengers values(1679,76 );
insert into Passengers values(667 ,86 );
insert into Passengers values(1552,132);
insert into Passengers values(512 ,147);
insert into Passengers values(1497,156);
insert into Passengers values(907 ,158);
insert into Passengers values(1537,206);
insert into Passengers values(1535,219);
insert into Passengers values(584 ,301);
insert into Passengers values(16  ,318);
insert into Passengers values(166 ,375);
insert into Passengers values(1103,398);
insert into Passengers values(831 ,431);
insert into Passengers values(659 ,447);
insert into Passengers values(241 ,449);
insert into Passengers values(695 ,495);
insert into Passengers values(1702,517);
insert into Passengers values(499 ,536);
insert into Passengers values(685 ,541);
insert into Passengers values(523 ,573);
insert into Passengers values(1283,586);
insert into Passengers values(1013,619);
insert into Passengers values(256 ,680);
insert into Passengers values(854 ,698);
insert into Passengers values(1077,702);
insert into Passengers values(1684,779);
insert into Passengers values(1715,800);
insert into Passengers values(1772,804);
insert into Passengers values(69  ,807);
insert into Passengers values(261 ,919);
insert into Passengers values(581 ,922);
insert into Passengers values(1627,999);



-- Dataset for Test case 4
insert into buses values (238,4  ,4 );
insert into buses values (718,42 ,5 );
insert into buses values (689,52 ,8 );
insert into buses values (324,55 ,3 );
insert into buses values (358,59 ,7 );
insert into buses values (550,86 ,2 );
insert into buses values (46 ,91 ,5 );
insert into buses values (60 ,110,3 );
insert into buses values (667,123,8 );
insert into buses values (47 ,146,9 );
insert into buses values (671,158,2 );
insert into buses values (461,181,5 );
insert into buses values (399,183,9 );
insert into buses values (196,226,2 );
insert into buses values (549,227,7 );
insert into buses values (62 ,238,5 );
insert into buses values (251,269,6 );
insert into buses values (315,294,7 );
insert into buses values (243,305,4 );
insert into buses values (98 ,338,6 );
insert into buses values (642,369,6 );
insert into buses values (191,380,3 );
insert into buses values (67 ,394,2 );
insert into buses values (303,397,1 );
insert into buses values (663,466,1 );
insert into buses values (524,507,1 );
insert into buses values (405,556,5 );
insert into buses values (543,586,9 );
insert into buses values (177,623,3 );
insert into buses values (195,728,5 );
insert into buses values (573,747,6 );
insert into buses values (390,769,10);
insert into buses values (661,785,9 );
insert into buses values (494,798,5 );
insert into buses values (114,804,6 );
insert into buses values (571,810,9 );
insert into buses values (26 ,813,10);
insert into buses values (507,823,2 );
insert into buses values (739,829,4 );
insert into buses values (74 ,830,7 );
insert into buses values (483,849,1 );
insert into buses values (758,877,9 );
insert into buses values (597,895,2 );
insert into buses values (255,969,6 );
insert into buses values (717,977,5 );

insert into Passengers values(1490,4  );
insert into Passengers values(1535,8  );
insert into Passengers values(1283,34 );
insert into Passengers values(1230,58 );
insert into Passengers values(821 ,102);
insert into Passengers values(1388,104);
insert into Passengers values(1207,127);
insert into Passengers values(1110,144);
insert into Passengers values(566 ,149);
insert into Passengers values(1774,160);
insert into Passengers values(47  ,166);
insert into Passengers values(1099,167);
insert into Passengers values(1336,178);
insert into Passengers values(1251,193);
insert into Passengers values(572 ,194);
insert into Passengers values(524 ,208);
insert into Passengers values(1100,209);
insert into Passengers values(1211,246);
insert into Passengers values(885 ,249);
insert into Passengers values(403 ,268);
insert into Passengers values(538 ,274);
insert into Passengers values(1397,287);
insert into Passengers values(1303,301);
insert into Passengers values(1293,313);
insert into Passengers values(1133,315);
insert into Passengers values(216 ,324);
insert into Passengers values(318 ,337);
insert into Passengers values(373 ,345);
insert into Passengers values(49  ,351);
insert into Passengers values(998 ,358);
insert into Passengers values(109 ,364);
insert into Passengers values(245 ,383);
insert into Passengers values(205 ,383);
insert into Passengers values(410 ,395);
insert into Passengers values(179 ,410);
insert into Passengers values(1429,415);
insert into Passengers values(440 ,427);
insert into Passengers values(388 ,429);
insert into Passengers values(1470,453);
insert into Passengers values(1067,459);
insert into Passengers values(96  ,475);
insert into Passengers values(1363,496);
insert into Passengers values(229 ,498);
insert into Passengers values(1298,503);
insert into Passengers values(293 ,509);
insert into Passengers values(683 ,524);
insert into Passengers values(374 ,528);
insert into Passengers values(9   ,539);
insert into Passengers values(966 ,540);
insert into Passengers values(1275,552);
insert into Passengers values(1221,553);
insert into Passengers values(319 ,565);
insert into Passengers values(1131,569);
insert into Passengers values(1339,587);
insert into Passengers values(18  ,598);
insert into Passengers values(1024,653);
insert into Passengers values(396 ,663);
insert into Passengers values(409 ,677);
insert into Passengers values(545 ,689);
insert into Passengers values(999 ,699);
insert into Passengers values(1219,714);
insert into Passengers values(1195,725);
insert into Passengers values(957 ,738);
insert into Passengers values(1717,750);
insert into Passengers values(118 ,753);
insert into Passengers values(873 ,758);
insert into Passengers values(1706,759);
insert into Passengers values(1570,765);
insert into Passengers values(1469,772);
insert into Passengers values(1417,776);
insert into Passengers values(1773,809);
insert into Passengers values(568 ,823);
insert into Passengers values(83  ,831);
insert into Passengers values(804 ,835);
insert into Passengers values(418 ,837);
insert into Passengers values(1471,861);
insert into Passengers values(816 ,880);
insert into Passengers values(1673,881);
insert into Passengers values(1158,882);
insert into Passengers values(1466,910);
insert into Passengers values(172 ,927);
insert into Passengers values(1254,929);
insert into Passengers values(1337,934);
insert into Passengers values(1739,939);
insert into Passengers values(611 ,940);
insert into Passengers values(415 ,945);
insert into Passengers values(585 ,947);
insert into Passengers values(1632,949);
insert into Passengers values(1679,971);
insert into Passengers values(332 ,976);


-- Dataset for Test case 5
insert into buses values (81 ,57 ,10);
insert into buses values (137,69 ,7 );
insert into buses values (132,103,1 );
insert into buses values (756,138,3 );
insert into buses values (553,139,9 );
insert into buses values (591,196,5 );
insert into buses values (254,205,1 );
insert into buses values (664,218,10);
insert into buses values (440,234,4 );
insert into buses values (211,253,8 );
insert into buses values (54 ,286,7 );
insert into buses values (621,334,9 );
insert into buses values (516,345,2 );
insert into buses values (616,416,2 );
insert into buses values (32 ,436,9 );
insert into buses values (336,462,5 );
insert into buses values (61 ,468,4 );
insert into buses values (233,501,3 );
insert into buses values (492,508,9 );
insert into buses values (628,526,3 );
insert into buses values (93 ,563,1 );
insert into buses values (8  ,574,1 );
insert into buses values (76 ,586,3 );
insert into buses values (23 ,650,6 );
insert into buses values (147,669,7 );
insert into buses values (601,679,5 );
insert into buses values (179,696,10);
insert into buses values (647,703,5 );
insert into buses values (148,711,10);
insert into buses values (352,728,5 );
insert into buses values (176,746,5 );
insert into buses values (26 ,770,3 );
insert into buses values (231,772,2 );
insert into buses values (434,798,9 );
insert into buses values (64 ,826,1 );
insert into buses values (641,829,6 );
insert into buses values (484,846,3 );
insert into buses values (337,896,3 );

insert into Passengers values(108 ,1  );
insert into Passengers values(646 ,54 );
insert into Passengers values(1656,55 );
insert into Passengers values(1762,91 );
insert into Passengers values(89  ,101);
insert into Passengers values(427 ,150);
insert into Passengers values(1357,156);
insert into Passengers values(325 ,203);
insert into Passengers values(847 ,206);
insert into Passengers values(1036,211);
insert into Passengers values(119 ,214);
insert into Passengers values(1765,218);
insert into Passengers values(303 ,225);
insert into Passengers values(466 ,237);
insert into Passengers values(722 ,255);
insert into Passengers values(1659,279);
insert into Passengers values(1528,281);
insert into Passengers values(628 ,283);
insert into Passengers values(575 ,300);
insert into Passengers values(1075,306);
insert into Passengers values(743 ,309);
insert into Passengers values(894 ,327);
insert into Passengers values(190 ,388);
insert into Passengers values(502 ,392);
insert into Passengers values(541 ,401);
insert into Passengers values(1037,407);
insert into Passengers values(1093,412);
insert into Passengers values(1252,417);
insert into Passengers values(632 ,430);
insert into Passengers values(339 ,431);
insert into Passengers values(735 ,433);
insert into Passengers values(778 ,443);
insert into Passengers values(877 ,446);
insert into Passengers values(1137,473);
insert into Passengers values(1076,488);
insert into Passengers values(589 ,504);
insert into Passengers values(1763,509);
insert into Passengers values(172 ,525);
insert into Passengers values(1720,537);
insert into Passengers values(612 ,546);
insert into Passengers values(1588,550);
insert into Passengers values(651 ,553);
insert into Passengers values(363 ,567);
insert into Passengers values(1440,584);
insert into Passengers values(694 ,591);
insert into Passengers values(1338,614);
insert into Passengers values(652 ,631);
insert into Passengers values(1646,632);
insert into Passengers values(369 ,650);
insert into Passengers values(310 ,655);
insert into Passengers values(1006,661);
insert into Passengers values(1111,667);
insert into Passengers values(1556,695);
insert into Passengers values(1020,699);
insert into Passengers values(232 ,734);
insert into Passengers values(1017,785);
insert into Passengers values(516 ,786);
insert into Passengers values(1324,789);
insert into Passengers values(1487,792);
insert into Passengers values(5   ,809);
insert into Passengers values(173 ,847);
insert into Passengers values(982 ,863);
insert into Passengers values(455 ,872);
insert into Passengers values(769 ,879);
insert into Passengers values(260 ,893);
insert into Passengers values(123 ,914);
insert into Passengers values(1117,918);
insert into Passengers values(170 ,929);
insert into Passengers values(788 ,931);
insert into Passengers values(32  ,935);
insert into Passengers values(943 ,943);
insert into Passengers values(532 ,943);
insert into Passengers values(1334,944);
insert into Passengers values(866 ,954);
insert into Passengers values(697 ,959);
insert into Passengers values(255 ,964);

*/
select * from buses
select * from passengers
select *
from busses b
join passengers p on p.arrival_time<=b.arrival_time

with recursive cte as
(
),
cte_data as
(		select row_number()over(order by arrival_time) as rn,bus_id,capacity
		,(select count(1) from passengers p where p.arrival_time<=b.arrival_time) as total_passengers
		from buses b
)
select * from cte

--------------------question 5--------------------------
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


select * from salary;
select * from income;
select * from deduction;
select * from emp_transaction;

select s.emp_id,s.emp_name,x.trns_type
,case
 when x.trns_type='Basic' then round((s.base_salary*x.percentage)/100,2)
when x.trns_type='Allowance' then round((s.base_salary*x.percentage)/100,2)
when x.trns_type='Others' then round((s.base_salary*x.percentage)/100,2) 
when x.trns_type='Insurance' then round((s.base_salary*x.percentage)/100,2)
when x.trns_type='Health' then round((s.base_salary*x.percentage)/100,2)
when x.trns_type='House' then round((s.base_salary*x.percentage)/100,2)
end as amount
from salary s
cross join (
select income as trns_type,percentage from income
union 
select  deduction as trns_type ,percentage from  deduction)x


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

select * from emp_transaction

SELECT 
    emp_name,
    SUM(CASE WHEN trns_type = 'Basic' THEN amount ELSE 0 END) AS Basic,
    SUM(CASE WHEN trns_type = 'Allowance' THEN amount ELSE 0 END) AS Allowance,
    SUM(CASE WHEN trns_type = 'Others' THEN amount ELSE 0 END) AS Others,
    SUM(CASE WHEN trns_type = 'Health' THEN amount ELSE 0 END) AS Health,
    SUM(CASE WHEN trns_type = 'House' THEN amount ELSE 0 END) AS House,
    SUM(CASE WHEN trns_type = 'Insurance' THEN amount ELSE 0 END) AS Insurance,
    (SUM(CASE WHEN trns_type = 'Basic' THEN amount ELSE 0 END) + 
     SUM(CASE WHEN trns_type = 'Allowance' THEN amount ELSE 0 END) + 
     SUM(CASE WHEN trns_type = 'Others' THEN amount ELSE 0 END)) AS Gross,
    (SUM(CASE WHEN trns_type = 'Insurance' THEN amount ELSE 0 END) + 
     SUM(CASE WHEN trns_type = 'Health' THEN amount ELSE 0 END) + 
     SUM(CASE WHEN trns_type = 'House' THEN amount ELSE 0 END)) AS Total_Deductions,
    ((SUM(CASE WHEN trns_type = 'Basic' THEN amount ELSE 0 END) + 
      SUM(CASE WHEN trns_type = 'Allowance' THEN amount ELSE 0 END) + 
      SUM(CASE WHEN trns_type = 'Others' THEN amount ELSE 0 END)) - 
     (SUM(CASE WHEN trns_type = 'Insurance' THEN amount ELSE 0 END) + 
      SUM(CASE WHEN trns_type = 'Health' THEN amount ELSE 0 END) + 
      SUM(CASE WHEN trns_type = 'House' THEN amount ELSE 0 END))) AS Net_Pay
FROM emp_transaction
GROUP BY emp_name;

select emp_name
,sum(case when trns_type='Basic' THEN AMOUNT ELSE 0 END) AS Basic
,sum(case when trns_type='Allowance' THEN AMOUNT ELSE 0 END) AS Allowance
,sum(case when trns_type='Others' THEN AMOUNT ELSE 0 END )AS Others
,(sum(case when trns_type='Basic' THEN AMOUNT ELSE 0 END)+sum(case when trns_type='Allowance' THEN AMOUNT ELSE 0 END) +sum(case when trns_type='Others' THEN AMOUNT ELSE 0 END )) as gross
, SUM(CASE WHEN trns_type = 'Health' THEN amount ELSE 0 END) AS Health
,SUM(CASE WHEN trns_type = 'House' THEN amount ELSE 0 END) AS House
  ,SUM(CASE WHEN trns_type = 'Insurance' THEN amount ELSE 0 END) AS Insurance
  ,(SUM(CASE WHEN trns_type = 'Insurance' THEN amount ELSE 0 END) + 
     SUM(CASE WHEN trns_type = 'Health' THEN amount ELSE 0 END) + 
     SUM(CASE WHEN trns_type = 'House' THEN amount ELSE 0 END)) AS Total_Deductions
      , ((SUM(CASE WHEN trns_type = 'Basic' THEN amount ELSE 0 END) + 
      SUM(CASE WHEN trns_type = 'Allowance' THEN amount ELSE 0 END) + 
      SUM(CASE WHEN trns_type = 'Others' THEN amount ELSE 0 END)) - 
     (SUM(CASE WHEN trns_type = 'Insurance' THEN amount ELSE 0 END) + 
      SUM(CASE WHEN trns_type = 'Health' THEN amount ELSE 0 END) + 
      SUM(CASE WHEN trns_type = 'House' THEN amount ELSE 0 END))) AS Net_Pay
FROM emp_transaction
GROUP BY emp_name;
------------------------question 7-------------------------
select product_id, day_indicator, dates
from (
	select * 
	, case when substring(day_indicator,(((datepart(dw, dates) + 5)%7) + 1),1) = '1' 
				then 'Include' else 'Exlcude' end as flag
	from Day_Indicator) x
where flag='Include';


------------------------------------------------
    select * from Day_Indicator


select *,(DAYOFWEEK(Dates)+5)%7+1
,substring(day_indicator,(DAYOFWEEK(Dates)+5)%7+1,1) as extractvalue
 from Day_Indicator

select product_id, day_indicator, dates
from (
		SELECT 
			*,
			CASE 
				WHEN SUBSTRING(Day_Indicator, ((DAYOFWEEK(Dates) + 5) % 7) + 1, 1) = '1' THEN 'Include' 
				ELSE 'Exclude' 
			END AS flag
		FROM 
			Day_Indicator
            
	)x
	where flag='Include'
    
    ---------question 9----------------------
    
    select * from orders;
    
    select *,
    row_number()over (partition by dates  order by customer_id ) as rnk
    from orders
    
select 
dates, product_id  as products 
from orders
union
select dates,GROUP_CONCAT(product_id SEPARATOR ',') AS products
from orders
group by customer_id, dates
order by dates, products;
---------------------------------question 11-------------------------
select * from hotel_ratings;

with cte as
(
select *,round(avg(rating)over(partition by hotel order by year
range between unbounded preceding and unbounded following ),2) as rnk
from  hotel_ratings
),
cte_rnk as 
(
select *,abs(rnk-rating),
rank() over(partition by hotel order by abs(rnk-rating) desc ) rn
from cte
)
select * from cte_rnk
where rn>1

-------------------------------------------------------
with cte as
(
select *, round(avg(rating) over(partition by hotel order by year
range between unbounded preceding and unbounded following),2) as avg_rating
from hotel_ratings
),
cte_rnk as
(
select *,abs(avg_rating-rating)
, rank() over(partition by hotel order by abs(avg_rating-rating) desc ) rnk
from cte
    )
select hotel, year, rating
from cte_rnk
where rnk > 1
order by hotel,year;


-----------------------question13----------------------------
use challenge_thirtydays
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
select emp.name as manager ,count(mng.manager) as employee
from employee_managers emp
join employee_managers mng
on emp.id=mng.manager
group by emp.name
order by count(mng.manager) desc 


use challenge_thirtydays
select * from friends

with cteallfrn as
(
select friend1,friend2 from 
Friends
union all
select friend2,friend1 from 
Friends

)
select distinct  f.*
,count(af.friend2) over( partition by f.friend1 ,f.friend2 order by  af.friend2 range between unbounded preceding and unbounded following) as mutual
 from friends f
 left join cteallfrn af on f.friend1=af.friend1
 and af.friend2 in (select af2.friend2  from cteallfrn af2 where af2.friend1=f.friend2)
order by 1

-------question 17--------------

drop table if exists user_login;
create table user_login
(
	user_id		int,
	login_date	date
);
select * from user_login;

INSERT INTO user_login VALUES(1, STR_TO_DATE('01/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(1, STR_TO_DATE('02/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(1, STR_TO_DATE('03/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(1, STR_TO_DATE('04/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(1, STR_TO_DATE('06/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(1, STR_TO_DATE('10/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(1, STR_TO_DATE('11/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(1, STR_TO_DATE('12/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(1, STR_TO_DATE('13/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(1, STR_TO_DATE('14/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(1, STR_TO_DATE('20/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(1, STR_TO_DATE('25/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(1, STR_TO_DATE('26/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(1, STR_TO_DATE('27/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(1, STR_TO_DATE('28/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(1, STR_TO_DATE('29/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(1, STR_TO_DATE('30/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(2, STR_TO_DATE('01/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(2, STR_TO_DATE('02/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(2, STR_TO_DATE('03/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(2, STR_TO_DATE('04/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(3, STR_TO_DATE('01/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(3, STR_TO_DATE('02/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(3, STR_TO_DATE('03/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(3, STR_TO_DATE('04/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(3, STR_TO_DATE('04/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(3, STR_TO_DATE('04/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(3, STR_TO_DATE('05/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(4, STR_TO_DATE('01/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(4, STR_TO_DATE('02/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(4, STR_TO_DATE('03/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(4, STR_TO_DATE('04/03/2024', '%d/%m/%Y'));
INSERT INTO user_login VALUES(4, STR_TO_DATE('04/03/2024', '%d/%m/%Y'));



select * 
, dense_rank()over(partition by user_id order by user_id ,login_date) as rw
,login_date-cast(dense_rank()over(partition by user_id order by user_id ,login_date)as int) 
from user_login


with cte as
(
SELECT 
    *,
   
    DATE_SUB(login_date, INTERVAL DENSE_RANK() 
    OVER (PARTITION BY user_id ORDER BY user_id, login_date) DAY) AS date_grp
FROM 
    user_login
    )
    select user_id,date_grp
    ,min(login_date ) as startdate,max(login_date) as end_date
    ,max(login_date) -min(login_date )+1 as cons_days
    from cte
    group by user_id,date_grp
having (max(login_date) -min(login_date )+1)>=5
---------question 19--------------------------

SELECT
   DATE_FORMAT(order_time,'%b-%Y') AS PERIOD
   ,round((SUM( case when (TIMESTAMPDIFF(MINUTE, order_time, actual_delivery))>'30'
   then 1 else 0 end )/count(1))*100,2)
   ,sum(case when (TIMESTAMPDIFF(MINUTE, order_time, actual_delivery) >'30') then no_of_pizzas else 0 end) as pizzas
FROM
     pizza_delivery
     where actual_delivery is not null
    GROUP BY DATE_FORMAT(order_time, '%b-%Y')
    order by select extract(month from DATE_FORMAT(order_time, '%b-%Y'))
    
    
    
    select  MIN(order_time) from pizza_delivery
    
    
    
 SELECT
    DATE_FORMAT(order_time, '%b-%Y') AS PERIOD,
    ROUND((SUM(CASE WHEN TIMESTAMPDIFF(MINUTE, order_time, actual_delivery) > 30 THEN 1 ELSE 0 END) / COUNT(1)) * 100, 2) AS percentage,
    SUM(CASE WHEN TIMESTAMPDIFF(MINUTE, order_time, actual_delivery) > 30 THEN no_of_pizzas ELSE 0 END) AS pizzas
FROM
    pizza_delivery
WHERE
    actual_delivery IS NOT NULL
GROUP BY
    DATE_FORMAT(order_time, '%b-%Y'), DATE_FORMAT(order_time, '%Y-%m')
ORDER BY
    min(order_time)


    -----------------21----------------------------------------
    use challenge_thirtydays
    select * from post_views
    
    with cte as 
    (
    select p.*
    , TIMESTAMPDIFF(second,session_starttime,session_endtime) as seconds
     from user_sessions s
    join post_views p on p.session_id=s.session_id
    )
    select
    post_id,
    sum((perc_viewed/100)*seconds)as viewtime
    from cte
    group by post_id
    having  sum((perc_viewed/100)*seconds)>5
    
    
    ---------question 23-------------
    select * from buses;
select * from Passengers;


select *
from buses b
join passengers  p  on
p.arrival_time<=b.arrival_time
order by bus_id

with recursive cte as
(
select rn,
 bus_id,capacity ,passengercount,least(capacity ,passengercount) as onboarded_bus
 ,least(capacity ,passengercount) as total_onboarded_bus
 from cte_data
 where rn=1
 union all
 select 
d. rn,
d. bus_id,d.capacity d.passengercount,
cte.total_onboarded_bus+least(d.capacity ,d.passengercount-cte.total_onboarded_bus) as onboarded_bus
,cte.total_onboarded_bus
 from cte
 join cte_data d on d.rn=cte.rn+1

),
cte_data as
(
select row_number()over(order by arrival_time) as rn,
 bus_id,capacity,
(select count(1) from passengers p where arrival_time<=b.arrival_time)passengercount
from buses b
)
select bus_id,onboarded_bus as passengers_cnt from
from 
 cte
 order bu bus_id



    
    
   with cte_data as
		(
        select row_number() over(order by arrival_time) as rn, bus_id
		, (select count(1) from passengers p 
		  where p.arrival_time <= b.arrival_time) as total_passengers, capacity
		from buses b
),
	cte as
		(select rn, bus_id, capacity, total_passengers
		 , case when capacity < total_passengers then capacity else total_passengers end as onboarded_bus
		 , case when capacity < total_passengers then capacity else total_passengers end as total_onboarded
		 from cte_data where rn=1
		union all
		 select d.rn, d.bus_id, d.capacity, d.total_passengers
		 , case when d.capacity < (d.total_passengers - cte.total_onboarded) then d.capacity else (d.total_passengers - cte.total_onboarded) end as onboarded_bus
		 , cte.total_onboarded + case when d.capacity < (d.total_passengers - cte.total_onboarded) then d.capacity else (d.total_passengers - cte.total_onboarded) end as total_onboarded
		 from cte 
		 join cte_data d on d.rn = cte.rn+1)
select bus_id, onboarded_bus as passengers_cnt
from cte
order by bus_id
    
    
    
  WITH RECURSIVE cte_data AS (
    SELECT 
        @row_number:=@row_number+1 AS rn,
        b.bus_id,
        (SELECT COUNT(1) FROM passengers p WHERE p.arrival_time <= b.arrival_time) AS total_passengers,
        b.capacity
    FROM 
        buses b, (SELECT @row_number:=0) AS r
    ORDER BY 
        arrival_time
),
cte AS (
    SELECT 
        rn,
        bus_id,
        capacity,
        total_passengers,
        CASE 
            WHEN capacity < total_passengers THEN capacity 
            ELSE total_passengers 
        END AS onboarded_bus,
        CASE 
            WHEN capacity < total_passengers THEN capacity 
            ELSE total_passengers 
        END AS total_onboarded
    FROM 
        cte_data 
    WHERE 
        rn = 1
    UNION ALL
    SELECT 
        d.rn, 
        d.bus_id, 
        d.capacity, 
        d.total_passengers,
        CASE 
            WHEN d.capacity < (d.total_passengers - cte.total_onboarded) THEN d.capacity 
            ELSE (d.total_passengers - cte.total_onboarded) 
        END AS onboarded_bus,
        cte.total_onboarded + CASE 
            WHEN d.capacity < (d.total_passengers - cte.total_onboarded) THEN d.capacity 
            ELSE (d.total_passengers - cte.total_onboarded) 
        END AS total_onboarded
    FROM 
        cte 
    JOIN 
        cte_data d ON d.rn = cte.rn + 1
)
SELECT 
    bus_id, 
    onboarded_bus AS passengers_cnt
FROM 
    cte
ORDER BY 
    bus_id;

    
    -----------------Question 25---------------------------
    
    drop table if exists product_demo;
create table product_demo
(
	store_id	int,
	product_1	varchar(50),
	product_2	varchar(50)
);
insert into product_demo values (1, 'Apple - IPhone', '   Apple - MacBook Pro');
insert into product_demo values (1, 'Apple - AirPods', 'Samsung - Galaxy Phone');
insert into product_demo values (2, 'Apple_IPhone', 'Apple: Phone');
insert into product_demo values (2, 'Google Pixel', ' apple: Laptop');
insert into product_demo values (2, 'Sony: Camera', 'Apple Vision Pro');
insert into product_demo values (3, 'samsung - Galaxy Phone', 'mapple MacBook Pro');
    select * from product_demo
    
    select store_id,
    sum(case when ltrim(lower(product_1)) like'apple%' then 1 else 0 end )as product_1
    , sum(case when ltrim(lower(product_2)) like'apple%' then 1 else 0 end )as product_2
    from product_demo
    group by store_id
    order by store_id;
    
    select store_id,ltrim( product_1),product_2
    from product_demo
    
  select store_id
, sum(case when ltrim(lower(product_1)) like 'apple%' then 1 else 0 end) as product_1
, sum(case when ltrim(lower(product_2)) like 'apple%' then 1 else 0 end) as product_2
from product_demo
group by store_id
order by store_id;
    
    select store_id,
    sum(case when ltrim(lower(product_1)) like'apple%' then 1 else 0 end) as product_1
    ,sum(case when ltrim(lower(product_2)) like'apple%' then 1 else 0 end) as product_1
    
    from product_demo
    group by store_id
order by store_id;
    ------------question 27---------------------

    use challenge_thirtydays
    
drop table if exists vacation_plans;
create table vacation_plans
(
	id 			int primary key,
	emp_id		int,
	from_dt		date,
	to_dt		date
);
insert into vacation_plans values(1,1, '2024-02-12', '2024-02-16');
insert into vacation_plans values(2,2, '2024-02-20', '2024-02-29');
insert into vacation_plans values(3,3, '2024-03-01', '2024-03-31');
insert into vacation_plans values(4,1, '2024-04-11', '2024-04-23');
insert into vacation_plans values(5,4, '2024-06-01', '2024-06-30');
insert into vacation_plans values(6,3, '2024-07-05', '2024-07-15');
insert into vacation_plans values(7,3, '2024-08-28', '2024-09-15');


drop table if exists leave_balance;
create table leave_balance
(
	emp_id			int,
	balance			int
);
insert into leave_balance values (1, 12);
insert into leave_balance values (2, 10);
insert into leave_balance values (3, 26);
insert into leave_balance values (4, 20);
insert into leave_balance values (5, 14);

select * from vacation_plans;
select * from leave_balance;

select * 
from vacation_plans v
join leave_balance b on v.id=b.emp_id

    
    select *  ,timestamp(day,v.from_dt,v.to_dt)
   
from vacation_plans v
join leave_balance b on v.emp_id=b.emp_id


with recursive cte as
(
    SELECT id,v.emp_id,from_dt, to_dt,b.balance
    , 
    TIMESTAMPdiff(day, from_dt, to_dt)+1 AS leave_apply
    ,row_number()over(partition by v.emp_id ) as rnk
FROM 
    vacation_plans v
JOIN 
    leave_balance b ON v.emp_id = b.emp_id
   
)

with recursive cte as (
	with cte_data as 
		(select v.id, v.emp_id, v.from_dt, v.to_dt
		, l.balance as leave_balance, count(d.dates) as vacation_days
		, row_number() over(partition by v.emp_id order by v.emp_id,v.id) as rn
		from vacation_plans v
		cross join lateral (select cast(dates as date) as dates, trim(to_char(dates,'Day')) as day
							from generate_series(v.from_dt,v.to_dt,'1 Day') dates) d
		join leave_balance l on l.emp_id=v.emp_id
		where day not in ('Saturday','Sunday')	
		group by v.id, v.emp_id, v.from_dt, v.to_dt, l.balance)
	select *, (leave_balance-vacation_days) as remaining_balance
	from cte_data	
	where rn=1
	union all
	select cd.*, (cte.remaining_balance-cd.vacation_days) as remaining_balance
	from cte 
	join cte_data cd on cd.rn=cte.rn+1 and cd.emp_id=cte.emp_id
	)
select id,emp_id,from_dt,to_dt,leave_balance, vacation_days
, case when remaining_balance < 0 then 'Insufficient Leave Balance' else 'Approved' end as status
from cte
    
    -----
    select * 
    from vacation_plans v
    cross join lateral(
    select 
    cast(dates as date)as dates,to_char(dates,'Day')as day
    from generate_series(v.from_dt,v.to_dt,'1 day')
    
    
    
with  recursive dateseries as
    (select  cast(v.from_dt as date) as dates from vacation_plans v
    union all 
    select dateadd(day,1 ,dates) from dateseries
    where dates<v.to_dt
    )
    select * from dateseries
    ---------------question 29------------------
    use challenge_thirtydays
    
 with cte as
 (
	 select distinct
	 first_value(times)over(partition by grp order by grp,times) as log_on
	 ,last_value(times)over(partition by grp order by grp,times
	 range between unbounded preceding and unbounded following) as log_off
	 from
	 (
	 select *
	,rn-row_number()over(order by times) as grp
	from
	 (
	select * 
	,row_number()over(order by times) as rn
	from login_details
	)x
	where status ='on'
	)y
),
cte_final as
(
select log_on,lead(times)over(order by times) as log_offf  from login_details l 
left join cte c
on  c.log_off=l.times
)
select  *,timestampdiff(minute,log_on,log_offf) as duration
 from cte_final  where log_on is not null


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    





