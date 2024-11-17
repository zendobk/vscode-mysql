-- Create table for Property Listings
CREATE TABLE PropertyListings (
  PropertyID INT AUTO_INCREMENT PRIMARY KEY,
  Address VARCHAR(255) NOT NULL,
  City VARCHAR(100) NOT NULL,
  State VARCHAR(100) NOT NULL,
  ZipCode VARCHAR(20) NOT NULL,
  Price DECIMAL(15, 2) NOT NULL,
  Bedrooms INT NOT NULL,
  Bathrooms INT NOT NULL,
  SquareFeet INT NOT NULL,
  ListingDate DATE NOT NULL,
  AgentID INT,
  FOREIGN KEY (AgentID) REFERENCES Agents(AgentID)
);

-- Create table for Agents
CREATE TABLE Agents (
  AgentID INT AUTO_INCREMENT PRIMARY KEY,
  FirstName VARCHAR(100) NOT NULL,
  LastName VARCHAR(100) NOT NULL,
  Email VARCHAR(100) NOT NULL,
  Phone VARCHAR(20) NOT NULL
);

-- Create table for Customers
CREATE TABLE Customers (
  CustomerID INT AUTO_INCREMENT PRIMARY KEY,
  FirstName VARCHAR(100) NOT NULL,
  LastName VARCHAR(100) NOT NULL,
  Email VARCHAR(100) NOT NULL,
  Phone VARCHAR(20) NOT NULL
);

-- Create table for Transaction Histories
CREATE TABLE TransactionHistories (
  TransactionID INT AUTO_INCREMENT PRIMARY KEY,
  PropertyID INT,
  CustomerID INT,
  AgentID INT,
  TransactionDate DATE NOT NULL,
  SalePrice DECIMAL(15, 2) NOT NULL,
  FOREIGN KEY (PropertyID) REFERENCES PropertyListings(PropertyID),
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
  FOREIGN KEY (AgentID) REFERENCES Agents(AgentID)
);

-- Create table for Geographic Information (Maps)
CREATE TABLE GeographicInformation (
  GeoID INT AUTO_INCREMENT PRIMARY KEY,
  PropertyID INT,
  Latitude DECIMAL(10, 8) NOT NULL,
  Longitude DECIMAL(11, 8) NOT NULL,
  FOREIGN KEY (PropertyID) REFERENCES PropertyListings(PropertyID)
);

-- Create table for Pricing Trends
CREATE TABLE PricingTrends (
  TrendID INT AUTO_INCREMENT PRIMARY KEY,
  PropertyID INT,
  Date DATE NOT NULL,
  Price DECIMAL(15, 2) NOT NULL,
  FOREIGN KEY (PropertyID) REFERENCES PropertyListings(PropertyID)
);

-- Query to find the average price of properties listed in each city
SELECT City, AVG(Price) AS AveragePrice
FROM PropertyListings
GROUP BY City;

-- Query to find the top 5 most expensive properties
SELECT *
FROM PropertyListings
ORDER BY Price DESC
LIMIT 5;

-- Query to find the total number of transactions made by each agent
SELECT Agents.AgentID, Agents.FirstName, Agents.LastName, COUNT(TransactionHistories.TransactionID) AS TotalTransactions
FROM Agents
JOIN TransactionHistories ON Agents.AgentID = TransactionHistories.AgentID
GROUP BY Agents.AgentID, Agents.FirstName, Agents.LastName;

-- Query to find the properties sold by a specific agent within a date range
SELECT PropertyListings.*
FROM PropertyListings
JOIN TransactionHistories ON PropertyListings.PropertyID = TransactionHistories.PropertyID
WHERE TransactionHistories.AgentID = 1
AND TransactionHistories.TransactionDate BETWEEN '2023-01-01' AND '2023-12-31';

-- Query to find the trend of property prices for a specific property
SELECT Date, Price
FROM PricingTrends
WHERE PropertyID = 1
ORDER BY Date;

-- Query to find properties within a specific geographic area (latitude and longitude range)
SELECT PropertyListings.*
FROM PropertyListings
JOIN GeographicInformation ON PropertyListings.PropertyID = GeographicInformation.PropertyID
WHERE GeographicInformation.Latitude BETWEEN 34.0000 AND 36.0000
AND GeographicInformation.Longitude BETWEEN -118.0000 AND -117.0000;
