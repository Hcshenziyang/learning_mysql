/*
题目

任务零：数据准备 (DML)
为了确保我们的查询能够覆盖到所有类型的场景（包括没有匹配的情况），请在你的数据库中执行以下操作：
添加一名没有被分配任何任务的用户：
username: 'unassigned_guy', email: NULL, role: 'Developer'
添加一个没有任何任务的项目：
project_name: 'Future Innovations', description: 'Exploring new technologies', start_date: '2025-12-01', end_date: NULL, status: 'Planning'，负责人可以暂设为 NULL。
在现有任务中，确保至少有一个 due_date 已过期的任务（即 due_date < CURDATE() ），且其 status 不是 'Done'。在 users 表中新增一名用户，角色为 'Product Manager'，且这个人没有负责任何项目。

任务一：联合查询 (UNION)
联合查询可以让你将多个 SELECT 语句的结果合并成一个结果集。
所有项目管理者和测试人员的列表：
查询所有 role 为 'Product Manager' 的用户的 username。
查询所有 role 为 'Tester' 的用户的 username。
使用 UNION ALL 将上述两个查询结果合并，并显示为一个名为 Relevant_Personnel 的列表。
思考：如果使用 UNION 而不是 UNION ALL，会有什么区别？（不要求写代码，但请思考）
所有进行中和阻塞的任务列表：
查询所有 status 为 'In Progress' 的任务的 task_name。
查询所有 status 为 'Blocked' 的任务的 task_name。
使用 UNION 将上述两个查询结果合并，并显示为一个名为 Urgent_Tasks 的列表，确保没有重复的任务名称（如果存在）。

任务二：子查询应用 (Subqueries)
子查询是 SQL 强大的特性之一，它可以让你在查询中使用另一个查询的结果。
A. 标量子查询 (Scalar Subquery)
返回单个值（一行一列）。
查找比平均任务预估工期更长的任务：
查询所有任务的 task_name 和 due_date，这些任务的 due_date 比所有任务的平均 due_date 更晚。
提示：你需要计算所有任务的平均 due_date 作为标量子查询。
注意：对于 NULL 的 due_date，需要考虑如何处理（例如，在计算平均值时排除 NULL 值）。
找出负责最多任务的项目负责人：
查询负责任务数量最多的用户的 username。
提示：这需要一个子查询来找出 MAX 任务数量，再用另一个子查询或 JOIN 来找到对应的 user_id。

B. 列子查询 (Column Subquery)
返回一列（多行一列）。
查找所有未分配给产品经理的任务：
查询所有任务的 task_name 和 status，这些任务没有分配给 role 为 'Product Manager' 的用户。
提示：使用 NOT IN 或 NOT EXISTS。
找出所有已完成且在截止日期后完成的任务：
查询所有已完成任务 (status = 'Done') 的 task_name 和 completion_date，这些任务的 completion_date 比其 due_date 晚。
提示：你可以使用一个子查询来筛选出所有 task_id，其中 completion_date > due_date。

C. 行子查询 (Row Subquery)
返回一行（多行多列）。
查找特定项目和状态的任务：
假设你想找到与 "Smart Factory OS Development" 项目中的 "Blocked" 任务具有相同 project_id 和 status 的所有任务。
查询所有 task_name，其 (project_id, status) 组合与 task_name 为 "work2" 且 status 为 "Blocked" 的任务（你之前插入的）的 (project_id, status) 组合完全相同。
提示：使用 (col1, col2) = (SELECT col1, col2 FROM …) 语法。

D. 表子查询 (Table Subquery)
返回多行多列，常用于 FROM 子句或 EXISTS。
查询每个项目中最晚截止日期的任务：
对于每个项目，查询其拥有最晚 due_date 的任务的 project_name, task_name 和 due_date。
提示：你需要一个子查询来找出每个 project_id 对应的 MAX(due_date)。然后将外部查询与这个子查询的结果连接起来。
思考：除了子查询，还有其他方式可以实现这个需求吗？（不要求写代码，但思考这个点，例如窗口函数，虽然你可能还没学到）
找出有任何任务已过期的项目：
查询所有包含至少一个 due_date 已过期（due_date < CURDATE()）且 status 不是 'Done' 的任务的项目名称 (project_name)。
提示：使用 EXISTS 或 IN。

任务三：复杂组合查询 (Joins & Subqueries & Functions)
将之前学过的知识点融会贯通，解决更贴近实际的复杂业务问题。
活跃项目与团队报告：
生成一份报告，显示所有未完成（status != 'Completed'）的项目。对于每个项目，显示：
项目名称 (project_name)
项目负责人 (responsible_user_id 对应的 username，如果无则显示 'Unassigned')
当前项目下不同角色的用户数量（例如，多少个 Developer，多少个 Tester 等）。
提示：需要 LEFT JOIN users 表获取负责人，LEFT JOIN tasks 表，然后使用 GROUP BY projects.project_id 结合 COUNT(DISTINCT users.role) 或 SUM(CASE WHEN … THEN 1 ELSE 0 END) 来统计不同角色的用户数量。

绩效评估辅助查询：
查询所有 Developer 角色用户，显示他们的 username，以及他们完成任务的平均耗时（从任务的 start_date 到 completion_date 的天数，如果任务未完成，则不计入）。
同时，显示他们总共负责的任务数量。
提示：需要 LEFT JOIN tasks 表，WHERE users.role = 'Developer'，GROUP BY username。计算平均耗时需要 DATEDIFF。

思考题（不要求写代码，但要求给出你的思路）：
在什么情况下，你认为使用子查询比使用连接 (JOIN) 更有优势？反之亦然？举例说明。
EXISTS 和 IN 在某些情况下可以互换使用。它们之间有什么性能或逻辑上的主要区别？在选择使用哪个时，你会考虑什么？*/

-- 任务零
use industrial_project_management;
select * from users;
insert users 
(username,email,role) 
values ('unassigned_guy',null,'Developer');
insert users 
(username,email,role) 
values ('test1',null,'Product Manager');

select * from projects;
alter table projects add responsible_user_id int null,
	add foreign key(responsible_user_id) references users(user_id) on delete set null;
update projects set responsible_user_id=1 where project_id in (3,4);
insert projects 
(project_name,description,start_date,end_date,status) 
values ('Future Innovations','Exploring new technologies','2025-12-01',null,'Planning');

select * from tasks;
update tasks set due_date='2021-10-11' where task_id in (10);

-- 任务一
select username as Relevant_Personnel from users where role='Product Manager'
union all
select username from users where role='Tester';
-- 思考：如果使用 UNION 而不是 UNION ALL，会有什么区别？（不要求写代码，但请思考） 
-- 回答：无区别，同一个字段两次筛选，不如用IN。如果不同字段，可能重复。
select task_name as Urgent_Tasks from tasks where status='In Progress'
union
select task_name from tasks where status='Blocked';

-- 任务二
-- A. 标量子查询 (Scalar Subquery)
select task_name, due_date from tasks 
where TO_DAYS(due_date)>
(select avg(TO_DAYS(due_date)) from tasks where due_date is not null);

select username
from users u
join (
    select assigned_to_user_id, COUNT(*) AS task_count
    from tasks
    where assigned_to_user_id is not null
    group by assigned_to_user_id
) t on u.user_id = t.assigned_to_user_id
where t.task_count = (
    select max(task_count)
    from (
        select count(*) as task_count
	    from tasks
	    where assigned_to_user_id is not null
	    group by assigned_to_user_id
    ) max_tasks
);

-- B. 列子查询 (Column Subquery)
select task_name,status
from tasks t
left join users u on t.assigned_to_user_id = u.user_id
where u.user_id is null or u.role not in('Product Manager');
-- 注意，这儿用left join而不是inner join可以避免遗漏，left全列出来，inner只会把匹配上的放出来


select task_name,completion_date
from tasks
where tasks.status in('Done') and tasks.task_id in (
select task_id from tasks
where completion_date>due_date
);

-- C. 行子查询 (Row Subquery)
select * from tasks
where (project_id,status) in
(select t.project_id,t.status
from tasks t
join projects p on t.project_id=p.project_id
where 
p.project_name = "Smart Factory OS Development" and t.status='Blocked');

-- D. 表子查询 (Table Subquery)
select p.project_name, t.task_name, t.due_date
from tasks t
join projects p on t.project_id=p.project_id
where (t.project_id,t.due_date) in (
	select t.project_id,max(t.due_date)
	from tasks t
	group by t.project_id);

select p.project_name
from projects p
join tasks t on t.project_id=p.project_id
where (t.project_id,t.task_name) in (
	select project_id,task_name
	from tasks
	where due_date < CURDATE() and status!='Done')

-- 任务三
-- 可能有点问题，后续再修正吧，头晕眼花的
SELECT
    p.project_name,
    IFNULL(pm.username, 'Unassigned') AS responsible_pm,
    COUNT(t.task_id) AS total_tasks,
    SUM(CASE WHEN t.status = 'Done' THEN 1 ELSE 0 END) AS completed_tasks,
    SUM(CASE WHEN t.status != 'Done' THEN 1 ELSE 0 END) AS pending_tasks,
    AVG(CASE WHEN t.status = 'Done' THEN DATEDIFF(t.completion_date, p.start_date) ELSE NULL END) AS avg_completion_days,
    GROUP_CONCAT(DISTINCT CONCAT(task_users.role, ':', task_users_count.role_count) SEPARATOR '; ') AS roles_summary -- 统计不同角色数量
FROM projects p
LEFT JOIN users pm ON p.responsible_user_id = pm.user_id -- 项目负责人
LEFT JOIN tasks t ON p.project_id = t.project_id -- 关联任务
LEFT JOIN (
    -- 子查询：统计每个项目下各个角色的用户数量
    SELECT tp.project_id, u.role, COUNT(DISTINCT u.user_id) AS role_count
    FROM tasks tp
    JOIN users u ON tp.assigned_to_user_id = u.user_id
    GROUP BY tp.project_id, u.role
) AS task_users_count ON p.project_id = task_users_count.project_id
LEFT JOIN users task_users ON t.assigned_to_user_id = task_users.user_id -- 关联任务分配者，用于获取角色
WHERE p.status != 'Completed'
GROUP BY p.project_id, p.project_name, pm.username;


SELECT
    u.username,
    COUNT(t.task_id) AS total_assigned_tasks, -- 总共负责的任务数量
    AVG(CASE
        WHEN t.status = 'Done' AND t.completion_date IS NOT NULL AND p.start_date IS NOT NULL
        THEN DATEDIFF(t.completion_date, p.start_date)
        ELSE NULL
    END) AS avg_completion_duration_days -- 已完成任务的平均耗时
FROM users u
LEFT JOIN tasks t ON u.user_id = t.assigned_to_user_id
LEFT JOIN projects p ON t.project_id = p.project_id -- 为了获取项目的 start_date
WHERE u.role = 'Developer' -- 只查询开发者
GROUP BY u.username
ORDER BY u.username;

/*思考题
-- 在什么情况下，你认为使用子查询比使用连接 (JOIN) 更有优势？反之亦然？举例说明。
-- 回答：子查询逻辑清晰，比如需要先计算一些平均值、最大值等中间结果，在做主查询。子查询符合人类思考过程。
-- 复杂场景下，子查询常用且有效。在判断是否满足条件时，EXISTS子查询更加高效，第一个匹配就停止。
-- JOIN处理大量数据时，优化器通常能够更好的优化JOIN操作，尤其是简单的一对多或者多对一关联查询中，JOIN高效。
-- JOIN从多个表同时选择和组合字段。对于简单的关联查询，JOIN可读性比子查询更好。



-- EXISTS 和 IN 在某些情况下可以互换使用。它们之间有什么性能或逻辑上的主要区别？在选择使用哪个时，你会考虑什么？
*回答：
IN：
逻辑：value IN (subquery_result_set)，子查询会完全执行并返回一个值列表。然后外部查询会检查 value 是否在这个列表中。
适用场景：当子查询返回的列表较小，且外部查询需要精确匹配列表中的某个值时。
性能考量：如果子查询返回的列表非常大，性能可能较差，因为需要将整个列表加载到内存中进行比较。
NULL 处理：value IN (NULL, ...) 永远返回 UNKNOWN。如果子查询返回结果中包含 NULL，
那么 NOT IN 可能会产生意想不到的结果（例如，WHERE value NOT IN (SELECT col FROM T WHERE col IS NOT NULL OR col IS NULL) 如果子查询结果中包含任何 NULL，整个 NOT IN 条件都会变为 UNKNOWN，导致无结果）。

EXISTS：
逻辑：EXISTS (subquery)，子查询会尝试执行。如果子查询返回任何一行（哪怕是 NULL 值），EXISTS 条件就为 TRUE，外部查询会继续处理当前行。
如果子查询没有返回任何行，EXISTS 就为 FALSE。
适用场景：当外部查询只需要判断“是否存在”满足特定条件的记录，而不需要具体返回这些记录的值时。常用于“相关子查询”，即子查询依赖于外部查询的字段。
性能考量：通常比 IN 更高效，尤其是在子查询结果集很大的情况下。因为 EXISTS 找到一个匹配就停止，不需要完全执行子查询或构建完整列表。
NULL 处理：EXISTS 对 NULL 不敏感。只要子查询返回一行，无论值是否为 NULL，EXISTS 都为 TRUE。
总结：在能互换的场景下，通常 EXISTS 的性能和鲁棒性优于 IN。IN 适用于列表较小或需要具体值比较的场景，而 EXISTS 适用于“存在性”判断的场景。
**/