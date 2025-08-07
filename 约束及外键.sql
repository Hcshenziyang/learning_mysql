drop database if exists industrial_project_management;
create database if not exists industrial_project_management;

use industrial_project_management;
create table projects(
project_id int primary key auto_increment,
project_name varchar(50) not null unique comment '项目名称',
description text null,
start_date date not null,
end_date date null,
constraint chk_dates check (end_date is null or end_date>=start_date),
status enum('Planning','Developing','Testing','Completed') 
not null default 'Planning'
)

create table users(
user_id int primary key auto_increment,
username varchar(50) not null unique,
email varchar(50) null unique,
role enum('Developer','Tester','Product Manager','Product/Data Analyst')
not null default 'Developer'
)

create table tasks(
task_id int primary key auto_increment,
project_id int not null,
FOREIGN KEY(project_id) REFERENCES projects(project_id) on delete cascade,
task_name varchar(50) not null,
task_details text null,
assigned_to_user_id int null,
FOREIGN KEY(assigned_to_user_id) REFERENCES users(user_id) on delete set null,
due_date date null,
completion_date date null,
constraint chk_taskdates check (completion_date is null or completion_date>=due_date),
status enum('Open', 'In Progress', 'Done', 'Blocked', 'New') 
not null default 'Open'
)

insert users (username,email,role) values
('hongcha','123@qq.com','Product/Data Analyst'),
('lisi','456@qq.com','Developer'),
('zhaoliu','789@qq.com','Tester');

insert projects (project_name,description,start_date,end_date,status) values
('Smart Factory OS Development',null,'2025-08-06','2025-08-10','Planning'),
('Data Analysis Platform','','2025-08-07',null,'Planning');

insert tasks (project_id,task_name,task_details,assigned_to_user_id,due_date,
completion_date,status) values
(3,'work1',null,1,'2025-04-10','2025-06-10','Done'),
(4,'work1',null,2,'2025-09-10',null,'Open'),
(3,'work2',null,3,'2025-10-10',null,'Blocked'),
(4,'work2',null,null,'2025-10-10',null,'Blocked'),
(3,'work3',null,null,'2025-11-06',null,'New');

alter table users modify email varchar(50) null;

ALTER TABLE tasks 
ADD CONSTRAINT uniq_project_task UNIQUE (project_id,task_name);

ALTER TABLE projects DROP CONSTRAINT chk_dates;
ALTER TABLE tasks DROP CONSTRAINT uniq_project_task;

/*
思考题（不要求写代码，但要求给出你的思路）：
你觉得在数据库设计时，主键约束、非空约束、唯一约束这三者之间有什么关联和区别？在选择使用哪个时，你的决策依据是什么？
回答：主键约束包含非空和唯一约束。每个表就一个主键约束，唯一约束适用于字段有非重复值的要求，非空约束适用于重要非空字段。

CHECK 约束和 ENUM 类型都能限制字段的取值范围。在什么情况下你会优先选择 CHECK 约束，什么情况下会优先选择 ENUM 类型？它们各自的优缺点是什么？
回答：ENUM是个数据类型，如果字段固定某些数据类型且利用索引，那么就采用ENUM。如果是业务临时性的或更加特殊涉及多表的取值范围，则采用CHECK。ENUM可以设置默认值，创建表时候更方便。CHECK更灵活。

在实际项目开发中，你是更倾向于在数据库层面（如 CHECK 约束、外键）强制数据一致性和完整性，还是更多地依赖应用程序的代码逻辑来保证？为什么？
回答：数据库层面和代码层面应该都需要有相应的。数据库显然更底层，更重要，设计到数据一致性和完整性的。而应用程序层面可以很好的规避一些错误问题并给予适当的提示，进一步辅助数据库。
*/