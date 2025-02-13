--Create Database
CREATE DATABASE OnlineBookstore;

--Switch to the database
\c OnlineBookstore;

--Create Tables
DROP TABLE IF EXISTS Books;      --create Books table
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,  -- Fixed syntax for PRIMARY KEY
    Title VARCHAR(100),          -- Fixed syntax for VARCHAR
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,          -- Fixed incorrect datatype 'NT' to 'INT'
    Price NUMERIC(10,2),         -- Fixed syntax for NUMERIC (added precision & scale)
    Stock INT
);

DROP TABLE IF EXISTS Customers;  -- Create customer table
CREATE TABLE Customers (
	CUSTOMER_ID SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(15),
	City VARCHAR(50),
	Country VARCHAR(150)
);

DROP TABLE IF EXISTS Orders;  -- Create order table
CREATE TABLE Orders (
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10,2)
);

SELECT *FROM Books;
SELECT *FROM Customers;
SELECT *FROM Orders;

-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'D:\DS Training\PGPDS_AI\postgresdb\Books.csv' 
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'D:\DS Training\PGPDS_AI\postgresdb\Customers.csv' 
CSV HEADER;

--Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'D:\DS Training\PGPDS_AI\postgresdb\Orders.csv'
CSV HEADER;

-- 1) Retrieve all books in the "Fiction" genre:
SELECT *FROM Books WHERE Genre = 'Fiction';

-- 2) Find books published after the year 1950:
SELECT *FROM Books WHERE Published_Year > 1950;

-- 3) List all customers from the Canada:
SELECT *FROM Customers WHERE Country='Canada';

-- 4) Show orders placed in November 2023:
SELECT *FROM Orders WHERE Order_date BETWEEN '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT SUM(Stock) as "Total_Stock" FROM Books;

-- 6) Find the details of the most expensive book:
SELECT *FROM Books Order BY Price DESC LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT *FROM Orders WHERE Quantity >1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT *FROM Orders WHERE Total_Amount>20;

-- 9) List all genres available in the Books table:
SELECT DISTINCT(Genre) FROM Books;

-- 10) Find the book with the lowest stock:
SELECT *FROM Books Order By Stock LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(Total_Amount) as "Total_Revenue" FROM Orders;


-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

SELECT b.Genre, SUM(o.Quantity) AS Total_Books_Sold 
FROM Orders o
JOIN Books b
ON o.Order_ID = b.Book_ID
GROUP BY b.Genre;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT AVG(Price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:

SELECT o.Customer_ID, c.Name, COUNT(o.Order_ID) AS Order_Count
FROM Orders o
Join Customers c
ON o.Customer_ID = c.Customer_ID
GROUP BY o.Customer_ID, c.Name
HAVING COUNT (Order_ID) >= 2;

-- 4) Find the most frequently ordered book:
SELECT *FROM orders ORDER BY Quantity DESC LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT *FROM Books WHERE Genre = 'Fantasy' ORDER BY Price DESC LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:

SELECT b.Author, SUM(o.Quantity) AS Total_Books_Sold
FROM Orders o
JOIN Books b
ON b.Book_ID = o.Book_ID
GROUP BY b.Author

-- 7) List the cities where customers who spent over $30 are located:
SELECT DISTINCT c.City, Total_Amount
FROM Orders o
JOIN Customers c
ON c.Customer_ID = o.Customer_ID
WHERE o.Total_Amount >30;

select *from orders
select *From customers
-- 8) Find the customer who spent the most on orders:
SELECT c.Customer_ID, c.Name, SUM(o.Total_Amount) AS Total_Spend
FROM Orders o
JOIN Customers c
ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name
Order BY Total_Spend DESC LIMIT 1;

--9) Calculate the stock remaining after fulfilling all orders:

SELECT b.Book_ID, b.Title, b.Stock, COALESCE(SUM(o.Quantity),0) AS Order_Quantity,
   b.Stock - COALESCE(SUM(o.Quantity),0) AS Remaining_Quantity
FROM Books b
LEFT JOIN Orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID



