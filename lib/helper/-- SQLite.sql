
insert into products values ("prdA31", "sản phẩm 2-B", "assets/images/ImageOffice/SmartFI_Box2.png", 30000, 100, "10%", "27000", 100);
insert into products values ("prdA2", "sản phẩm 2", "assets/images/ImageOffice/L24YK_1.png", 30000, 100, "10%", "27000");
insert into products values ("prdA13", "sản phẩm 3", "assets/images/ImageOffice/Sensor_Final_1.png", 30000, 100, "10%", "27000");
insert into products values ("prdA4", "sản phẩm 4", "assets/images/ImageOffice/SmartFI_Box2.png", 30000, 100, "10%", "27000")
SELECT * FROM products WHERE productId = 'prdA1'

UPDATE tasks
SET taskName = "Hoạt động 2.2"
WHERE taskId = "t2.2";

UPDATE users 
SET wallet = 100000 - (SELECT wallet FROM users WHERE id = 1)
WHERE id = 1;

-- ALTER TABLE products drop column price double;

ALTER TABLE products 
       ADD COLUMN status integer DEFAULT 0

UPDATE products 
       SET new_column_name = CAST(old_column_name as new_data_type_you_want)

CREATE TABLE IF NOT EXISTS products(productId TEXT PRIMARY KEY, productName TEXT, productImage TEXT, price integer, quantity integer, sale TEXT, prSale double, quantityTemp integer)
CREATE TABLE IF NOT EXISTS sliders(slideId integer PRIMARY KEY AUTOINCREMENT, image_path text)
CREATE TABLE IF NOT EXISTS userLogin(userId INTEGER PRIMARY KEY AUTOINCREMENT,userName TEXT,email TEXT,password TEXT, type Text, level integer)
CREATE TABLE IF NOT EXISTS orders(tradingCode text primary key, productId TEXT, userId TEXT, price double, address text, quantity integer, complete boolean)
Create table if not exists users(id integer primary key autoincrement, avatar text, name text, age integer, address text)
CREATE TABLE IF NOT EXISTS widgets(widgetId TEXT, title TEXT, productId TEXT, type TEXT, content Text, primary key(widgetId, productId, type))
Create table if not exists indexTasks(taskId text, userId integer, taskName text, note text, createTime text default CURRENT_TIMESTAMP, status int default 0, primary key(taskId, userId),
FOREIGN KEY (userId) REFERENCES userLogin(userId));
Create table if not exists tasks(taskId text, taskChildId text, taskChildName text, content text, createTime text default CURRENT_TIMESTAMP, completeTime text, status int default 0, primary key(taskId, taskChildId), 
FOREIGN KEY (taskId) REFERENCES tasks(taskId))


insert into indexTasks values ("t1", "2", "Hoạt động 1", "Thêm 10 sản phẩm mới",0)
insert into tasks values ("t1.1", "1", "Hoạt động 1", "Thêm 10 sản phẩm mới lần 1",0)
-- SQLite
INSERT INTO indexTasks (taskId, userId, taskName, note, status) VALUES ("tb1", "2", "Hoạt động 1", "Xóa sản phẩm",0);
INSERT INTO indexTasks (taskId, userId, taskName, note, status) VALUES ("tb2", "2", "Hoạt động 2", "Thêm sản phẩm",0);
INSERT INTO tasks (taskId, taskChildId, taskChildName, content) VALUES ("tb1", "t1", "Xóa lần 1", "Xóa 3 sản phẩm mới vừa thêm");
INSERT INTO tasks (taskId, taskChildId, taskChildName, content) VALUES ("tb", "t2", "Xóa lần 1", "Xóa 1 sản phẩm mới ngày 19");
UPDATE tasks SET taskId = 'tb1' WHERE taskChildId = 't2' 
Drop table indexTasks;
PRAGMA foreign_key_list(indexTasks);
delete from tasks where taskId = 't2' and userId = 1
delete from userLogin where userId = '3'
SELECT * FROM tasks WHERE userId = '2' and taskId like 't%' and taskId not like 't%.%'
select * from products
select * from indexTasks;
select * from userLogin;

PRAGMA foreign_keys = ON

ALTER TABLE orders DROP CONSTRAINT productId;

SELECT productId FROM products ORDER BY productId DESC LIMIT 1
SELECT * FROM products where productId like 'prdA%' ORDER BY productId DESC LIMIT 1
SELECT * FROM products WHERE productId LIKE 'prdB%' ORDER BY LENGTH(productId) DESC, productId DESC LIMIT 1;
Create table if not exists users(userId integer primary key autoincrement, name text, age integer, address text)
insert into widgets values ("wd1","Hot Product","prdA1","T1","List Sản phẩm Hot");
insert into widgets values ("wd1","Hot Product","prdA2","T1","List Sản phẩm Hot");
insert into widgets values ("wd1","Hot Product","prdA3","T1","List Sản phẩm Hot");
insert into widgets values ("wd1","Hot Product","prdB1","T1","List Sản phẩm Hot");
insert into widgets values ("wd2","Save 5500 TK in GoPro Hero 10!","1","T2","Get huge discount in products or save money\n by using coupons while checkout");
insert into widgets values ("wd5","-- BIG UPDATES --","1","T1","Sắp ra mắt những sản phẩm mới ngày 22/10/2023 \n          đáp ứng mọi yêu cầu của khách hàng");
insert into widgets values ("wd3","New Product","prdA1","T1","List Sản phẩm New");
insert into widgets values ("wd3","New Product","prdA2","T1","List Sản phẩm New");
insert into widgets values ("wd3","New Product","prdA3","T1","List Sản phẩm New");
insert into widgets values ("wd3","New Product","prdB1","T1","List Sản phẩm New");
insert into widgets values ("wd4","Sale Product","prdA1","T1","List Sản phẩm Sale");
insert into widgets values ("wd4","Sale Product","prdA2","T1","List Sản phẩm Sale");
insert into widgets values ("wd4","Sale Product","prdA3","T1","List Sản phẩm Sale");
insert into widgets values ("wd4","Sale Product","prdB1","T1","List Sản phẩm Sale");

insert into orders values ("abcd","prdA1", "1", 30000,"HY _ TQ", 10, 0);

SELECT * FROM users JOIN userLogin ON users.id = userLogin.userId;


-- change type column
ALTER TABLE products RENAME TO products_tmp;
CREATE TABLE products(
       productId TEXT PRIMARY KEY, productName TEXT, productImage TEXT, price integer, quantity integer, sale TEXT, prSale int, quantityTemp integer);
INSERT INTO products(productId, productName, productImage, price, quantity, sale, prSale, quantityTemp)

SELECT productId, productName, productImage, price, quantity, sale, prSale, quantityTemp FROM products_tmp;
