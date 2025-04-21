## 牛客SQL快速入门题型
select *
from user_profile

select device_id
,gender
,age
,university
from user_profile

select distinct university
from user_profile

select device_id
from user_profile
limit 2

select device_id user_infos_example
from user_profile
limit 2

select device_id
,university
from user_profile
where university = '北京大学'

select device_id
,gender
,age
,university
from user_profile
where age>24

select device_id
,gender
,age
from user_profile
where age between 20 and 23

select device_id
,gender
,age
,university
from user_profile
where university != '复旦大学'

select device_id
,gender
,age
,university
from user_profile
where age is not NULL

select device_id
,gender
,age
,university
,gpa
from user_profile
where gender = 'male' and gpa > 3.5

select device_id
,gender
,age
,university
,gpa
from user_profile
where university = '北京大学' or gpa > 3.7 

select device_id
,gender
,age
,university
,gpa
from user_profile
where university in ('北京大学','复旦大学','山东大学')

select device_id
,gender
,age
,university
,gpa
from user_profile
where gpa > 3.5 and university = '山东大学' or gpa  > 3.8 and university = '复旦大学'
order by device_id

select device_id
,age
,university
from user_profile
where university like "%北京%"

select max(gpa) gpa
from user_profile
where university = '复旦大学'

select count(gender) male_num
,avg(gpa) avg_gpa
from user_profile
where gender = 'male'

select gender
,university
,count(device_id) user_num
,avg(active_days_within_30) avg_active_day
,avg(question_cnt) avg_question_cnt
from user_profile
group by gender,university
order by gender,university

select university
,avg(question_cnt) avg_question_cnt
,avg(answer_cnt) avg_answer_cnt
from user_profile
group by university
having avg(question_cnt) < 5 or avg(answer_cnt) <20

select university
,avg(question_cnt) avg_question_cnt
from user_profile
group by university
order by avg_question_cnt

select a.device_id
,question_id
,result
from question_practice_detail a
join  user_profile b on a.device_id = b.device_id
where university = '浙江大学'

select
    count(date1) / count(*) avg_ret
from
    (
        select distinct
            device_id,
            date
        from
            question_practice_detail
    ) as a
    left join (
        select distinct
            device_id,
            date (date + 1) date1
        from
            question_practice_detail
    ) as b on a.device_id = b.device_id
    and a.date = b.date1

select if(profile like '%female','female','male') gender, count(*) number
from user_submit
group by gender

select device_id, trim("http:/url/" from blog_url)
from user_submit

select substr(profile,12,2) age, count(*) number
from user_submit    
group by age 

select device_id
,university
,gpa 
from
    (
    select device_id
    ,university
    ,gpa
    ,rank()over(partition by university order by gpa) r
    from user_profile
    order by university
    ) a
where a.r = 1

select b.device_id
,university
,count(result) 	question_cnt
,sum(if(result = 'right', 1, 0)) right_question_cnt
from user_profile b left join question_practice_detail c 
on b.device_id = c.device_id and month(date) = 8
where university = '复旦大学' 
group by b.device_id

select difficult_level
,sum(if(result = 'right', 1, 0))/count(result) correct_rate
from question_practice_detail b left join user_profile c  
on b.device_id = c.device_id
left join question_detail d 
on b.question_id = d.question_id
where university = '浙江大学'
group by difficult_level
order by correct_rate

select device_id
,age
from user_profile
order by age

select device_id
,gpa
,age
from user_profile
order by gpa,age

select device_id,gpa,age
from user_profile
order by gpa desc,age desc

select count(distinct device_id) did_cnt
,count(id) question_cnt
from question_practice_detail 
where month(date) = 8

### 大厂真题
#40
select *
from(
    select month
    ,row_number()over(partition by month order by play_pv desc,song_id) ranking
    ,song_name
    ,play_pv
    from
        (
        select month(fdate) month
        ,song_name
        ,a.song_id song_id
        ,count(*) play_pv
        from play_log a left join song_info b on a.song_id = b.song_id
        left join user_info c on a.user_id = c.user_id
        where singer_name = '周杰伦' and age between 18 and 25
        group by month,song_name,a.song_id
        ) t1
    ) t2
where ranking in (1,2,3)

#41
select user_id,max(consec_days) max_consec_days
from(
    select user_id,date2,count(*) consec_days
    from
        (
        select *,date_sub(fdate,interval date_rank day) date2
        from
            (
            select distinct *,row_number()over(partition by user_id order by fdate) date_rank
            from tb_dau
            where fdate between '2023-01-01' and '2023-01-31'
            ) t1
        ) t2
    group by user_id,date2
    ) t3
group by user_id

#42
select pay_ability
,concat(round(sum(if(overdue_days is not NULL,1,0))/count(*) *100,1), '%') overdue_ratio
from customer_tb a join loan_tb b on a.customer_id = b.customer_id
group by pay_ability
order by overdue_ratio desc

#43
select date_format(t_time,'%Y-%m') time
,sum(t_amount) total
from trade a left join customer b on a.t_cus = b.c_id
where c_name = 'Tom' and t_type = 1 and year(t_time) = 2023
group by date_format(t_time,'%Y-%m')
order by time

#44
select user_id
,room_id
,room_type
,days
from
(    select user_id
    ,a.room_id room_id
    ,room_type
    ,datediff(date(checkout_time),date(checkin_time)) days
    from checkin_tb a left join guestroom_tb b on a.room_id = b.room_id) t
where days >= 2 
order by days,room_id,user_id desc

#45
select sum(course1) + sum(course2) + sum(course3) staff_nums
from(select info_id,staff_id,course,
if(course like '%1%',1,0) course1,
if(course like '%2%',1,0) course2,
if(course like '%3%',1,0) course3
from cultivate_tb) nt

#46
select a.staff_id
,staff_name
from staff_tb a left join cultivate_tb b on a.staff_id = b.staff_id
where course like '%3%'

#47
select avg(score) avg_score
from  (select score
    from recommend_tb a left join user_action_tb b on a.rec_user = b.user_id
    where rec_info_l = hobby_l
    group by user_id) nt

#48
select product_name
,total_sales
,rank()over(partition by category order by total_sales desc) category_rank
from (
    select name product_name
    ,sum(quantity)  total_sales
    ,category
    from products a right join orders b on a.product_id = b.product_id
    where name is not NULL
    group by name,category) nt
order by category,total_sales desc

#49
select post,round(avg(timestampdiff(minute,first_clockin,last_clockin)/60),3) work_hours
from staff_tb a left join attendent_tb b on a.staff_id = b.staff_id
where first_clockin is not NULL or last_clockin is not NULL
group by post
order by work_hours desc

#50
select user_id
from
    (
    select user_id,time2,count(*) days
    from 
        (
        select user_id,date(log_time) time1,date(date_sub(log_time,interval date_rank day)) time2
        from
            (    
            select a.user_id user_id, log_time, rank()over(partition by user_id order by log_time) date_rank
            from login_tb a left join register_tb b on a.user_id = b.user_id
            where reg_port is not NULL
            order by a.user_id
            ) t1
        ) t2 
    group by user_id,time2
    ) t3
where days >=3

#51
select vip
,count(a.user_id) visit_nums
,count(distinct a.user_id) visit_users
from uservip_tb a right join visit_tb b on a.user_id = b.user_id
group by vip
order by visit_nums desc

#52
select vip,sum(if(order_price is NULL,0,order_price)) order_total
from uservip_tb a left join order_tb b on a.user_id = b.user_id
group by vip
order by order_total desc

#53
select a.user_id,count(distinct visit_time) visit_nums
from order_tb a left join visit_tb b on a.user_id = b.user_id  
where date(order_time) = '2022-09-02' and date(visit_time) = '2022-09-02'
group by a.user_id
order by visit_nums desc

#54
select t1.date,concat(round(order_num/visit_num*100,1),'%') cr
from
(select date(order_time) date,count(distinct user_id) order_num
from order_tb
group by date) t1
left join
(select date(visit_time) date,count(distinct user_id) visit_num
from visit_tb
group by date) t2
on t1.date = t2.date

#55
select a.staff_id,staff_name,concat(round(dock_salary/normal_salary*100,1),'%') dock_ratio
from staff_tb a left join salary_tb b on a.staff_id = b.staff_id
where department = 'dep1'
order by dock_ratio desc

#56
select user_id,sum(floor(timestampdiff(minute,visit_time,leave_time)/10)) point
from visit_tb 
group by user_id
order by point desc

#57
select a.user_id,point+sum(order_price) point
from order_tb a left join uservip_tb b on a.user_id = b.user_id
where order_price > 100
group by a.user_id
order by point desc

#58
select  date(order_time) order_date,a.user_id,count(*) order_nums,vip
from order_tb a left join uservip_tb b on a.user_id = b.user_id
group by date(order_time),a.user_id
having order_nums >= 2

#59
select department,avg(salary) avg_salary
from
    (
    select department,normal_salary - dock_salary salary
    from staff_tb a left join salary_tb b on a.staff_id = b.staff_id
    ) t1
where salary between 4000 and 30000
group by department
order by avg_salary desc

#60
select department,concat(round(sum(if(hour>9.5,1,0))/count(*)*100,1),'%') ratio
from 
    (
    select department,timestampdiff(minute,first_clockin,last_clockin)/60 hour
    from staff_tb a left join attendent_tb b on a.staff_id = b.staff_id
    ) t1
group by department
order by ratio desc

#61
select date(log_time) log_day,user_id,hobby
from 
    (
    select a.user_id user_id,hobby,log_time
    ,rank()over(partition by date(log_time) order by log_time) ranking
    from login_tb a left join user_action_tb b on a.user_id = b.user_id
    ) t1
where ranking = 1
order by log_day

#62
select cast(avg(abs(timestampdiff(second,a.logtime,b.logtime))) as signed) gap
from order_log a left join select_log b on a.order_id = b.order_id
and a.uid = b.uid and a.product_id = b.product_id

#63
select t2.music_name music_name
from (select music_name 
from music_likes a left join music b on a.music_id = b.id 
where user_id = 1) t1
right join
(select music_name,id
from music_likes a left join follow b on a.user_id = b.follower_id
left join music c on a.music_id = c.id
where b.user_id = 1) t2
on t1.music_name = t2.music_name
where t1.music_name is NULL
group by music_name,id
order by id

#64
select a.goods_id id,name,weight,sum(count) total
from trans a left join goods b on a.goods_id = b.id
where weight < 50
group by a.goods_id
having sum(count) >20
order by id

#65
select sum(read_num)/sum(show_num) fans_ctr
from b left join a on b.author_id = a.author_id
left join c on b.content_id = c.content_id
where a.fans_id = c.fans_id

#66
select count(*)
from
    (select sId
    from SC 
    group by sId
    having avg(score) > 60
    ) t1

#67
select t1.cid cid,pv,row_number()over(order by pv desc,b.release_date desc) rk
from 
(select uid,cid,cast(count(*) as decimal(10,3)) pv
from play_record_tb 
group by uid,cid
having count(*)>1) t1 
left join course_info_tb b on t1.cid = b.cid
order by rk
limit 3 

#68
select room_id,room_name,count(distinct user_id) user_count
from 
    (
    select a.room_id room_id,room_name,user_id
    from user_view_tb a left join room_info_tb b on a.room_id = b.room_id
    where in_time between '23:00:00' and '24:00:00' or out_time between '23:00:00' and '24:00:00'
    ) t1
group by room_id,room_name
order by user_count desc

#69
select sum(sales_num * goods_price),sum(sales_num * goods_price)/count(distinct user_id)
from sales_tb a left join goods_tb b on a.goods_id = b.goods_id

#70
with t1 as 
(select a.emp_id,a.exam_id,emp_level,tag
,timestampdiff(second,start_time,submit_time) time
,avg(timestampdiff(second,start_time,submit_time))over(partition by exam_id) avg_time
,score
,avg(score)over(partition by exam_id) avg_score
from exam_record a left join emp_info b on a.emp_id = b.emp_id
left join examination_info c on a.exam_id = c.exam_id
where emp_level < 7)

select emp_id,emp_level,tag exam_tag
from t1
where time < avg_time and score > avg_score
order by emp_id,exam_id

#71
select a.exp_number exp_number,exp_type,claims_cost
from express_tb a left join exp_cost_tb b on a.exp_number = b.exp_number
where claims_cost is not NULL
order by claims_cost desc

#72
select exp_type, round(avg(timestampdiff(minute,out_time,in_time)/60),1) time
from express_tb a left join exp_action_tb b on a.exp_number = b.exp_number
group by exp_type
order by time

#73
select round(avg(timestampdiff(minute,create_time,out_time)/60),3) time
from express_tb a left join exp_action_tb b on a.exp_number = b.exp_number

#74
select product_id,count(*) cnt
from 
    (
    select uid,product_id
    from user_client_log
    group by uid,product_id
    ) t1
group by product_id
order by cnt desc
limit 1

#75
select uid, count(*) cnt
from user_client_log
where step = 'order'
group by uid 
order by cnt desc,uid 
limit 3

#76
select product_id,product_name,type,price
from 
    (
    select *,rank()over(partition by type order by price desc) ranking
    from product_info
    ) t1
where ranking <= 2
order by price desc,product_name
limit 3

#77
select product_name,cast(avg(price) as signed) * count(*) price
from user_client_log a left join product_info b on a.product_id = b.product_id
where step = 'select'
group by product_name
order by price desc
limit 2

#78
select if(pay_method = '','error',pay_method) pay_method1,count(*) num
from user_client_log a left join product_info b on a.product_id = b.product_id 
where step = 'select' and product_name = 'anta'
group by pay_method1
order by num desc

#79
select customer_id,sum(balance) sum_balance
from account
group by customer_id
order by sum_balance desc,customer_id 

#80
select department,employee_name,salary
from
    (
    select *, rank()over(partition by department order by salary desc) rk
    from employees
    ) t1
where rk <= 2
order by 1,3 desc

#82
select order_id,customer_name,order_date
from 
    (
    select order_id,customer_name,order_date,
    row_number()over(partition by customer_name order by order_date desc) rk
    from orders a left join customers b on a.customer_id = b.customer_id
    ) t1
where rk = 1
order by 2
### 链接表不能直接*

#83
select substr(order_id,6,4) product_id, count(*) cnt
from order_log
group by 1

#84
select order_id,customer_name,order_date
from 
    (
    select order_id,customer_name,order_date
    ,row_number()over(partition by customer_name order by order_date desc) ranking
    from orders a left join customers b on a.customer_id = b.customer_id
    ) t1
where ranking = 1

#85
with t4 as    
    (select product_id
    ,round(avg(unit_price),2) * sum(quantity) total_sales
    ,round(avg(unit_price),2) unit_price,sum(quantity) total_quantity
    ,round(round(avg(unit_price),2) * sum(quantity) / 12,2) avg_monthly_sales
    ,max(monthly_quantity) max_monthly_quantity
    from 
        (
        select order_id,a.product_id,unit_price,quantity
        ,sum(quantity)over(partition by a.product_id,date(order_date)) monthly_quantity
        from orders a left join customers b on a.customer_id = b.customer_id
        left join products c on a.product_id = c.product_id
        ) t3
    group by product_id),
    t2 as
    (select *
    from 
        (
        select a.product_id
        ,a.customer_id
        ,row_number()over(partition by a.product_id order by quantity desc,customer_age) rk
        ,case when customer_age between 1 and 10 then '1-10'
        when customer_age between 11 and 20 then '11-20'
        when customer_age between 21 and 30 then '21-30'
        when customer_age between 31 and 40 then '31-40'
        when customer_age between 41 and 50 then '41-50'
        when customer_age between 51 and 60 then '51-60'
        else '61+' end  customer_age_group
        from orders a left join customers b on a.customer_id = b.customer_id
        left join products c on a.product_id = c.product_id
        ) t1
    where rk = 1)

select t4.product_id,total_sales,unit_price,total_quantity
,avg_monthly_sales,max_monthly_quantity,customer_age_group
from t4 left join t2 using(product_id)
order by 2 desc, 1

#86
select department
,round(avg(actual_salary),2) average_actual_salary
,ifnull(round(avg(if(staff_gender = 'male',actual_salary,null)),2),0) average_actual_salary_male
,ifnull(round(avg(if(staff_gender = 'female',actual_salary,null)),2),0) average_actual_salary_female
from 
    (
    select department,staff_gender,normal_salary - dock_salary actual_salary
    from staff_tb a left join salary_tb b on a.staff_id = b.staff_id
    ) t1
group by department
order by 2 desc

#87
select customer_id,customer_name,product_name latest_order
from 
    (
    select a.customer_id customer_id,customer_name,product_name
    ,rank()over(partition by customer_name order by order_date desc) rk 
    from orders a left join customers b on a.customer_id = b.customer_id
    left join products c on a.product_id = c.product_id
    ) t1
where rk = 1
order by 1

#88
with t1 as
    (
    select a.cid cid,sum(if(a.start_time between b.start_time and b.end_time, 1, 0)) num
    from play_record_tb a join play_record_tb b on a.cid = b.cid
    group by a.id,a.cid
    ) ##提前创建好一个表：避免麻烦

select cid,max(num) max_peak_uv
from t1
group by cid
order by 2 desc,1
limit 3

#89
with t1 as
    (
        select cust_name,a.order_num order_num,quantity,item_price
        from Orders a left join Customers b on a.cust_id = b.cust_id
        left join OrderItems c on a.order_num = c.order_num 
    )

select cust_name, order_num, quantity * item_price OrderTotal
from t1
order by 1

#90
select count(distinct a.uid)
from user_info a left join order_log b on a.uid = b.uid
where order_id is null

#92
select city,sum(total_amount) total_order_amount
from orders a left join customers b on a.customer_id = b.customer_id
group by city
order by 2 desc,1

#93
select channel,count(*) cnt
from user_info a left join order_log b on a.uid = b.uid
where order_id is null
group by channel
order by 2 desc, 1
limit 1

#94
with t2 as (select *
from 
    (
    select *,row_number()over(partition by EMPLOYEE_ID order by UPDATE_DT desc) rk
    from EMPLOYEE_UPDATE
    ) t1
where rk = 1)

select a.EMPLOYEE_ID EMPLOYEE_ID
,if(UPDATE_DT > LAST_UPDATE_DT,NEW_POSITION,POSITION) POSITION
,if(UPDATE_DT > LAST_UPDATE_DT,UPDATE_DT,LAST_UPDATE_DT) LAST_UPDATE_DT
from EMPLOYEE_INFO a left join t2 using(EMPLOYEE_ID)

#95
select a.cid cid
,count(*) pv
,round(sum(timestampdiff(minute,start_time,end_time)),3)  time_len
from play_record_tb a left join course_info_tb b on a.cid = b.cid
where datediff(start_time,release_date)<7
group by a.cid
having avg(score) >= 3
order by 2 desc,3 desc
limit 3

#where提前进行了筛选 
#而不是cast(sum(if(start_time 
#between release_date and date_add(release_date,interval 7 day),1,0)) as signed) pv

## SQL热题

#200
select *
from employees
order by hire_date desc
limit 1

#201
select emp_no, birth_date, first_name, last_name, gender, hire_date
from
    (    
    select *, dense_rank()over(order by hire_date desc) rk
    from employees
    ) t1
where rk = 3
order by emp_no 

#202
select a.emp_no, salary, from_date, a.to_date, dept_no  
from salaries a left join dept_manager b on a.emp_no = b.emp_no
where dept_no is not null
order by 1

#203
select last_name, first_name, dept_no
from employees a left join dept_emp b on a.emp_no = b.emp_no
where dept_no != 'null'

#204
select last_name, first_name, dept_no  
from employees a left join dept_emp b using(emp_no)

#206
select distinct emp_no, cnt
from (
    select emp_no,count(emp_no)over(partition by emp_no) cnt
    from salaries   
    ) t1
where cnt>15

#207
select distinct salary
from salaries
order by 1 desc

#209
select emp_no
from employees a left join dept_manager b using(emp_no)
where dept_no is null

#210
select a.emp_no, b.emp_no manager
from dept_emp a left join dept_manager b on a.dept_no = b.dept_no
where a.emp_no != b.emp_no

#211
select  dept_no, emp_no, salary
from
    ( 
    select dept_no, a.emp_no, salary, rank()over(partition by dept_no order by salary desc) rk
    from dept_emp a left join salaries b using(emp_no)
    ) t1
where rk = 1
order by 1

#214
select *
from employees
where emp_no % 2 = 1 and last_name != 'Mary'
order by hire_date desc

#215
select title, avg(s.salary)
from titles a left join salaries s using(emp_no)
group by 1

#216
select emp_no, salary
from
    (
    select *, dense_rank()over(order by salary desc) rk
    from salaries
    ) t1
where rk = 2
order by 1

#217
select emp_no, salary, last_name, first_name
from employees a left join salaries b using(emp_no)
where salary = 
(
    select max(salary)
    from salaries 
    where salary <
    (
        select max(salary)
        from salaries
    )
)

#218
select last_name, first_name, dept_name
from dept_emp a left join departments b on a.dept_no = b.dept_no
right join employees c on a.emp_no = c.emp_no

#219
select t1.emp_no, end_salary - start_salary growth
from 
(select a.emp_no, salary start_salary
from employees a left join salaries b using(emp_no)
where hire_date = from_date) t1
left join 
(select emp_no, salary end_salary
from salaries
where to_date = '9999-01-01') t2
using(emp_no)
where end_salary is not null
order by 2

#221
select dept_no, dept_name, count(*)
from dept_emp a left join departments b using(dept_no)
left join salaries using(emp_no)
group by dept_no, dept_name
order by 1

#222
select emp_no, salary, dense_rank()over(order by salary desc) t_rank
from salaries
order by 2 desc, 1

#223
select a.dept_no, a.emp_no, salary
from dept_emp a left join dept_manager b using(dept_no)
left join salaries c on a.emp_no = c.emp_no
where a.emp_no != b.emp_no

#224
select c.emp_no, t2.emp_no manager_no, salary emp_salary, boss_salary manager_salary
from dept_emp c left join salaries b using(emp_no)
left join
(select dept_no, emp_no, salary boss_salary
from dept_manager a left join salaries b using(emp_no)) t2
using(dept_no)
where salary > boss_salary

#225
select distinct a.dept_no, dept_name, title, count(*)over(partition by a.dept_no, title)
from dept_emp a left join departments b using(dept_no)
left join titles c using(emp_no)

#228
select a.film_id, title
from film a left join film_category b using(film_id)
where category_id is null

#229
select title, description
from film_category a left join film b using(film_id)
left join category c using(category_id)
where name = 'Action'

#231
select concat(last_name,' ',first_name)
from employees

#232
create table actor
(
    actor_id smallint(5) primary key not null,
    first_name varchar(45) not null,
    last_name varchar(45) not null,
    last_update date not null
)

#233
insert into actor(actor_id,first_name,last_name,last_update)
values (1,'PENELOPE','GUINESS','2006-02-15 12:34:33'),
(2,'NICK','WAHLBERG','2006-02-15 12:34:33')

#250
select id, length(string) - length(replace(string, ',', ''))
from strings

#251
select first_name
from employees
order by right(first_name, 2)

#252
select dept_no, group_concat(emp_no) employees
from dept_emp
group by dept_no

#253
with t1 as
(
    select *
    from salaries
    where to_date = '9999-01-01'
)
select avg(salary)
from t1
where salary != (
    select max(salary)
    from
        (
    select *
    from salaries
    where to_date = '9999-01-01'
) t2
) 
and salary != 
(
    select min(salary)
    from (
    select *
    from salaries
    where to_date = '9999-01-01'
) t3
)