/*


*/
use industrial_project_management;
-- USE仅仅针对DML AND DDL,DCL使用时必须写全名称。
alter table users modify role 
	enum('Developer','Tester','Product Manager','Product/Data Analyst') 
	not null default 'Developer';

update users set role='Product/Data Analyst' where username='hongcha';

CREATE USER 'junior_dev'@'localhost' IDENTIFIED BY 'dev_password_123';
CREATE USER 'intern_tester'@'localhost' IDENTIFIED BY 'test_password_456';

-- 测试权限
GRANT SELECT ON industrial_project_management.* TO 'intern_tester'@'localhost';
GRANT UPDATE(status,completion_date) ON industrial_project_management.tasks TO 'intern_tester'@'localhost';

-- 开发权限
GRANT SELECT ON industrial_project_management.* TO 'junior_dev'@'localhost';
GRANT INSERT ON industrial_project_management.tasks TO 'junior_dev'@'localhost';
GRANT UPDATE(task_id,task_name,task_details,assigned_to_user_id,status,due_date,completion_date)
ON industrial_project_management.tasks TO 'junior_dev'@'localhost';


-- 数据分析平台
CREATE USER 'readonly_analyst'@'%' IDENTIFIED BY 'analysis_pwd_789';
GRANT SELECT ON industrial_project_management.* TO 'readonly_analyst'@'%';

SHOW GRANTS FOR 'junior_dev'@'localhost';
SHOW GRANTS FOR 'intern_tester'@'localhost';
SHOW GRANTS FOR 'readonly_analyst'@'%';

GRANT delete ON industrial_project_management.tasks TO 'junior_dev'@'localhost';
revoke update on industrial_project_management.tasks from 'junior_dev'@'localhost';
GRANT update(task_id,task_name,task_details,assigned_to_user_id,status,completion_date) ON industrial_project_management.tasks TO 'junior_dev'@'localhost';

revoke all ON industrial_project_management.* FROM 'intern_tester'@'localhost';
DROP USER 'intern_tester'@'localhost';

