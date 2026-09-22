
# 🏥 Hospital Management Analytics — SQL Project

## 📌 Project Overview

This project analyzes hospital and management data using **MySQL** to identify insights related to patients, doctors, departments, appointments, admissions, treatment costs, and hospital performance.

The project demonstrates practical SQL skills used by Data Analysts, including **data cleaning, joins, aggregations, subqueries, CTEs, CASE statements, window functions, ranking, date analysis, and time-based calculations**.

---

## 🎯 Project Objectives

The main objectives of this project are to:

- Analyze patient demographics and registrations
- Analyze hospital appointments and their status
- Measure hospital admissions and treatment costs
- Identify high-performing doctors and departments
- Analyze common diagnoses
- Calculate average hospital stay
- Analyze monthly admission and revenue trends
- Identify patients requiring greater attention
- Practice advanced SQL queries used in real-world analytics

---

## 🗂️ Dataset

The dataset is **synthetic and created for learning and portfolio purposes**.

The project contains **1,080 records** across five main tables:

| Table | Records | Description |
|---|---:|---|
| Patients | 220 | Patient demographic and registration information |
| Doctors | 24 | Doctor and specialization information |
| Departments | 6 | Hospital department information |
| Appointments | 650 | Patient appointment records |
| Admissions | 180 | Hospital admission and treatment information |

---

## 🏗️ Database Schema

### Departments
- `department_id` — Primary Key
- `department_name`

### Patients
- `patient_id` — Primary Key
- `patient_name`
- `gender`
- `date_of_birth`
- `city`
- `registration_date`

### Doctors
- `doctor_id` — Primary Key
- `doctor_name`
- `department_id` — Foreign Key
- `specialization`
- `joining_date`

### Appointments
- `appointment_id` — Primary Key
- `patient_id` — Foreign Key
- `doctor_id` — Foreign Key
- `appointment_date`
- `appointment_status`

### Admissions
- `admission_id` — Primary Key
- `patient_id` — Foreign Key
- `doctor_id` — Foreign Key
- `admission_date`
- `discharge_date`
- `diagnosis`
- `treatment_cost`

### Relationships

```text
Departments
     │
     └── Doctors
           │
           ├── Appointments ─── Patients
           │
           └── Admissions ───── Patients
```

---

## 🛠️ Tools & Technologies

- **MySQL**
- SQL
- MySQL Workbench
- Excel / CSV
- Git & GitHub

---

## 📊 SQL Concepts Used

This project covers both beginner and advanced SQL concepts:

### Basic SQL
- SELECT
- WHERE
- ORDER BY
- GROUP BY
- HAVING
- DISTINCT
- LIMIT

### Joins
- INNER JOIN
- LEFT JOIN
- Multiple-table joins

### Aggregations
- COUNT()
- SUM()
- AVG()
- MIN()
- MAX()

### Conditional Logic
- CASE

### Advanced SQL
- CTEs
- Subqueries
- Window Functions
- PARTITION BY
- RANK()
- DENSE_RANK()
- LAG()
- Running totals

### Date & Time Analysis
- YEAR()
- MONTH()
- DATE_FORMAT()
- DATEDIFF()
- Month-over-month analysis

---

## 🔍 Key Analysis Questions

Some of the business questions answered in this project include:

1. How many patients are registered in the hospital?
2. How many patients are from each city?
3. What is the gender distribution?
4. How many doctors work in each department?
5. What is the appointment completion rate?
6. Which patients have more than two appointments?
7. What is the total treatment revenue?
8. What is the average treatment cost?
9. Which diagnosis generates the highest revenue?
10. What is the average hospital stay?
11. Which departments have the highest treatment revenue?
12. Which patients have never been admitted?
13. Which patients have been admitted multiple times?
14. Which doctors have the highest number of patients?
15. Who are the top 3 doctors in each department?
16. What is the monthly hospital revenue?
17. What is the month-over-month revenue growth?
18. What is the first admission date for each patient?
19. Which patients have increasing treatment costs?
20. Which doctors have above-average admission counts?

---

## 📁 Project Structure

```text
hospital-healthcare-analytics-sql/
│
├── data/
│   ├── patients.csv
│   ├── doctors.csv
│   ├── departments.csv
│   ├── appointments.csv
│   └── admissions.csv
│
├── analysis/
│   └── questions_solutions.md
│
├── excel/
│   └── hospital_sql_project.xlsx
│
└── README.md
```

---

## 📌 Skills Demonstrated

Through this project, I demonstrated:

- Relational database understanding
- SQL querying
- Data aggregation
- Data analysis
- Complex joins
- CTEs and subqueries
- Window functions
- Ranking analysis
- Time-series analysis
- Business problem solving
- MySQL database management

---

## 👨‍💻 Author

**Vijay Kumar**

Aspiring Data Analyst | SQL | Power BI | Excel | Python

---
