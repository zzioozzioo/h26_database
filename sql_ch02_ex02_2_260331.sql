-- 연습문제 19번 --
-- 1. 도착지가 제주인 항공편에 대한 정보를 보이시오
select fid, fdate, time from Flight where dest = '제주';

-- 2. 출발지가 김포(src)이고 도착지가 제주(dest)인 항공편에 대한 정보를 보이시오
select fid, fdate, time from Flight where src = '김포' and dest = '제주';

-- 3. 고객번호가 100번인 승객이 2025년1월 1일 이후에 탑승한 비행기 번호(fid)를 보이시오
select fid from Booking where pid = 100 and fdate >= TO_DATE('2025-01-01');

-- 4. 예약을 한 적이 있는 고객의 이름(pname)을 보이시오
select distinct p.pname from Passenger p join Booking b on p.pid = b.pid;

-- 5. 예약을 한 적이 없는 고객의 이름(pname)을 보이시오
select distinct p.pname from Passenger p 
where not exists (
    select 1 from booking b where b.pid = p.pid
);

-- 6. 고객번호가 100번인 승객이 거주하는 도시(pcity)와 같은 도시에 위치한 여행사(aname)의 이름을 보이시오
select a.aname from Agency a 
join Passenger p on a.acity = p.pcity 
where p.pid = 100;

-- 7. 2025년 1월 1일부터 1월 30일 사이에 출발시각이 16:00이후인 항공편 정보를 보이시오
select fid, fdate, time, src, dest from Flight 
where fdate >= TO_DATE('2025-01-01') and fdate <= TO_DATE('2025-01-30') 
and time >= '16:00';

-- 8. 고객번호가 100번인 승객이 한 번도 예약하지 않은 여행사의 이름(aname)을 보이시오
select a.aname from Agency a 
where not exists (
    select 1 from Booking b where b.pid = 100
);

-- 9. 마당여행사(aname)를 통해 예약한 남자 승객(pgender)의 정보를 보이시오
select distinct p.pid, p.pname, p.pcity from Passenger p 
join Booking b on p.pid = b.pid and p.pgender = '남'
join Agency a on b.aid = a.aid and a.aname = '마당여행사';


-- 연습문제 20번 --
-- 1. 각 릴레이션의 기본키를 정하시오
Employee - empno
Department - deptno
Project - projno
Works - empno + projno (복합키)

-- 2. 릴레이션 간의 관계를 고려하여 외래키를 찾아보시오

-- 3. 모든 직원의 이름을 보이시오
select name from Employee;

-- 4. 성별이 여자인 직원의 이름을 보이시오
select name from Employee where sex = '여';

-- 5. 부서장(manager)의 이름과 주소를 보이시오
select e.name, e.address from Employee e
join Department d on e.deptno = d.deptno
where d.manager is not null;
?? 왜 틀렷지

-- 6. IT부서에서 근무하는 직원의 이름과 주소를 보이시오
select e.name, e.address from Employee e 
join Department d on e.deptno = d.deptno
where d.deptname = 'IT부서';

-- 7. ‘미래’라는 이름의 프로젝트에서 일하는 직원의 이름을 보이시오
select e.name from Employee e
join Works w on e.empno = w.empno
join Project p on p.projno = w.projno
where p.projname = '미래';