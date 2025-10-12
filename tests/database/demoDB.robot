*** Settings ***
Library    DatabaseLibrary

*** Variables ***
${DBPATH}    ${EXECDIR}/data/SQLite.db

*** Test Cases ***
Connect To SQLite And Query Data
    [Documentation]    Kết nối tới SQLite, đọc dữ liệu từ bảng users
    Connect To Database    sqlite3    ${DBPATH}
    ${result}=    Query    SELECT * FROM users;
    Log To Console    \n✅ Data từ bảng users: ${result}
    Disconnect From Database

# --- 1. Kết nối DB ---
Connect To SQLite Database
    [Documentation]    Kết nối tới file SQLite
    Connect To Database    sqlite3    ${DBPATH}
    Log To Console    ✅ Đã kết nối SQLite: ${DBPATH}

# --- 2. Tạo bảng ---
Create Products Table
    [Documentation]    Tạo bảng sản phẩm nếu chưa có
    Connect To Database    sqlite3    ${DBPATH}
    ${query}=    Catenate
    ...    CREATE TABLE IF NOT EXISTS products (
    ...    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ...    name TEXT NOT NULL,
    ...    price REAL,
    ...    stock INTEGER
    ...    );
    Execute Sql String    ${query}
    Log To Console    ✅ Đã tạo bảng products
    Disconnect From Database

# --- 3. Thêm dữ liệu ---
Insert Sample Data
    [Documentation]    Thêm 3 sản phẩm mẫu vào bảng
    Connect To Database    sqlite3    ${DBPATH}
    Execute Sql String    INSERT INTO products (name, price, stock) VALUES ('Laptop', 1500.0, 10);
    Execute Sql String    INSERT INTO products (name, price, stock) VALUES ('Mouse', 25.0, 100);
    Execute Sql String    INSERT INTO products (name, price, stock) VALUES ('Keyboard', 45.0, 50);
    Log To Console    ✅ Đã thêm dữ liệu thành công
    Disconnect From Database

# --- 4. Truy vấn kiểm tra ---
Query Products
    [Documentation]    Lấy danh sách sản phẩm hiện có
    Connect To Database    sqlite3    ${DBPATH}
    ${rows}=    Query    SELECT * FROM products;
    Log Many    ${rows}
    Log To Console    ✅ Có ${len(${rows})} sản phẩm trong DB
    Disconnect From Database

# --- 5. Cập nhật dữ liệu ---
Update Product Stock
    [Documentation]    Tăng tồn kho của Laptop lên 15
    Connect To Database    sqlite3    ${DBPATH}
    Execute Sql String    UPDATE products SET stock=15 WHERE name='Laptop';
    ${result}=    Query    SELECT stock FROM products WHERE name='Laptop';
    Should Be Equal As Integers    ${result[0][0]}    15
    Log To Console    ✅ Cập nhật tồn kho Laptop thành công
    Disconnect From Database

# --- 6. Xóa dữ liệu ---
Delete Product
    [Documentation]    Xóa sản phẩm 'Mouse'
    Connect To Database    sqlite3    ${DBPATH}
    Execute Sql String    DELETE FROM products WHERE name='Mouse';
    ${rows}=    Query    SELECT * FROM products;
    Log To Console    ✅ Còn lại ${len(${rows})} sản phẩm sau khi xóa
    Disconnect From Database

# --- 7. Kiểm tra tồn tại bảng ---
Check Tables Exist
    [Documentation]    Kiểm tra danh sách bảng trong DB
    Connect To Database    sqlite3    ${DBPATH}
    ${tables}=    Query    SELECT name FROM sqlite_master WHERE type='table';
    Log To Console    ✅ Các bảng hiện có: ${tables}
    Disconnect From Database
