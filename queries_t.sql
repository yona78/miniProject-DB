-- Basic Salary Query (no specials additions, absences or taxes)
SELECT ID,
       rank,
       scope,
       seniority,
	   
       ExtraHours,
       ((rank * 1000) * (scope / 100) + (rank * 50 * ExtraHours)) * (1 + 0.02 * Seniority) 
       AS base_salary
FROM employee;

---------------------------------------------------------------------------------------

-- Asministrator Salary (Bruto)
SELECT employee.ID,
       rank,
       scope,
       seniority,
       ExtraHours,

       ((rank * 1000) * (scope / 100) + (rank * 5 * ExtraHours)) * (1 + 0.02 * Seniority) +
       0.07 * administrator.has_degree * (rank * 1000) * (scope / 100) +
       0.03 * administrator.double_degree * (rank * 1000) * (scope / 100) -
       COALESCE(CASE 
					        WHEN absences.is_illness = 0 THEN absences.duration 
					        ELSE 0
                END) * 
      (rank * 1000) * (scope / 100) / 22, 0) 

	   AS bruto_salary

FROM employee NATURAL JOIN administrator LEFT JOIN absences ON employee.ID = absences.ID

GROUP BY employee.ID, employee.rank, employee.Seniority, employee.ExtraHours;

---------------------------------------------------------------------------------------

-- Cashier Salary (Bruto)
SELECT ID,
       rank,
       scope,
       seniority,
       ExtraHours,

       ((rank * 1000) * (scope / 100) + (rank * 50 * ExtraHours)) * (1 + 0.02 * Seniority) 

       AS bruto_salary

FROM employee NATURAL JOIN cashier LEFT JOIN absences ON employee.ID = absences.ID

GROUP BY employee.ID, employee.rank, employee.Seniority, employee.ExtraHours;

---------------------------------------------------------------------------------------

--Security Guard Salary (Bruto)
SELECT employee.ID,
       rank,
       scope,
       seniority,
       ExtraHours,

       ((rank * 1000) * (scope / 100) + (rank * 5 * ExtraHours)) * (1 + 0.02 * Seniority) -

       COALESCE(CASE WHEN absences.is_illness = 0 THEN absences.duration ELSE 0 END) * 
                (rank*1000)*(scope/100)/22, 0) + 

       COALESCE(CASE WHEN securityguard.gunLicense = 'M16' THEN 800
                     WHEN securityguard.gunLicense = 'Uzi' THEN 500
                     ELSE 0
				        END)

       AS bruto_salary

FROM employee NATURAL JOIN securityguard LEFT JOIN  absences ON employee.ID = absences.ID
GROUP BY employee.ID, employee.rank, employee.Seniority, employee.ExtraHours;

---------------------------------------------------------------------------------------

--Engineer Guard Salary (Bruto)
SELECT employee.ID,
       rank,
       scope,
       seniority,
       ExtraHours,

       ((rank * 1000) * (scope / 100) + (rank * 5 * ExtraHours)) * (1 + 0.02 * Seniority) +
       0.07 * engineer.has_degree * (rank * 1000) * (scope / 100) +
       0.03 * engineer.double_degree * (rank * 1000) * (scope / 100) -
       COALESCE(CASE 
					        WHEN absences.is_illness = 0 THEN absences.duration 
					        ELSE 0
                END) * 
      (rank * 1000) * (scope / 100) / 22, 0) 

	   AS bruto_salary

FROM employee NATURAL JOIN engineer LEFT JOIN absences ON employee.ID = absences.ID

GROUP BY employee.ID, employee.rank, employee.Seniority, employee.ExtraHours;

---------------------------------------------------------------------------------------

-- Inspector Salary (Bruto)
SELECT ID,
       rank,
       scope,
       seniority,
       ExtraHours,

       ((rank * 1000) * (scope / 100) + (rank * 50 * ExtraHours)) * (1 + 0.02 * Seniority) 

       AS bruto_salary

FROM employee NATURAL JOIN inspector LEFT JOIN absences ON employee.ID = absences.ID

GROUP BY employee.ID, employee.rank, employee.Seniority, employee.ExtraHours;

---------------------------------------------------------------------------------------

--Driver Salary (Bruto)
SELECT employee.ID,
       rank,
       scope,
       seniority,
       ExtraHours,

       ((rank * 1000) * (scope / 100) + (rank * 5 * ExtraHours)) * (1 + 0.02 * Seniority) -

       COALESCE(CASE WHEN absences.is_illness = 0 THEN absences.duration ELSE 0 END) *
               (rank * 1000)  *(scope  /100) / 22, 0) + 

       COALESCE(CASE WHEN driver.License = 'C' THEN 800
                	 ELSE 0 END) +

       driver.Risk * 50

       AS bruto_salary

FROM employee NATURAL JOIN driver LEFT JOIN  absences ON employee.ID = absences.ID
GROUP BY employee.ID, employee.rank, employee.Seniority, employee.ExtraHours;

---------------------------------------------------------------------------------------

-- Any Employee Salary (Neto)
SELECT employee.ID,
 
	   COALESCE(CASE 
                	WHEN admin_bruto.salary < 6400 THEN 0.9 * admin_bruto.salary 
                	WHEN admin_bruto.salary < 10000 THEN 0.86 * admin_bruto.salary 
                	WHEN admin_bruto.salary < 24000 THEN 0.82 * admin_bruto.salary
                	ELSE 0.76 * admin_bruto.salary END, 0
             ) +

					(tax_credis.num_of_kids + 
					 tax_credis.married + tax_credis.pref_area + 
					 tax_credis.fresh_grad + tax_credis.citizen * 2.25) * 235 as neto_salary

FROM employee JOIN admin_bruto NATURAL JOIN tax_credis ON employee.ID = tax_credis.ID

---------------------------------------------------------------------------------------
