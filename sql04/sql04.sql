--1번문제
/*
 * 가장 늦게 입사한 직원의 이름 (first_name과 last_name)과 연봉과 근무하는 부서 이름은? 
 */

select e.first_name ||' '|| last_name as name ,
       e.salary, 
       de.department_name, 
       e.hire_date
from employees e, departments de
where hire_date in (select max(hire_date) 
                    from employees)
      and e.department_id = de.department_id;  

--2번문제
/*
 * 평균 연봉이 가장 높은 부서 직원들의 직원번호, 이름, 성 과 업무, 연봉을 조회하시오
 */

select em.employee_id, 
       em.first_name, 
       em.last_name, 
       em.salary, 
       jobs.job_title
from employees em,jobs, (select department_id 
                         from (select department_id, avg(salary)salary 
                               from employees 
                               group by department_id )s1,
                                            (select max(salary)salary 
                                             from (select department_id , avg(salary)salary
                                                   from employees 
                                                   group by department_id))s2
                         where s1.salary = s2.salary)s3
where em.department_id = s3.department_id and em.job_id = jobs.job_id; 

--3번문제
/*
 * 평균급여가 가장 높은 부서는?
 */
select d.department_name
from (select department_id, avg(salary)savg 
      from employees 
      group by department_id)s ,
     (select max(avg(salary))smax 
      from employees 
      group by department_id)m, 
      departments d
where s.savg = m.smax 
      and s.department_id = d.department_id; 

--4번문제
/*
 * 평균급여가 가장 높은 지역은?
 */
   
 select region_name
from (select r.region_name, avg(salary)avg1
      from employees e, 
           departments d,
           locations l, 
           countries c,
           regions r
      where e.department_id = d.department_id 
            and d.location_id = l.location_id 
            and l.country_id = c.country_id
            and c.region_id = r.region_id  
      group by r.region_name)s,
      (select max(avg1)avg2
      from(select avg(salary)avg1
      from employees e, 
           departments d,
           locations l, 
           countries c,
           regions r
      where e.department_id = d.department_id 
            and d.location_id = l.location_id 
            and l.country_id = c.country_id
            and c.region_id = r.region_id  
      group by r.region_id))m
where s.avg1 = m.avg2;

--5번 문제 
/*
 * 평균급여가 가장 높은 업무는?
 */

select j1.job_title
from (select em.job_id, 
             avg(em.salary)avg1 
      from employees em 
      group by em.job_id)s1,
     (select max(avg(em.salary))max1 
      from employees em, jobs j
      where em.job_id =j.job_id
      group by j.job_id)s2, jobs j1
where s1.job_id = j1.job_id and s1.avg1 = s2.max1;
      