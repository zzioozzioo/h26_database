import oracledb

dsn = "localhost:1521/FREE"
username = "c##madang"
password = "madang"
conflag = True

try:
    print("데이터베이스 연결 준비...")
    print(f"DSN: {dsn}")
    conn = oracledb.connect(user=username, password=password, dsn=dsn)
    print("데이터베이스 연결 성공!")
    conflag = True
except Exception as e:
    print(f"데이터베이스 연결 실패: {e}")
    print("다음을 확인해 주세요: Oracle 실행 중, 사용자명, 비밀번호, 서비스명")
    conflag = False

if conflag:
    try:
        cursor = conn.cursor()
        sqlstring = "SELECT * FROM book"
        cursor.execute(sqlstring)
        data = cursor.fetchall()

        for row in data:
            print(row[0], row[1], row[2], row[3])
        cursor.close()
        conn.close()
    except Exception as e:
        print("데이터 조회 중 오류 발생: ", e)
else:
    print("데이터베이스 연결 실패")