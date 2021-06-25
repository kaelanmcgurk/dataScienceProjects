/* lead_status */
SELECT 
    COUNT(distinct lead_id) as total_leads, 
    type_name as lead_source_name, 
    (
        SELECT COUNT(*) 
        FROM leads l2, status, lead_sources ls 
        WHERE 
            l2.status = status_id AND 
            type = 5 AND 
            l2.lead_source = ls.source_id AND 
            ls.source_type = lst.lead_source_type_id AND 
            DATE(l2.date_created) BETWEEN (CURDATE() - INTERVAL 42 DAY) AND 
            CURDATE()) as success_status_leads, 
    (
        SELECT COUNT(*) 
        FROM leads l2, status, lead_sources ls
        WHERE 
            l2.status = status_id AND 
            type = 3 AND 
            l2.lead_source = ls.source_id AND 
            ls.source_type = lst.lead_source_type_id AND 
            DATE(l2.date_created) BETWEEN (CURDATE() - INTERVAL 42 DAY) AND CURDATE()) as recycle_status_leads, 
    (
        SELECT COUNT(*) 
        FROM leads l2, status, lead_sources ls 
        WHERE 
            l2.status = status_id AND 
            type = 2 AND 
            l2.lead_source = ls.source_id AND 
            ls.source_type = lst.lead_source_type_id AND 
            DATE(l2.date_created) BETWEEN (CURDATE() - INTERVAL 42 DAY) AND CURDATE()) as trash_status_leads 
FROM leads l1, lead_sources, lead_source_type lst 
WHERE 
    lead_source = source_id AND 
    source_type = lead_source_type_id AND 
    DATE(l1.date_created) BETWEEN (CURDATE() - INTERVAL 42 DAY) AND CURDATE() 
GROUP BY lead_sources.source_type






/* get_dollar_per_lead */
SELECT 
	user_id, 
	CONCAT(u.first_name, " ", u.last_name) as user_name, 
	COUNT(DISTINCT lead_id) as pipe_count, 
	(SELECT 
           SUM(total) 
           FROM lead_products 
           WHERE rep_id = user_id AND 
           (
               (
                   SELECT 
                       status 
                   FROM leads l 
                   WHERE lead = l.lead_id) = 18 OR 
               (
                   SELECT 
                       status 
                   FROM leads l 
                   WHERE lead = l.lead_id) = 71) AND 
               DATE(install_signed_date) BETWEEN CURDATE() - INTERVAL 42 DAY AND CURDATE()) as six_week_total
	FROM 
		users u, 
		leads 
	WHERE 
		owner = user_id AND 
		u.organization = ? AND 
		status <> 18 AND 
		(role = 29 OR role = 30 OR role = 1) AND 
		password_hash IS NOT NULL 
	GROUP BY 
		user_id 
	HAVING 
		pipe_count > 4 AND 
		six_week_total IS NOT NULL
	ORDER BY 
		pipe_count DESC


/* all reps */
SELECT 
	COUNT(DISTINCT(CASE WHEN kept = 1 THEN a.lead END)) AS kept_number,
    COUNT(DISTINCT a.lead) AS set_number,
	IF(COUNT(DISTINCT a.lead) = 0, 0, (COUNT(DISTINCT(CASE WHEN kept = 1 THEN a.lead END)) / COUNT(DISTINCT a.lead)) * 100) AS kept_percentage 
FROM appointments a
WHERE 
	creator = 3220110 AND 
	status = 3 AND
    DATE(appointment_created_at) BETWEEN CURDATE() - INTERVAL 42 DAY AND CURDATE();

SELECT
    (COUNT(DISTINCT(CASE WHEN lead_source = 15 THEN lead_id END)) / COUNT(DISTINCT lead_id)) * 100 as referral_percentage
FROM leads l
WHERE
	(SELECT
		rep_id
	 FROM lead_products lp
     WHERE lp.lead = l.lead_id
     ORDER BY lp.id
     DESC LIMIT 1) = ? AND
    (status = 18 OR status = 71) AND
    (SELECT
		install_signed_date
	 FROM lead_products lp
     WHERE
		rep_id = ? AND
        lp.lead = lead_id
	 ORDER BY id DESC
     LIMIT 1) BETWEEN CURDATE() - INTERVAL 42 DAY AND CURDATE()