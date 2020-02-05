--과제 8
SELECT  r.region_id, r.region_name ,c.country_name
FROM  regions r JOIN countries c 
ON (r.REGION_ID = c.REGION_ID
AND region_name = 'Europe');

-- 조인 9
SELECT  r.region_id, r.region_name ,c.country_name, l.city
FROM  regions r JOIN countries c 
ON (r.REGION_ID = C.REGION_ID
) JOIN locations l ON(c.country_id = l.country_id AND region_name = 'Europe');

--조인 10
SELECT r.region_id, r.region_name ,c.country_name, l.city, d.department_name
FROM regions r JOIN countries c ON (r.region_id = c.region_id)
               JOIN locations l ON (c.country_id = l.country_id)
               JOIN departments d ON (d.location_id=l.location_id and region_name = 'Europe');
        
--조인 11


SELECT r.region_id, r.region_name ,c.country_name, l.city, d.department_name, concat(e.first_name, e.last_name) name
FROM regions r JOIN countries c ON (r.region_id = c.region_id)
               JOIN locations l ON (c.country_id = l.country_id)
               JOIN departments d ON (d.location_id=l.location_id) 
               JOIN employees e ON (e.department_id = d.department_id and region_name = 'Europe');
        


--조인 12
SELECT e.employee_id , concat(e.first_name, e.last_name) name , j.job_id, j.job_title
FROM employees e JOIN jobs j ON (e.job_id =j.job_id );

--조인 13
--직원의 담당업무 명칭 , 직원의 매니저 정보가 keypoint
SELECT e.manager_id, concat(m.first_name, m.last_name) mgr_name, e.employee_id, concat(e.first_name, e.last_name) name,
        e.job_id , j.job_title
FROM employees e JOIN employees m ON (m.employee_id = e.manager_id ) JOIN jobs j on(e.job_id= j.job_id);