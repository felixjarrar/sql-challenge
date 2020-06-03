-- Create Tables

CREATE TABLE titles (
    title_identification VARCHAR   NOT NULL,
    title VARCHAR   NOT NULL,
    PRIMARY KEY (title_identification)
);
CREATE TABLE employees (
    emp_number INT   NOT NULL,
    emp_title_identification VARCHAR NOT NULL,
    birth_date DATE   NOT NULL,
    first_name VARCHAR   NOT NULL,
    last_name VARCHAR   NOT NULL,
    sex VARCHAR   NOT NULL,
    hire_date DATE   NOT NULL,
    FOREIGN KEY (emp_title_identification) REFERENCES titles (title_identification),
    PRIMARY KEY (emp_number)
);


CREATE TABLE departments (
    dept_number VARCHAR   NOT NULL,
    dept_name VARCHAR   NOT NULL,
    PRIMARY KEY (dept_number)
);

CREATE TABLE dept_manager (
    dept_number VARCHAR   NOT NULL,
    emp_number INT   NOT NULL,
    FOREIGN KEY (emp_number) REFERENCES employees (emp_number),
    FOREIGN KEY (dept_number) REFERENCES departments (dept_number)
);

CREATE TABLE dept_emp (
    emp_number INT   NOT NULL,
    dept_number VARCHAR   NOT NULL,
    FOREIGN KEY (emp_number) REFERENCES employees (emp_number),
    FOREIGN KEY (dept_number) REFERENCES departments (dept_number),
    PRIMARY KEY (emp_number,dept_number)
);


CREATE TABLE salaries (
    emp_number INT   NOT NULL,
    salary INT   NOT NULL,
    FOREIGN KEY (emp_number) REFERENCES employees (emp_number),
	PRIMARY KEY (emp_number)
);

-- Salary 
SELECT  emp.emp_number,
        emp.last_name,
        emp.first_name,
        emp.sex,
        sal.salary
FROM employees as emp
    LEFT JOIN salaries as sal
    ON (emp.emp_number = sal.emp_number)
ORDER BY emp.emp_number;

-- Employees that were hired in the year 1986
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31';

-- Department managers
SELECT  dm.dept_number,
        d.dept_name,
        dm.emp_number,
        e.last_name,
        e.first_name
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_number = d.dept_number)
    INNER JOIN employees AS e
        ON (dm.emp_number = e.emp_number);


-- Employee/department association
SELECT  e.emp_number,
        e.last_name,
        e.first_name,
        d.dept_name
FROM employees AS e
    INNER JOIN dept_emp AS de
        ON (e.emp_number = de.emp_number)
    INNER JOIN departments AS d
        ON (de.dept_number = d.dept_number)
ORDER BY e.emp_number;

-- First name, "Hercules", last name, starts with "B"
SELECT first_name, last_name, birth_date, sex
FROM employees
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';

-- Employees in the Sales department
SELECT  e.emp_number,
        e.last_name,
        e.first_name,
        d.dept_name
FROM employees AS e
    INNER JOIN dept_emp AS de
        ON (e.emp_number = de.emp_number)
    INNER JOIN departments AS d
        ON (de.dept_number = d.dept_number)
WHERE d.dept_name = 'Sales'
ORDER BY e.emp_number;

-- Development departments and employee sales
SELECT  e.emp_number,
        e.last_name,
        e.first_name,
        d.dept_name
FROM employees AS e
    INNER JOIN dept_emp AS de
        ON (e.emp_number = de.emp_number)
    INNER JOIN departments AS d
        ON (de.dept_number = d.dept_number)
WHERE d.dept_name IN ('Sales', 'Development')
ORDER BY e.emp_number;

-- How often do employee last names occur?
SELECT last_name, COUNT(last_name)
FROM employees
GROUP BY last_name
ORDER BY COUNT(last_name) DESC;