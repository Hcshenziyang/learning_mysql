/*第一阶段：数据录入与初始化 (INSERT)

加入几名人员：

 'hongcha'，'hongcha@example.com'， 'Product Manager'

'lisi', 'lisi@example.com', 'Developer'

'wangwu', 'wangwu@example.com', 'Developer'

'zhaoliu', 'zhaoliu@example.com', 'Tester'

'qianqi', 'qianqi@example.com', 'Tester'

新建项目： 现在要启动一个新项目，叫做 'Smart Factory OS Development'。

项目描述是 'Developing a new operating system for smart factory automation.'

开始日期是 '2023-01-15'。

状态是 'Developing'。

这个项目的负责人是（'hongcha'）。需要查一下user_id然后填进去。

项目任务分配： 为 'Smart Factory OS Development' 项目创建几个初始任务，并分配给团队成员：

任务1： 'Design Core Modules'，任务详情 'Outline the architecture for communication, control, and data processing.'，分配给 'lisi'，状态 'In Progress'。

任务2： 'Develop User Interface'，任务详情 'Create a user-friendly interface for system monitoring.'，分配给 'wangwu'，状态 'New'。

任务3： 'Integrate PLC Drivers'，任务详情 'Develop and integrate drivers for various PLC brands.'，分配给 'lisi'，状态 'New'。

任务4： 'Setup Testing Environment'，任务详情 'Configure virtual machines and physical hardware for testing.'，分配给 'zhaoliu'，状态 'Open'。

第二阶段：数据更新与维护 (UPDATE)

项目状态变更： 'Smart Factory OS Development' 项目进展顺利，现在需要将它的状态更新为 'Testing'。同时，该项目的负责人 'hongcha' 暂时调配去负责其他工作，所以将该项目的负责人设置为空。

任务进度更新：

'Design Core Modules' 任务已经完成，将其状态更新为 'Done'。

'Develop User Interface' 任务遇到了一些障碍，需要将它的状态更新为 'Blocked'。

'Integrate PLC Drivers' 任务现在由 'wangwu' 接手，更新其assigned_to_user_id。

用户信息更新： 'lisi' 的邮箱地址发生了变化，更新为 'lisi.new@example.com'。

第三阶段：数据删除 (DELETE)

删除任务： 发现 'Setup Testing Environment' 这个任务计划有变，不需要了，请将其删除。

删除用户： 有一名临时开发人员 'lisi' 已经离职，你需要将他从users表中删除。观察一下，他负责的项目和任务有什么变化？
 */
use industrial_project_management;
insert users (username, email, role) values
    ('hongcha','hongcha@example.com','Product Manager'),
    ('lisi','lisi@example.com','Developer'),
    ('wangwu','wangwu@example.com','Developer'),
    ('zhaoliu','zhaoliu@example.com','Tester'),
    ('qianqi','qianqi@example.com','Tester');

insert projects values
	(1,'Smart Factory OS Development',
	'Developing a new operating system for smart factory automation.',
	'2023-01-15',null,'Developing',1);

insert tasks values
	(1,1,'Design Core Modules','Outline the architecture for communication,control,and data processing.',2,'In Progress'),
	(2,1,'Develop User Interface','Create a user-friendly interface for system monitoring.',3,'New'),
	(3,1,'Integrate PLC Drivers','Develop and integrate drivers for various PLC brands.',2,'New'),
	(4,1,'Setup Testing Environment','Configure virtual machines and physical hardware for testing.',4,'Open');

-- update projects set status='Testing' where project_id=1;
-- update projects set responsible_user_id=null where project_id=1;
UPDATE projects SET status='Testing', responsible_user_id=NULL WHERE project_id=1;

update tasks set status='Done' where task_name='Design Core Modules';
update tasks set status='Blocked' where task_name='Develop User Interface';
update tasks set assigned_to_user_id=3 where task_name='Integrate PLC Drivers';
update users set email='lisi.new@example.com' where username='lisi';

delete from tasks where task_name='Setup Testing Environment';
delete from users where username='lisi';
-- 删除人员，对应的任务也一并删除
