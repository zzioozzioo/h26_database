-- 문제 24 [인사부서 데이터베이스] --

-- (1) 교재질의
-- 1. Employees와 Departments 테이블에 저장된 튜플의 개수를 출력하시오.
select count(*) from Employees;
select count(*) from Departments;

-- 2. Employees테이블에 대한 employee_id, job_id, hire_date,를 출력하시오.
select employee_id, job_id, hire_date from Employees;

-- 3. Employees테이블에서 salary가 12,000이상인 last_name과 salary를 출력하시오.
select last_name, salary from Employees
where salary >= 12000;

-- 4. 부서번호(department_id)가 20 혹은 50인 직원의 last_name과 department_id를 last_name에 대하여 오름차순으로 출력하시오.
select last_name, department_id from Employees
where department_id in (20, 50)
order by last_name;

-- 5. last_name의 세 번째에 a가 들어가는 직원의 last_name을 출력하시오.
select distinct last_name from Employees
where last_name like '__a%';

-- 6. 같은 일(job)을 하는 사람의 수를 세어 출력하시오.
select job_id, count(employee_id) from Employees
group by job_id;

-- 7. 급여(salary)의 최대값과 최소값의 차이를 구하시오.
select max(salary)-min(salary) as "차이" from Employees;

-- 8. Toronto에서 일하는 직원의 last_name, job, department_id, Department_name을 출력하시오.
select e.last_name, e.job_id, d.department_id, d.department_name from Employees e
join Departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id
where l.city = 'Toronto';


-- (2) 부속질의
-- 1. 전체 직원 평균 급여보다 많이 받는 직원의 last_name과 salary를 출력하시오.
-- 전체 직원 평균 급여 추출
select avg(salary) from Employees

select last_name, salary from Employees
where salary > (
    select avg(salary) from Employees
);

-- 2. dea hann과 같은 job_id를 가진 직원의 last_name과 job_id를 출력하시오.
select last_name, job_id from Employees
where job_id = (
    select job_id from Employees
    where last_name = 'De Haan'
);

-- 3. 부서별 최고 급여를 받는 직원의 last_name, department_id를 출력하시오.
-- 부서별 최고 급여 추출
select department_id, max(salary) from Employees
group by department_id

-- 해당 급여를 받는 직원의 last_name, department_id 추출
select last_name, salary, department_id from Employees
where (department_id, salary) in (
    select department_id, max(salary) from Employees
    group by department_id
);

-- 4. IT부서 직원의 평균 급여보다 많이 받는 직원의  last_name과 salary를 출력하시오.
-- IT부서 직원의 평균 급여 추출
select avg(e.salary) from Employees e
join Departments d on e.department_id = d.department_id
where d.department_name = 'IT'

-- 해당 급여보다 많이 받는 직원의 last_name과 salary 추출
select last_name, salary from Employees
where salary > (
    select avg(e.salary) from Employees e
    join Departments d on e.department_id = d.department_id
    where d.department_name = 'IT'
);

-- 5. 직무이력(JOB_HISTORY)이 있는 직원의 last_name과 현재 job_id를 출력하시오.
select last_name, job_id from Employees
where employee_id in (
    select employee_id from JOB_HISTORY
);

-- 다른 방법
select e.last_name, e.job_id from Employees e
where exists (
    select 1 from JOB_HISTORY jh
    where e.employee_id = jh.employee_id
);


-- 6. 직무이력이 없는 직원의 last_name과 employee_id를 출력하시오.
select e.last_name, e.job_id from Employees e
where not exists (
    select 1 from JOB_HISTORY jh
    where e.employee_id = jh.employee_id
);

-- 7. 급여가 자신이 속한 부서 평균보다 높은 직원의 이름,급여,부서번호를 출력하시오(상관부속질의)
-- 자신이 속한 부서 평균 추출
select avg(salary) from Employees
group by department_id

-- 해당 평균보다 높은 ~
select last_name, salary, department_id from Employees e1
where salary > (
    select avg(salary) from Employees e2
    where e1.department_id = e2.department_id
    group by department_id
);

-- 8. kochhar(101)를 관리자로 두는 직원의 이름과 급여를 출력하시오.
select last_name, salary from Employees
where manager_id = 101;

-- 9. 급여 최상위 3명의 last_name과 salary를 출력하시오.
select last_name, salary from Employees
order by salary asc
fetch first 3 row only;

-- 10. FI_ACCOUNT 직원 중 급여가 FI_ACCOUNT 평균보다 높은 직원을 출력하시오.
-- FI_ACCOUNT 평균 추출
select avg(salary) from Employees
where job_id = 'FI_ACCOUNT'

-- FI_ACCOUNT 직원 중 급여가 해당 평균보다 높은 직원
select employee_id from Employees
where salary > (
    select avg(salary) from Employees
    where job_id = 'FI_ACCOUNT'
) and job_id = 'FI_ACCOUNT';