use INDUSTRIAL_PROJECT_MANAGEMENT;
alter table tasks add due_date date null;
alter table tasks add completion_date date null;

insert users (username,email,role) values ('sunba','sunba@example.com','Developer');
insert projects 
	(project_name,description,start_date,status) 
	values 
	('Data Analysis Platform','Build a platform for internal data analysis and reporting.',
	'2023-03-01','Planning');

insert tasks (project_id,task_name,assigned_to_user_id,status,due_date,completion_date)
	values
	('1','Refactor API Endpoints','3','In Progress',null,null),
	('1','Write Unit Tests for Core Modules','5','New','2023-10-01',null),
	('1','Deploy to Staging Server',null,'Blocked',null,null),
	('2','Define Data Schema','1','Done','2023-04-10','2023-04-08'),
	('2','Develop Data Ingestion Pipeline','6','In Progress','2023-09-30',null),
	('2','Create Dashboard Mockups','1','In Progress','2023-08-25',null),
	('2','User Authentication Module','6','New','2023-11-01',null),
	('2','Initial Market Research',null,'Open',null,null);

-- 1.基本信息检索
select username,email from users where role='Developer';
select task_name,project_id from tasks where status='Blocked';

-- 2. 条件与排序组合
select task_name,project_id,due_date 
	FROM tasks 
	where status!='Done' and due_date is not null
	ORDER BY due_date asc 
	limit 5;
select task_name,due_date 
	from tasks 
	where due_date>='2023-08-01';

-- 3.聚合和分组-基本统计
select count(*) as total_projects from projects;
select MAX(due_date) from tasks;

-- 4.聚合和分组-分组分析
select assigned_to_user_id,count(task_name) from tasks 
	where status!='Done'
	group by assigned_to_user_id;

select assigned_to_user_id,count(task_name) from tasks 
	where status!='Done'
	group by assigned_to_user_id
	having count(task_name)>=2;

select project_id,status,count(task_name)
	from tasks
	-- where status='Open' or status='In Progress' or status='Blocked'
	where status in ('Open','In Progress','Blocked')
	group by project_id,status;


