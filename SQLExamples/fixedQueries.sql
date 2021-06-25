/* lead_status */
SELECT 
	COUNT(DISTINCT l.lead_id) as total_leads, 
    type_name as lead_source_name, 
    (SELECT
		COUNT(l2.lead_id)
	 FROM leads l2
     JOIN status s2 ON l2.status = s2.status_id
     JOIN lead_sources ls2 ON l2.lead_source = ls2.source_id
	 JOIN lead_source_type lst2 ON ls2.source_type  = lst2.lead_source_type_id
	 WHERE 
        lst2.lead_source_type_id = lst.lead_source_type_id AND
		s2.type = 5) AS trashLeads,
	(SELECT
		COUNT(l2.lead_id)
	 FROM leads l2
     JOIN status s2 ON l2.status = s2.status_id
     JOIN lead_sources ls2 ON l2.lead_source = ls2.source_id
	 JOIN lead_source_type lst2 ON ls2.source_type  = lst2.lead_source_type_id
	 WHERE 
        lst2.lead_source_type_id = lst.lead_source_type_id AND
		s2.type = 3) AS RecycledLeads,
	(SELECT
		COUNT(l2.lead_id)
	 FROM leads l2
     JOIN status s2 ON l2.status = s2.status_id
     JOIN lead_sources ls2 ON l2.lead_source = ls2.source_id
	 JOIN lead_source_type lst2 ON ls2.source_type  = lst2.lead_source_type_id
	 WHERE 
        lst2.lead_source_type_id = lst.lead_source_type_id AND
		s2.type = 2) AS SuccessLeads
FROM leads l
JOIN lead_sources ls ON l.lead_source  = ls.source_id 
JOIN lead_source_type lst ON ls.source_type  = lst.lead_source_type_id  
GROUP BY ls.source_type;



/* get dollar per lead */

SELECT 
	user_id, 
    CONCAT(first_name, " ", last_name) as consultant, 
    (SELECT 
		COUNT(lead_id) 
	 FROM leads 
     WHERE organization = 1 AND 
     status <> 18 AND 
     owner = user_id) as leads_in_pipe 
FROM users 
WHERE organization = 1 
GROUP BY user_id 
HAVING leads_in_pipe > 2 
ORDER BY leads_in_pipe DESC;



/* all reps */
SELECT 
    (COUNT(DISTINCT(CASE WHEN lead_source = 15 THEN lead_id END)) / COUNT(DISTINCT lead_id)) * 100 as referral_percentage
FROM leads l
WHERE 
	(SELECT
		rep_id 
	 FROM lead_products lp
     WHERE lp.lead = l.lead_id 
     ORDER BY lp.id 
     DESC LIMIT 1) = 3220110 AND 
    (status = 18 OR status = 71) AND 
    (SELECT 
		install_signed_date 
	 FROM lead_products lp
     WHERE 
		rep_id = 3220110 AND 
        lp.lead = lead_id 
	 ORDER BY id DESC 
     LIMIT 1) BETWEEN CURDATE() - INTERVAL 42 DAY AND CURDATE();

SELECT 
	COUNT(DISTINCT(CASE WHEN lead_source = 15 THEN lead_id END)) AS referral_number,
    COUNT(DISTINCT lead_id) AS customer_number,
    (COUNT(DISTINCT(CASE WHEN lead_source = 15 THEN lead_id END)) / COUNT(DISTINCT lead_id)) * 100 as referral_percentage
FROM leads l
WHERE 
	(SELECT
		rep_id 
	 FROM lead_products lp
     WHERE lp.lead = l.lead_id 
     ORDER BY lp.id 
     DESC LIMIT 1) = 3220110 AND 
    (status = 18 OR status = 71) AND 
    (SELECT 
		install_signed_date 
	 FROM lead_products lp
     WHERE 
		rep_id = 3220110 AND 
        lp.lead = lead_id 
	 ORDER BY id DESC 
     LIMIT 1) BETWEEN CURDATE() - INTERVAL 42 DAY AND CURDATE();




/* team sales report */
SELECT 
    t.name,
    id AS team_id,
    COUNT(DISTINCT uit.user) AS team_members,
    IFNULL(FORMAT((SELECT 
                        SUM(lp.total)
                    FROM
                        lead_products lp
					JOIN user_in_team uit ON lp.rep_id = uit.user
                    WHERE
                        user = rep_id
                            AND uit.team = t.id
                            AND ((SELECT 
                                l.status
                            FROM
                                leads l
                            WHERE
                                lp.lead = l.lead_id) = 18
                            OR (SELECT 
                                l.status
                            FROM
                                leads l
                            WHERE
                                lp.lead = l.lead_id) = 71)),
                2),
            '0.00') AS total_revenue,
    IFNULL(FORMAT((SELECT 
                        SUM(total)
                    FROM
                        lead_products lp
					JOIN user_in_team uit ON lp.rep_id = uit.user
                    WHERE
                            uit.team = t.id
                            AND team_lead = 1
                            AND ((SELECT 
                                l.status
                            FROM
                                leads l
                            WHERE
                                lp.lead = l.lead_id) = 18
                            OR (SELECT 
                                l.status
                            FROM
                                leads l
                            WHERE
                                lp.lead = l.lead_id) = 71)),
                2),
            '0.00') AS team_lead_total_revenue,
    IFNULL((SELECT 
                    SUM(lp.total)
                FROM
                        lead_products lp
					JOIN user_in_team uit ON lp.rep_id = uit.user
                    WHERE
						uit.team = t.id
                        AND ((SELECT 
                            l.status
                        FROM
                            leads l
                        WHERE
                            lp.lead = l.lead_id) = 18
                        OR (SELECT 
                            l.status
                        FROM
                            leads l
                        WHERE
                            lp.lead = l.lead_id) = 71)),
            '0.00') AS raw_total_revenue,
    (SELECT 
            COUNT(DISTINCT lp.lead)
        FROM
			lead_products lp
		JOIN user_in_team uit ON lp.rep_id = uit.user
		WHERE
                uit.team = t.id
                AND ((SELECT 
                    l.status
                FROM
                    leads l
                WHERE
                    lp.lead = l.lead_id) = 18
                OR (SELECT 
                    l.status
                FROM
                    leads l
                WHERE
                    lp.lead = l.lead_id) = 71)) AS total_customers,
    (SELECT 
            COUNT(DISTINCT lp.lead)
				FROM
                        lead_products lp
				JOIN user_in_team uit ON lp.rep_id = uit.user
				WHERE
                uit.team = t.id
                AND (SELECT 
                    l.status
                FROM
                    leads l
                WHERE
                    lp.lead = l.lead_id) = 4) AS total_cancel,
    (SELECT 
            COUNT(DISTINCT a.lead)
        FROM
            appointments a
		JOIN user_in_team uit ON a.creator = uit.user
        WHERE
				a.status = 3
                AND uit.team = t.id) AS total_sets,
    (SELECT 
            COUNT(DISTINCT a.lead)
        FROM
            appointments a
		JOIN user_in_team uit ON a.creator = uit.user
        WHERE
            a.status = 3
                AND uit.team = t.id
                AND kept = 1) AS total_kept
FROM
    teams t
JOIN user_in_team uit ON t.id = uit.team
JOIN users u ON u.user_id = uit.user
WHERE
    team_type = 'Sales'
GROUP BY uit.team
ORDER BY t.name ASC;