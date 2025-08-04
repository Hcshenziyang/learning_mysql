/*
创建数据库和核心表：

首先，创建一个名为 industrial_project_management 的数据库。

然后，在这个数据库中创建三张表：

projects 表：

project_id：项目的唯一标识，自增长的主键。

project_name：项目名称，不能为空，最大长度100。

description：项目描述，可以为空，文本类型。

start_date：项目开始日期，不能为空。

end_date：项目结束日期，可以为空。

status：项目状态，不能为空，默认为 'Planning'，只能是 'Planning', 'Developing', 'Testing', 'Completed' 中的一个。

users 表：

user_id：用户的唯一标识，自增长的主键。

username：用户名，不能为空，最大长度50，且唯一。

email：用户邮箱，不能为空，最大长度100，且唯一。

role：用户角色，不能为空，默认为 'Developer'，只能是 'Developer', 'Tester', 'Product Manager' 中的一个。

tasks 表：

task_id：任务的唯一标识，自增长的主键。

project_id：任务所属的项目ID，不能为空。

task_name：任务名称，不能为空，最大长度100。

description：任务描述，可以为空，文本类型。

assigned_to_user_id：任务指派给的用户ID，可以为空。

due_date：任务截止日期，可以为空。

status：任务状态，不能为空，默认为 'Open'，只能是 'Open', 'In Progress', 'Done', 'Blocked' 中的一个。

注意：project_id 和 assigned_to_user_id 都需要设置外键约束，分别关联到 projects 表的 project_id 和 users 表的 user_id。并且，当父表中的记录被删除时，子表中的关联记录也应该被删除（级联删除）。

表结构修改：

现在，我们发现 projects 表中少了一个记录项目负责人ID的字段。请在 projects 表中添加一个名为 responsible_user_id 的字段，它应该是一个整型，可以为空，并且需要关联到 users 表的 user_id。如果用户被删除了，项目负责人ID应该被设置为NULL（SET NULL）。

由于业务调整，users 表中的 email 字段现在允许为空了。请修改 email 字段的约束。

我们决定将 tasks 表中的 status 字段的默认值改为 'New'。请进行修改。

将 tasks 表的 description 字段名修改为 task_details。

删除操作：

由于某个功能模块被废弃，你需要删除 tasks 表中的 due_date 字段。

最后，这个项目管理系统不再需要了，请删除 industrial_project_management 数据库。
*/

create database industrial_project_management;
use industrial_project_management;
create table projects(
	project_id int auto_increment primary key,
	project_name varchar(100) not null,
	description TEXT null,
	start_date date not null,
	end_date date null,
	status enum('Planning','Developing','Testing','Completed') not null default 'Planning'
	
);

create table users(
	user_id int auto_increment primary key,
	username varchar(100) not null unique,
	email varchar(50) not null unique,
	role enum('Developer','Tester','Product Manager') not null default 'Developer'
);

create table tasks(
	task_id int auto_increment primary key,
	project_id int not null,
	task_name varchar(100) not null,
	description text null,
	assigned_to_user_id int(20) null,
	due_date date null comment '任务截止日期',
	status enum('Open','In Progress','Done','Blocked') not null default 'Open',
	FOREIGN KEY(project_id) REFERENCES projects(project_id) on delete cascade,
	FOREIGN KEY(assigned_to_user_id) REFERENCES users(user_id) on delete cascade
	
);

alter table projects add responsible_user_id int(10) null,
	add foreign key(responsible_user_id) references users(user_id) on delete set null;

alter table users modify email varchar(50) null;


alter table tasks modify status enum('Open','In Progress','Done','Blocked','New') not null default 'New';
alter table tasks change description task_details  text null;

alter table tasks drop due_date;
-- drop database industrial_project_management;