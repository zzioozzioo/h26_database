-- 문제 23 [사원 데이터베이스] --

-- (1) 교재질의
-- 1. 사원의 이름과 업무를 출력하시오. 단 사원의 이름은 ‘사원이름’, ‘업무는 ’사원업무‘, 머리글이 나오도록 출력하시오.
select ename as "사원이름", job as "사원업무" from emp;

-- 2. 30번 부서에 근무하는 모든 사원의 이름과 급여를 출력하시오
select ename, sal from emp e
join dept d on e.deptno = d.deptno
where d.deptno = 30;

-- 3. 사원번호와 이름, 현재급여, 증가된 급여분(열 이름은  증가액), 10% 인상된 급여(열 이름은  '인상된 급여')를 
-- 사원 번호 순으로 출력하시오.
select empno, ename, sal, comm as "증가액", sal*1.1 as "인상된 급여" from emp
order by empno;

-- 4. 'S'로 시작하는 모든 사원과 부서번호를 출력하시오.
select ename, deptno from emp
where ename like 'S%';

-- 5. 모든 사원의 최대 및 최소 급여, 합계 및 평균 급여를 출력하시오. 
-- 열이름은 각각 MAX, MIN, SUM, AVG로 한다. 단 소수점 이하는 반올림하여 정수로 출력한다.
select round(max(sal)) as MAX, 
        round(min(sal)) as MIN, 
        round(sum(sal)) as SUM, 
        round(avg(sal)) as AVG 
from emp;

-- 6. 업무(job)별로 동일한 업무를 하는 사원의 수를 출력하시오. 
-- 열이름은 각각 '업무' 와 '업무별 사원수'로 한다.
select job as "업무", count(empno) as "업무별 사원수" from emp
group by job;

-- 7. 사원의 최대 급여와 최소 급여의 차액을 출력하시오.
select max(sal)-min(sal) as "급여의 차액" from emp;

-- 8. 30번 부서의 사원 수와 사원들 급여의 합계와 평균을 출력하시오.
select count(e.empno), sum(e.sal), avg(e.sal) from emp e
join dept d on e.deptno = d.deptno
where d.deptno = 30;

-- 9. 평균 급여가 가장 높은 부서의 번호를 출력하시오.
select deptno from emp
group by deptno
order by avg(sal) desc
fetch first 1 row only;

-- 10. 세일즈맨(SALESMAN)을 제외하고, 각 업무별 사원의 총급여가 3,000이상인 각각 업무에 대해서, 
-- 업무명과 각 업무별 평균 급여를 출력하시오.
select job, avg(sal) from emp 
where job != 'salesman'
group by job
having sum(sal) >= 3000;

-- 11. 전체 사원 가운데 직속상관이 있는 사원의 수를 출력하시오.
select count(empno) from emp
where mgr is not null;

-- 12. EMP 테이블에서 이름, 급여, 커미션 금액(comm), 총액(sal*12+comm)을 구하여 총액이 많은 순서대로 출력하시오.
-- [참고] NVL(컬럼명, 기본값) -> 해당 컬럼의 데이터가 null이면 기본값으로 채워준다.
select ename, sal, comm, (sal*12+NVL(comm, 0)) as total from emp
order by total desc;

-- 13. 부서별로 같은 업무를 하는 사람의 인원수를 구하여 부서번호, 업무 이름, 인원수를 출력하시오.
select deptno, job, count(empno) as "인원수" from emp
group by deptno, job;

-- 14. 사원이 한 명도 없는 부서의 이름을 출력하시오.
select d.dname from dept d
left outer join emp e on d.deptno = e.deptno
group by d.dname
having count(e.empno) = 0;

-- 15. 같은 업무를 하는 사람의 수가 4명 이상인 업무와 인원수를 출력하시오.
select job, count(empno) from emp
group by job
having count(empno) >= 4;

-- 16. 사원번호가 7400 이상 7600 이하인 사원의 이름을 출력하시오.
select ename from emp
where empno >= 7400 and empno <= 7600;

-- 17. 사원의 이름과 사원의 부서이름을 출력하시오.
select e.ename, d.dname from emp e
join dept d on e.deptno = d.deptno;

-- 18. 사원의 이름과 팀장(mgr)의 이름을 출력하시오.
select ename, mgr from emp;

-- 19. 사원 SCOTT보다 급여를  많이 받는 사람의 이름을 출력하시오.
-- [참고] "" -> 컬럼명, 테이블명, 별칭 / '' -> 데이터(문자열, 날짜)
select ename from emp
where sal > (
    select sal from emp
	where ename = 'SCOTT'
);

-- 20. 사원 SCOTT이 일하는 부서번호 혹은 DALLAS 에 있는 부서번호를 출력하시오.
select distinct d.deptno from dept d 
join emp e on d.deptno = e.deptno
where e.ename = 'SCOTT' or d.loc = 'DALLAS';


-- (2) 단순질의
-- 1. comm(커미션)이 NULL이 아닌 사원의 이름과 커미션을 출력하시오.
select ename, comm from emp
where comm is not null;

-- 2. 급여가 1500이상 3000 이하인 사원의 이름과 급여를 급여 오름차순으로 출력하시오.
select ename, sal from emp
where sal >= 1500 and sal <= 3000
order by sal;

-- 3. 1981년에 입사한 사원의 이름과 입사일을 출력하시오.
select ename, hiredate from emp
where hiredate LIKE '81%';

-- 4. 이름의 세 번째 글자가  ‘A’인 사원을 출력하시오.
select ename from emp
where ename like '__A%';

-- 5. 사원의 이름을 소문자로 출력하시오.
select lower(ename) from emp;

-- 6. 사원 이름, 입사일, 오늘까지의 근무 개월 수를 출력하시오.
-- [참고] 함수 MONTHS_BETWEEN() 사용하면 두 날짜 사이의 개월 수를 구할 수 있다.
-- round()로 감싸면 반올림, trunc()로 감싸면 버림(만으로 계산)
select ename, hiredate, trunc(MONTHS_BETWEEN(sysdate, hiredate)) as "근무 개월 수"
from emp;

-- 7. 사원 이름과 이름의 글자 수를 글자 수 내림차순으로 출력하시오.
select ename, length(ename) as "이름의 글자 수" from emp
order by length(ename);

-- 8. comm이 NULL이면 0으로 대체하여 총소득(sal+comm)을 출력하시오.
select ename, sal+nvl(comm, 0) as "총 소득" from emp;

--9. ANALYST 또는 PRESIDENT인 사원의 이름, 업무, 급여를 출력하시오.
select ename, job, sal from emp
where job = 'ANALYST' or job = 'PRESIDENT';

-- 10. 이름 길이가 긴 순, 같으면 알파벳 순으로 사원 이름을 출력하시오.
select ename from emp
order by length(ename) desc, ename;


-- (3) 부속질의
-- 1. JONES와 같은 부서에 근무하는 사원의 이름을 출력하시오(JONES본인 제외)
select ename from emp
where deptno = (
select deptno from emp
	where ename = 'JONES'
) and ename != 'JONES';

-- 2. 각 부서에서 가장 높은 급여를 받는 사원의 이름, 급여, 부서번호를 출력하시오.
-- 각 부서에서 가장 높은 급여 추출
select max(e.sal) from emp e
join dept d on e.deptno = d.deptno
group by d.deptno

-- 해당 급여와 동일한 급여를 받는 사원 추출
select ename, sal, deptno from emp
where sal = (
	select max(e.sal) from emp e
	join dept d on e.deptno = d.deptno
	group by d.deptno
);

-- 다시!!!----------
-- where sal = ()로 푸는 방식
select ename, sal, deptno from emp e1
where sal = (
	select max(sal) from emp e2
	where e2.deptno = e1.deptno
);

-- 부서번호와 급여를 세트로 묶어서 비교하는 방식
select ename, sal, deptno from emp
where (deptno, sal) in (
	select deptno, max(sal) from emp
	group by deptno
);

-- 3. 30번 부서 평균 급여보다 급여가 높은 사원의 이름과 급여를 출력하시오.
-- 30번 부서 평균 급여 추출
select avg(sal) from emp 
where deptno = 30

-- 해당 급여보다 급여가 높은 사원 추출
select ename, sal from emp
where sal > (
	select avg(sal) from emp 
	where deptno = 30
);

-- 4. MANAGER 직급 평균 급여보다 적은 CLERK 사원의 이름과 급여를 출력하시오.
-- manager 직급 평균 급여 추출
select avg(sal) from emp
where job = 'MANAGER'

-- 해당 급여보다 적은 CLERK 사원의 이름과 급여 출력
select ename, sal from emp
where sal < (
	select avg(sal) from emp
	where job = 'MANAGER'
) and job = 'CLERK';

-- 5. 업무별 최고 급여를 받는 사원의 이름, 업무, 급여를 출력하시오.
-- 업무별 최고 급여 추출
select job, max(sal) from emp
group by job

-- 해당 급여를 받는 사원의 이름, 업무, 급여 추출
select e.ename, e.job, e.sal from emp e
where sal = (
	select max(sal) from emp e2
	where e.job = e2.job
	group by job
);

-- 6. KING에게 직접 보고하는 사원의 이름과 업무를 출력하시오.
-- mgr의 이름이 KING인 사원을 추출
select ename from emp
where mgr = (
    select empno from emp
    where ename = 'KING'
);

-- 7. 입사일이 가장 최근인 사원과 가장 오래된 사원을 함께 출력하시오.
select ename from emp
where hiredate in (
    select max(hiredate), min(hiredate) from emp
);
-- 틀린 이유: WHERE hiredate IN (('83/01/12', '80/12/17')) -> 여기서 비교하려는 값의 개수가 맞지 않기 때문

select ename from emp
where hiredate in(
    select max(hiredate) from emp
    union
    select max(hiredate) from emp
)

-- 혹은

select ename from emp
where hiredate = (select max(hiredate) from emp)
    or hiredate = (select min(hiredate) from emp);

-- 8. 전체 평균 급여보다 급여가 높고 직위가 MANAGER인 사원을 출력하시오.
-- 전체 평균 급여 추출
select avg(sal) from emp

-- 해당 급여보다 급여가 높고 직위가 MANAGER인 사원 추출
select ename from emp
where sal > (select avg(sal) from emp) and job = 'MANAGER';

-- 9. 급여가 전체 사원 급여 합계의 10%를 초과하는 사원의 이름과 급여를 출력하시오.
-- 전체 사원 급여 합계의 10% 추출
select sum(sal)*0.1 from emp

-- 해당 수치를 초과하는 급여의 사원 이름과 급여 추출
select ename, sal from emp
where sal > (select sum(sal)*0.1 from emp);

-- 10. BLAKE와 같은 직위(job)를 가진 사원의 이름과 급여를 출력하시오(BLAKE 본인 제외)
-- BLAKE의 직위 추출
select job from emp
where ename = 'BLAKE'

-- 해당 직위를 가진 사원의 이름과 급여 추출
select ename, sal from emp
where job = (
    select job from emp
    where ename = 'BLAKE'
) and ename != 'BLAKE';

-- 11. 30번 부서에 속한 사원과 같은 직위(job)를 가진 모든 사원을 출력하시오. 
-- 30번 부서에 속한 사원의 직위 추출
select job from emp
where deptno = 30

-- 해당 직위를 가진 모든 사원 추출
select ename from emp
where job in (
    select job from emp
    where deptno = 30);

-- 12. 급여가 모든 CLERK보다 많은 사원의 이름과 급여를 출력하시오(ALL)
-- 모든 CLERK의 급여 추출
select sal from emp
where job = 'CLERK'

-- 해당 급여들보다 많은 사원의 이름과 급여 추출
select ename, sal from emp
where sal > ALL (
    select sal from emp
    where job = 'CLERK'
);

-- 13. SALESMAN 중 누구보다도 급여가 많은 사원의 이름과 급여를 출력하시오.(ANY)
-- 모든 SALESMAN의 급여 추출
select sal from emp
where job = 'SALESMAN'

-- 해당 급여들 중 어떤 것보다도 많은 사원의 이름과 급여 추출
select ename, sal from emp 
where sal > ANY (
    select sal from emp
    where job = 'SALESMAN'
);

-- 14. 부하 직원이 존재하는 (관리자인) 사원의 이름과 직위를 출력하시오(EXITS)
select ename, job from emp e1
where exists (
    select 1 from emp e2
    where e2.mgr = e1.empno
);

-- 15. 급여 상위 3위 안에 드는 사원의 이름과 급여를 출력하시오.
-- 급여 상위 3위의 급여 추출
select sal from emp
order by sal desc
fetch first 3 row only

-- 해당 사원의 이름과 급여 추출
select ename, sal from emp
where sal in (
    select sal from emp
    order by sal desc
    fetch first 3 row only
);


-- (4) 조인질의
-- 1. 사원의 이름과 소속 부서 이름을 출력하시오.
select e.ename, d.dname from emp e
join dept d on e.deptno = d.deptno;

-- 2. 사원의 이름과 팀장의 이름을 출력하시오.(셀프 조인)
select e1.ename as "팀장의 이름", e2.ename as "사원의 이름" from emp e1
join emp e2 on e1.empno = e2.mgr;

-- 3. 사원이 한 명도 없는 부서의 이름을 출력하시오.
-- [참고] inner join을 하면 사원이 없는 부서는 제외되므로, left outer join을 해야 한다.
select dname from dept d
left outer join emp e on d.deptno = e.deptno
group by dname
having count(e.empno) = 0;

-- [다른 방식]
-- not exists 사용
select dname from dept d
where not exists (
    select 1 from emp e 
    where e.deptno = d.deptno
);

-- not in 사용
select dname from dept
where deptno not in (
    select distinct deptno from emp
);

-- 4. NEW YORK에 근무하는 사원의 이름과 업무를 출력하시오.
select ename, job from emp e
join dept d on e.deptno = d.deptno
where d.loc = 'NEW YORK';

-- 5. 사원이름, 급여, 급여 등급을 출력하시오.(SALGRADE 활용)
select e.ename, e.sal, s.grade from emp e
join salgrade s on e.sal between s.losal and s.hisal;

-- 6. 사원이름, 급여, 급여 등급, 부서 이름을 한 번에 출력하시오.
select ename, e.sal, s.grade, d.dname from emp e
join dept d on e.deptno = d.deptno 
join salgrade s on e.sal between s.losal and s.hisal;

-- 7. 자신의 상관보다 급여가 높은 사원의 이름과 두 사람의 급여를 출력하시오.
-- [참고] 셀프 조인을 통해 두 사람의 급여를 한 번에 추출 가능
-- 오답
select e1.sal, e2.sal from emp e1
where e1.sal > (
    select e2.sal from emp e2 -- 서브쿼리 내에서만 e2를 볼 수 있음 -> 틀림!!
    where e1.mgr = e2.empno
);

select e1.sal, e2.sal from emp e1
join emp e2 on e1.mgr = e2.empno -- e1: 사원의 테이블, e2: 상관의 테이블
where e1.sal > e2.sal;

-- 8. 사원 이름, 부서이름, 근무 도시를 출력하시오.
select e.ename, d.dname, d.loc from emp e
join dept d on d.deptno = e.deptno;

-- 9. CHICAGO에 근무하는 사원 수를 출력하시오.
select count(distinct empno) from emp e
join dept d on e.deptno = d.deptno
where d.loc = 'CHICAGO';

-- 10. 부서별 인원 수가 많은 순으로 부서번호, 부서이름, 인원수를 출력하시오.
-- [참고] select 절에서 집계함수를 제외한 나머지 컬럼 -> group by 절에도 명시!!
-- group by를 부서번호로만 하면 논리적으로 부서이름을 함께 찾을 수 없음.
-- 출력할 모든 기준 컬럼을 group by에 넣어주어야 함.
select d.deptno, d.dname, count(e.empno) as "인원수" from dept d
join emp e on e.deptno = d.deptno
group by d.deptno, d.dname
order by "인원수" desc;

-- 11. 부서별 평균 급여를 부서이름과 함께 출력하시오.
select avg(e.sal), d.dname from emp e
join dept d on e.deptno = d.deptno
group by d.deptno, d.dname;

-- 12. 급여 등급이 3등급인 사원의 이름, 급여, 부서이름을 출력하시오.
select e.ename, e.sal, d.dname from emp e
join dept d on e.deptno = d.deptno
join salgrade s on e.sal between s.losal and s.hisal -- and s.grade = 3;
where s.grade = 3;

-- 13. 사원의 이름, 입사일, 입사 요일을 부서이름과 함께 출력하시오.
-- [참고] 날짜에서 요일 추출하는 방법: TO_CHAR(hiredate, 'DY')
select e.ename, e.hiredate, TO_CHAR(e.hiredate, 'DY') as "입사 요일", d.dname  
from emp e
join dept d on d.deptno = e.deptno;

-- 14. 같은 부서에서 근무하는 사원끼리 이름을 나란히 출력하시오.(셀프 조인, 중복제거)
-- [참고] 순서만 다른 중복을 제거하기 위해서는 distinct를 써서는 안 됨.
-- 순서 다른 중복을 모두 제거하려면 '<'을 활용 -> 알파벳 순서가 고정되어 각 쌍 중에 하나만 나옴
select e1.ename, e2.ename from emp e1
join emp e2 on e1.deptno = e2.deptno
where e1.ename < e2.ename;

-- 15. 사원이름, 상관이름, 상관의 부서이름을 출력하시오(셀프+DEPTt조인)
select e1.ename, e2.ename, d.dname from emp e1
join emp e2 on e1.mgr = e2.empno
join dept d on e2.deptno = d.deptno;

-- (5) 집계질의
-- 1. 업무별 최고, 최소, 평균 급여와 사원 수를 출력하시오.
select max(sal), min(sal), avg(sal), count(empno) from emp
group by job;

-- 2. 부서별, 업무별 인원수를 출력하시오.
-- [참고] (부서별 인원수, 업무별 인원수)가 아니라 부서와 업무가 같은 인원수를 구하는 것.
-- 전자의 경우는 rollup()이라는 함수를 활용하면 됨.
select deptno, job, count(empno) from emp
group by deptno, job
order by deptno, job; -- 필수는 X

-- 3. 직원별 총 급여(sal*12+comm)를 내림차순으로 출력하시오.
select ename, sal*12+nvl(comm, 0) as "총 급여" from emp
order by "총 급여" desc;

-- 4. 평균 급여보다 높은 급여를 받는 부서(번호)와 해당 부서의 평균 급여를 출력하시오
-- 평균 급여 추출
select avg(sal) from emp

-- 평균보다 급여가 높은 부서 번호와 해당 부서의 평균 급여 추출
-- [틀린 이유] group by를 하고 나서 조건 비교를 할 때는 where가 아니라 having을 써줘야 함.
select e1.deptno, avg(e1.sal) from emp e1
group by e1.deptno
having avg(e1.sal) > (
    select avg(e2.sal) from emp e2
);

-- 5. 입사년도별 사원 수를 출력하시오.
select TO_CHAR(hiredate, 'YY') as "입사년도", count(empno) from emp
group by "입사년도";

-- 6. 급여 등급별 사원 수와 평균 급여를 출력하시오.
select s.grade, count(e.empno) as "사원 수", avg(e.sal) as "평균 급여" from emp e
join salgrade s on e.sal between s.losal and s.hisal
group by s.grade;

-- 7. 총급여가 5000 이상인 부서의 번호와 합계를 출력하시오.
select deptno, sum(sal*12+nvl(comm, 0)) as "부서별 총 급여" from emp
group by deptno
having "부서별 총 급여" > 5000;

-- 8. 각 사원의 급여가 전체 급여 합계에서 차지하는 비율(%)을 출력하시오.
select round(ratio_to_report(sal) over() * 100, 2) || '%' as "백분율"
from emp;

-- 9. 근속 연수 10년 이상인 사원의 이름, 입사일, 근속 연수를 출력하시오.
-- [참고] where절에서 별칭 쓰면 안 됨. select절보다 먼저 실행되기 때문에 sql이 알 수가 없음.
select ename, hiredate, trunc(MONTHS_BETWEEN(sysdate, hiredate)/12) as "근속 연수"
from emp
where trunc(MONTHS_BETWEEN(sysdate, hiredate)/12) >= 10;

-- 별칭 쓰고 싶다면 인라인 뷰 활용
select * from (
    select ename, hiredate, trunc(MONTHS_BETWEEN(sysdate, hiredate)/12) as "근속 연수"
    from emp
)
where "근속 연수" >= 10; -- 바깥쪽에서 사용 가능

-- 10. 급여 상위 5명의 사원 이름과 급여를 출력하시오
select ename, sal from emp
order by sal desc
fetch first 5 row only;
