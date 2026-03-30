create database finance

use finance
-- DROP TABLES (for clean reloads)
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Invoices;
DROP TABLE IF EXISTS Expenses;
DROP TABLE IF EXISTS Budgets;
DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Vendors;
DROP TABLE IF EXISTS Customers;

-- CUSTOMERS
CREATE TABLE Customers (
    CustomerID VARCHAR(10) PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Industry VARCHAR(50),
    Country VARCHAR(50),
    JoinDate DATE
);

INSERT INTO Customers VALUES
('C001', 'Alpha Tech Ltd', 'IT Services', 'UK', '2022-01-15'),
('C002', 'Beta Pharma', 'Healthcare', 'USA', '2022-03-20'),
('C003', 'Gamma Retailers', 'Retail', 'Ghana', '2023-02-10'),
('C004', 'Delta Finance', 'Financial Services', 'UK', '2023-08-05'),
('C005', 'Zenith Logistics', 'Transport', 'Canada', '2024-01-12');

-- VENDORS
CREATE TABLE Vendors (
    VendorID VARCHAR(10) PRIMARY KEY,
    VendorName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Country VARCHAR(50),
    ContractStart DATE
);

INSERT INTO Vendors VALUES
('V001', 'Office Depot', 'Office Supplies', 'UK', '2022-02-01'),
('V002', 'CloudNet Hosting', 'IT Services', 'USA', '2022-04-15'),
('V003', 'CleanPro Ltd', 'Cleaning', 'Ghana', '2023-01-01'),
('V004', 'SafeTransports', 'Logistics', 'Canada', '2023-09-10');

-- EMPLOYEES
CREATE TABLE Employees (
    EmployeeID VARCHAR(10) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Department VARCHAR(50),
    Position VARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(12,2)
);

INSERT INTO Employees VALUES
('E001', 'James Smith', 'Finance', 'Accountant', '2021-11-01', 45000),
('E002', 'Sarah Johnson', 'Sales', 'Sales Manager', '2022-02-12', 60000),
('E003', 'David Wilson', 'IT', 'IT Specialist', '2022-06-05', 52000),
('E004', 'Mary Adams', 'HR', 'HR Officer', '2023-03-10', 40000),
('E005', 'Peter Brown', 'Finance', 'CFO', '2023-07-01', 95000);

-- ACCOUNTS
CREATE TABLE Accounts (
    AccountID VARCHAR(10) PRIMARY KEY,
    AccountName VARCHAR(50),
    Type VARCHAR(20)
);

INSERT INTO Accounts VALUES
('A100', 'Cash', 'Asset'),
('A200', 'Accounts Receivable', 'Asset'),
('A300', 'Accounts Payable', 'Liability'),
('A400', 'Revenue', 'Revenue'),
('A500', 'Expenses', 'Expense'),
('A600', 'Salaries Payable', 'Liability'),
('A700', 'Equity', 'Equity');

-- ===============================
-- INVOICES
-- ===============================
CREATE TABLE Invoices (
    InvoiceID VARCHAR(10) PRIMARY KEY,
    CustomerID VARCHAR(10) FOREIGN KEY REFERENCES Customers(CustomerID),
    InvoiceDate DATE,
    DueDate DATE,
    TotalAmount DECIMAL(12,2),
    Status VARCHAR(20)
);

INSERT INTO Invoices VALUES
('I001', 'C001', '2023-01-20', '2023-02-20', 12000, 'Paid'),
('I002', 'C002', '2023-02-15', '2023-03-15', 18000, 'Paid'),
('I003', 'C003', '2023-04-10', '2023-05-10', 7500, 'Overdue'),
('I004', 'C004', '2023-06-05', '2023-07-05', 22000, 'Paid'),
('I005', 'C005', '2023-09-12', '2023-10-12', 15500, 'Pending'),
('I006', 'C001', '2024-01-25', '2024-02-25', 9800, 'Pending');

-- PAYMENTS
CREATE TABLE Payments (
    PaymentID VARCHAR(10) PRIMARY KEY,
    InvoiceID VARCHAR(10) FOREIGN KEY REFERENCES Invoices(InvoiceID),
    PaymentDate DATE,
    Amount DECIMAL(12,2),
    Method VARCHAR(20)
);

INSERT INTO Payments VALUES
('P001', 'I001', '2023-02-18', 12000, 'Bank Transfer'),
('P002', 'I002', '2023-03-10', 18000, 'Card'),
('P003', 'I004', '2023-06-25', 22000, 'Bank Transfer');

-- EXPENSES

CREATE TABLE Expenses (
    ExpenseID VARCHAR(10) PRIMARY KEY,
    VendorID VARCHAR(10) FOREIGN KEY REFERENCES Vendors(VendorID),
    ExpenseDate DATE,
    Amount DECIMAL(12,2),
    Category VARCHAR(50),
    AccountID VARCHAR(10) FOREIGN KEY REFERENCES Accounts(AccountID)
);

INSERT INTO Expenses VALUES
('EX001', 'V001', '2023-01-15', 2500, 'Office Supplies', 'A500'),
('EX002', 'V002', '2023-03-20', 4800, 'IT Services', 'A500'),
('EX003', 'V003', '2023-05-12', 1800, 'Cleaning', 'A500'),
('EX004', 'V004', '2023-07-01', 6000, 'Logistics', 'A500'),
('EX005', 'V001', '2023-11-10', 2700, 'Office Supplies', 'A500');


-- BUDGETS

CREATE TABLE Budgets (
    BudgetID VARCHAR(10) PRIMARY KEY,
    Department VARCHAR(50),
    Year INT,
    BudgetAmount DECIMAL(12,2),
    ActualSpent DECIMAL(12,2) NULL
);

INSERT INTO Budgets VALUES
('B001', 'Finance', 2023, 120000, 118500),
('B002', 'Sales', 2023, 150000, 142300),
('B003', 'IT', 2023, 90000, 94000),
('B004', 'HR', 2023, 60000, 58000),
('B005', 'Finance', 2024, 130000, NULL);

--BASIC KPIs
--Q.1. List all customers by country.
select * from Customers
--solution
select CustomerName,Country from Customers

--Q.2. Find the total number of invoices raised in 2023.
select * from Invoices
--solution
select count(InvoiceID)no_of_invoices,year(InvoiceDate)[year] from Invoices
where year(InvoiceDate)=2023 group by year(InvoiceDate)

--Q.3. Get the total revenue per customer (sum of invoice amounts grouped by customer).
select * from Invoices
--solution
select sum(TotalAmount)totalrevenue,CustomerID from Invoices group by CustomerID

--Q.4. Show all employees who work in the Finance department.
select * from Employees
--solution
select * from Employees where Department='finance'

--Q.5. Write a query to find the distinct job titles of all employees.
select * from Employees
--solution
select FullName,Position from Employees

--Q.6. Retrieve all vendors located in the United States.
select * from Vendors
--solution
select * from Vendors where Country='usa'

--Q.7. Retrieve all invoices with a total amount greater than 10,000
select * from Invoices
--solution
select * from Invoices where TotalAmount>10000

--Q.8.Show the total expenses for each category from the Expenses table.
select * from Expenses
--solution
select sum(Amount)total_exp,Category from Expenses group by Category

--Q.9. List the top 3 highest-paid employees.
select * from Employees
--solution
select top 3 FullName,Salary from Employees order by Salary desc

--Q.10. Find the total number of customers in each country.
select * from Customers
--solution
select count(CustomerID)no_of_customers,Country from Customers group by Country

--Q.11. Retrieve all invoices that are currently pending.
select * from Invoices
--solution
select * from Invoices where Status='pending'

--Q.12. Show the total payment amount received for each invoice.
select * from Payments
select * from Invoices
--solution
select PaymentID,InvoiceID,Amount from Payments

--Q.13.List all expenses that were made in the year 2023.
select * from Expenses
--solution
select * from Expenses where year(ExpenseDate)=2023

--Q.14. Retrieve all invoices along with the customer name for each invoice.
select * from Invoices
select * from Customers
--solution
select i.InvoiceID,i.CustomerID,c.CustomerName
from Invoices i join Customers c on i.CustomerID=c.CustomerID

--Q.15. Show all vendors who have provided office supplies.
select * from Vendors
--solution
select * from Vendors where Category='office supplies'

--Q.16. Find the average salary of employees in the company.
select  * from Employees
--solution
select avg(Salary)avg_salary from Employees

--Q.17. List all invoices that are paid and have an amount greater than 15,000.
select * from Invoices
--solution
select * from Invoices where Status='paid' and TotalAmount>15000

--Q.18. Retrieve all employees who were hired after January 1, 2023.
select * from Employees
--solution
select * from Employees where HireDate > '2023-01-01'

--Q.19. Show the total revenue generated in 2023 (sum of all invoice amounts for that year).
select * from Invoices
--solution
select sum(TotalAmount)total_revenue from Invoices where year(InvoiceDate)=2023

--Q.20. List all invoices along with their payment status  show whether they 
--have been paid in full, partially paid, or not paid
select * from Invoices
--solution
select InvoiceID,Status,
choose(case when Status='paid' then 1
when Status='overdue'then 2
when Status='pending' then 3
end,
'paid in full',
'partially paid',
'not paid')as payment_status
from Invoices

-- INTERMEDIATE KPIs

--Q.1. Calculate the Days Sales Outstanding (DSO) for the company.
--DSO = Average number of days between InvoiceDate and PaymentDate for invoices that have been paid.
select * from Payments
select * from Invoices
--solution
select avg(DATEDIFF(DAY,i.InvoiceDate,p.PaymentDate))avg_days
from Payments p join Invoices i on p.InvoiceID=i.InvoiceID where i.Status='paid'

--Q.2. Calculate the budget variance for each department.
--Budget variance = BudgetAmount – ActualSpent
--Show Department, Year, BudgetAmount, ActualSpent, and Variance.
select * from Budgets
--solution
select Department,Year,BudgetAmount,ActualSpent,(BudgetAmount-ActualSpent)as variance  
from Budgets 

--Q.3. Find the top 5 customers who generated the highest total revenue in 2023.
select * from Customers
select * from Invoices
--solution
select top 5 c.CustomerID,c.CustomerName,i.TotalAmount
from Invoices i join Customers c on i.CustomerID=c.CustomerID where year(i.InvoiceDate)=2023
order by i.TotalAmount desc
--Q.4. Find the average payment delay per customer.
--Payment delay = difference (in days) between InvoiceDate and PaymentDate.
--Show CustomerName and their average delay.
select * from Invoices
select * from Payments
select * from Customers
--solution
select DATEDIFF(DAY,i.InvoiceDate,p.PaymentDate)paymentdelay,c.CustomerName,c.CustomerID
from Invoices i join Payments p on i.InvoiceID=p.InvoiceID 
join Customers c on i.CustomerID=c.CustomerID
group by c.CustomerName,i.InvoiceDate,p.PaymentDate,c.CustomerID

--Q.5. Identify the top 3 departments with the highest total expenses in 2023.
select * from Budgets
--solution
select top 3 sum(BudgetAmount)total_exp,Department,Year
from Budgets where Year=2023 group by Department,Year
--Q.6. Find all customers who have more than one invoice in the dataset.
select * from Invoices
--solution
select count(InvoiceID)no_of_invoices,CustomerID from Invoices 
 group by CustomerID having COUNT(InvoiceID)>1
--Q.7. Write a query to find the total number of customers from each country in the Customers table.
--Display the country and the customer count, sorted from highest to lowest.
select * from Customers
--solution
select count(CustomerID)no_of_cust,Country from Customers group by Country order by no_of_cust desc
--Q.8. Write a query to find the invoice with the highest total amount in the invoices table.
select * from Invoices
--solution
select top 1 InvoiceID,TotalAmount from Invoices order by TotalAmount desc
--Q.9. Write a query to find the average salary per department from the employees table.
select * from Employees
--solution
select avg(Salary)avg_salary,Department from Employees group by Department
--Q.10. Write a query to find all invoices that are overdue.
select * from Invoices
--solution
select * from Invoices where Status='overdue'

--ADVANCED KPIs

--Q.1. Find the top 3 customers by total payments in 2023, and
--also show how much more each customer paid compared to the average payment of all customers in 2023.

select * from Invoices
--solution

select  top 3 TotalAmount,CustomerID,(TotalAmount-
(select avg(TotalAmount)avgtotal from Invoices where year(InvoiceDate)=2023 )) compare
from Invoices where year(InvoiceDate)=2023
order by compare desc

--Q.2. Find the top 5 invoices with the highest delays in payment for 2023. For each invoice, show:
--Invoice ID
--Customer Name
--Invoice Date
--Payment Date
--Delay in days (PaymentDate - InvoiceDate)
--Rank of the delay (using a window function)
select * from Invoices
select * from Payments
select * from Customers
--solution
with deley as(
select i.InvoiceID as invoice,c.CustomerName as cusname,i.InvoiceDate as invdate
,p.PaymentDate as paydate,
datediff(DAY,i.InvoiceDate,p.PaymentDate)delaydays
from Invoices i join Payments p on i.InvoiceID=p.InvoiceID  join
Customers c on i.CustomerID=c.CustomerID where year(p.PaymentDate)=2023)
select invoice,cusname,invdate,paydate,delaydays,
rank()over (order by delaydays desc)[rank] from deley
--Q.3. Analyze monthly revenue trends for 2023 and identify any month where revenue decreased
--compared to the previous month. Use a CTE and the LAG() window function. Display:
--Month
--Total Revenue
--Previous Month Revenue
--Difference
--Indicator (Increase/Decrease)
select * from Invoices
--solution
with monthlyrevenue as
(select MONTH(InvoiceDate)[month],sum(TotalAmount)as totalrevenue,
lag(TotalAmount)over(order by MONTH(InvoiceDate)  )as prevmonthrev
from Invoices
where year(InvoiceDate)=2023 group by month(InvoiceDate),TotalAmount)
select [month],totalrevenue,prevmonthrev,(totalrevenue-prevmonthrev)as diff,
CHOOSE(case when (totalrevenue-prevmonthrev)>0 then 1
when (totalrevenue-prevmonthrev)<0 then 2
end,
'increased',
'decreased')as indicator
from monthlyrevenue

--Q.4. Find the top 3 customers who have made the largest total payments.Display CustomerName and TotalPaid.
select * from Customers
select * from Payments
select * from Invoices
--solution
select top 3 c.CustomerName,i.TotalAmount from Invoices i 
join Customers c on i.CustomerID=c.CustomerID where i.Status='paid' order by TotalAmount desc
--Q.5. Calculate the percentage contribution of each customer to the total revenue in 2023.
--Show: CustomerName, TotalRevenue, RevenuePercentage.
--Round the percentage to 2 decimal places.
select * from Customers
select * from Invoices
--solution

select  i.CustomerID,
round(sum(i.TotalAmount)over (partition by i.customerid)*
100.0/sum(i.TotalAmount)over(),2 )as [percentage],c.CustomerName,
(select sum(TotalAmount) from Invoices)as totalrevenue from Invoices i join Customers c
on i.CustomerID=c.CustomerID where year(i.InvoiceDate)=2023 order by i.CustomerID

--Q.6. Write a query to calculate the average, minimum, and maximum invoice amount per month in 2023.
   select * from Invoices
 --solution
 select avg(TotalAmount)avgamt,min(TotalAmount)mintotal,max(TotalAmount)maxtotal,month(InvoiceDate)[month]
 from Invoices where year(InvoiceDate)=2023 group by month(InvoiceDate) 
--Q.7. Find customers who have not made any payments in 2023.
select * from Invoices
--solution
select * from Invoices where Status='pending' and year(InvoiceDate)=2023
--Q.8. Find the customers whose total payments are less than 50% of their total invoice amount in 2023.
select * from Invoices
--solution

select CustomerID,TotalAmount,(select sum(TotalAmount)/2 from Invoices) as  salary
from Invoices  where TotalAmount< (select sum(TotalAmount)/2 from Invoices where year(InvoiceDate)=2023) 

--Q.9.Rank customers by total payments in 2023 using a window function so you can 
--see the rank of each customer.
select * from Invoices
--solution
select CustomerID,TotalAmount,year(InvoiceDate)[year],rank()over(order by totalamount desc)[rank] 
from Invoices where year(InvoiceDate)=2023

--Q.10. Find all customers whose total payments in 2023 are greater than the 
--average payment of all customers in 2023.
select * from Invoices
--solution
select CustomerID,InvoiceID,TotalAmount from Invoices where year(InvoiceDate)=2023 
and TotalAmount>(select avg(TotalAmount) from Invoices where year(InvoiceDate)=2023)

--Q.11. Use a Common Table Expression (CTE) to find the top 5 customers with the
--highest total payments in 2023.
select * from Invoices
--solution
with top5 as (
select CustomerID,year(InvoiceDate)[year],TotalAmount
from Invoices where year(InvoiceDate)=2023  )
select top 5 customerid,[year],totalamount from top5 order by totalamount desc
--Q.12. Find the top 3 departments with the highest average salary in 2023.
select * from Employees
--solution
select top 3 Department,avg(Salary)avgsalary from Employees 
where year(HireDate)=2023 group by Department order by avgsalary desc
--Q.13. Write a query to find the total salary paid per department in 2023,
--and also calculate what percentage of the company’s total 2023 salary each department represents.
select * from Employees
--solution
select Department,
 ROUND(sum(Salary)over(partition by department)*100/
sum(Salary)over (),2)as [percentage],Salary
from Employees where year(HireDate)=2023 group by Department,Salary
--Q.14. Rank departments by total salary in 2023 using a window function, and also 
--show each department’s percentage of total salary.
select * from Employees
--solution
select Department,sum(Salary)totalsalary,rank()over(order by salary desc)[rank],
round(sum(Salary)over(partition by department)*100/sum(Salary)over(),4)as [percentage]
from Employees where year(HireDate)=2023group by Department,Salary
