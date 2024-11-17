-- Create tables for Product Catalogs
CREATE TABLE Products (
  ProductID INT AUTO_INCREMENT PRIMARY KEY,
  ProductName VARCHAR(255) NOT NULL,
  Description TEXT,
  Price DECIMAL(10, 2) NOT NULL,
  Category VARCHAR(100),
  StockQuantity INT NOT NULL
);

-- Create tables for Customer Orders and Transactions
CREATE TABLE Customers (
  CustomerID INT AUTO_INCREMENT PRIMARY KEY,
  FirstName VARCHAR(100) NOT NULL,
  LastName VARCHAR(100) NOT NULL,
  Email VARCHAR(255) NOT NULL UNIQUE,
  Phone VARCHAR(20)
);

CREATE TABLE Orders (
  OrderID INT AUTO_INCREMENT PRIMARY KEY,
  CustomerID INT,
  OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  TotalAmount DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
  OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
  OrderID INT,
  ProductID INT,
  Quantity INT NOT NULL,
  Price DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Create tables for Payment Processing
CREATE TABLE Payments (
  PaymentID INT AUTO_INCREMENT PRIMARY KEY,
  OrderID INT,
  PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  Amount DECIMAL(10, 2) NOT NULL,
  PaymentMethod VARCHAR(50),
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Create tables for Inventory Management
CREATE TABLE Inventory (
  InventoryID INT AUTO_INCREMENT PRIMARY KEY,
  ProductID INT,
  Quantity INT NOT NULL,
  LastUpdated DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Create tables for User Reviews
CREATE TABLE Reviews (
  ReviewID INT AUTO_INCREMENT PRIMARY KEY,
  ProductID INT,
  CustomerID INT,
  Rating INT CHECK (Rating >= 1 AND Rating <= 5),
  Comment TEXT,
  ReviewDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Sample queries to retrieve data

-- Get total sales amount for each product
SELECT
  Products.ProductID,
  Products.ProductName,
  SUM(OrderDetails.Quantity * OrderDetails.Price) AS TotalSales
FROM
  OrderDetails
JOIN
  Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY
  Products.ProductID, Products.ProductName;

-- Get the number of orders placed by each customer
SELECT
  Customers.CustomerID,
  Customers.FirstName,
  Customers.LastName,
  COUNT(Orders.OrderID) AS NumberOfOrders
FROM
  Orders
JOIN
  Customers ON Orders.CustomerID = Customers.CustomerID
GROUP BY
  Customers.CustomerID, Customers.FirstName, Customers.LastName;

-- Get the average rating for each product
SELECT
  Products.ProductID,
  Products.ProductName,
  AVG(Reviews.Rating) AS AverageRating
FROM
  Reviews
JOIN
  Products ON Reviews.ProductID = Products.ProductID
GROUP BY
  Products.ProductID, Products.ProductName;

-- Get the total amount spent by each customer
SELECT
  Customers.CustomerID,
  Customers.FirstName,
  Customers.LastName,
  SUM(Orders.TotalAmount) AS TotalSpent
FROM
  Orders
JOIN
  Customers ON Orders.CustomerID = Customers.CustomerID
GROUP BY
  Customers.CustomerID, Customers.FirstName, Customers.LastName;

-- Get the most recent order for each customer
SELECT
  Customers.CustomerID,
  Customers.FirstName,
  Customers.LastName,
  Orders.OrderID,
  Orders.OrderDate
FROM
  Orders
JOIN
  Customers ON Orders.CustomerID = Customers.CustomerID
WHERE
  Orders.OrderDate = (
    SELECT MAX(OrderDate)
    FROM Orders AS O
    WHERE O.CustomerID = Customers.CustomerID
  );
