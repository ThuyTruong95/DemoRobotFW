*** Settings ***
Library     DatabaseLibrary


*** Test Cases ***
Connect db posgre
    # 1. DB PostgreSQL (psycopg2)
    Connect To Database
    ...    psycopg2
    ...    db_name=db
    ...    db_user=db_user
    ...    db_password=pass
    ...    db_host=127.0.0.1
    ...    db_port=5432

    # 2. Microsoft SQL Server (pymssql)

    # UTF-8 charset is used by default
    Connect To Database
    ...    pymssql
    ...    db_name=db
    ...    db_user=db_user
    ...    db_password=pass
    ...    db_host=127.0.0.1
    ...    db_port=1433

    # Specifying a custom charset
    Connect To Database
    ...    pymssql
    ...    db_name=db
    ...    db_user=db_user
    ...    db_password=pass
    ...    db_host=127.0.0.1
    ...    db_port=1433
    ...    db_charset=cp1252

    # 3. DB MySQL (pymysql)
    # UTF-8 charset is used by default
    Connect To Database
    ...    pymysql
    ...    db_name=db
    ...    db_user=db_user
    ...    db_password=pass
    ...    db_host=127.0.0.1
    ...    db_port=3306

    # Specifying a custom charset
    Connect To Database
    ...    pymysql
    ...    db_name=db
    ...    db_user=db_user
    ...    db_password=pass
    ...    db_host=127.0.0.1
    ...    db_port=3306
    ...    db_charset=cp1252
