use challenge_thirtydays

-----------------------------------------------Query 22-----------------------------------------------
/* -- Problem Statement: IPL Winning Streak
Given table has details of every IPL 2023 matches. Identify the maximum winning streak for each team. 
Additional test cases: 
1) Update the dataset such that when Chennai Super Kings win match no 17, your query shows the updated streak.
2) Update the dataset such that Royal Challengers Bangalore loose all match and your query should populate the winning streak as 0
*/

drop table if exists ipl_results;
create table ipl_results
(
	match_no		int,
	round_number	varchar(50),
	dates			date,
	location		varchar(50),
	home_team		varchar(50),
	away_team		varchar(50),
	result			varchar(50)
);
insert into ipl_results values(1 , '1', '2023-03-31', 'Narendra Modi Stadium, Ahmedabad','Gujarat Titans','Chennai Super Kings','Gujarat Titans');
insert into ipl_results values(2 , '1', '2023-04-01', 'Punjab Cricket Association IS Bindra Stadium, Moha','Punjab Kings','Kolkata Knight Riders','Punjab Kings');
insert into ipl_results values(3 , '1', '2023-04-01', 'Bharat Ratna Shri Atal Bihari Vajpayee Ekana Crick','Lucknow Super Giants','Delhi Capitals','Lucknow Super Giants');
insert into ipl_results values(4 , '1', '2023-04-02', 'Rajiv Gandhi International Stadium, Hyderabad','Sunrisers Hyderabad','Rajasthan Royals','Rajasthan Royals');
insert into ipl_results values(5 , '1', '2023-04-02', 'M Chinnaswamy Stadium, Bengaluru','Royal Challengers Bangalore','Mumbai Indians','Royal Challengers Bangalore');
insert into ipl_results values(6 , '1', '2023-04-03', 'MA Chidambaram Stadium, Chennai','Chennai Super Kings','Lucknow Super Giants','Chennai Super Kings');
insert into ipl_results values(7 , '1', '2023-04-04', 'Arun Jaitley Stadium, Delhi','Delhi Capitals','Gujarat Titans','Gujarat Titans');
insert into ipl_results values(8 , '1', '2023-04-05', 'Barsapara Cricket Stadium, Guwahati','Rajasthan Royals','Punjab Kings','Punjab Kings');
insert into ipl_results values(9 , '1', '2023-04-06', 'Eden Gardens, Kolkata','Kolkata Knight Riders','Royal Challengers Bangalore','Kolkata Knight Riders');
insert into ipl_results values(10 , '1', '2023-04-07', 'Bharat Ratna Shri Atal Bihari Vajpayee Ekana Crick','Lucknow Super Giants','Sunrisers Hyderabad','Lucknow Super Giants');
insert into ipl_results values(11 , '2', '2023-04-08', 'Barsapara Cricket Stadium, Guwahati','Rajasthan Royals','Delhi Capitals','Rajasthan Royals');
insert into ipl_results values(12 , '2', '2023-04-08', 'Wankhede Stadium, Mumbai','Mumbai Indians','Chennai Super Kings','Chennai Super Kings');
insert into ipl_results values(13 , '2', '2023-04-09', 'Narendra Modi Stadium, Ahmedabad','Gujarat Titans','Kolkata Knight Riders','Kolkata Knight Riders');
insert into ipl_results values(14 , '2', '2023-04-09', 'Rajiv Gandhi International Stadium, Hyderabad','Sunrisers Hyderabad','Punjab Kings','Sunrisers Hyderabad');
insert into ipl_results values(15 , '2', '2023-04-10', 'M Chinnaswamy Stadium, Bengaluru','Royal Challengers Bangalore','Lucknow Super Giants','Lucknow Super Giants');
insert into ipl_results values(16 , '2', '2023-04-11', 'Arun Jaitley Stadium, Delhi','Delhi Capitals','Mumbai Indians','Mumbai Indians');
insert into ipl_results values(17 , '2', '2023-04-12', 'MA Chidambaram Stadium, Chennai','Chennai Super Kings','Rajasthan Royals','Rajasthan Royals');
insert into ipl_results values(18 , '2', '2023-04-13', 'Punjab Cricket Association IS Bindra Stadium, Moha','Punjab Kings','Gujarat Titans','Gujarat Titans');
insert into ipl_results values(19 , '2', '2023-04-14', 'Eden Gardens, Kolkata','Kolkata Knight Riders','Sunrisers Hyderabad','Sunrisers Hyderabad');
insert into ipl_results values(20 , '3', '2023-04-15', 'M Chinnaswamy Stadium, Bengaluru','Royal Challengers Bangalore','Delhi Capitals','Royal Challengers Bangalore');
insert into ipl_results values(21 , '3', '2023-04-15', 'Bharat Ratna Shri Atal Bihari Vajpayee Ekana Crick','Lucknow Super Giants','Punjab Kings','Punjab Kings');
insert into ipl_results values(22 , '3', '2023-04-16', 'Wankhede Stadium, Mumbai','Mumbai Indians','Kolkata Knight Riders','Mumbai Indians');
insert into ipl_results values(23 , '3', '2023-04-16', 'Narendra Modi Stadium, Ahmedabad','Gujarat Titans','Rajasthan Royals','Rajasthan Royals');
insert into ipl_results values(24 , '3', '2023-04-17', 'M Chinnaswamy Stadium, Bengaluru','Royal Challengers Bangalore','Chennai Super Kings','Chennai Super Kings');
insert into ipl_results values(25 , '3', '2023-04-18', 'Rajiv Gandhi International Stadium, Hyderabad','Sunrisers Hyderabad','Mumbai Indians','Mumbai Indians');
insert into ipl_results values(26 , '3', '2023-04-19', 'Sawai Mansingh Stadium, Jaipur','Rajasthan Royals','Lucknow Super Giants','Lucknow Super Giants');
insert into ipl_results values(27 , '3', '2023-04-20', 'Punjab Cricket Association IS Bindra Stadium, Moha','Punjab Kings','Royal Challengers Bangalore','Royal Challengers Bangalore');
insert into ipl_results values(28 , '3', '2023-04-20', 'Arun Jaitley Stadium, Delhi','Delhi Capitals','Kolkata Knight Riders','Delhi Capitals');
insert into ipl_results values(29 , '3', '2023-04-21', 'MA Chidambaram Stadium, Chennai','Chennai Super Kings','Sunrisers Hyderabad','Chennai Super Kings');
insert into ipl_results values(30 , '4', '2023-04-22', 'Bharat Ratna Shri Atal Bihari Vajpayee Ekana Crick','Lucknow Super Giants','Gujarat Titans','Gujarat Titans');
insert into ipl_results values(31 , '4', '2023-04-22', 'Wankhede Stadium, Mumbai','Mumbai Indians','Punjab Kings','Punjab Kings');
insert into ipl_results values(32 , '4', '2023-04-23', 'M Chinnaswamy Stadium, Bengaluru','Royal Challengers Bangalore','Rajasthan Royals','Royal Challengers Bangalore');
insert into ipl_results values(33 , '4', '2023-04-23', 'Eden Gardens, Kolkata','Kolkata Knight Riders','Chennai Super Kings','Chennai Super Kings');
insert into ipl_results values(34 , '4', '2023-04-24', 'Rajiv Gandhi International Stadium, Hyderabad','Sunrisers Hyderabad','Delhi Capitals','Delhi Capitals');
insert into ipl_results values(35 , '4', '2023-04-25', 'Narendra Modi Stadium, Ahmedabad','Gujarat Titans','Mumbai Indians','Gujarat Titans');
insert into ipl_results values(36 , '4', '2023-04-26', 'M Chinnaswamy Stadium, Bengaluru','Royal Challengers Bangalore','Kolkata Knight Riders','Kolkata Knight Riders');
insert into ipl_results values(37 , '4', '2023-04-27', 'Sawai Mansingh Stadium, Jaipur','Rajasthan Royals','Chennai Super Kings','Rajasthan Royals');
insert into ipl_results values(38 , '4', '2023-04-28', 'Punjab Cricket Association IS Bindra Stadium, Moha','Punjab Kings','Lucknow Super Giants','Lucknow Super Giants');
insert into ipl_results values(39 , '4', '2023-04-29', 'Eden Gardens, Kolkata','Kolkata Knight Riders','Gujarat Titans','Gujarat Titans');
insert into ipl_results values(40 , '4', '2023-04-29', 'Arun Jaitley Stadium, Delhi','Delhi Capitals','Sunrisers Hyderabad','Sunrisers Hyderabad');
insert into ipl_results values(41 , '5', '2023-04-30', 'MA Chidambaram Stadium, Chennai','Chennai Super Kings','Punjab Kings','Punjab Kings');
insert into ipl_results values(42 , '5', '2023-04-30', 'Wankhede Stadium, Mumbai','Mumbai Indians','Rajasthan Royals','Mumbai Indians');
insert into ipl_results values(43 , '5', '2023-05-01', 'Bharat Ratna Shri Atal Bihari Vajpayee Ekana Crick','Lucknow Super Giants','Royal Challengers Bangalore','Royal Challengers Bangalore');
insert into ipl_results values(44 , '5', '2023-05-02', 'Narendra Modi Stadium, Ahmedabad','Gujarat Titans','Delhi Capitals','Delhi Capitals');
insert into ipl_results values(46 , '5', '2023-05-03', 'Bharat Ratna Shri Atal Bihari Vajpayee Ekana Crick','Lucknow Super Giants','Chennai Super Kings','No Result');
insert into ipl_results values(45 , '5', '2023-05-03', 'Punjab Cricket Association IS Bindra Stadium, Moha','Punjab Kings','Mumbai Indians','Mumbai Indians');
insert into ipl_results values(47 , '5', '2023-05-04', 'Rajiv Gandhi International Stadium, Hyderabad','Sunrisers Hyderabad','Kolkata Knight Riders','Kolkata Knight Riders');
insert into ipl_results values(48 , '5', '2023-05-05', 'Sawai Mansingh Stadium, Jaipur','Rajasthan Royals','Gujarat Titans','Gujarat Titans');
insert into ipl_results values(49 , '5', '2023-05-06', 'MA Chidambaram Stadium, Chennai','Chennai Super Kings','Mumbai Indians','Chennai Super Kings');
insert into ipl_results values(50 , '5', '2023-05-06', 'Arun Jaitley Stadium, Delhi','Delhi Capitals','Royal Challengers Bangalore','Delhi Capitals');
insert into ipl_results values(51 , '6', '2023-05-07', 'Narendra Modi Stadium, Ahmedabad','Gujarat Titans','Lucknow Super Giants','Gujarat Titans');
insert into ipl_results values(52 , '6', '2023-05-07', 'Sawai Mansingh Stadium, Jaipur','Rajasthan Royals','Sunrisers Hyderabad','Sunrisers Hyderabad');
insert into ipl_results values(53 , '6', '2023-05-08', 'Eden Gardens, Kolkata','Kolkata Knight Riders','Punjab Kings','Kolkata Knight Riders');
insert into ipl_results values(54 , '6', '2023-05-09', 'Wankhede Stadium, Mumbai','Mumbai Indians','Royal Challengers Bangalore','Mumbai Indians');
insert into ipl_results values(55 , '6', '2023-05-10', 'MA Chidambaram Stadium, Chennai','Chennai Super Kings','Delhi Capitals','Chennai Super Kings');
insert into ipl_results values(56 , '6', '2023-05-11', 'Eden Gardens, Kolkata','Kolkata Knight Riders','Rajasthan Royals','Rajasthan Royals');
insert into ipl_results values(57 , '6', '2023-05-12', 'Wankhede Stadium, Mumbai','Mumbai Indians','Gujarat Titans','Mumbai Indians');
insert into ipl_results values(58 , '6', '2023-05-13', 'Rajiv Gandhi International Stadium, Hyderabad','Sunrisers Hyderabad','Lucknow Super Giants','Lucknow Super Giants');
insert into ipl_results values(59 , '6', '2023-05-13', 'Arun Jaitley Stadium, Delhi','Delhi Capitals','Punjab Kings','Punjab Kings');
insert into ipl_results values(60 , '7', '2023-05-14', 'Sawai Mansingh Stadium, Jaipur','Rajasthan Royals','Royal Challengers Bangalore','Royal Challengers Bangalore');
insert into ipl_results values(61 , '7', '2023-05-14', 'MA Chidambaram Stadium, Chennai','Chennai Super Kings','Kolkata Knight Riders','Kolkata Knight Riders');
insert into ipl_results values(62 , '7', '2023-05-15', 'Narendra Modi Stadium, Ahmedabad','Gujarat Titans','Sunrisers Hyderabad','Gujarat Titans');
insert into ipl_results values(63 , '7', '2023-05-16', 'Bharat Ratna Shri Atal Bihari Vajpayee Ekana Crick','Lucknow Super Giants','Mumbai Indians','Lucknow Super Giants');
insert into ipl_results values(64 , '7', '2023-05-17', 'Himachal Pradesh Cricket Association Stadium, Dhar','Punjab Kings','Delhi Capitals','Delhi Capitals');
insert into ipl_results values(65 , '7', '2023-05-18', 'Rajiv Gandhi International Stadium, Hyderabad','Sunrisers Hyderabad','Royal Challengers Bangalore','Royal Challengers Bangalore');
insert into ipl_results values(66 , '7', '2023-05-19', 'Himachal Pradesh Cricket Association Stadium, Dhar','Punjab Kings','Rajasthan Royals','Rajasthan Royals');
insert into ipl_results values(67 , '7', '2023-05-20', 'Arun Jaitley Stadium, Delhi','Delhi Capitals','Chennai Super Kings','Chennai Super Kings');
insert into ipl_results values(68 , '7', '2023-05-20', 'Eden Gardens, Kolkata','Kolkata Knight Riders','Lucknow Super Giants','Lucknow Super Giants');
insert into ipl_results values(69 , '7', '2023-05-21', 'Wankhede Stadium, Mumbai','Mumbai Indians','Sunrisers Hyderabad','Mumbai Indians');
insert into ipl_results values(70 , '7', '2023-05-21', 'M Chinnaswamy Stadium, Bengaluru','Royal Challengers Bangalore','Gujarat Titans','Gujarat Titans');
insert into ipl_results values(71 , 'Qualifier 1' ,'2023-05-23', 'MA Chidambaram Stadium, Chennai','Gujarat Titans','Chennai Super Kings','Chennai Super Kings');
insert into ipl_results values(72 , 'Eliminator' ,'2023-05-24', 'MA Chidambaram Stadium, Chennai','Lucknow Super Giants','Mumbai Indians','Mumbai Indians');
insert into ipl_results values(73 , 'Qualifier 2' ,'2023-05-26', 'Narendra Modi Stadium, Ahmedabad','Gujarat Titans','Mumbai Indians','Gujarat Titans');
insert into ipl_results values(74 , 'Final' ,'2023-05-29', 'Narendra Modi Stadium, Ahmedabad','Chennai Super Kings','Gujarat Titans','Chennai Super Kings');


select * from ipl_results;
update ipl_results
set result='Chennai Super Kings'
where match_no=17 
UPDATE ipl_results
SET result='Chennai Super Kings'
WHERE match_no = 17;

UPDATE ipl_results
SET result = 'Chennai Super Kings'
WHERE match_no = 17
LIMIT 1;

/* -- Update dataset to test result
update ipl_results
set result='Chennai Super Kings'
where match_no=17 ;

update ipl_results
set result='Mumbai Indians'
where match_no=5;

update ipl_results
set result='Delhi Capitals'
where match_no=20;

update ipl_results
set result='Punjab Kings'
where match_no=27;

update ipl_results
set result='Rajasthan Royals'
where match_no=32;

update ipl_results
set result='Lucknow Super Giants'
where match_no=43;

update ipl_results
set result='Rajasthan Royals'
where match_no=60;

update ipl_results
set result='Sunrisers Hyderabad'
where match_no=65;
*/

with cte_teams as 
		(select home_team as teams from ipl_results 
		union select away_team as teams from ipl_results),
	cte as
		(select dates
		, t.teams as teams
		, result 
		, row_number() over(partition by t.teams order by dates) as id
		from ipl_results r
		join cte_teams t on r.home_team=t.teams or r.away_team=t.teams),
	cte_diff as
		(select dates,teams, result, id
		, id - row_number() over(partition by teams order by id) as diff
		from cte
		where result = teams),
	cte_final as 
		(select *
		,count(1) over(partition by teams, diff order by id
					  range between unbounded preceding and unbounded following) as streak
		from cte_diff)
select t.teams, coalesce(max(streak),0) as max_winning_streak
from cte_teams t
left join cte_final f on f.teams=t.teams
group by t.teams
order by max_winning_streak desc;



------------------------------------------------------------

with cte_teams as
				(
				select home_team  as teams from ipl_results
				union 
				select away_team as teams  from ipl_results
				),
cte as
					(select dates,concat(home_team,'Vs',away_team)as matches, teams,result
					,row_number()over(partition by teams order by teams,dates)as id
					from  cte_teams t
					join ipl_results r on r.home_team=t.teams or r.away_team=t.teams),
cte_diff as
    (select *
    ,row_number()over(partition by teams order by teams,dates)  as rnk
    ,id-row_number()over(partition by teams order by teams,dates) as diff
    from cte
where result=teams),
cte_final as
(select *
,
count(1)over(partition by teams,diff order by teams,dates range between unbounded preceding and  unbounded following) as streak
 from cte_diff)
 select teams,max(streak) as max_winng
 from cte_final
 group by teams
 order by max_winng

use challenge_thirtydays

with cte_teams as
(
		select home_team   as teams from ipl_results
		union select away_team   as teams from ipl_results
),
cte as
(
select dates,teams,concat(home_team ,'Vs',away_team)as matches,result
,row_number()over(partition by teams order by teams,dates) as id
 from cte_teams t 
 join  ipl_results r 
 on r.away_team=t.teams or r.home_team=t.teams
),
cte_diff as
(
select *,
row_number()over(partition by teams order by teams,dates) as rnk
,id-row_number()over(partition by teams order by teams,dates) as diff
 from cte
where result=teams),
cte_final as
(    select * 
	,count(1)over(partition by teams,diff order by teams,dates range between unbounded preceding and unbounded following) as streak
	from cte_diff
)
select teams,max(streak)as max_wing from cte_final
group by teams
order by max_wing desc


---------------------------------------------question 2-----------------------------------
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
-------------------------------------------------

        
with cte_trail1 as 
(        
        select 
        t1.hut1 as starthut
        ,h1.name as start_hut_name
        ,h1.altitude as start_hut_alt
        ,t1.hut2 as end_hut
        from mountain_huts h1
        join trails t1 on t1.hut1=h1.id
),
cte_trail2 as
(
   select
    t2.*
    
    ,h2.name as end_hut_name
    ,h2.altitude as end_hut_alt
    ,case when start_hut_alt >h2.altitude then 1 else 0 end as flag
    from cte_trail1  t2
    join  mountain_huts h2 on t2.end_hut=h2.id
)
,

cte_final as
(select 
		case when flag =1 then start_hut_alt else end_hut_alt   end as start_hut_altitude
		,case when flag =1 then start_hut_name else end_hut_name end as start_hut_names
		,case when flag =1 then end_hut_alt else start_hut_alt end  as end_hut_altitude
		,case when flag =1 then end_hut_name else start_hut_name end as end_hut_names
		from cte_trail2
)
select 
c1.start_hut_names as startpt
,c1.end_hut_names as mdlpt
,c2.start_hut_names as  lstpt
from cte_final c1
join cte_final c2 on c1.end_hut_altitude=c2.start_hut_altitude
-------------Question 26----------------------------------------------------

PROBLEM STATEMENT:
Given table contains tokens taken by different customers in a tax office.
Write a SQL query to return the lowest token number which is unique to a customer (meaning token should be allocated to just a single customer).
*/

drop table if exists tokens;
create table tokens
(
	token_num	int,
	customer	varchar(20)
);
insert into tokens values(1, 'Maryam');
insert into tokens values(2, 'Rocky');
insert into tokens values(3, 'John');
insert into tokens values(3, 'John');
insert into tokens values(2, 'Arya');
insert into tokens values(1, 'Pascal');
insert into tokens values(9, 'Kate');
insert into tokens values(9, 'Ibrahim');
insert into tokens values(8, 'Lilly');
insert into tokens values(8, 'Lilly');
insert into tokens values(5, 'Shane');

select * from tokens;

select token_num ,count(1)
from
 (
 select distinct * from tokens
)t
group by token_num
having count(token_num)=1
order by token_num
limit 1


-- Solution 1:
select token_num
from (select distinct * from tokens) t
group by token_num
having count(token_num) = 1
order by token_num 
limit 1

---------------------------sol 2-----------------------
select min(token_num) from
(

select token_num ,count(1)
from
 (
 select distinct * from tokens
)t
group by token_num
having count(token_num)=1
order by token_num)x

-- Solution 2:
select min(token_num) as token_num
from (
	select token_num
	from (
		select token_num, customer
		from tokens group by token_num, customer
		order by token_num) x 
	group by token_num	
	having count(1) = 1) y;



-- Solution 3:
select token_num
from (
	select token_num, customer
	from tokens group by token_num, customer
	order by token_num) x 
group by token_num	
having count(1) = 1
order by token_num 
limit 1;
----------------question 4----------------

use challenge_thirtydays
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

select min(id),min(name),min(location) from Q4_data;
select max(id),min(name),min(location) from Q4_data;
--------------------------question 6----------------------------------
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

select *
from (
select *, lag(marks,1,0) over(order by test_id) as prev_test_mark
	from student_tests
    ) x
where x.marks > prev_test_mark;
-------------------------------------------
select test_id,marks from
(
select *,
lag(marks,1,0)over(order by test_id) as prev_test_marks from student_tests
)x
where x.marks>prev_test_marks

------------------excluding first row---------------
select test_id,marks from
(
select *,
lag(marks,1,marks)over(order by test_id) as prev_test_marks from student_tests
)x
where x.marks>prev_test_marks
-----------------------------question 8-----------------------
select * from job_skills;

with cte as
(
select *
,sum(case when job_role is null then 0 else 1 end) over(order by row_id) as rnk
from job_skills
)
select *,
 first_value(job_role) over(partition by rnk order by row_id) as job_role
, skills
from cte
---------using recurssive function--------
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
---------------------------------------
with recursive cte as 
(
select row_id,job_role,skills
from job_skills where row_id=1
union
select j.row_id,coalesce(j.job_role,c.job_role) as job_role,j.skills
from 
cte c join job_skills j on j.row_id=c.row_id+1)
select * from cte

---syntax------
with recurssive cte as
(base query  -----first time
union
recursive query with tremination condtn)  in each iteration only this part executed
select * from cte
------------------------------question 10-----------------------
select * from auto_repair

  select v.value velocity, l.value level,count(1) as count
        from auto_repair l
        join auto_repair v on v.auto=l.auto and v.repair_date=l.repair_date and l.client=v.client
        where l.indicator='level'
        and v.indicator='velocity'
        group by v.value,l.value

SELECT
    velocity,
    COUNT(CASE WHEN level = 'good' THEN 1 END) AS good,
    COUNT(CASE WHEN level = 'wrong' THEN 1 END) AS wrong,
    COUNT(CASE WHEN level = 'regular' THEN 1 END) AS regular
FROM
    (
        SELECT
            v.value AS velocity,
            l.value AS level
        FROM
            auto_repair l
            JOIN auto_repair v ON v.auto = l.auto
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
    
    --------------------------------question 12------------------------
   use challenge_thirtydays 
   DROP TABLE IF EXISTS company;
CREATE TABLE company
(
	employee	varchar(10) primary key,
	manager		varchar(10)
);

INSERT INTO company values ('Elon', null);
INSERT INTO company values ('Ira', 'Elon');
INSERT INTO company values ('Bret', 'Elon');
INSERT INTO company values ('Earl', 'Elon');
INSERT INTO company values ('James', 'Ira');
INSERT INTO company values ('Drew', 'Ira');
INSERT INTO company values ('Mark', 'Bret');
INSERT INTO company values ('Phil', 'Mark');
INSERT INTO company values ('Jon', 'Mark');
INSERT INTO company values ('Omid', 'Earl');




with recursive  cte_teams as
(
   SELECT mng.employee,concat('team',row_number()over(order by mng.employee))as teams
   FROM company root
   join company mng on root.employee=mng.manager
   where root.manager is Null
   ),
 cte as
   (
   select c.employee ,c.manager,t.teams
   from company c
   cross join cte_teams t
    where c.manager is null
   ),

   SELECT * FROM cte
   with recursive cte as
		(select c.employee, c.manager, t.teams
		 from company c
		 cross join cte_teams t 
		 where c.manager is null
		 union 
		 select c.employee, c.manager
		 /*, case when t.teams is not null then t.teams 
		 		else case when c.manager = cte.employee then cte.teams end 
		   end as teams*/
		 , coalesce(t.teams, cte.teams) as teams 
		 from company c
		 join cte on cte.employee = c.manager
		 left join cte_teams t on t.employee = c.employee
		),
	cte_teams as
		(SELECT mng.employee, concat('Team ', row_number() over(order by mng.employee)) as teams
		FROM company root
		join company mng on root.employee = mng.manager
		where root.manager is null)
select teams, string_agg(employee, ', ') as members
from cte 
group by teams
order by teams
   
----------------------------------   
   
   
   
   
WITH RECURSIVE cte_teams AS (
    SELECT mng.employee, CONCAT('Team ', ROW_NUMBER() OVER (ORDER BY mng.employee)) AS teams
    FROM company root
    JOIN company mng ON root.employee = mng.manager
    WHERE root.manager IS NULL
),
cte AS (
    SELECT c.employee, c.manager, t.teams
    FROM company c
    CROSS JOIN cte_teams t
    WHERE c.manager IS NULL
	UNION 
    SELECT c.employee, c.manager,
    COALESCE(t.teams, cte.teams) AS teams 
    FROM company c
    JOIN cte ON cte.employee = c.manager
    LEFT JOIN cte_teams t ON t.employee = c.employee
 
)
SELECT *
FROM cte 

   -- ----------queation 14----------------------
 use challenge_thirtydays
select * from invoice;
select min(serial_no) from invoice
select  max(serial_no) from invoice
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


with recursive cte as 
(
select min(serial_no) as n from invoice
union 
select n+1 as n  from cte
where n< (select  max(serial_no) from invoice)
)
select n as missing_serial  from cte
except
select serial_no from invoice

-------------------------------


question 16---------------------
use challenge_thirtydays

drop table if exists covid_cases;
create table covid_cases
(
	cases_reported	int,
	dates			date	
);

INSERT INTO covid_cases VALUES (20124, STR_TO_DATE('10/01/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (40133, STR_TO_DATE('15/01/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (65005, STR_TO_DATE('20/01/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (30005, STR_TO_DATE('08/02/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (35015, STR_TO_DATE('19/02/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (15015, STR_TO_DATE('03/03/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (35035, STR_TO_DATE('10/03/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (49099, STR_TO_DATE('14/03/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (84045, STR_TO_DATE('20/03/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (100106, STR_TO_DATE('31/03/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (17015, STR_TO_DATE('04/04/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (36035, STR_TO_DATE('11/04/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (50099, STR_TO_DATE('13/04/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (87045, STR_TO_DATE('22/04/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (101101, STR_TO_DATE('30/04/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (40015, STR_TO_DATE('01/05/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (54035, STR_TO_DATE('09/05/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (71099, STR_TO_DATE('14/05/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (82045, STR_TO_DATE('21/05/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (90103, STR_TO_DATE('25/05/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (99103, STR_TO_DATE('31/05/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (11015, STR_TO_DATE('03/06/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (28035, STR_TO_DATE('10/06/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (38099, STR_TO_DATE('14/06/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (45045, STR_TO_DATE('20/06/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (36033, STR_TO_DATE('09/07/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (40011, STR_TO_DATE('23/07/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (25001, STR_TO_DATE('12/08/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (29990, STR_TO_DATE('26/08/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (20112, STR_TO_DATE('04/09/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (43991, STR_TO_DATE('18/09/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (51002, STR_TO_DATE('29/09/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (26587, STR_TO_DATE('25/10/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (11000, STR_TO_DATE('07/11/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (35002, STR_TO_DATE('16/11/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (56010, STR_TO_DATE('28/11/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (15099, STR_TO_DATE('02/12/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (38042, STR_TO_DATE('11/12/2020', '%d/%m/%Y'));
INSERT INTO covid_cases VALUES (73030, STR_TO_DATE('26/12/2020', '%d/%m/%Y'));


select * from covid_cases;

with cte as 
		(select extract(month from dates) as month
		, sum(cases_reported) as monthly_cases
		from covid_cases
		group by extract(month from dates)),
	cte_final as
		(select *
		, sum(monthly_cases) over(order by month) as total_cases
		from cte)
select month
, case when month > 1 
			then cast(round((monthly_cases/lag(total_cases) over(order by month))*100,1) as varchar)
	   else '-' end as percentage_increase
from cte_final;


-------------
with cte as
(
select extract(month from dates) months
,sum(cases_reported ) cases
from covid_cases
group by extract(month from dates)
),
cte_final as
(
select * ,sum(cases) over(order by months) as total_cases
from cte
)
select *
,case when months>1
then round((cases/lag(total_cases) over(order by months))*100,1) else '-' end as percentage
from cte_final

-------question 18-------------------
drop table if exists employees;
create table employees
(
	id			int,
	name		varchar(50)
);
insert into employees values(1, 'Lewis');
insert into employees values(2, 'Max');
insert into employees values(3, 'Charles');
insert into employees values(4, 'Sainz');


drop table if exists events;
create table events
(
	event_name		varchar(50),
	emp_id			int,
	dates			date
);
insert into events values('Product launch', 1,str_to_date('01-03-2024','%d-%m-%Y'));
insert into events values('Product launch', 3,str_to_date('01-03-2024','%d-%m-%Y'));
insert into events values('Product launch', 4,str_to_date('01-03-2024','%d-%m-%Y'));
insert into events values('Conference', 2, str_to_date('02-03-2024','%d-%m-%Y'));
insert into events values('Conference', 2, str_to_date('03-03-2024','%d-%m-%Y'));
insert into events values('Conference', 3, str_to_date('02-03-2024','%d-%m-%Y'));
insert into events values('Conference', 4,str_to_date('02-03-2024','%d-%m-%Y'));
insert into events values('Training', 3, str_to_date('04-03-2024','%d-%m-%Y'));
insert into events values('Training', 2, str_to_date('04-03-2024','%d-%m-%Y'));
insert into events values('Training', 4, str_to_date('04-03-2024','%d-%m-%Y'));
insert into events values('Training', 4, str_to_date('05-03-2024','%d-%m-%Y'));


select * from employees
select * from events


select e.id,e.name as employee,count(distinct event_name)
 from employees e 
join events ev on  e.id=ev.emp_id
group by e.id, e.name
having count(distinct event_name)=(SELECT COUNT(distinct event_name) FROM events)

-----------------question 20------------------------


select id,country ,age
from
(
select *
,row_number()over(partition by country order by age) as rn
,count(id) over(partition by  country order by age range between unbounded preceding and unbounded following) as count
 from people

 )
x
where rn >=count/2 and rn<=(count/2)+1



-----------------question22-------------------
select * from ipl_results

with cte_teams as
(
select home_team  as teams from  ipl_results
union 
select away_team  as teams from  ipl_results
),
cte as
(
select  r.dates,concat(r.home_team,'   Vs   ',r.away_team) as matches,t.teams,r.result
,ROW_NUMBER()over(partition by teams order by teams,dates) as id
from cte_teams t
join ipl_results r on r.home_team=t.teams or r.away_team=t.teams

),
cte_diff as
(
select * ,ROW_NUMBER()over(partition by teams order by teams,dates)rnk
,id-ROW_NUMBER()over(partition by teams order by teams,dates)diff

from cte
where result=teams),
cte_final as
(
select *,count(1) over(partition by teams,diff order by teams,dates range between unbounded preceding and unbounded following) as streak
from cte_diff
)
select teams,max(streak) as max_winning_streak
from cte_final
group by teams
order by max_winning_streak desc

---------------question 24---------------------------
select * from tokens 

select token_num,customer
,row_number()over(partition by token_num order by token_num)rn
from tokens

select min(token_num) from 
(
select token_num,count(1) from
(
select token_num, customer
		from tokens group by token_num, customer
		order by token_num
        ) x 
	group by token_num	
	having count(1) = 1
)y

   ----------question 26--------------------
   use challenge_thirtydays
   
   
   drop table if exists tokens;
create table tokens
(
	token_num	int,
	customer	varchar(20)
);
insert into tokens values(1, 'Maryam');
insert into tokens values(2, 'Rocky');
insert into tokens values(3, 'John');
insert into tokens values(3, 'John');
insert into tokens values(2, 'Arya');
insert into tokens values(1, 'Pascal');
insert into tokens values(9, 'Kate');
insert into tokens values(9, 'Ibrahim');
insert into tokens values(8, 'Lilly');
insert into tokens values(8, 'Lilly');
insert into tokens values(5, 'Shane');
   select * from tokens 

select token_num,customer
,row_number()over(partition by token_num order by token_num)rn
from tokens

select min(token_num) from 
(
select token_num,count(1) from
(
select token_num, customer
		from tokens group by token_num, customer
		order by token_num
        ) x 
	group by token_num	
	having count(1) = 1
)y
   
   -----------question 28-----------------
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

select * from item

select 
id,length(group_concat(items)as length

from item
cross apply string_split(items,',')
group by id
   
SELECT 
    id,
    GROUP_CONCAT(LENGTH(value) SEPARATOR ',') AS lengths
FROM 
    item
CROSS JOIN 
    STRING_SPLIT(items, ',')
    
GROUP BY 
    id;


select *,
 string_to_array(items,',')
 from item
   
   
   select *
   from item
   cross apply string_split(items,',')
   
   
   
   -----------------30 Question---------------------------------
   use challenge_thirtydays
   
select * from students;
select * from student_marks;
select * from subjects;
select * from subjects
select student_id, subject1 from
 student_marks;
 
 
 


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
---------------------------------------------------------------------------------------------
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
    ctes as
    (
    
select s.name,c.* from cte c 
join students s on c.student_id=s.roll_no
where c.marks is not null
order by c.student_id
),
cte_sub as
(
select a.subject_code,b. subject_name,b.pass_marks
from
(

select row_number()over(order by ordinal_position) as rn,column_name as subject_code
 from information_schema.columns
where TABLE_SCHEMA = 'challenge_thirtydays'
and table_name='student_marks'
and column_name like'Subject%')a
join
(
select  row_number()over(order by id) as rn,pass_marks ,
name as subject_name
from subjects)b on b.rn=a.rn),
 cte_final as
 (
select ct.student_id,ct.name
,avg(ct.marks)as percentage_marks
,group_concat( case when ct.marks >=cts.pass_marks then null else cts.subject_name END SEPARATOR ' ') as  failedsubject
 from ctes ct
join cte_sub cts on ct.subject_code =cts.subject_code
group by ct.student_id,ct.name
order by ct.student_id
)
select student_id,name,percentage_marks,coalesce(failedsubject,'-'),case when failedsubject is not null then 'failed' 
when percentage_marks >=70  then 'First class'
when percentage_marks between 50 and 70  then 'Second class'
when percentage_marks < 50 then 'Third class' end as result
from cte_final 