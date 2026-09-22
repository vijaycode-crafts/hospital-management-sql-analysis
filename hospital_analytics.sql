CREATE DATABASE IF NOT EXISTS hospital_analytics;
USE hospital_analytics;

DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS admissions;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
 department_id INT PRIMARY KEY,
 department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE patients (
 patient_id INT PRIMARY KEY,
 patient_name VARCHAR(100) NOT NULL,
 gender ENUM('Male','Female') NOT NULL,
 date_of_birth DATE NOT NULL,
 city VARCHAR(50) NOT NULL,
 registration_date DATE NOT NULL
);

CREATE TABLE doctors (
 doctor_id INT PRIMARY KEY,
 doctor_name VARCHAR(100) NOT NULL,
 department_id INT NOT NULL,
 specialization VARCHAR(100) NOT NULL,
 joining_date DATE NOT NULL,
 FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE appointments (
 appointment_id INT PRIMARY KEY,
 patient_id INT NOT NULL,
 doctor_id INT NOT NULL,
 appointment_date DATE NOT NULL,
 appointment_status ENUM('Completed','Cancelled','No Show','Scheduled') NOT NULL,
 FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
 FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE admissions (
 admission_id INT PRIMARY KEY,
 patient_id INT NOT NULL,
 doctor_id INT NOT NULL,
 admission_date DATE NOT NULL,
 discharge_date DATE NOT NULL,
 diagnosis VARCHAR(100) NOT NULL,
 treatment_cost DECIMAL(12,2) NOT NULL,
 FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
 FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

 ## Data was imported from csv files through Table Data import Wizard

SELECT * FROM patients;
SELECT * FROM departments;
SELECT * FROM doctors;
SELECT * FROM appointments;
SELECT * FROM admissions;

# Find all patients from Hyderabad.
SELECT * FROM patients
WHERE city = 'Hyderabad';

# Count the total number of patients.
SELECT COUNT(*) AS Total_patients FROM patients;

# Find all doctors in the Cardiology department.
SELECT doctor_name, specialization FROM doctors doc JOIN
departments dep ON doc.department_id = dep.department_id
WHERE specialization = 'Cardiology'; 

# Find the average treatment cost.
SELECT AVG(treatment_cost) FROM admissions;

# Find the highest treatment cost.
SELECT MAX(treatment_cost) FROM admissions;

# Count patients by gender.
SELECT gender, COUNT(*) AS Total_patients FROM patients 
GROUP BY gender ;

# Find the number of patients treated by each doctor.
SELECT * FROM patients;
SELECT * FROM doctors;
SELECT doctor_id , COUNT(patient_id) FROM admissions
GROUP BY doctor_id;

# Find total treatment revenue by department.
SELECT  dep.department_name , SUM(treatment_cost) AS Revenue FROM doctors doc JOIN
admissions adm ON doc.doctor_id = adm.doctor_id 
JOIN departments dep ON dep.department_id = doc.department_id
GROUP BY dep.department_name;

# Find the top 5 most common diagnoses.
SELECT diagnosis , COUNT(diagnosis)  FROM admissions
GROUP BY diagnosis
ORDER BY COUNT(diagnosis) DESC
LIMIT 5;

# Find patients who have had more than 2 appointments.
SELECT pt.patient_id , COUNT(appointment_id) AS no_of_appointments FROM patients pt 
JOIN appointments ap ON pt.patient_id = ap.patient_id
GROUP BY pt.patient_id 
HAVING no_of_appointments > 2;

# Find doctors who have treated more than 20 patients.
SELECT doctor_id, COUNT(patient_id) AS patient_count FROM appointments
GROUP BY doctor_id
HAVING patient_count >20;

# Find patients who were never admitted.
SELECT pt.patient_id , pt.patient_name  FROM patients pt
LEFT JOIN admissions ad ON pt.patient_id = ad.patient_id
WHERE ad.admission_id IS NULL;

# Calculate the average treatment cost for each department.
SELECT  dep.department_name , AVG(treatment_cost) AS avg_treatment_cost FROM doctors doc JOIN
admissions adm ON doc.doctor_id = adm.doctor_id 
JOIN departments dep ON dep.department_id = doc.department_id
GROUP BY dep.department_name;

# Find the average hospital stay in days.
SELECT AVG(datediff(discharge_date,admission_date)) as avg_stay_days FROM admissions;

# Find the number of admissions by month.
SELECT month(admission_date) AS month_num , monthname(admission_date) AS admission_month , 
COUNT(admission_id) AS no_of_admissions FROM admissions
GROUP BY month_num , admission_month
ORDER BY 1; 
# OR # If u want month with their year
SELECT date_format(admission_date,'%Y-%m') AS month ,COUNT(admission_id) FROM admissions
GROUP BY month ORDER BY month;

# Find the second-highest treatment cost.
WITH CTE AS (
SELECT treatment_cost , RANK() OVER ( ORDER BY treatment_cost DESC) as ranking FROM admissions )
SELECT treatment_cost FROM CTE
WHERE ranking = 2;

# Find the top 3 doctors in each department using RANK().
WITH CTE AS
(SELECT doc.department_id,doc.doctor_id,doc.doctor_name, COUNT(admission_id) total_admissions 
FROM doctors doc JOIN admissions ad
ON doc.doctor_id=ad.doctor_id
GROUP BY doc.doctor_id,doc.doctor_name), 
CTE2 AS (
SELECT *, DENSE_RANK() OVER (PARTITION BY department_id ORDER BY total_admissions) AS rankings
FROM CTE )
SELECT * FROM CTE2 
WHERE rankings <= 3;

# Find each patient's first admission date.
SELECT patient_id,MIN(admission_date) FROM admissions 
GROUP BY patient_id;

# Find patients who were admitted more than once.
WITH CTE AS (
SELECT patient_id,COUNT(*) AS count FROM admissions
GROUP BY patient_id )
SELECT patient_id FROM CTE 
WHERE count > 1;

# Calculate month-over-month admission growth using LAG().
WITH CTE AS
(SELECT date_format(admission_date,'%Y-%m') AS month ,
COUNT(*) as numbers FROM admissions
GROUP BY month ),
CTE2 AS (
SELECT *,  LAG (numbers) OVER( ORDER BY month) AS previous_month  FROM  CTE)
SELECT * , ROUND( ((numbers - previous_month)/previous_month)*100,2 )AS mom_growth FROM CTE2;

# Calculate the running total of treatment revenue.
WITH CTE AS
(SELECT date_format(admission_date,'%Y-%m') month , SUM(treatment_cost) revenue FROM admissions
GROUP BY month ORDER BY month)
SELECT month , revenue , SUM(revenue) OVER (ORDER BY month) running_revenue FROM CTE;

# Find doctors whose patient count is above the average doctor patient count.
WITH CTE AS
(SELECT doctor_id,COUNT(*) total FROM appointments
GROUP BY doctor_id)
SELECT * FROM CTE 
WHERE total > (SELECT AVG(total) FROM CTE);

# Use CASE to classify patients
-- 0–17 → Child
-- 18–59 → Adult
-- 60+ → Senior
SELECT patient_id,patient_name , timestampdiff(YEAR,date_of_birth,curdate()) age ,
CASE
	WHEN timestampdiff(YEAR,date_of_birth,curdate())<18 THEN 'Child'
    WHEN timestampdiff(YEAR,date_of_birth,curdate())<60 THEN 'Adult'
    ELSE 'Senior'
END as age_classification
FROM patients;

# Find the department with the highest average treatment cost.
SELECT dep.department_id,dep.department_name, AVG(treatment_cost) AS avg_cost
FROM doctors d JOIN admissions a
ON d.doctor_id = a.doctor_id 
JOIN departments dep  ON
d.department_id = dep.department_id
GROUP BY dep.department_id,dep.department_name
ORDER BY avg_cost DESC
LIMIT 1 ;

# Find patients whose latest admission cost is higher than their previous admission cost.
WITH CTE AS
(SELECT patient_id , treatment_cost , admission_date , LAG(treatment_cost) OVER (PARTITION BY patient_id ORDER BY admission_date) previous_cost
FROM admissions)
SELECT patient_id FROM CTE 
WHERE treatment_cost > previous_cost ;
