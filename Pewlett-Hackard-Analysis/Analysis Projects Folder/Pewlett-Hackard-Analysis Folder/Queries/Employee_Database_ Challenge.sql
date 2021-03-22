-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
	dept_no VARCHAR(4) NOT NULL,
	dept_name VARCHAR(40) NOT NULL,
	PRIMARY KEY (dept_no),
	UNIQUE (dept_name)
);

SELECT * FROM departments;

CREATE TABLE employees (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

SELECT * FROM employees; 

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
PRIMARY KEY (emp_no, dept_no)
);

SELECT * FROM dept_manager;

CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR (4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

SELECT * FROM dept_emp;

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	-- FOREIGN KEY (from_date) REFERENCES dept_manager (from_date),
	PRIMARY KEY (emp_no, from_date)
);

SELECT * FROM salaries;

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR (200) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,	
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
	);

SELECT * FROM titles

-- Determine Retirement Eligibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- How Many Employees were Born in 1952
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

--How Many Employees were Born in 1953, 1954, and 1955.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

--Narrow the Search for Retirement Eligibility

-- Employees Born Between 1952 and 1955 AND Hired Between 1985 and 1988.
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Count the Queries

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create New Tables   
-- 'retirement_info'

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

-- Drop the current retirement_info table
DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Check the table
SELECT * FROM retirement_info;

--Joining departments and dept_manager Tables
SELECT departments.dept_name,
	dept_manager.emp_no,
	dept_manager.from_date,
	dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- Use Aliases for Code Readability

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no,
	ri.first_name,
ri.last_name,
	de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

-- Use Aliases to update other JOIN (Joining departmeents and dept_manager tables)

-- Joining departments and dept_manager tables
SELECT d.dept_name,
	dm.emp_no,
	dm.from_date,
	dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- 1. Use Left Join for retirement_info and dept_emp tables
-- 2. Create a new table to hold the information named "current_emp"
-- 3. Add the code that will join these two tables
-- 4. Add a filter using the WHERE keyword
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01')

SELECT * FROM current_emp;

-- Employee count by department_number using GROUPBY
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;

-- Employee count by department number using ORDER BY
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Create Additional Lists (Employees, Managers, Department Retirees)

-- Employees List (emp_no)

-- SELECT statement
SELECT * FROM salaries;

-- Sort the column in descending order to know the most recent date on the lest
SELECT * FROM salaries
ORDER BY to_date DESC;

-- Add SELECT Statement, update INTO portion
SELECT emp_no, 
	first_name, 
last_name,
	gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Join emp_info table to salaries table using aliases
SELECT e.emp_no,
	e.first_name,
e.last_name,
	e.gender,
	s.salary,
	de.to_date
-- INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- List of Managers (manager_info)

-- List of managers per department
SELECT dm.dept_no,
	d.dept_name,
	dm.emp_no,
	ce.last_name,
	ce.first_name,
	dm.from_date,
	dm.to_date
-- INTO manager_info
FROM dept_manager AS dm
	INNER JOIN departments AS d
		ON (dm.dept_no = d.dept_no)
	INNER JOIN current_emp AS ce
		ON (dm.emp_no = ce.emp_no);
		
-- List of Departments (dept_info)

-- Department Retirees
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);


-- Deliverable 1: The Number of Retiring Employees by Title

-- Create a Retirement Titles tables that holds all the "titles" of current
-- "employees" who were born between Jan 1, 1952 "AND" Dec 31, 1955.

-- Titles of all retiring employees in aliases, INNER join titles table
SELECT e.emp_no,
    e.first_name,
e.last_name,
    t.title,
    t.from_date,
    t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles AS t
ON (e.emp_no = t.emp_no)
-- Years
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- Select
SELECT * FROM retirement_titles

-- Check the table titles
SELECT emp_no
first_name,
last_name,
title
-- from_date (date)
-- to_date (date)
FROM retirement_titles;

-- Use the Distinct ON statement, create a unique titles tables using the INTO clause
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
-- Create Unique Titles using the 'INTO' clause
INTO unique_titles
FROM retirement_titles
-- Sort the Unique Titles table in ascending order, descending order by last_date "to_date" 
ORDER BY emp_no, to_date DESC;

-- Select 
SELECT * FROM unique_titles;

-- Retrieve the number of titles from the Unique Titles table, create a Retiring Titles table 
-- to hold the required information
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
-- Group the table by title, sort the count column in descending order
GROUP BY title
ORDER BY count DESC;

--Select
SELECT * FROM retiring_titles;

-- Deliverable 2: The Employees Eligible for the Mentorship Program

-- Create a mentorship_eligibility table that holds the current employees
-- who were born between January 1, 1965 and December 31, 1965 
SELECT DISTINCT ON (e.emp_no) e.emp_no,
e.first_name,
e.last_name,
e.birth_date,
de.from_date,
de.to_date,
t.title

INTO mentorship_eligibility
FROM employees AS e
-- JOIN the Employees and Department Employee Tables
JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
-- JOIN the Employees and Titles tables
JOIN titles AS t
ON (e.emp_no = t.emp_no)
-- Filter the data on the to_date column to get current employees
--whose birth dates are between January 1, 1965 and December 31, 1965
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
-- Order table by employee number
ORDER BY e.emp_no;

SELECT * FROM mentorship_eligibility
