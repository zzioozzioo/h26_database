마당 서점 테이블을 기준으로 프로시저를 작성하시오.
테이블 주요 컬럼
  Book: bokid, bookname,  publisher, price
  Customer: custid, name, address, phone
  Orders: orderid, custid, bookid, saleprice, orderdate 

[기본 CRUD (문제 1~5)]
1. bookid를 입력받아 해당 도서의 bookname, publisher, price를 출력하는 프로시저를 작
성하시오.
create or replace procedure get_book_info(p_bookid in book.bookid%type) is
    v_bookname book.bookname%type;
    v_publisher book.publisher%type;
    v_price book.price%type;
begin
    select bookname, publisher, price   
    into v_bookname, v_publisher, v_price
    from book
    where bookid = p_bookid;
    dbms_output.put_line('도서명 : ' || v_bookname);
    dbms_output.put_line('출판사 : ' || v_publisher);
    dbms_output.put_line('가격 : ' || v_price);
exception -- begin-end 사이에 예외 처리 꼭 해주기
    when no_data_found then
        dbms_output.put_line('해당 도서번호가 존재하지 않습니다. ID: ' || p_bookid); 
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);   
end;


2. 새로운 고객 정보(custid, name, address, phone)를 입력받아 Customer 테이블에 삽입
하는 프로시저를 작성하시오.
create or replace procedure add_customer(
    p_custid in customer.custid%type,
    p_name in customer.name%type,
    p_address in customer.address%type,
    p_phone in customer.phone%type
) is
begin
    insert into customer (custid, name, address, phone)
    values (p_custid, p_name, p_address, p_phone);
    dbms_output.put_line('고객이 정상적으로 등록되었습니다.');
exception
    when dup_val_on_index then
        dbms_output.put_line('이미 존재하는 고객번호입니다. : ' || p_custid);   
    when others then
        rollback; -- 트랜잭션 롤백: 변동 사항(데이터 삽입)이 있을 때, 오류 발생 시 이전 상태로 되돌리는 것
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;

3. bookid와 새로운 price를 입력받아 해당 도서의 가격을 수정하는 프로시저를 작성하시오.
create or replace procedure update_book_price(
    p_bookid in book.bookid%type,
    p_new_price in book.price%type
)
is
begin
    update book
    set price = p_new_price
    where bookid = p_bookid;
    if sql%rowcount > 0 then
        dbms_output.put_line('도서 가격이 성공적으로 업데이트되었습니다. 도서 ID: ' || p_bookid);
    else
        dbms_output.put_line('해당 도서를 찾을 수 없습니다. ID: ' || p_bookid);
    end if;
exception
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;

4. custid를 입력받아 해당 고객의 주문 내역을 Orders 테이블에서 모두 삭제한 후, 
Customer 테이블에서도 해당 고객을 삭제하는 프로시저를 작성하시오.
create or replace procedure delete_customer_and_orders(p_custid in customer.custid%type) is
begin
    delete from orders where custid = p_custid; -- 주문 내역 삭제
    delete from customer where custid = p_custid; -- 고객 정보 삭제
    dbms_output.put_line('고객과 해당 고객의 주문 내역이 성공적으로 삭제되었습니다. 고객 ID: ' || p_custid);    
exception
    when others then
        rollback; -- 트랜잭션 롤백: 변동 사항(데이터 삭제)이 있을 때, 오류 발생 시 이전 상태로 되돌리는 것
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;

5. orderid를 입력받아 해당 주문의 고객 이름, 도서명, 주문금액, 주문날짜를 출력하는 프로
시저를 작성하시오.
create or replace procedure get_order_info(p_orderid in orders.orderid%type) is
    v_custname customer.name%type;
    v_bookname book.bookname%type;
    v_saleprice orders.saleprice%type;
    v_orderdate orders.orderdate%type;
begin
    select c.name, b.bookname, o.saleprice, o.orderdate
    into v_custname, v_bookname, v_saleprice, v_orderdate
    from orders o
    join customer c on o.custid = c.custid
    join book b on o.bookid = b.bookid
    where o.orderid = p_orderid;
    dbms_output.put_line('고객 이름 : ' || v_custname);
    dbms_output.put_line('도서명 : ' || v_bookname);
    dbms_output.put_line('주문 금액 : ' || v_saleprice);
    dbms_output.put_line('주문 날짜 : ' || v_orderdate);
exception
    when no_data_found then
        dbms_output.put_line('해당 주문번호가 존재하지 않습니다. ID: ' || p_orderid); 
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;


[조건 조회 (문제 6~10)]
6. 출판사 이름을 입력받아 해당 출판사의 도서 목록(bookid, bookname, price)을 모두 출
력하는 프로시저를 작성하시오.
create or replace procedure get_books_by_publisher(p_publisher in book.publisher%type) is
    v_bookid book.bookid%type;
    v_bookname book.bookname%type;
    v_price book.price%type;
    cursor c_books is
        select bookid, bookname, price
        from book
        where publisher = p_publisher;
begin
    open c_books;
    loop
        fetch c_books into v_bookid, v_bookname, v_price;
        exit when c_books%notfound;
        dbms_output.put_line('도서 ID: ' || v_bookid || ', 도서명: ' || v_bookname || ', 가격: ' || v_price);
    end loop;
    close c_books;
exception
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;

7. custid를 입력받아 해당 고객의 전체 주문 내역(도서명, 주문금액, 주문날짜)을 주문날짜 
오름차순으로 출력하는 프로시저를 작성하시오.
create or replace procedure get_customer_orders(p_custid in customer.custid%type) is
    v_bookname book.bookname%type;
    v_saleprice orders.saleprice%type;
    v_orderdate orders.orderdate%type;
    cursor c_orders is
        select b.bookname, o.saleprice, o.orderdate
        from orders o
        join book b on o.bookid = b.bookid
        where o.custid = p_custid
        order by o.orderdate asc;
begin
    open c_orders;
    loop
        fetch c_orders into v_bookname, v_saleprice, v_orderdate;
        exit when c_orders%notfound;
        dbms_output.put_line('도서명: ' || v_bookname || ', 주문 금액: ' || v_saleprice || ', 주문 날짜: ' || v_orderdate);
    end loop;
    close c_orders;
exception
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;

8. 시작 날짜와 종료 날짜를 입력받아 해당 기간 내 주문된 모든 주문 정보(고객명, 도서명, 
주문금액, 주문날짜)를 출력하는 프로시저를 작성하시오.
create or replace procedure get_orders_by_date_range(
    p_start_date in orders.orderdate%type,
    p_end_date in orders.orderdate%type
) is
    v_custname customer.name%type;
    v_bookname book.bookname%type;
    v_saleprice orders.saleprice%type;
    v_orderdate orders.orderdate%type;
    cursor c_orders is
        select c.name, b.bookname, o.saleprice, o.orderdate
        from orders o
        join customer c on o.custid = c.custid
        join book b on o.bookid = b.bookid
        where o.orderdate between p_start_date and p_end_date
        order by o.orderdate asc;
begin
    open c_orders;
    loop
        fetch c_orders into v_custname, v_bookname, v_saleprice, v_orderdate;
        exit when c_orders%notfound;
        dbms_output.put_line('고객명: ' || v_custname || ', 도서명: ' || v_bookname || ', 주문 금액: ' || v_saleprice || ', 주문 날짜: ' || v_orderdate);
    end loop;
    close c_orders;
exception
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;

9. 도서 이름을 입력받아 해당 도서를 주문한 고객의 이름과 주문금액을 출력하는 프로시저를 
작성하시오.
create or replace procedure get_customers_by_book(p_bookname in book.bookname%type) is
    v_custname customer.name%type;
    v_saleprice orders.saleprice%type;
    cursor c_customers is
        select c.name, o.saleprice
        from orders o
        join customer c on o.custid = c.custid
        join book b on o.bookid = b.bookid
        where b.bookname = p_bookname;
begin
    open c_customers;
    loop
        fetch c_customers into v_custname, v_saleprice;
        exit when c_customers%notfound;
        dbms_output.put_line('고객명: ' || v_custname || ', 주문 금액: ' || v_saleprice);
    end loop;
    close c_customers;
exception
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;

10. 특정 주문금액 이상의 주문을 한 고객의 custid, name, 주문 건수를 출력하는 프로시저
를 작성하시오.
create or replace procedure get_customers_by_min_order_amount(p_min_amount in orders.saleprice%type) is
    v_custid customer.custid%type;
    v_name customer.name%type;
    v_order_count number;
    cursor c_customers is
        select c.custid, c.name, count(*) as order_count
        from orders o
        join customer c on o.custid = c.custid
        where o.saleprice >= p_min_amount
        group by c.custid, c.name;
begin
    open c_customers;
    loop
        fetch c_customers into v_custid, v_name, v_order_count;
        exit when c_customers%notfound;
        dbms_output.put_line('고객 ID: ' || v_custid || ', 이름: ' || v_name || ', 주문 건수: ' || v_order_count);
    end loop;
    close c_customers;
exception
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;


[계산 및 통계 (문제 11~13)]
11. custid를 입력받아 해당 고객의 총 주문금액 합계를 OUT 매개변수로 반환하고 화면에도 
출력하는 프로시저를 작성하시오.
create or replace procedure get_total_order_amount(
    p_custid in customer.custid%type,
    p_total_amount out number
) is
begin
    select sum(saleprice)
    into p_total_amount
    from orders
    where custid = p_custid;
    dbms_output.put_line('고객 ID: ' || p_custid || ', 총 주문금액: ' || p_total_amount);
exception
    when no_data_found then
        p_total_amount := 0; -- 주문이 없는 경우 총 금액을 0으로 설정
        dbms_output.put_line('고객 ID: ' || p_custid || '는 주문이 없습니다. 총 주문금액: 0');
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;

12. 출판사 이름을 입력받아 해당 출판사 도서들의 평균 주문금액, 최고 주문금액, 최저 주문
금액을 출력하는 프로시저를 작성하시오.
create or replace procedure get_order_stats_by_publisher(p_publisher in book.publisher%type) is
    v_avg_price number;
    v_max_price number;
    v_min_price number;
begin
    select avg(o.saleprice), max(o.saleprice), min(o.saleprice)
    into v_avg_price, v_max_price, v_min_price
    from orders o
    join book b on o.bookid = b.bookid
    where b.publisher = p_publisher;
    dbms_output.put_line('출판사: ' || p_publisher || ', 평균 주문금액: ' || v_avg_price || ', 최고 주문금액: ' || v_max_price || ', 최저 주문금액: ' || v_min_price);
exception
    when no_data_found then
        dbms_output.put_line('출판사: ' || p_publisher || '의 도서에 대한 주문이 없습니다.');
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;

13. 전체 도서 중 주문 횟수가 가장 많은 도서의 이름과 주문 횟수를 OUT 매개변수로 반환
하는 프로시저를 작성하시오.
create or replace procedure get_most_ordered_book(
    p_bookname out book.bookname%type,
    p_order_count out number
)
is
begin
    select b.bookname, count(*) as order_count
    into p_bookname, p_order_count
    from orders o
    join book b on o.bookid = b.bookid
    group by b.bookname
    order by order_count desc
    fetch first 1 row only;
    dbms_output.put_line('가장 많이 주문된 도서: ' || p_bookname || ', 주문 횟수: ' || p_order_count);
exception
    when no_data_found then
        p_bookname := null;
        p_order_count := 0;
        dbms_output.put_line('주문된 도서가 없습니다.');
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;


[예외 처리 및 응용 (문제 14~15)]
14. 주문 삽입 시 입력한 saleprice가 해당 도서의 price보다 크면 오류 메시지를 출력하고 
삽입을 중단하며, 정상이면 Orders 테이블에 삽입하는 프로시저를 작성하시오.
create or replace procedure insert_order(
    p_custid in orders.custid%type,
    p_bookid in orders.bookid%type,
    p_saleprice in orders.saleprice%type
) is
    v_book_price book.price%type;   
begin
    select price into v_book_price from book where bookid = p_bookid;
    if p_saleprice > v_book_price then
        dbms_output.put_line('오류: 주문 금액이 도서 가격보다 큽니다. 주문이 삽입되지 않았습니다. 도서 ID: ' || p_bookid);
    else
        insert into orders (custid, bookid, saleprice, orderdate)
        values (p_custid, p_bookid, p_saleprice, sysdate);
        dbms_output.put_line('주문이 성공적으로 삽입되었습니다. 고객 ID: ' || p_custid || ', 도서 ID: ' || p_bookid);
    end if;
exception
    when no_data_found then
        dbms_output.put_line('해당 도서번호가 존재하지 않습니다. ID: ' || p_bookid); 
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;

15. custid를 입력받아 해당 고객의 총 주문금액이 30,000원 이상이면 'VIP 고객', 10,000원 
이상이면 '일반 고객', 그 미만이면 '신규 고객'으로 등급을 분류하여 출력하는 프로시저를 작
성하시오.
create or replace procedure classify_customer(p_custid in customer.custid%type) is
    v_total_amount number;
    v_grade varchar2(20);
begin
    select sum(saleprice) into v_total_amount from orders where custid = p_custid;
    if v_total_amount >= 30000 then
        v_grade := 'VIP 고객';
    elsif v_total_amount >= 10000 then
        v_grade := '일반 고객';
    else
        v_grade := '신규 고객';
    end if;
    dbms_output.put_line('고객 ID: ' || p_custid || ', 총 주문금액: ' || v_total_amount || ', 등급: ' || v_grade);
exception
    when no_data_found then
        dbms_output.put_line('고객 ID: ' || p_custid || '는 주문이 없습니다. 등급: 신규 고객');
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;


주어진 테이블을 기준으로 프로시저를 생성하시오.
테이블 주요 컬럼
극장( __극장번호__, 극장이름, 위치)
상영관(__극장번호__, __상영관번호__, 영화제목, 가격, 좌석수 )
예약(__극장번호,__ __상영관번호, 고객번호__, 좌석번호, 날짜)
고객(__고객번호__, 이름, 주소)

[기본 CRUD]
1. 특정 극장번호를 입력받아 해당 극장의 이름과 위치를 출력하는 프로시저를 작성하시오.
create or replace procedure get_theater_info(p_theater_id in theater.theater_id%type) is
    v_theater_name theater.theater_name%type;
    v_location theater.location%type;
begin
    select theater_name, location
    into v_theater_name, v_location
    from theater
    where theater_id = p_theater_id;
    dbms_output.put_line('극장이름 : ' || v_theater_name);
    dbms_output.put_line('위치 : ' || v_location);
exception
    when no_data_found then
        dbms_output.put_line('해당 극장번호가 존재하지 않습니다. ID: ' || p_theater_id); 
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;

2. 새로운 극장 정보(극장번호, 극장이름, 위치)를 입력받아 극장 테이블에 삽입하는 프로시저
를 작성하시오.
create or replace procedure add_theater(
    p_theater_id in theater.theater_id%type,
    p_theater_name in theater.theater_name%type,
    p_location in theater.location%type
) is
begin
    insert into theater (theater_id, theater_name, location)
    values (p_theater_id, p_theater_name, p_location);
    dbms_output.put_line('극장이 정상적으로 등록되었습니다. 극장 ID: ' || p_theater_id);
exception
    when dup_val_on_index then
        dbms_output.put_line('이미 존재하는 극장번호입니다. : ' || p_theater_id);   
    when others then
        rollback;
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;    

3. 극장번호와 새로운 위치를 입력받아 해당 극장의 위치를 수정하는 프로시저를 작성하시오.
create or replace procedure update_theater_location(
    p_theater_id in theater.theater_id%type,
    p_new_location in theater.location%type
) is
begin
    update theater
    set location = p_new_location
    where theater_id = p_theater_id;
    if sql%rowcount > 0 then
        dbms_output.put_line('극장 위치가 성공적으로 업데이트되었습니다. 극장 ID: ' || p_theater_id);
    else
        dbms_output.put_line('해당 극장을 찾을 수 없습니다. ID: ' || p_theater_id);
    end if;
exception
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;

4. 극장번호를 입력받아 해당 극장과 그 극장의 모든 상영관 정보를 삭제하는 프로시저를 작
성하시오.
create or replace procedure delete_theater_and_screens(p_theater_id in theater.theater_id%type) is
begin
    delete from screen where theater_id = p_theater_id; -- 상영관 정보 삭제
    delete from theater where theater_id = p_theater_id; -- 극장 정보 삭제
    dbms_output.put_line('극장과 해당 극장의 모든 상영관 정보가 성공적으로 삭제되었습니다. 극장 ID: ' || p_theater_id);
exception
    when others then
        rollback;
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;

5. 상영관번호와 극장번호를 입력받아 해당 상영관의 영화제목, 가격, 좌석수를 출력하는 프
로시저를 작성하시오.
create or replace procedure get_screen_info(
    p_theater_id in screen.theater_id%type,
    p_screen_id in screen.screen_id%type
) is
    v_movie_title screen.movie_title%type;
    v_price screen.price%type;
    v_seat_count screen.seat_count%type;
begin
    select movie_title, price, seat_count
    into v_movie_title, v_price, v_seat_count
    from screen
    where theater_id = p_theater_id and screen_id = p_screen_id;
    dbms_output.put_line('영화제목 : ' || v_movie_title);
    dbms_output.put_line('가격 : ' || v_price); 
    dbms_output.put_line('좌석수 : ' || v_seat_count);
exception
    when no_data_found then
        dbms_output.put_line('해당 상영관이 존재하지 않습니다. 극장 ID: ' || p_theater_id || ', 상영관 ID: ' || p_screen_id); 
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;

[조건 조회]
6. 특정 가격 이하의 상영관 목록을 모두 출력하는 프로시저를 작성하시오.
create or replace procedure get_screens_by_max_price(p_max_price in screen.price%type) is
    v_theater_id screen.theater_id%type;
    v_screen_id screen.screen_id%type;
    v_movie_title screen.movie_title%type;
    v_price screen.price%type;
    cursor c_screens is
        select theater_id, screen_id, movie_title, price
        from screen
        where price <= p_max_price;
begin
    open c_screens;
    loop
        fetch c_screens into v_theater_id, v_screen_id, v_movie_title, v_price;
        exit when c_screens%notfound;
        dbms_output.put_line('극장 ID: ' || v_theater_id || ', 상영관 ID: ' || v_screen_id || ', 영화제목: ' || v_movie_title || ', 가격: ' || v_price);
    end loop;
    close c_screens;
exception
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;

7. 특정 날짜를 입력받아 그날 예약된 모든 예약 정보(극장번호, 상영관번호, 고객번호, 좌석
번호)를 출력하는 프로시저를 작성하시오.
create or replace procedure get_reservations_by_date(p_reservation_date in reservation.reservation_date%type) is
    v_theater_id reservation.theater_id%type;
    v_screen_id reservation.screen_id%type;
    v_cust_id reservation.cust_id%type;
    v_seat_number reservation.seat_number%type;
    cursor c_reservations is
        select theater_id, screen_id, cust_id, seat_number
        from reservation
        where reservation_date = p_reservation_date;
begin
    open c_reservations;
    loop
        fetch c_reservations into v_theater_id, v_screen_id, v_cust_id, v_seat_number;
        exit when c_reservations%notfound;
        dbms_output.put_line('극장 ID: ' || v_theater_id || ', 상영관 ID: ' || v_screen_id || ', 고객 ID: ' || v_cust_id || ', 좌석 번호: ' || v_seat_number);
    end loop;
    close c_reservations;
exception
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;

8. 고객번호를 입력받아 해당 고객의 전체 예약 내역(극장이름, 영화제목, 날짜, 좌석번호)을 
출력하는 프로시저를 작성하시오.
create or replace procedure get_customer_reservations(p_cust_id in reservation.cust_id%type) is
    v_theater_name theater.theater_name%type;
    v_movie_title screen.movie_title%type;
    v_reservation_date reservation.reservation_date%type;
    v_seat_number reservation.seat_number%type;
    cursor c_reservations is
        select t.theater_name, s.movie_title, r.reservation_date, r.seat_number
        from reservation r
        join theater t on r.theater_id = t.theater_id
        join screen s on r.theater_id = s.theater_id and r.screen_id = s.screen_id
        where r.cust_id = p_cust_id;
begin
    open c_reservations;
    loop
        fetch c_reservations into v_theater_name, v_movie_title, v_reservation_date, v_seat_number;
        exit when c_reservations%notfound;
        dbms_output.put_line('극장이름: ' || v_theater_name || ', 영화제목: ' || v_movie_title || ', 날짜: ' || v_reservation_date || ', 좌석 번호: ' || v_seat_number);
    end loop;
    close c_reservations;
exception
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;

9. 영화제목을 입력받아 해당 영화를 상영 중인 극장 이름과 위치를 출력하는 프로시저를 작
성하시오.
create or replace procedure get_theaters_by_movie(p_movie_title in screen.movie_title%type) is
    v_theater_name theater.theater_name%type;
    v_location theater.location%type;
    cursor c_theaters is
        select t.theater_name, t.location
        from screen s
        join theater t on s.theater_id = t.theater_id
        where s.movie_title = p_movie_title;
begin
    open c_theaters;
    loop
        fetch c_theaters into v_theater_name, v_location;
        exit when c_theaters%notfound;
        dbms_output.put_line('극장이름: ' || v_theater_name || ', 위치: ' || v_location);
    end loop;
    close c_theaters;
exception
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;

10. 특정 극장번호를 입력받아 해당 극장의 상영관별 총 예약 건수를 출력하는 프로시저를 작
성하시오.
create or replace procedure get_reservation_count_by_screen(p_theater_id in reservation.theater_id%type) is
    v_screen_id reservation.screen_id%type;
    v_reservation_count number;
    cursor c_screens is
        select screen_id, count(*) as reservation_count
        from reservation
        where theater_id = p_theater_id
        group by screen_id;
begin
    open c_screens;
    loop
        fetch c_screens into v_screen_id, v_reservation_count;
        exit when c_screens%notfound;
        dbms_output.put_line('상영관 ID: ' || v_screen_id || ', 예약 건수: ' || v_reservation_count);
    end loop;
    close c_screens;
exception
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;


[계산 및 통계]
11. 극장 번호를 입력받아 해당 극장 전체 상영관의 평균 좌석수를 OUT 매개변수로 반환하
는 프로시저를 작성하시오.
create or replace procedure get_average_seat_count_by_theater(
    p_theater_id in screen.theater_id%type,
    p_avg_seat_count out number
) is
begin
    select avg(seat_count)
    into p_avg_seat_count
    from screen
    where theater_id = p_theater_id;
    dbms_output.put_line('극장 ID: ' || p_theater_id || ', 평균 좌석수: ' || p_avg_seat_count);
exception
    when no_data_found then
        p_avg_seat_count := 0; -- 상영관이 없는 경우 평균 좌석수를 0으로 설정
        dbms_output.put_line('극장 ID: ' || p_theater_id || '에는 상영관이 없습니다. 평균 좌석수: 0');
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;

12. 상영관 번호와 극장 번호를 입력받아 해당 상영관의 좌석 예약률(예약건수 / 좌석수 * 100)을 계산하여 출력하는 프로시저를 작성하시오.
create or replace procedure get_seat_reservation_rate(
    p_theater_id in reservation.theater_id%type,
    p_screen_id in reservation.screen_id%type
) is
    v_seat_count screen.seat_count%type;
    v_reservation_count number;
    v_reservation_rate number;
begin
    select seat_count into v_seat_count from screen where theater_id = p_theater_id and screen_id = p_screen_id;
    select count(*) into v_reservation_count from reservation where theater_id = p_theater_id and screen_id = p_screen_id;
    if v_seat_count > 0 then
        v_reservation_rate := (v_reservation_count / v_seat_count) * 100;
        dbms_output.put_line('극장 ID: ' || p_theater_id || ', 상영관 ID: ' || p_screen_id || ', 좌석 예약률: ' || v_reservation_rate || '%');
    else
        dbms_output.put_line('해당 상영관의 좌석 수가 0입니다. 극장 ID: ' || p_theater_id || ', 상영관 ID: ' || p_screen_id);
    end if;
exception
    when no_data_found then
        dbms_output.put_line('해당 상영관이 존재하지 않습니다. 극장 ID: ' || p_theater_id || ', 상영관 ID: ' || p_screen_id); 
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);    
end;

13. 특정 고객 번호를 입력받아 해당 고객이 지출한 총 예약 금액(예약 건수 * 가격)을 OUT 
매개변수로 반환하는 프로시저를 작성하시오.
create or replace procedure get_total_reservation_amount_by_customer(
    p_cust_id in reservation.cust_id%type,
    p_total_amount out number
) is    
begin
    select sum(s.price)
    into p_total_amount
    from reservation r
    join screen s on r.theater_id = s.theater_id and r.screen_id = s.screen_id
    where r.cust_id = p_cust_id;
    dbms_output.put_line('고객 ID: ' || p_cust_id || ', 총 예약 금액: ' || p_total_amount);
exception
    when no_data_found then
        p_total_amount := 0; -- 예약이 없는 경우 총 금액을 0으로 설정
        dbms_output.put_line('고객 ID: ' || p_cust_id || '는 예약이 없습니다. 총 예약 금액: 0');
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;


[예외처리 및 응용]
14. 예약 삽입 시 해당 상영관의 좌석 수보다 예약 건수가 많으면 오류 메시지를 출력하고 
삽입을 중단하는 프로시저를 작성하시오.
create or replace procedure insert_reservation(
    p_theater_id in reservation.theater_id%type,
    p_screen_id in reservation.screen_id%type,
    p_cust_id in reservation.cust_id%type,
    p_seat_number in reservation.seat_number%type,
    p_reservation_date in reservation.reservation_date%type
) is
    v_seat_count screen.seat_count%type;
    v_reservation_count number;
begin
    select seat_count into v_seat_count from screen where theater_id = p_theater_id
    and screen_id = p_screen_id;
    select count(*) into v_reservation_count from reservation where theater_id = p_theater_id   
    and screen_id = p_screen_id and reservation_date = p_reservation_date;
    if v_reservation_count >= v_seat_count then
        dbms_output.put_line('오류: 해당 상영관의 좌석이 모두 예약되었습니다. 예약이 삽입되지 않았습니다. 극장 ID: ' || p_theater_id || ', 상영관 ID: ' || p_screen_id);
    else
        insert into reservation (theater_id, screen_id, cust_id, seat_number, reservation_date)
        values (p_theater_id, p_screen_id, p_cust_id, p_seat_number, p_reservation_date);
        dbms_output.put_line('예약이 성공적으로 삽입되었습니다. 고객 ID: ' || p_cust_id || ', 극장 ID: ' || p_theater_id || ', 상영관 ID: ' || p_screen_id);
    end if;
exception
    when no_data_found then
        dbms_output.put_line('해당 상영관이 존재하지 않습니다. 극장 ID: ' || p_theater_id || ', 상영관 ID: ' || p_screen_id); 
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;

15. 특정 극장번호와 날짜를 입력받아, 그날 예약이 없는 상영관 목록을 출력하는 프로시저를 
작성하시오.
create or replace procedure get_available_screens_by_date(
    p_theater_id in reservation.theater_id%type,
    p_reservation_date in reservation.reservation_date%type
) is
    v_screen_id screen.screen_id%type;
    v_movie_title screen.movie_title%type;
    cursor c_available_screens is
        select s.screen_id, s.movie_title
        from screen s
        where s.theater_id = p_theater_id
        and not exists (
            select 1 from reservation r
            where r.theater_id = s.theater_id
            and r.screen_id = s.screen_id
            and r.reservation_date = p_reservation_date
        );
begin
    open c_available_screens;
    loop
        fetch c_available_screens into v_screen_id, v_movie_title;
        exit when c_available_screens%notfound;
        dbms_output.put_line('상영관 ID: ' || v_screen_id || ', 영화제목: ' || v_movie_title);
    end loop;
    close c_available_screens;
exception
    when others then
        dbms_output.put_line('오류 발생 : ' || sqlerrm);
end;


학생수강 테이블
학생(__학번__, 이름, 전공, 학년)
수강(__과목코드__, __학번__, 수강학기, 성적)
과목(__과목코드__, 과목이름, 강의실, 요일, 담당교수)

[기본 CRUD]
1. 학번을 입력받아 해당 학생의 이름, 전공, 학년을 출력하는 프로시저를 작성하시오.
2. 새로운 학생 정보(학번, 이름, 전공, 학년)를 입력받아 학생 테이블에 삽입하는 프로시저를 
작성하시오.
3. 학번과 새로운 학년을 입력받아 해당 학생의 학년 정보를 수정하는 프로시저를 작성하시
오.
4. 학번을 입력받아 해당 학생의 수강 내역을 모두 삭제한 후 학생 정보도 삭제하는 프로시저
를 작성하시오.
5. 과목코드를 입력받아 해당 과목의 과목이름, 강의실, 요일, 담당교수를 출력하는 프로시저
를 작성하시오.


[조건 조회]
6. 전공을 입력받아 해당 전공 학생들의 학번과 이름 전체를 출력하는 프로시저를 작성하시
오.
7. 학번을 입력받아 해당 학생이 수강한 과목명, 수강학기, 성적을 모두 출력하는 프로시저를 
작성하시오.
8. 담당교수 이름을 입력받아 해당 교수가 강의하는 과목을 수강한 학생들의 이름과 성적을 
출력하는 프로시저를 작성하시오.
9. 수강학기를 입력받아 해당 학기에 수강 인원이 가장 많은 과목 이름과 인원수를 출력하는 
프로시저를 작성하시오.
10. 특정 요일을 입력받아 그 요일에 강의가 있는 과목 목록과 강의실을 출력하는 프로시저를 
작성하시오.


[계산 및 통계]
11. 학번을 입력받아 해당 학생의 전체 평균 성적을 OUT 매개변수로 반환하는 프로시저를 
작성하시오.
12. 과목코드를 입력받아 해당 과목의 수강생 평균 성적과 최고 성적, 최저 성적을 출력하는 
프로시저를 작성하시오.
13. 학년을 입력받아 해당 학년 학생들의 전공별 평균 성적을 출력하는 프로시저를 작성하시
오.


[예외 처리 및 응용]
14. 수강 신청 시 동일 학번과 과목코드로 이미 수강 내역이 존재하면 '이미 수강 중입니다' 
메시지를 출력하고 삽입을 중단하는 프로시저를 작성하시오.
15. 특정 수강학기를 입력받아 성적이 NULL인 학생의 학번, 이름, 과목이름을 출력하고 성적 
미입력 건수를 OUT 매개변수로 반환하는 프로시저를 작성하시오.