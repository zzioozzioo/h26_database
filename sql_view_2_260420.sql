-- 수강신청 데이터베이스 --
-- 학생(학번, 이름, 전공, 학년)
-- 수강(과목코드, 학번, 수강학기, 성적)
-- 과목(과목코드, 과목이름, 강의실, 요일, 담당교수)

-- (1) 학생 수강 전체 현황 뷰를 작성하시오. (학생정보+수강 과목+성적을 한 눈에 확인 가능하도록 작성)
create or replace view v_st_all as
    select s.*, e.*
    from 학생 s
    join 수강 e on s.학번 = e.학번
    join 과목 c on e.과목코드 = c.과목코드;

-- (2) 각 학생별 평균 성적 뷰를 작성하시오. (각 학생의 전체 수강 과목 평균 성적 계산 뷰)
create or replace view v_st_avg_score as
    select s.학번, s.이름, avg(e.성적) as "평균 성적" 
    from 학생 s
    join 수강 e on s.학번 = e.학번
    group by s.이름, s.학번;

-- (3) 과목별 수강 인원 및 평균 성적 뷰를 작성하시오. (각 과목의 수강 인원과 평균, 최고,최저 성적 통계 뷰)
create or replace view v_count_avg_score as
    select count(s.학번) as "수강인원", 
    avg(e.성적) as "평균", 
    MAX(e.성적) as "최고성적", 
    MIN(e.성적) as "최저성적"
    from 학생 s
    join 수강 e on s.학번 = e.학번
    group by e.과목코드;

-- (4) 성적 우수 학생 뷰를 작성하시오. (평균 성적이 90점 이상이 우수 학생만 조회하는 뷰)
create or replace view v_good_student as
    select s.*, avg(e.성적) as "평균"
    from 학생 s
    join 수강 e on s.학번 = e.학번
    group by s.학번
    having avg(e.성적) > 90;

-- (5) 전공 별 수강 통계 뷰를 작성하시오. (전공별 총 수강 건수와 전공 평균 성적 비교 뷰)
create or replace view v_specialty_course as
    select count(e.과목코드) as "총 수강 건수",
    avg(e.성적) as "전공 평균 성적"
    from 학생 s
    join 수강 e on s.학번 = e.학번
    group by s.전공; 

-- (6) 학기별 수강 현황 뷰를 작성하시오.
reate or replace view v_haki_course as
    select c.과목이름, e.수강학기, count(s.학번) as "수강인원"
    from 학생 s
    join 수강 e on s.학번 = e.수강
    group by e.과목번호, c.과목이름, e.수강학기;

-- (7) 미수강 학생 뷰를 작성하시오.
create or replace view v_no_enrollment_st as
    select s.*
    from 학생 s
    where not exists(
        select 1
        from 수강 e
        where e.학번 = s.학번
    );

-- (8) 담당 교수별 강의 및 수강 현황 뷰를 작성하시오. (과목별 담당 과목 수와 총 수강 학생수를 집계하는 뷰)
create or replace view v_professor_stats as
    select c.담당교수, count(distinct c.과목코드) as "담당과목수",
    count(s.학번) as "총 수강 학생수"
    from 과목 c
    left join 수강 e on c.과목코드 = e.과목코드
    group by c.담당교수;

-- (9) 학년별 수강 과목 수 및 평균 성적 뷰를 작성하시오. (학년에 따른 수강 부담과 성적 추이를 파악하는 뷰 작성)
create or replace view v_course_count_avg_score as
    select count(distinct e.과목코드) as "학년별 수강 과목 수", avg(e.성적) as "평균 성적"
    from 학생 s
    join 수강 e on s.학번 = e.학번
    group by s.학년;

-- (10) 성적 미입력(NULL) 수강 내역 뷰를 작성하시오. (성적이 아직 입력되지 않은 수강 내역 관리용이다.)
create or replace view v_not_input_grade as
    select distinct 과목코드
    from 수강
    where 성적 is null;


-- 극장 데이터베이스 --
-- 극장(극장번호, 극장이름, 위치)
-- 상영관(극장번호, 상영관번호, 영화제목, 가격, 좌석수)
-- 예약(극장번호, 상영관번호, 고객번호, 좌석번호, 날짜)
-- 고객(고객번호, 이름, 주소)

-- 1. 전체 상영 정보 통합 뷰를 작성하시오. (극장 + 상영관 + 영화 정보를 한눈에 확인 가능하도록 작성)
create or replace view v_total_screening_info as
    select t.극장이름, s.상영관번호, s.영화제목, s.가격, s.좌석수
    from 극장 t
    join 상영관 s on t.극장번호 = s.극장번호;

-- 2 .예약 전체 현황 뷰를 작성하시오 (고객이 어떤 극장·상영관·영화를 예약했는지 통합 조회하도록 작성)
create or replace view v_total_reservation_info as
    select c.고객이름, t.극장이름, s.상영관번호, s.영화제목, r.날짜
    from 극장 t
    join 상영관 s on t.극장번호 = s.극장번호
    join 예약 r on r.극장번호 = s.극장번호 and r.상영관번호 = s.상영관번호
    join 고객 c on r.고객번호 = c.고객번호;

-- 3. 극장별 상영 영화 목록 뷰를 작성하시오 (각 극장에서 상영 중인 영화와 가격, 좌석수 조회)
create or replace view v_go_movie as
    select t.극장이름, s.영화제목, s.가격, s.좌석수
    from 극장 t
    join 상영관 s on t.극장번호 = s.극장번호
    order by t.극장번호;

-- 4. 고객별 예약 내역 뷰를 작성하시오 (고객별 예약한 영화 목록과 날짜, 금액 조회가능한 뷰)
create or replace view v_customer_reservation_info as
    select c.이름, s.영화제목, r.날짜, s.가격
    from 고객 c
    join 예약 r on c.고객번호 = r.고객번호
    join 상영관 s on r.극장번호 = s.극장번호 and r.상영관번호 = s.상영관번호
    order by c.고객번호;

-- 5. 상영관별 예약 인원 및 잔여 좌석 뷰를 작성하시오 (상영관의 총 좌석 대비 예약 현황과 잔여 좌석 계산)
create or replace view v_screen_reservation_remining_seats as
    select (s.좌석수/count(r.좌석))*100 as "총 좌석 대비 예약", (s.좌석수 - count(r.좌석)) as "잔여좌석"
    from 상영관 s
    join 예약 r on s.극장번호 = r.극장번호 and s.상영관번호 = r.상영관번호
    group by s.극장번호, s.상영관번호;

-- 6. 극장별 총 예약 수 및 매출 뷰를 작성하시오 (극장별 총 예약 건수와 누적 매출 집계를 볼 수 있는 뷰)
create or replace view v_theater_reservation_money as
    select t.극장이름, count(r.고객번호) as "총 예약 건수", sum(s.가격) as "누적 매출"
    from 극장 t
    join 상영관 s on t.극장번호 = s.극장번호
    join 예약 r on s.극장번호 = r.극장번호 and s.상영관번호 = r.상영관번호
    group by t.극장번호, t.극장이름;

-- 7. 영화별 예약 현황 뷰를 작성하시오 (영화 제목별 총 예약 인원과 총 매출 집계 뷰)
create or replace view v_movie_reservation_info as
    select s.영화제목, count(r.고객번호), sum(s.가격)*count(r.고객번호) as "총매출"
    from 상영관 s
    join 예약 r on s.극장번호 = r.극장번호 and s.상영관번호 = r.상영관번호
    group by s.영화제목;

-- 8. 날짜별 예약 현황 뷰를 작성하시오 (날짜별 예약 건수와 해당 날짜 매출 조회 가능한 뷰 작성)
create or replace view v_date_reservation_info as
    select r.날짜, sum(s.가격) as "해당 날짜 매출"
    from 예약 r
    join 상영관 s on r.극장번호 = s.극장번호 and r.상영관번호 = s.상영관번호
    group by r.날짜;

-- 9. 예약 이력이 없는 고객 뷰 (한 번도 예약한 적 없는 고객 조회하는 뷰 작성)
create or replace view v_not_reservation_customer as
    select c.이름
    from 고객 c
    where not exists(
        select 1
        from 예약 r
        where c.고객번호 = r.고객번호
    );

-- 10. 고객별 총 예약 횟수 및 결제 금액 뷰 (고객의 예약 활동 통계) (충성 고객 분석용)
create or replace view v_all_reservation_cash_costomer as
    select c.이름, count(r.고객번호) as "총예약횟수", sum(s.가격) as "결제금액"
    from 고객 c
    join 예약 r on c.고객번호 = r. 고객번호
    join 상영관 s on r.극장번호 = s.극장번호 and r.상영관번호 = s.상영관번호
    group by c.고객번호, c.이름;

-- 11. 가격이 가장 비싼 상영관 뷰를 작성하시오 (티켓 가격 기준 상위 상영관 목록 조회하는 뷰 작성)
create or replace view v_max_price_screen as
    select t.극장이름, s.상영관번호, s.가격
    from 극장 t
    join 상영관 s on t.극장번호 = s.극장번호
    where s.가격 = (
        select MAX(가격) 
        from 상영관
    );

-- 12. 위치별 극장 및 상영 현황 뷰 (지역(위치)별로 운영 중인 극장과 상영 영화 수 집계하는 뷰 작성)
create or replace view v_location_screening_stats as
    select t.위치, count(distinct t.극장번호) as "극장수", count(s.영화제목) as "총 상영 영화수"
    from 극장 t
    left join 상영관 s on t.극장번호 = s.극장번호
    group by t.위치;

-- 13. 만석 상영관 뷰를 작성하시오 (예약 좌석 수가 전체 좌석 수와 동일한 매진 상영관 조회)
create or replace view v_sold_out_screens as
    select t.극장이름, s.상영관번호
    from 상영관 s
    join 극장 t on s.극장번호 = t.극장번호
    left join 예약 r on s.극장번호 = r.극장번호 and s.상영관번호 = r.상영관번호
    group by t.극장이름, s.상영관번호
    having s.좌석수 = count(r.고객번호);

-- 14. 특정 날짜 예약 고객 상세 뷰를 작성하시오 (날짜별 예약 고객 정보와 관람 영화 상세 조회)
create or replace view v_reservation_detail_by_date as
    select r.날짜, c.이름, t.극장이름, s.상영관번호, s.영화제목, r.좌석번호
    from 예약 r
    join 고객 c on r.고객번호 = c.고객번호
    join 상영관 s on r.극장번호 = s.극장번호 and r.상영관번호 = s.상영관번호
    join 극장 t on s.극장번호 = t.극장번호;

-- 15. 예약 없는 상영관 뷰 (개설되었지만 예약이 한 건도 없는 상영관 조회)
create or replace view v_unreserved_screens as
    select t.극장이름, s.상영관번호
    from 상영관 s
    join 극장 t on s.극장번호 = t.극장번호
    left join 예약 r on s.극장번호 = r.극장번호 and s.상영관번호 = r.상영관번호
    where r.고객번호 is null;


-- 판매원 데이터베이스 --
-- Salesperson(name, age, salary)
-- Order(number, custname, salesperson,amount)
-- Customer(name, city, industrytype)
-- Order.salesperson → Salesperson.name 참조
-- Order.custname → Customer.name 참조

-- 1. 전체 주문 통합 현황 뷰를 작성하시오 (주문 + 고객 + 영업사원 정보를 한눈에 통합 조회 뷰)
create or replace view v_order_total_info as
    select o.number, o.amount, c.name, c.industrytype, s.name, s.age
    from Order o
    join Customer c on o.custname = c.name
    join Salesperson s on o.salesperson = s.name;
 
-- 2. 영업사원별 총 주문 금액 및 건수 뷰를 작성하시오 (영업사원별 실적(주문 건수, 총 매출) 집계)
create or replace view v_salesperson_performance as
    select s.name, count(o.number) as "주문건수", sum(o.amount) as "총매출액"
    from Salesperson s
    left join Order o on s.name = o.salesperson
    group by s.name;

-- 3. 고객별 총 주문 금액 뷰를 작성하시오 (고객별 누적 주문 횟수와 총 구매 금액 집계 포함된 뷰)
create or replace view v_customer_purchase_summary as
    select c.name, count(o.number) as "누적주문횟수", NVL(avg(o.amount), 0) as "평균주문금액"
    from Customer c
    left join Order o on c.name = o.custname
    group by c.name;

-- 4. 도시별 주문 현황 뷰를 작성하시오 (도시(city)별 총 주문 건수와 매출 집계 포함된 뷰)
create or replace view v_city_sales_stats as
    select c.city, count(o.number) as "총주문건수", sum(o.amount) as "매출 집계"
    from Customer c
    join Order o on c.name = o.custname
    group by c.city;

-- 5. 업종별 주문 통계 뷰를 작성하시오 (산업 유형(industrytype)별 주문 건수 및 총 매출 비교 뷰)
create or replace view v_industry_sales_stats as
    select c.industrytype, count(o.number) as "주문건수", sum(o.amount) as "총 매출"
    from Customer c
    join Order o on c.name = o.custname
    group by c.industrytype;

-- 6. 고액 주문 뷰 (amount 상위)를 작성하시오 (주문 금액이 평균 이상인 고액 주문만 조회하는 뷰)
create or replace view v_high_value_orders as
    select o.*
    from Order o
    where o.amount >= (select avg(amount) from Order);

-- 7. 주문 실적 없는 영업사원 뷰를 작성하시오 (한 건도 주문을 처리하지 않은 영업사원 조회 뷰)
create or replace view v_inactive_salespersons as
    select s.*
    from Salesperson s
    where not exists(
        select 1
        from Order o
        where s.name = o.salesperson
    );

-- 8. 주문 이력 없는 고객 뷰를 작성하시오 (등록은 되어 있지만 한 번도 주문하지 않은 고객 조회 뷰)
create or replace view v_non_ordering_customers as
    select c.*
    from Customer c
    where not exists (
        select 1
        from Order o
        where c.name = o.custname
    );

-- 9. 영업사원 급여 등급 뷰를 작성하시오 (급여 구간별로 영업사원을 분류하는 뷰)
create or replace view v_salesperson_salary_grade as
    select name, salary,
    case
        when salary >= 20000 then 'A'
        when salary >= 10000 then 'B'
        else 'C'
    end as "급여등급"
    from Salesperson;

-- 10. 영업사원별 담당 고객 목록 뷰를 작성하시오 (각 영업사원이 주문을 처리한 고객 목록(중복 제거) 생성 뷰)
create or replace view v_salesperson_customer_list as
    select distinct s.name as "영업사원", c.name as "담당고객"
    from Salesperson s
    join Order o on s.name = o.salesperson
    join Customer c on o.custname = c.name;

-- 11. 최고 실적 영업사원 뷰를 작성하시오 (총 주문 금액이 가장 높은 영업사원 조회하는 뷰)
create or replace view v_top_salesperson as
    select s.name, sum(o.amount) as "총 주문 금액"
    from Salesperson s
    join Order o on s.name = o.salesperson
    group by s.name, s.age
    having sum(o.amount) = (
        select max(total)
        from (
            select sum(amount) as total
            from Order
            group by salesperson
        )
    );
  
-- 12. 도시별 영업사원 활동 현황 뷰를 작성하시오 (어느 도시의 고객에게 얼마나 판매했는지 영업사원 기준 집계 뷰)
create or replace view v_salesperson_activity_by_city as
    select s.name, c.city, count(o.number) as "판매수"
    from Salesperson s
    join Order o on s.name = o.salesperson
    join Customer c on o.custname = c.name
    group by s.name, c.city;

-- 13. 영업사원 급여 대비 매출 효율 뷰를 작성하시오 (영업사원 급여 대비 총 매출 비율로 효율성 측정 뷰)
create or replace view v_sales_efficiency as
    select s.name, round(sum(o.amount)/ s.salary, 2)*100 as "급여 대비 총 매출"
    from Salesperson s
    join Order o on s.name = o.salesperson
    group by s.name, s.salary;

-- 14. 업종별 담당 영업사원 현황 뷰를 작성하시오 (산업 유형별로 어떤 영업사원이 활동하는지 파악)
create or replace view v_salesperson_by_industry as
    select distinct c.industrytype, s.name, count(o.number) as "해당업종 판매건수"
    from Customer c
    join Order o on c.name = o.custname
    join Salesperson s on o.salesperson = s.name
    group by c.industrytype, s.name;

-- 15. 주문 금액 구간별 분류 뷰를 작성하시오 (주문을 금액 구간으로 나누어 분류 및 통계 제공 뷰)
create or replace view v_order_amount_segments as
    select 
        case
            when amount >= 10000 then 'A'
            when amount >= 8000 then 'B'
            when amount >= 5000 then 'C'
            else 'D'
        end as "금액 구간",
        count(number) as "주문건수"
    from Order
    group by
        case
            when amount >= 10000 then 'A'
            when amount >= 8000 then 'B'
            when amount >= 5000 then 'C'
            else 'D'
        end;


-- 여행사 데이터베이스 --
-- Passenger(pid, pname, pgender, pcity)
-- Agency(aid, aname, acity)
-- Flight(fid, fdate, time, src, dest)
-- Booking(pid, aid, fid, fdate)
-- Booking.pid → Passenger.pid 참조
-- Booking.aid → Agency.aid 참조
-- Booking.fid → Flight.fid 참조

-- 1. 전체 예약 통합 현황 뷰를 작성하시오 (승객 + 여행사 + 항공편 정보를 한눈에 통합 조회 뷰)
create or replace view v_booking_all as
    select p.*, a.*, f.*, b.*
    from Booking b
    join Passenger p on b.pid = p.pid
    join Agency a on b.aid = a.aid
    join Flight f on b.fid = f.fid;

-- 2. 승객별 예약 내역 뷰를 작성하시오 (각 승객이 예약한 항공편과 여행사 정보 조회 뷰)
create or replace view v_passenger_bookings as
    select p.pname, f.fid, f.src, f.dest, f.fdate, a.aname
    from Passenger p
    join Booking b on p.pid = b.pid
    join Flight f on b.fid = f.fid
    join Agency a on b.aid = a.aid;

-- 3. 여행사별 예약 건수 및 실적 뷰를 작성하시오 (각 여행사의 총 예약 건수와 취급 항공편 수 집계 뷰)
create or replace view v_agency_performance as
    select a.aname, count(b.fid) as "총 예약 건수", 
    count(distinct b.fid) as "취급 항공편 수" 
    from Agency a
    left join booking b on a.aid = b.aid
    group by a.aname;

-- 4. 항공편별 예약 승객 수 뷰를 작성하시오 (각 항공편의 예약된 승객 수와 출발·도착지 조회 뷰)
create or replace view v_flight_occupancy as
    select f.fid, count(b.pid) as "예약 승객 수", f.src, f.dest
    from Flight f
    left join Booking b on f.fid = b.fid
    group by f.fid, f.src, f.dest;

-- 5. 출발지·도착지별 노선 통계 뷰를 작성하시오 (노선(src → dest)별 운항 횟수와 총 예약 건수 집계 뷰)
create or replace view v_route_statistics as
    select f.src, f.dest, 
    count(distinct f.fid) as "운항횟수", 
    count(b.pid) as "총 예약 건수"
    from Flight f
    join Booking on f.fid = b.fid
    group by f.src, f.dest;

-- 6. 도시별 승객 예약 현황 뷰를 작성하시오 (승객 거주 도시별 총 예약 건수 및 이용 현황 집계 뷰)
create or replace view v_city_passenger_stats as
    select p.pcity, 
    count(distinct p.pid) as "총승객수", 
    count(b.fid) as "총 예약건수", 
    count(distinct b.aid) as "이용한여행사수"
    from Passenger p
    left join Booking b on p.pid = b.pid
    group by p.pcity;

-- 7. 성별 이용 통계 뷰를 작성하시오 (성별(pgender)에 따른 예약 건수와 이용 노선 수 비교 뷰)
create or replace view v_gender_usage_stats as
    select p.pgender, 
    count(b.fid) as "예약건수", 
    count(distinct f.fid) as "이용한 노선 수"
    from Passenger p
    left join booking b on p.pid = b.pid
    left join flight f on b.fid = f.fid
    group by p.pgender;

-- 8. 예약 이력 없는 승객 뷰를 작성하시오 (한 번도 예약하지 않은 승객 조회 (비활성 승객 관리) 뷰)
create or replace view v_inactive_passengers as
    select p.*
    from Passenger p
    where not exists(
        select 1
        from Booking b
        where p.pid = b.pid
    );

-- 9. 예약 실적 없는 여행사 뷰를 작성하시오 (한 건도 예약을 처리하지 않은 여행사 조회 뷰)
create or replace view v_inactive_agencies as
    select a.*
    from Agency a
    where not exists (
        select 1
        from Booking b
        where a.aid = b.aid
    );

-- 10. 승객별 이용 여행사 목록 뷰를 작성하시오 (각 승객이 이용한 여행사 목록 (중복 제거) 뷰)
create or replace view v_passenger_agency_list as
    select distinct p.pid, p.pname, a.aid, a.aname
    from Passenger p
    join Booking b on p.pid = b.pid
    join Agency a on b.aid = a.aid;

-- 11. 동일 출발·도착지 왕복 노선 뷰를 작성하시오 (왕복 운항이 가능한 노선 쌍(A→B, B→A) 조회 뷰)
create or replace view v_round_trip_routes as
    select distinct f1.src, f1.dest, f2.src, f2.dest
    from Flight f1
    join Flight f2 on f1.src = f2.dest and f1.dest = f2.src
    where f1.src < f1.dest;

-- 12. 여행사별 담당 승객 상세 뷰를 작성하시오 (여행사별로 담당한 승객 정보와 이용 항공편 상세 조회 뷰)
create or replace view v_agency_customer_details as
    select a.aname, p.pname, f.fid, f.src, f.dest
    from Agency a
    join Booking b on a.aid = b.aid
    join Passenger p on b.pid = p.pid
    join Flight f on b.fid = f.fid;

-- 13. 날짜별 예약 및 항공편 현황 뷰를 작성하시오 (날짜별 총 예약 건수와 운항 항공편 수 집계 뷰)
create or replace view v_daily_flight_stats as
    select f.fdate,
    count(b.pid) as "총예약건수", 
    count(distinct f.fid) as "운항 항공편 수"
    from Flight f
    left join booking b on f.fid = b.pid and f.fdate = b.fdate
    group by f.fdate;

-- 14. 다중 항공편 이용 승객 뷰를 작성하시오 (2개 이상의 항공편을 예약한 승객 조회 (자주 이용 고객) 뷰)
create or replace view v_frequent_flyers as
    select p.pid, p.pname, count(b.fid) as "총 예약 건수"
    from Passenger p
    join Booking b on p.pid = b.pid
    group by p.pid, p.pname
    having count(b.fid) >= 2;

-- 15. 승객-여행사 동일 도시 예약 뷰를 작성하시오 (승객의 거주 도시와 여행사 위치가 같은 예약 조회 뷰)
create or replace view v_local_agency_bookings as
    select p.pname, p.pcity, a.aname, a.acity, f.fid
    from Booking b
    join Passenger p on b.pid = p.pid
    join Agency a on b.aid = a.aid
    join Flight f on b.fid = f.fid
    where p.pcity = a.acity;


-- 기업 프로젝트 데이터베이스 -- 
-- Employee(empno, name, phoneno, address, sex, position, deptno)
-- Department(deptno, deptname, manager)
-- Project(projno,proname,deptno)
-- Works(empno, projno, hours_worked)
-- Employee.deptno → Department.deptno 참조
-- Project.deptno → Department.deptno 참조
-- Works.empno → Employee.empno 참조
-- Works.projno → Project.projno 참조


-- [뷰 생성 질의어 ]
-- 1. 직원 전체 정보 통합 뷰를 작성하시오 (직원 정보와 소속 부서명을 함께 조회하는 뷰)
create or replace view v_employee_dept_info as
    select e.*, d.deptname
    from Employee e
    join Department d on e.deptno = d.deptno;

-- 2. 직원별 프로젝트 참여 현황 뷰를 작성하시오 (직원이 참여 중인 프로젝트명과 투입 시간 조회하는 뷰)
create or replace view v_employee_project_status as
    select e.name, p.proname, w.hours_worked
    from Employee e
    join Works w on e.empno = w.empno
    join Project p on w.projno = p.projno;

-- 3. 부서별 직원 수 및 현황 뷰를 작성하시오 (부서별 소속 직원 수와 관리자 정보 집계 뷰)
create or replace view v_dept_summary as
    select d.deptname, d.manager, count(e.empno) as "소속직원수"
    from Department d
    left join Employee e on d.deptno = e.deptno
    left join (
        select empno
        from Works
        group by empno
    ) w on e.empno = w.empno
    group by d.deptname, d.manager;

-- 4. 프로젝트별 참여 직원 및 총 투입 시간 뷰를 작성하시오 (각 프로젝트에 참여한 직원 수와 총 근무 시간 집계 뷰)
create or replace view v_project_work_stats as
    select p.projno, p.proname, 
    count(w.empno) as "참여직원수", 
    sum(w.hours_worked) as "총 근무 시간"
    from Project p
    left join Works w on p.projno = w.projno
    group by p.projno, p.proname;

-- 5. 직원별 총 근무 시간 뷰를 작성하시오 (직원이 전체 프로젝트에 투입한 총 시간 집계 뷰)
create or replace view v_employee_total_hours as
    select e.empno, e.name, 
    count(w.projno) as "참여 프로젝트 수", 
    sum(nvl(w.hours_worked, 0)) as "총 근무시간"
    from Employee e
    left join Works w on e.empno = w.empno
    group by e.empno, e.name, e.position;

-- 6. 부서별 프로젝트 현황 뷰를 작성하시오 (각 부서가 담당하는 프로젝트 수와 총 투입 시간 집계 뷰)
create or replace view v_dept_project_stats as
    select d.deptno, d.deptname, 
    count(distinct p.projno) as "담당프로젝트수", 
    sum(nvl(w.hours_worked, 0)) as "부서총투입시간"
    from Department d
    left join Project p on d.deptno = p.deptno
    left join Works w on p.projno = w.projno
    group by d.deptno, d.deptname;

-- 7. 프로젝트에 참여하지 않는 직원 뷰를 작성하시오 (어떤 프로젝트에도 투입되지 않은 직원 조회 뷰)
create or replace view v_unassigned_employees as
    select e.empno,e.name
    from Employee e
    where not exists(
        select 1
        from Works w
        where e.empno = w.empno
    );

-- 8. 성별 프로젝트 참여 통계 뷰를 작성하시오 (성별(sex)에 따른 프로젝트 참여 수와 평균 근무 시간 비교 뷰)
create or replace view v_gender_work_stats as
    select e.sex, 
    count(w.projno) as "프로젝트 참여 수", 
    avg(nvl(w.hours_worked, 0)) as "평균 근무 시간"
    from Employee e
    left join Works w on e.empno = w.empno
    group by e.sex;

-- 9. 관리자(Manager) 직원 상세 뷰를 작성하시오 (부서 관리자로 지정된 직원의 상세 정보 조회 뷰)
create or replace view v_manager_details as
    select d.deptname, e.*
    from Department d
    join Employee e on d.manager = e.name;

-- 10. 직책별 프로젝트 참여 현황 뷰를 작성하시오 (직책(position)별 총 프로젝트 참여 건수와 평균 투입 시간 뷰)
create or replace view v_position_work_stats as
    select e.position, 
    count(w.projno) as "총참여건수", 
    round(avg(nvl(w.hours_worked, 0)), 1) as "평균투입시간"
    from Employee e
    left join Works w on e.empno = w.empno
    group by e.position;

-- 11. 다중 프로젝트 참여 직원 뷰를 작성하시오 (2개 이상의 프로젝트에 참여 중인 직원 조회 뷰)
create or replace view v_multi_project_workers as
    select e.empno, e.name, count(w.projno) as "참여프로젝트수"
    from Employee e
    join Department d on e.deptno = d.deptno
    join Works w on e.empno = w.empno
    group by e.empno, e.name
    having count(w.projno) >= 2;

-- 12. 부서 내 프로젝트 참여 직원 상세 뷰를 작성하시오 (같은 부서 소속 직원이 해당 부서 프로젝트에 참여하는 현황 뷰)
create or replace view v_dept_internal_project_status as
    select d.deptname, p.proname, e.name
    from Department d
    join Project p on d.deptno = p.deptno
    join Works w on p.projno = w.projno
    join Employee e on w.empno = e.empno and e.deptno = d.deptno;

-- 13. 타 부서 프로젝트 참여 직원 뷰를 작성하시오 (자신의 소속 부서가 아닌 타 부서 프로젝트에 참여하는 직원 뷰)
create or replace view v_external_project_support as
    select e.name, d_emp.deptname, p.proname, d_proj.deptname
    from Employee e
    join Department d_emp on e.deptno = d_emp.deptno
    join Project p on w.projno = p.projno
    join Department d_proj on p.deptno = d_proj.deptno
    where e.deptno != p.deptno;

-- 14. 고투입 시간 직원 뷰 (평균 이상 근무)를 작성하시오 (프로젝트 평균 투입 시간보다 많이 근무한 직원 조회 뷰)
create or replace view v_high_effort_employees as
    select e.name, p.proname, w.hours_worked
    from Employee e
    join Works w on e.empno = w.empno
    join Project p on w.projno = p.projno
    where w.gours_worked > (select avg(hours_worked) from Works);

-- 15. 프로젝트 미배정 부서 뷰를 작성하시오 (담당 프로젝트가 하나도 없는 부서 조회 뷰)
create or replace view v_departments_with_no_projects as
    select d.deptno, d.deptname
    from Department d
    where not exists (
        select 1
        from Project p
        where d.deptno = p.deptno
    );
