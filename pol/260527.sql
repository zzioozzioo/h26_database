--1)
SELECT BRAND_CD, INVOICE_NO, ITEM_CD, ORDER_QTY
  FROM A_OUT_D
 WHERE INVOICE_NO LIKE '#0%' 
   AND ORDER_QTY >= 3
 ORDER BY ORDER_QTY DESC;
 
 --2)
SELECT BRAND_CD, INVOICE_NO, ITEM_CD, ORDER_QTY
  FROM A_OUT_D
 WHERE INVOICE_NO LIKE '#0%' 
   AND ORDER_QTY >= 3
 ORDER BY ORDER_QTY DESC, ITEM_CD ASC;
 
 --3)
 SELECT BRAND_CD, INVOICE_NO, ITEM_CD, ORDER_QTY
 FROM (
     SELECT BRAND_CD, INVOICE_NO, ITEM_CD, ORDER_QTY
      FROM A_OUT_D
     WHERE INVOICE_NO LIKE '#0%' 
       AND ORDER_QTY >= 3
     ORDER BY ORDER_QTY DESC, ITEM_CD
)
WHERE ROWNUM <= 2;
--FETCH NEXT 2 ROWS ONLY;

--1)
SELECT COUNT(INVOICE_NO)
  FROM A_OUT_M
 WHERE OUTBOUND_DATE BETWEEN '2023-01-03' AND '2023-01-04';
 
--2) 
SELECT SUM(ORDER_QTY)
  FROM A_OUT_D
 WHERE BRAND_CD = '1001';
 
 
--1)
SELECT BRAND_CD, COUNT(INVOICE_NO)
-- COUNT에 컬럼명을 명시하는 경우는 DISTINCT 적용하기 위한 경우가 대부분
  FROM A_OUT_M
 GROUP BY BRAND_CD;
 
--2)
SELECT BRAND_CD, OUTBOUND_DATE, COUNT(INVOICE_NO)
  FROM A_OUT_M
 GROUP BY BRAND_CD, OUTBOUND_DATE;
 
--3)
SELECT BRAND_CD, SUM(ORDER_QTY)
  FROM A_OUT_D
 GROUP BY BRAND_CD;
 
--4)
SELECT BRAND_CD, ITEM_CD, SUM(ORDER_QTY)
  FROM A_OUT_D
 GROUP BY BRAND_CD, ITEM_CD;
 
--5)
SELECT BRAND_CD, MAX(ORDER_QTY), MIN(ORDER_QTY)
  FROM A_OUT_D
 GROUP BY BRAND_CD;
 
 
 --1)
 SELECT D.*
   FROM A_OUT_D D
  WHERE D.INVOICE_NO IN (
                          SELECT M.INVOICE_NO
                            FROM A_OUT_M M
                           WHERE M.OUTBOUND_DATE = '2023-01-03'
                         );
                     
--2)
SELECT *
  FROM A_OUT_D
 WHERE (BRAND_CD, INVOICE_NO) IN (
                                SELECT BRAND_CD, INVOICE_NO
                                  FROM A_OUT_M
                                 WHERE BRAND_CD = '1001'
                                   AND OUT_TYPE_DIV LIKE 'M1%'
                                );
                        
SELECT *
  FROM A_OUT_D
 WHERE BRAND_CD = '1001'
   AND INVOICE_NO IN (
                        SELECT BRAND_CD, INVOICE_NO
                          FROM A_OUT_M
                         WHERE OUT_TYPE_DIV LIKE 'M1%'
                     );

--3)
SELECT *
  FROM A_OUT_M
 WHERE (BRAND_CD, INVOICE_NO) IN (
                                    SELECT BRAND_CD, INVOICE_NO
                                      FROM A_OUT_D
                                     GROUP BY BRAND_CD, INVOICE_NO
                                    HAVING SUM(ORDER_QTY) >= 3
                                    );
                        

--1)
SELECT D.BRAND_CD, (
                    SELECT A.ITEM_CD 
                      FROM A_ITEM A
                     WHERE A.BRAND_CD = D.BRAND_CD
                       AND A.ITEM_CD = D.ITEM_CD
                   ), SUM(D.ORDER_QTY)
  FROM A_OUT_D D
 GROUP BY D.BRAND_CD, D.ITEM_CD;

-- 교수님 풀이
SELECT BRAND_CD, ITEM_CD, SUM_QTY
      , (SELECT S1.ITEM_NM
           FROM A_ITEM S1
          WHERE S1.BRAND_CD = M1.BRAND_CD
            AND S1.ITEM_CD = M1.ITEM_CD
        ) AS ITEM_NM
  FROM (
        SELECT BRAND_CD, ITEM_CD, SUM(ORDER_QTY) AS SUM_QTY
          FROM A_OUT_D
         GROUP BY BRAND_CD, ITEM_CD
       ) M1;


-- 문제) 출고일자 + 10일 결과 출력
SELECT DISTINCT OUTBOUND_DATE
  FROM LO_OUT_M M1
 WHERE M1.OUTBOUND_DATE BETWEEN TO_DATE(:OUTBOUND_DATE, 'YYYY-MM-DD') + 1
                            AND TO_DATE(:OUTBOUND_DATE, 'YYYY-MM-DD') + 10
   AND EXISTS (
                SELECT 1
                  FROM LO_OUT_M M2
                 WHERE M2.OUTBOUND_DATE = M1.OUTBOUND_DATE
              )
 ORDER BY M1.OUTBOUND_DATE
;

-- 교수님 풀이 1
SELECT DISTINCT OUTBOUND_DATE
  FROM LO_OUT_M
 WHERE OUTBOUND_DATE BETWEEN TO_DATE(:OUTBOUNT_DATE) + 1
                            AND TO_DATE(:OUTBOUND_DATE) + 10
 ORDER BY OUTBOUND_DATE
 ;

-- 교수님 풀이 2
SELECT *
  FROM (
        SELECT TO_DATE(:OUTBOUND_DATE) + NO AS DAY
          FROM CS_NO
         WHERE NO <= :DAYS
        ) M1
 WHERE EXISTS (
                SELECT 1
                  FROM LO_OUT_M S1
                 WHERE S1.OUTBOUND_DATE = M1.DAY
              )
ORDER BY DAY
;


-- 문제) LO_OUT_M 테이블을 메인 쿼리에서 사용하고 LO_OUT_D 테이블을 스칼라 쿼리에서 사용하기
-- 조건에 해당하는 INVOICE_NO에 대해 ORDER_QTY이 가장 큰 LINE_NO를 함께 구하기

-- 교수님 풀이
SELECT INVOICE_NO, OUT_TYPE_DIV, OUT_BOX_DIV
       , TO_NUMBER(SUBSTR(MAX_VAL, 1, 5)) AS MAX_ORDER_QTY
       , TO_NUMBER(SUBSTR(MAX_VAL, 7, 3)) AS MAX_LINE_NO
  FROM (
        SELECT INVOICE_NO, OUT_TYPE_DIV, OUT_BOX_DIV
            , (SELECT MAX(LPAD(ORDER_QTY, 5, '0') || '-' || LPAD(LINE_NO, 3, '0'))
                 FROM LO_OUT_D M2
                WHERE M2.INVOICE_NO = M1.INVOICE_NO
              ) AS MAX_VAL
          FROM LO_OUT_M M1
         WHERE OUTBOUND_DATE = '2019-06-03'
           AND OUTBOUND_NO BETWEEN 'D190603-897353' AND 'D190603-897360'
       )
;