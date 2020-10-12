# 基础

```sh
#本地登录
mysql -u root -p
#树莓派的MariaDB登录
sudo mysql
#修改密码
mysql -u root -p
#检查是否启动
ps -ef | grep mysqld
```

## 基础命令

```mysql
#显示数据库列表
show databases;
#选择某个库（如主库）
use mysql;
#显示库中的表
show tables;
#显示表的具体内容
describe test_table;
#创建库
create test_table;
create DATABASE Websites;
#删除库
drop DATABASE test2;
#删除表
drop TABLE test_table;
#显示表中的记录
select * from test_table;
#重命名表
RENAME TABLE table1 TO table2;
```

# 常用命令

## 创建表

```mysql
#创建表
#CREATE TABLE table_name (column_name column_type);
CREATE TABLE test_table(
test_id INT NOT NULL AUTO_INCREMENT,	#整型
test_title VARCHAR(100) NOT NULL,		#字符串型
test_author VARCHAR(40) NOT NULL,		#字符串型
submission_date DATE,					#DATE型
PRIMARY KEY ( test_id )					#主键
)ENGINE=InnoDB DEFAULT CHARSET=utf8;	#引擎、字符编码
```

```mysql
CREATE TABLE Websites (
    id int not null auto_increment,
    name varchar(100) not null,
    url varchar(100) not null,
    country varchar(40) not null,
    PRIMARY KEY (id)
	) charset = utf8;
```

说明：

- 如果你不想字段为 `NULL`可以设置字段的属性为 `NOT NULL`， 在操作数据库时如果输入该字段的数据为`NULL ，就会报错。
- `AUTO_INCREMENT`定义列为自增的属性，一般**用于主键**，数值会**自动加1**。
- `PRIMARY KEY`关键字用于**定义列为主键**。您可以使用多列来定义主键，列间以逗号分隔。
- `ENGINE`设置**存储引擎**，`CHARSET`设置**编码**。注意在table外面设置。

## 插入数据

语法：

```mysql
INSERT INTO table_name ( field1, field2,...fieldN )	#表名
                       VALUES
                       ( value1, value2,...valueN );#一条数据
```

示例：

```mysql
INSERT INTO test_table
	(test_title, test_author, submission_date)
	VALUES
	('标题1', '作者1', NOW());#NOW()当前时间
```

```mysql
INSERT INTO Websites (name,url,country) VALUES ("Google","https://www.google.com","USA");
```

## 查询数据WHERE

语法：

```mysql
SELECT field1, field2,...fieldN FROM table_name1, table_name2...
[WHERE condition1 [AND [OR]] condition2.....
```

说明：

- 查询语句中你可以使用一个或多个表，表之间使用逗号`, `分割，并使用**WHERE**语句来设定查询条件。（注意是`WHERE`不是`WHILE`）
- 可以在`WHERE`子句中指定任何条件。
- 可以使用`AND`或者`OR`指定一个或多个条件。
- `WHERE`子句也可以运用于SQL的`DELETE`或者`UPDATE`命令。
- `WHERE`子句类似于程序语言中的if条件，根据MySQL表中的字段值来读取指定的数据。

示例：

```mysql
#显示表中的所有记录
select * from test_table;
#使用WHILE子句
SELECT * from test_table WHERE test_author='我';
SELECT name,url FROM Websites WHERE name = 'Baidu' OR id = 1;
```

**Note：**MySQL 的 WHERE 子句的字符串比较是不区分大小写的。 你可以使用`BINARY`关键字来设定WHERE子句的字符串比较是区分大小写的。

```mysql
SELECT * from test_table WHERE BINARY test_author='Liuly.com';
```

## 更新数据

语法：

```mysql
UPDATE table_name SET field1=new_value1, field2=new_value2 [WHERE Clause];
```

示例：

```mysql
UPDATE test_table SET test_title='学习 C++' WHERE test_id=3;
```

## 删除数据

语法：

```mysql
DELETE FROM table_name [WHERE Clause];
```

示例：

```mysql
DELETE FROM test_table WHERE test_id=3;
```

## LIKE子句

有时候我们需要获取`test_author`字段含有 "COM" 字符的所有记录，这时我们就需要在`WHERE`子句中使用`LIKE`子句。

SQL LIKE子句中使用百分号**%**字符来表示任意字符，类似于UNIX或正则表达式中的星号*****。

如果没有使用百分号 **%**, LIKE 子句与等号 **=** 的效果是一样的。

语法：

```mysql
SELECT field1, field2,...fieldN 
FROM table_name
WHERE field1 LIKE condition1 [AND [OR]] filed2 = 'somevalue'
```

- 你可以在 WHERE 子句中指定任何条件。
- 你可以在 WHERE 子句中使用LIKE子句。
- 你可以使用LIKE子句代替等号 **=**。
- LIKE 通常与 **%** 一同使用，类似于一个元字符的搜索。
- 你可以使用 AND 或者 OR 指定一个或多个条件。
- 你可以在 DELETE 或 UPDATE 命令中使用 WHERE...LIKE 子句来指定条件。

**Note：**不区分大小写。

示例：

```mysql
# %作用类似于*
SELECT * FROM Websites  WHERE url LIKE '%qq%';
```

## UNION操作符

MySQL UNION操作符用于连接两个以上的 SELECT 语句的结果组合到一个结果集合中。多个SELECT语句会**删除重复**的数据。

语法：

```mysql
SELECT expression1, expression2, ... expression_n
FROM tables
[WHERE conditions]
UNION [ALL | DISTINCT]
SELECT expression1, expression2, ... expression_n
FROM tables
[WHERE conditions];
```

参数：

- **expression1, expression2, ... expression_n**: 要检索的列。
- **tables:** 要检索的数据表。
- **WHERE conditions:** 可选， 检索条件。
- **DISTINCT:** 可选，删除结果集中重复的数据。默认情况下UNION操作符已经删除了重复数据，所以DISTINCT修饰符对结果没啥影响。
- **ALL:** 可选，返回所有结果集，包含重复数据。

示例：

```mysql
SELECT test_title test_author
FROM test_table
UNION
SELECT name url
FROM Websites
ORDER BY test_title;
# 注意：最好是表的expression是一样的
```

### 带条件的UNION

 从 "Websites" 和 "apps" 表中选取**所有的**中国(CN)的数据(包含重复的值)。

```mysql
SELECT country, name FROM Websites
WHERE country='CN'
UNION ALL
SELECT country, app_name FROM apps
WHERE country='CN'
ORDER BY country;
```

## 排序ORDER BY

如果我们需要对读取的数据进行排序，我们就可以使用MySQL的 `ORDER BY`子句来设定你想按哪个字段哪种方式来进行排序，再返回搜索结果。

语法：

```mysql
SELECT field1, field2,...fieldN FROM table_name1, table_name2...
ORDER BY field1 [ASC [DESC][默认 ASC]], [field2...] [ASC [DESC][默认 ASC]]
```

- 你可以使用任何字段来作为排序的条件，从而返回排序后的查询结果。
- 你可以设定**多个**字段来排序。
- 你可以使用`ASC`或`DESC`关键字来设置查询结果是按**升序**或**降序**排列。 默认情况下，它是按升序排列。
- 你可以添加`WHERE...LIKE`子句来设置条件。

示例：

```mysql
SELECT * FROM Websites ORDER BY name;
```

## 分组GROUP BY

GROUP BY 语句根据一个或多个列对结果集进行分组。

在分组的列上我们可以使用`COUNT`, `SUM`, `AVG`等函数。

语法：

```mysql
SELECT column_name, function(column_name)
FROM table_name
WHERE column_name operator value
GROUP BY column_name;
```

示例：

```mysql
#创建表
CREATE TABLE `employee_tbl` (
  `id` int(11) NOT NULL,
  `name` char(10) NOT NULL DEFAULT '',
  `date` datetime NOT NULL,
  `singin` tinyint(4) NOT NULL DEFAULT '0' COMMENT '登录次数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#插入数据
INSERT INTO `employee_tbl` VALUES
('1', '小明', '2016-04-22 15:25:33', '1'),
('2', '小王', '2016-04-20 15:25:47', '3'),
('3', '小丽', '2016-04-19 15:26:02', '2'),
('4', '小王', '2016-04-07 15:26:14', '4'),
('5', '小明', '2016-04-11 15:26:40', '4'),
('6', '小明', '2016-04-04 15:26:54', '2');
#使用 GROUP BY 语句 将数据表按名字进行分组，并统计每个人有多少条记录
SELECT name, COUNT(*) FROM employee_tbl GROUP BY name;
```

结果：

```
+--------+----------+
| name   | COUNT(*) |
+--------+----------+
| 小丽   |        1 |
| 小明   |        3 |
| 小王   |        2 |
+--------+----------+
```

### 使用 WITH ROLLUP

WITH ROLLUP 可以实现在分组统计数据基础上再进行**总的统计**（SUM,AVG,COUNT…）。

例如我们将以上的数据表按名字进行分组，统计记录数，再统计每个人登录的总次数：

```mysql
SELECT name, COUNT(*), SUM(singin) as singin_count FROM  employee_tbl GROUP BY name WITH ROLLUP;
```

结果：

```
+--------+----------+--------------+
| name   | COUNT(*) | singin_count |
+--------+----------+--------------+
| 小丽   |        1 |            2 |
| 小明   |        3 |            7 |
| 小王   |        2 |            7 |
| NULL   |        6 |           16 |
+--------+----------+--------------+
```

其中记录NULL表示所有人。

**Note：** WITH ROLLUP就一个目的：追加一个总的统计结果

我们可以使用 coalesce 来设置一个可以取代 NULL 的名称，`coalesce`语法：

```mysql
SELECT coalesce(a,b,c);
```

参数说明：如果a\==NULL,则选择b；如果b==NULL,则选择c；以此类推，如果a b c 都为NULL，则返回为NULL（没意义）。

以下实例中如果名字为空我们使用**总数**代替：

```mysql
SELECT coalesce(name, '总数'), COUNT(*), SUM(singin) as singin_count FROM  employee_tbl GROUP BY name WITH ROLLUP;
#结果：
+--------------------------+----------+--------------+
| coalesce(name, '总数')   | COUNT(*) | singin_count |
+--------------------------+----------+--------------+
| 小丽                     |        1 |            2 |
| 小明                     |        3 |            7 |
| 小王                     |        2 |            7 |
| 总数                     |        6 |           16 |
+--------------------------+----------+--------------+
```

## JOIN连接多个表

在前几章节中，我们已经学会了如何在一张表中读取数据，这是相对简单的，但是在真正的应用中经常需要从多个数据表中读取数据。

本章节我们将向大家介绍如何使用 MySQL 的 JOIN 在两个或多个表中查询数据。

你可以在 SELECT, UPDATE 和 DELETE 语句中使用 Mysql 的 JOIN 来联合多表查询。

JOIN 按照功能大致分为如下三类

- **INNER JOIN（内连接,或等值连接）**：获取两个表中字段匹配关系的记录。
- **LEFT JOIN（左连接）：**获取左表所有记录，即使右表没有对应匹配的记录。
- **RIGHT JOIN（右连接）：** 与 LEFT JOIN 相反，用于获取右表所有记录，即使左表没有对应匹配的记录。

示例：

```mysql
#创建数据库
CREATE DATABASE RUNNOOB;
USE RUNNOOB;

#创建表tcount_tbl
CREATE TABLE tcount_tbl (
  runoob_author CHAR(20) NOT NULL,
  runoob_count INT NOT NULL,
  PRIMARY KEY (runoob_author)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#向tcount_tbl插入数据
INSERT INTO tcount_tbl
	(runoob_author, runoob_count)
	VALUES
	('菜鸟教程', 10),
	('RUNOOB.COM', 20),
	('Google', 22);

#创建表runoob_tbl
CREATE TABLE runoob_tbl (
   runoob_id INT NOT NULL auto_increment,
  runoob_title CHAR(20) NOT NULL,
  runoob_author CHAR(20) NOT NULL,
  submission_date DATE,
  PRIMARY KEY (runoob_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#向runoob_tbl插入数据
INSERT INTO runoob_tbl
	(runoob_title, runoob_author, submission_date)
	VALUES
	('学习 PHP', '菜鸟教程', '2017-04-12'),
	('学习 MySQL', '菜鸟教程', '2017-04-12'),
	('学习 Java', 'RUNOOB.COM', '2015-05-01'),
	('学习 Python', 'RUNOOB.COM', '2016-03-06'),
	('学习 C', 'FK', '2017-04-05');

#查询
SELECT a.runoob_id, a.runoob_author, b.runoob_count
FROM
runoob_tbl a INNER JOIN tcount_tbl b
ON
a.runoob_author = b.runoob_author;
```

结果：

```
+-----------+---------------+--------------+
| runoob_id | runoob_author | runoob_count |
+-----------+---------------+--------------+
|         1 | 菜鸟教程      |           10 |
|         2 | 菜鸟教程      |           10 |
|         3 | RUNOOB.COM    |           20 |
|         4 | RUNOOB.COM    |           20 |
+-----------+---------------+--------------+
```

**用WHERE子句：**

```mysql
SELECT a.runoob_id, a.runoob_author, b.runoob_count FROM runoob_tbl a, tcount_tbl b WHERE a.runoob_author = b.runoob_author;
+-----------+---------------+--------------+
| runoob_id | runoob_author | runoob_count |
+-----------+---------------+--------------+
|         1 | 菜鸟教程      |           10 |
|         2 | 菜鸟教程      |           10 |
|         3 | RUNOOB.COM    |           20 |
|         4 | RUNOOB.COM    |           20 |
+-----------+---------------+--------------+
```

## NULL 值处理

使用`SELECT`命令及`WHERE`子句来读取数据表中的数据，但是当提供的查询条件字段为`NULL`时，该命令可能就无法正常工作。

为了处理这种情况，MySQL提供了三大运算符:

- **IS NULL:** 当列的值是 NULL，此运算符返回 true。
- **IS NOT NULL:** 当列的值不为 NULL, 运算符返回 true。
- **<=>:** 比较操作符(不同于 = 运算符)，当比较的的两个值相等或者都为NULL时返回 true。

示例：

```mysql
#创建表
create table runoob_test_tbl(
	runoob_author varchar(40) NOT NULL,
	runoob_count  INT
	);
#插入数据
INSERT INTO runoob_test_tbl (runoob_author, runoob_count) values ('RUNOOB', 20);
INSERT INTO runoob_test_tbl (runoob_author, runoob_count) values ('菜鸟教程', NULL);
INSERT INTO runoob_test_tbl (runoob_author, runoob_count) values ('Google', NULL);
INSERT INTO runoob_test_tbl (runoob_author, runoob_count) values ('FK', 20);
#测试
SELECT * FROM runoob_test_tbl WHERE runoob_count IS NULL;
SELECT * FROM runoob_test_tbl WHERE runoob_count IS NOT NULL;
```

## 正则表达式REGEXP

MySQL中使用 REGEXP 操作符来进行正则表达式匹配。

如果您了解PHP或Perl，那么操作起来就非常简单，因为MySQL的正则表达式匹配与这些脚本的类似。

| 模式       | 描述                                                         |
| :--------- | :----------------------------------------------------------- |
| ^          | 匹配输入字符串的开始位置。如果设置了 RegExp 对象的 Multiline 属性，^ 也匹配 '\n' 或 '\r' 之后的位置。 |
| $          | 匹配输入字符串的结束位置。如果设置了RegExp 对象的 Multiline 属性，$ 也匹配 '\n' 或 '\r' 之前的位置。 |
| .          | 匹配除 "\n" 之外的任何单个字符。要匹配包括 '\n' 在内的任何字符，请使用像 '[.\n]' 的模式。 |
| [...]      | 字符集合。匹配所包含的任意一个字符。例如， '[abc]' 可以匹配 "plain" 中的 'a'。 |
| [^...]     | 负值字符集合。匹配未包含的任意字符。例如， '[^abc]' 可以匹配 "plain" 中的'p'。 |
| p1\|p2\|p3 | 匹配 p1 或 p2 或 p3。例如，'z\|food' 能匹配 "z" 或 "food"。'(z\|f)ood' 则匹配 "zood" 或 "food"。 |
| *          | 匹配前面的子表达式零次或多次。例如，zo* 能匹配 "z" 以及 "zoo"。* 等价于{0,}。 |
| +          | 匹配前面的子表达式一次或多次。例如，'zo+' 能匹配 "zo" 以及 "zoo"，但不能匹配 "z"。+ 等价于 {1,}。 |
| {n}        | n 是一个非负整数。匹配确定的 n 次。例如，'o{2}' 不能匹配 "Bob" 中的 'o'，但是能匹配 "food" 中的两个 o。 |
| {n,m}      | m 和 n 均为非负整数，其中n <= m。最少匹配 n 次且最多匹配 m 次。 |

示例：

查找name字段中以'st'为开头的所有数据：

```mysql
SELECT name FROM person_tbl WHERE name REGEXP '^st';
```

查找name字段中以'ok'为结尾的所有数据：

```mysql
SELECT name FROM person_tbl WHERE name REGEXP 'ok$';
```

查找name字段中包含'mar'字符串的所有数据：

```mysql
SELECT name FROM person_tbl WHERE name REGEXP 'mar';
```

查找name字段中以元音字符开头或以'ok'字符串结尾的所有数据：

```mysql
SELECT name FROM person_tbl WHERE name REGEXP '^[aeiou]|ok$';
```

## 事务

MySQL 事务主要用于处理操作量大，复杂度高的数据。比如说，在人员管理系统中，你删除一个人员，你既需要删除人员的基本资料，也要删除和该人员相关的信息，如信箱，文章等等，这样，这些数据库操作语句就构成一个事务！

```mysql
# 创建表
CREATE TABLE runoob_transaction_test( id int(5)) engine=innodb;  # 创建数据表

# 处理一个事务
begin;  # 开始事务
insert into runoob_transaction_test value(5);
insert into runoob_transaction_test value(6);
commit; # 提交事务

#查看结果
select * from runoob_transaction_test;
+------+
| id   |
+------+
| 5    |
| 6    |
+------+
 
# 一个新的事务
begin;    # 开始事务
nsert into runoob_transaction_test values(7);
rollback;   # 回滚

# 查看结果
select * from runoob_transaction_test;   # 因为回滚所以数据没有插入
+------+
| id   |
+------+
| 5    |
| 6    |
+------+
```

## ALTER命令

当我们需要修改数据表名或者修改数据表字段时，就需要使用到`ALTER`命令。

示例：

```mysql
# 创建一个表
create table testalter_tbl
	(
	i INT,
	c CHAR(1)
	);
# 结果如下	
+-------+---------+------+-----+---------+-------+
| Field | Type    | Null | Key | Default | Extra |
+-------+---------+------+-----+---------+-------+
| i     | int(11) | YES  |     | NULL    |       |
| c     | char(1) | YES  |     | NULL    |       |
+-------+---------+------+-----+---------+-------+

# 删除表中的字段
ALTER TABLE testalter_tbl  DROP i;
# 结果如下
+-------+---------+------+-----+---------+-------+
| Field | Type    | Null | Key | Default | Extra |
+-------+---------+------+-----+---------+-------+
| c     | char(1) | YES  |     | NULL    |       |
+-------+---------+------+-----+---------+-------+

# 添加一列（添加到数据表字段的末尾）
ALTER TABLE testalter_tbl ADD i INT;
# 结果如下
+-------+---------+------+-----+---------+-------+
| Field | Type    | Null | Key | Default | Extra |
+-------+---------+------+-----+---------+-------+
| c     | char(1) | YES  |     | NULL    |       |
| i     | int(11) | YES  |     | NULL    |       |
+-------+---------+------+-----+---------+-------+

#如果你需要指定新增字段的位置，可以使用MySQL提供的关键字 FIRST (设定位第一列)， AFTER 字段名（设定位于某个字段之后）
ALTER TABLE testalter_tbl DROP i;
ALTER TABLE testalter_tbl ADD i INT FIRST;
ALTER TABLE testalter_tbl DROP i;
ALTER TABLE testalter_tbl ADD i INT AFTER c;
```

### 修改字段类型及名称

如果需要修改字段类型及名称, 你可以在ALTER命令中使用 MODIFY 或 CHANGE 子句 。

```mysql
# 把字段 c 的类型从 CHAR(1) 改为 CHAR(10)
ALTER TABLE testalter_tbl MODIFY c CHAR(10);

# 使用 CHANGE 子句, 语法有很大的不同。 在 CHANGE 关键字之后，紧跟着的是你要修改的字段名，然后指定新字段名及类型
ALTER TABLE testalter_tbl CHANGE i j BIGINT;
ALTER TABLE testalter_tbl CHANGE j j INT;

# 当你修改字段时，你可以指定是否包含值或者是否设置默认值
ALTER TABLE testalter_tbl MODIFY j BIGINT NOT NULL DEFAULT 100;
```

## 索引

索引的建立对于MySQL的高效运行是很重要的，索引可以大大提高MySQL的检索速度。

索引也是一张表，该表保存了主键与索引字段，并指向实体表的记录。

索引也有它的缺点：虽然索引大大提高了查询速度，同时却会降低更新表的速度，如对表进行INSERT、UPDATE和DELETE。因为更新表时，MySQL不仅要保存数据，还要保存一下索引文件。建立索引会占用磁盘空间的索引文件。

### 普通索引

这是最基本的索引，它没有任何限制。它有以下几种创建方式：

**1、创建索引**

```mysql
CREATE INDEX indexName ON table_name (column_name);
```

如果是`CHAR`，`VARCHAR`类型，length可以小于字段实际长度；如果是BLOB和TEXT类型，必须指定 length。

**2、修改表结构（添加索引）**

```mysql
ALTER table tableName ADD INDEX indexName(columnName);
```

**3、创建表的时候直接指定**

```mysql
CREATE TABLE mytable(  
	ID INT NOT NULL,   
	username VARCHAR(16) NOT NULL,  
	INDEX [indexName] (username(length))
	); 
```

### 唯一索引

它与前面的普通索引类似，不同的就是：索引列的值必须唯一，但允许有空值。如果是组合索引，则列值的组合必须唯一。它也有以下几种创建方式：

**1、创建索引**

```mysql
CREATE UNIQUE INDEX indexName ON mytable(username(length));
```

**2、修改表结构**

```mysql
ALTER table mytable ADD UNIQUE [indexName] (username(length));
```

**3、创建表的时候直接指定**

```mysql
CREATE TABLE mytable(
	ID INT NOT NULL,
	username VARCHAR(16) NOT NULL,
	UNIQUE [indexName] (username(length))
	);
```

### 其他命令

**四种方式添加数据表的索引**

- `ALTER TABLE tbl_name ADD PRIMARY KEY (column_list);`该语句添加一个主键，这意味着索引值必须是唯一的，且不能为NULL。
- `ALTER TABLE tbl_name ADD UNIQUE index_name (column_list);`这条语句创建索引的值必须是唯一的（除了NULL外，NULL可能会出现多次）。
- `ALTER TABLE tbl_name ADD INDEX index_name (column_list);`添加普通索引，索引值可出现多次。
- `ALTER TABLE tbl_name ADD FULLTEXT index_name (column_list);`该语句指定了索引为 FULLTEXT ，用于全文索引。

**使用 ALTER 命令添加和删除主键**

主键作用于列上（可以一个列或多个列联合主键），添加主键索引时，你需要确保该主键默认不为空（NOT NULL）。实例如下：

```mysql
ALTER TABLE testalter_tbl MODIFY i INT NOT NULL;
ALTER TABLE testalter_tbl ADD PRIMARY KEY (i);
```

使用 ALTER 命令删除主键：

```mysql
ALTER TABLE testalter_tbl DROP PRIMARY KEY;
```

**显示索引信息**

```mysql
SHOW INDEX FROM table_name; \G
# \G 格式化输出信息
```

## 临时表

临时表在我们需要保存一些临时数据时是非常有用的。临时表只在当前连接可见，当关闭连接时，Mysql会自动删除表并释放所有空间。

临时表只在当前连接可见，如果你使用PHP脚本来创建MySQL临时表，那每当PHP脚本执行完成后，该临时表也会自动销毁。

如果你使用了其他MySQL客户端程序连接MySQL数据库服务器来创建临时表，那么只有在关闭客户端程序时才会销毁临时表，当然你也可以手动销毁。

**示例：**

```mysql
# 创建临时表
CREATE TEMPORARY TABLE SalesSummary (
	product_name VARCHAR(50) NOT NULL,
	total_sales DECIMAL(12,2) NOT NULL DEFAULT 0.00,
	avg_unit_price DECIMAL(7,2) NOT NULL DEFAULT 0.00,
	total_units_sold INT UNSIGNED NOT NULL DEFAULT 0
	);
# 插入数据
INSERT INTO SalesSummary
	(product_name, total_sales, avg_unit_price, total_units_sold)
	VALUES
	('cucumber', 100.25, 90, 2);
# 说明：
# 使用show tables;不会显示临时表
# 使用SELECT * FROM SalesSummary;可以正常显示

#删除临时表
DROP TABLE SalesSummary;
```

## 复制表

如果我们需要完全的复制MySQL的数据表，包括表的结构，索引，默认值等。

本章节将为大家介绍如何完整的复制MySQL数据表，步骤如下：

```mysql
# 1、获取数据表的完整结构
SHOW CREATE TABLE runoob_tbl \G;
# 将得到如下的内容：
*************************** 1. row ***************************
       Table: runoob_tbl
Create Table: CREATE TABLE `runoob_tbl` (
  `runoob_id` int(11) NOT NULL AUTO_INCREMENT,
  `runoob_title` char(20) NOT NULL,
  `runoob_author` char(20) NOT NULL,
  `submission_date` date DEFAULT NULL,
  PRIMARY KEY (`runoob_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8

# 2、复制这些创建表的语句，然后修改克隆表的名称，就可以创建克隆表了
CREATE TABLE `clone_tbl` (
  `runoob_id` int(11) NOT NULL AUTO_INCREMENT,
  `runoob_title` char(20) NOT NULL,
  `runoob_author` char(20) NOT NULL,
  `submission_date` date DEFAULT NULL,
  PRIMARY KEY (`runoob_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

# 3、创建完克隆表后，把想要的数据拷贝到克隆表中
INSERT INTO clone_tbl
	(runoob_id, runoob_title, runoob_author, submission_date)
	SELECT runoob_id, runoob_title, runoob_author, submission_date
	FROM runoob_tbl;
```

## 元数据

获取服务器元数据：

| 命令                  | 描述                      |
| :-------------------- | :------------------------ |
| `SELECT VERSION( );`  | 服务器版本信息            |
| `SELECT DATABASE( );` | 当前数据库名 (或者返回空) |
| `SELECT USER( );`     | 当前用户名                |
| `SHOW STATUS;`        | 服务器状态                |
| `SHOW VARIABLES;`     | 服务器配置变量            |

## 自增序列

MySQL 序列是一组整数：1, 2, 3, ...，由于一张数据表只能有一个字段**自增主键**， 如果你想实现其他字段也实现自动增加，就可以使用MySQL序列来实现。

**auto_increment自增**

```mysql
# 创建表
CREATE TABLE insect
	(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,	  # 主键自增
	PRIMARY KEY (id),							# 设置主键（设置语句不一定放在最后）
	name VARCHAR(30) NOT NULL,
	date DATE NOT NULL,
	origin VARCHAR(30) NOT NULL
	);

# 插入数据
INSERT INTO insect (id,name,date,origin) VALUES
	(NULL,'housefly','2001-09-10','kitchen'),		# 可以不设定自增主键，或设置为NULL
	(NULL,'millipede','2001-09-10','driveway'),
	(NULL,'grasshopper','2001-09-10','front yard');

# 查看
SELECT * FROM insect ORDER BY id;

+----+-------------+------------+------------+
| id | name        | date       | origin     |
+----+-------------+------------+------------+
|  1 | housefly    | 2001-09-10 | kitchen    |
|  2 | millipede   | 2001-09-10 | driveway   |
|  3 | grasshopper | 2001-09-10 | front yard |
+----+-------------+------------+------------+
```

### 重置序列

如果你删除了数据表中的多条记录，并希望对剩下数据的AUTO_INCREMENT列进行重新排列，那么你可以通过**删除自增的列，然后重新添加**来实现。不过该操作要非常小心，如果在删除的同时又有新记录添加，有可能会出现数据混乱。操作如下所示：

```mysql
# 删除自增列
ALTER TABLE insect DROP id;
# 重新添加自增列，并设置为主键
ALTER TABLE insect
	ADD id INT UNSIGNED NOT NULL AUTO_INCREMENT FIRST,
	ADD PRIMARY KEY (id);
```

### 设置序列的开始值

一般情况下序列的开始值为1，但如果你需要指定一个**开始值100**，那我们可以通过以下语句来实现：

```mysql
# 创建表时指定自增起始值
CREATE TABLE insect
	(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	PRIMARY KEY (id),
	name VARCHAR(30) NOT NULL, 
	date DATE NOT NULL,
	origin VARCHAR(30) NOT NULL
	)engine=innodb auto_increment=100 charset=utf8;
	
# 创建表后修改自增起始值
ALTER TABLE t AUTO_INCREMENT = 100;
```

## 重复数据

有些 MySQL 数据表中可能存在重复的记录，有些情况我们允许重复数据的存在，但有时候我们也需要删除这些重复的数据。

本章节我们将为大家介绍如何防止数据表出现重复数据及如何删除数据表中的重复数据。

**防止表中出现重复数据**

你可以在 MySQL 数据表中设置指定的字段为`PRIMARY KEY`(**主键**)或者`UNIQUE`(**唯一**)索引来保证数据的唯一性。

如果你想设置表中字段**first_name，last_name数据不能重复**，你可以设置**双主键模式**来设置数据的唯一性，如果你设置了双主键，那么那个键的默认值不能为 NULL，可设置为 NOT NULL。如下所示：

```mysql
CREATE TABLE person_tbl
(
   first_name CHAR(20) NOT NULL,
   last_name CHAR(20) NOT NULL,
   sex CHAR(10),
   PRIMARY KEY (last_name, first_name)
);
```

如果我们设置了唯一索引，那么在插入重复数据时，SQL语句将无法执行成功，并抛出错。

如果不想被执行出错的情况打断，可以使用`INSERT IGNORE INTO`，会忽略数据库中已经存在的数据，如果数据库没有数据，就插入新的数据，如果有数据的话就跳过这条数据。

INSERT IGNORE INTO当插入数据时，在设置了记录的唯一性后，如果插入重复数据，将不返回错误，只以警告形式返回。 而`REPLACE INTO`如果存在primary或unique相同的记录，则先删除掉。再插入新记录。

**统计重复数据**

以下我们将统计表中first_name和last_name的重复记录数：（first_name和last_name一样）

```mysql
SELECT COUNT(*) as repetitions, last_name, first_name
	FROM person_tbl
	GROUP BY last_name, first_name
	HAVING repetitions > 1;
```

以上查询语句将返回person_tbl表中重复的记录数。一般情况下，查询重复的值，请执行以下操作：

- 确定哪一列包含的值可能会重复。
- 在列选择列表使用`COUNT(*)`列出的那些列。
- 在`GROUP BY`子句中列出的列。
- `HAVING`子句设置重复数大于1。

**过滤重复数据**

如果你需要读取不重复的数据可以在 SELECT 语句中使用 DISTINCT 关键字来过滤重复数据。

```mysql
SELECT DISTINCT last_name, first_name FROM person_tbl;
```

你也可以使用GROUP BY来读取数据表中不重复的数据：

```mysql
SELECT last_name, first_name
	FROM person_tbl
	GROUP BY (last_name, first_name);
```

**删除重复数据**

如果你想删除数据表中的重复数据，你可以使用以下的SQL语句：

```mysql
# 创建并复制一份原数据表（会剔除重复数据）
CREATE TABLE tmp SELECT last_name, first_name, sex FROM person_tbl  GROUP BY (last_name, first_name, sex);
# 删除原数据表
DROP TABLE person_tbl;
# 重命名数据表成为原数据表
ALTER TABLE tmp RENAME TO person_tbl;
```

当然你也可以在数据表中添加 INDEX（索引） 和 PRIMAY KEY（主键）这种简单的方法来删除表中的重复记录。方法如下：

```mysql
ALTER IGNORE TABLE person_tbl ADD PRIMARY KEY (last_name, first_name);
```

## SQL注入

如果您通过网页获取用户输入的数据并将其插入一个MySQL数据库，那么就有可能发生SQL注入安全的问题。

本章节将为大家介绍如何防止SQL注入，并通过脚本来过滤SQL中注入的字符。

所谓SQL注入，就是通过把SQL命令插入到Web表单递交或输入域名或页面请求的查询字符串，最终达到欺骗服务器执行恶意的SQL命令。

我们永远不要信任用户的输入，我们必须认定用户输入的数据都是不安全的，我们都需要对用户输入的数据进行过滤处理。

## 导出数据

可以使用`SELECT...INTO OUTFILE`语句来简单的导出数据到文本文件上。

示例：

```mysql
# 将数据表 runoob_tbl 数据导出到 /tmp/runoob.txt 文件中
SELECT * FROM runoob_tbl INTO OUTFILE '/tmp/runoob.txt';

# 导出CSV格式
SELECT * FROM passwd INTO OUTFILE '/tmp/runoob.csv'
	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n';
	
# 生成一个文件，各值用逗号隔开。这种格式可以被许多程序使用
SELECT a,b,a+b INTO OUTFILE '/tmp/result.text'
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	FROM test_table;
```

`SELECT ... INTO OUTFILE`语句有以下属性：

- LOAD DATA INFILE是SELECT ... INTO OUTFILE的**逆操作**。为了将一个数据库的数据写入一个文件，使用SELECT ... INTO OUTFILE，为了将文件读回数据库，使用LOAD DATA INFILE。
- SELECT...INTO OUTFILE 'file_name'形式的SELECT可以把被选择的行写入一个文件中。**该文件被创建到服务器主机上**，因此您必须拥有FILE权限，才能使用此语法。
- **输出不能是一个已存在的文件**。防止文件数据被篡改。
- 你需要有一个登陆服务器的账号来检索文件。否则 SELECT ... INTO OUTFILE 不会起任何作用。
- 在UNIX中，该文件被创建后是可读的，权限由MySQL服务器所拥有。这意味着，虽然你就可以读取该文件，但可能无法将其删除。

### 导出表作为原始数据

`mysqldump`是 mysql 用于转存储数据库的实用程序。它主要产生一个 SQL 脚本，其中包含从头重新创建数据库所必需的命令 CREATE TABLE INSERT 等。

使用`mysqldump`导出数据需要使用`--tab`选项来指定导出文件指定的目录，该目标必须是可写的。

以下实例将数据表 runoob_tbl 导出到 /tmp 目录中：

```mysql
mysqldump -u root -p --no-create-info --tab=/tmp RUNOOB runoob_tbl
```

### 导出 SQL 格式的数据

导出 SQL 格式的数据到指定文件，如下所示：

```mysql
mysqldump -u root -p RUNOOB runoob_tbl > dump.txt
```

### 将数据表及数据库拷贝至其他主机

```mysql
# 备份数据
mysqldump -u root -p database_name table_name > dump.txt
# 导入数据
mysql -u root -p database_name < dump.txt
```

(通过管道)直接导入远程主机

```mysql
mysqldump -u root -p database_name | mysql -h other_host.com database_name
```

## 导入数据

**mysql 命令导入**

语法：

```mysql
mysql -u用户名    -p密码    <  要导入的数据库数据
```

示例：

```mysql
mysql -uroot -p123456 < runoob.sql
```

**source 命令导入**

```mysql
create database abc;      # 创建数据库
use abc;                  # 使用数据库 
set names utf8;           # 设置编码
source /home/abc/abc.sql  # 导入备份的数据库
```

**使用 LOAD DATA 导入数据**

MySQL 中提供了LOAD DATA INFILE语句来**插入**数据。以下实例中将从当前目录中读取文件 dump.txt ，将该文件中的数据插入到当前数据库的 mytbl 表中。

```mysql
LOAD DATA LOCAL INFILE 'dump.txt' INTO TABLE mytbl;
```

如果指定LOCAL关键词，则表明从客户主机上按路径读取文件。如果没有指定，则文件在服务器上按路径读取文件。

你能明确地在LOAD DATA语句中指出列值的分隔符和行尾标记，但是默认标记是定位符和换行符。

两个命令的 FIELDS 和 LINES 子句的语法是一样的。两个子句都是可选的，但是如果两个同时被指定，FIELDS 子句必须出现在 LINES 子句之前。

如果用户指定一个 FIELDS 子句，它的子句 （TERMINATED BY、[OPTIONALLY] ENCLOSED BY 和 ESCAPED BY) 也是可选的，不过，用户必须至少指定它们中的一个。

```mysql
LOAD DATA LOCAL INFILE 'dump.txt' INTO TABLE mytbl
FIELDS TERMINATED BY ':'
LINES TERMINATED BY '\r\n';
```

LOAD DATA 默认情况下是按照数据文件中列的顺序插入数据的，如果数据文件中的列与插入表中的列不一致，则需要指定列的顺序。

如，在数据文件中的列顺序是 a,b,c，但在插入表的列顺序为b,c,a，则数据导入语法如下：

```mysql
LOAD DATA LOCAL INFILE 'dump.txt' 
INTO TABLE mytbl (b, c, a);
```

**使用 mysqlimport 导入数据**

mysqlimport 客户端提供了 LOAD DATA INFILEQL 语句的一个命令行接口。mysqlimport 的大多数选项直接对应 LOAD DATA INFILE 子句。

从文件 dump.txt 中将数据导入到 mytbl 数据表中, 可以使用以下命令：

```mysql
mysqlimport -u root -p --local mytbl dump.txt

# 可以指定选项来设置指定格式,命令语句格式如下：
mysqlimport -u root -p --local --fields-terminated-by=":" --lines-terminated-by="\r\n"  mytbl dump.txt

# 使用 --columns 选项来设置列的顺序：
mysqlimport -u root -p --local --columns=b,c,a mytbl dump.txt
```

## MYSQL函数

[参考](https://www.runoob.com/mysql/mysql-functions.html)

## MYSQL函数

[参考](https://www.runoob.com/mysql/mysql-operator.html)

# 其他

## limit限定返回结果的数量

```mysql
select * from tableName limit i,n
# 功能：返回查询结果中索引从i到i+1的结果
# tableName：表名
# i：为查询结果的起始索引值(默认从0开始)，当i=0时可省略i
# n：为查询结果返回的数量
# i与n之间使用英文逗号","隔开

# 返回前n个结果
limit n 等同于 limit 0,n

# 返回第2大的结果
select distinct salary from Employee order by salary desc limit 1,1
# distinct（区别重复值）
# order by salary desc（按salary的降序排列，asc升序）
```

## IF和IFNULL

**IF**

语法：

```mysql
if(condition,a,b);
```

condition==true，if()函数的输出值就是a，否则是b，有点像三元表达式

示例：

把salary表中的女改成男，男改成女:

```mysql
update salary set sex = if( sex = '男','女','男');
```

**IFNULL**

```mysql
SELECT IFNULL(NULL,"11"); -> 11
SELECT IFNULL("00","11"); -> 00
```

## 排名函数（ROW_NUMBER、RANK、DENSE_RANK、NTILE）

**ROW_NUMBER()**

ROW_NUMBER()函数作用就是将select查询到的数据进行排序，**每一条数据加一个唯一的序号**，他不能用做于学生成绩的排名，一般多用于分页查询。

```mysql
# 按照id升序排列，分数并列的名次也不一样
select row_number() over (order by id desc) row_number_column, name from Websites;
```

**RANK()**

RANK()函数，顾名思义排名函数，可以对某一个字段进行排名。

当存在相同成绩的学生时，ROW_NUMBER()会依次进行排序，他们序号不相同，而Rank()则不一样出现相同的，他们的排名是一样的。但是下一名同学的排名序号不是紧接着这个同学。

```mysql
# 按课程分组，并在每个课程中按降序排列，排序结果不连续
select name,course,rank() over(partition by course order by score desc) rank_column from student;
```

**DENSE_RANK()**

DENSE_RANK()函数也是排名函数，和RANK()功能相似，也是对字段进行排名。DENSE_RANK()排名是连续的。

```mysql
# 按课程分组，并在每个课程中按降序排列，排序结果连续
select name,course,dense_rank() over(partition by course order by score desc) rank from student;
```

## having

having子句可以让我们筛选**成组后的**各种数据，**where字句在聚合前先筛选记录**，也就是说作用在group by和having子句前。而 having子句在聚合后对组记录进行筛选。

