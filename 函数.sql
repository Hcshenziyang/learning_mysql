/*题目

补充 due_date 和 completion_date 数据：

你之前插入的那些任务，很多 due_date 都是 null。现在，请为所有 due_date 为 null 且 status 不是 'Done' 的任务，随机生成一个在当前日期到未来两个月之间的 due_date。

修改邮箱，比如qq.com或者163.com——已经修改了wangwu email为qq.com，zhaoliu email为163.com。

任务一：字符串与日期函数应用 (String, Date Functions)

用户邮箱域名分析：

你想统计一下公司内部有多少种不同的邮箱域名。查询 users 表，列出所有不重复的邮箱域名（例如，hongcha@example.com 的域名就是 example.com）。

提示：你需要用到 SUBSTRING 和 LOCATE 或 INSTR 函数来找到 @ 符号的位置。

项目名称标准化显示：

在报表展示时，你希望所有项目名称都能以大写字母开头。查询 projects 表，显示项目名称，但要求所有项目名称的首字母大写，其余小写。例如，'smart factory os development' 应该显示为 'Smart factory os development'。

提示：结合 UPPER, LOWER, SUBSTRING 来实现。

任务截止日期概览：

你想要一个快速的概览，看看每个任务的截止日期是哪年哪月。查询 tasks 表，显示任务名称，以及它的截止日期的年份和月份（格式如 "2023年9月"）。

提示：使用 YEAR(), MONTH() 和 CONCAT()。

任务状态优先级分类：

现在你想要一个更直观的任务优先级视图。查询 tasks 表，显示任务名称，以及一个根据其 status 字段生成的优先级描述：

'Blocked' 状态的任务显示为 'Urgent: Action Required'

'In Progress' 的显示为 'Normal: Ongoing'

'New' 或 'Open' 的显示为 'Low: Pending'

'Done' 的显示为 'Completed'

其他未知状态（如果有的话）显示为 'Unknown Status'

提示：这是 CASE WHEN 语句的典型应用场景。

负责人状态智能显示：

在展示任务列表时，如果 assigned_to_user_id 为空，你希望显示 'Unassigned'，否则显示分配人的用户名。查询 tasks 表，显示任务名称，以及其负责人（如果是未分配，则显示 'Unassigned'，否则显示对应的用户id）。

提示：使用 IFNULL() 或 CASE WHEN。

项目负责人空缺预警：

你非常关心项目有没有负责人。查询 projects 表，显示项目名称和项目负责人，如果负责人为空，显示 '!!!Missing Responsible PM!!!'。

提示：同样是 IFNULL() 或 CASE WHEN 的应用。*/

use industrial_project_management;

update tasks 
	set due_date=DATE_ADD('2025-08-04', INTERVAL round(rand()*60) day )
	where due_date is null and status!='Done';

select distinct
lower(substring(email,locate('@',email)+1))
from users;

SELECT
    CONCAT(UPPER(SUBSTRING(project_name, 1, 1)), LOWER(SUBSTRING(project_name, 2))) AS standardized_project_name
FROM projects;


select
task_name,year(due_date),month(due_date)
from tasks;

SELECT
    task_name,
    CASE
        WHEN status = 'Blocked' THEN 'Urgent: Action Required'
        WHEN status = 'In Progress' THEN 'Normal: Ongoing'
        WHEN status IN ('New', 'Open') THEN 'Low: Pending' -- 使用 IN 关键字
        WHEN status = 'Done' THEN 'Completed'
        ELSE 'Unknown Status'
    END AS task_priority
FROM tasks;


select 
task_name,ifnull(assigned_to_user_id,'Unassigned')
from tasks;

select 
project_name,ifnull(responsible_user_id,'Unassigned')
from projects;