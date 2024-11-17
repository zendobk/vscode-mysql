-- Customer account management
CREATE TABLE Customers (
  CustomerID INT AUTO_INCREMENT PRIMARY KEY,
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  Email VARCHAR(100),
  Phone VARCHAR(15),
  Address VARCHAR(255),
  DateOfBirth DATE
);

CREATE TABLE Accounts (
  AccountID INT AUTO_INCREMENT PRIMARY KEY,
  CustomerID INT,
  AccountType VARCHAR(50),
  Balance DECIMAL(15, 2),
  CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Transaction tracking
CREATE TABLE Transactions (
  TransactionID INT AUTO_INCREMENT PRIMARY KEY,
  AccountID INT,
  TransactionType VARCHAR(50),
  Amount DECIMAL(15, 2),
  TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- Loan and mortgage systems
CREATE TABLE Loans (
  LoanID INT AUTO_INCREMENT PRIMARY KEY,
  CustomerID INT,
  LoanType VARCHAR(50),
  LoanAmount DECIMAL(15, 2),
  InterestRate DECIMAL(5, 2),
  StartDate DATE,
  EndDate DATE,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Mortgages (
  MortgageID INT AUTO_INCREMENT PRIMARY KEY,
  CustomerID INT,
  PropertyAddress VARCHAR(255),
  MortgageAmount DECIMAL(15, 2),
  InterestRate DECIMAL(5, 2),
  StartDate DATE,
  EndDate DATE,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Fraud detection
CREATE TABLE FraudAlerts (
  AlertID INT AUTO_INCREMENT PRIMARY KEY,
  AccountID INT,
  AlertType VARCHAR(50),
  AlertDescription TEXT,
  AlertDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- Compliance and audit logs
CREATE TABLE AuditLogs (
  LogID INT AUTO_INCREMENT PRIMARY KEY,
  UserID INT,
  ActionType VARCHAR(50),
  ActionDescription TEXT,
  ActionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample queries

-- Query to get the total balance of all accounts for a specific customer
SELECT c.CustomerID, c.FirstName, c.LastName, SUM(a.Balance) AS TotalBalance
FROM Customers c
JOIN Accounts a ON c.CustomerID = a.CustomerID
WHERE c.CustomerID = 1
GROUP BY c.CustomerID, c.FirstName, c.LastName;

-- Query to get the average loan amount and interest rate for each loan type
SELECT LoanType, AVG(LoanAmount) AS AverageLoanAmount, AVG(InterestRate) AS AverageInterestRate
FROM Loans
GROUP BY LoanType;

-- Query to get the number of transactions per account
SELECT a.AccountID, COUNT(t.TransactionID) AS TransactionCount
FROM Accounts a
LEFT JOIN Transactions t ON a.AccountID = t.AccountID
GROUP BY a.AccountID;

-- Query to get customers with more than one account
SELECT c.CustomerID, c.FirstName, c.LastName, COUNT(a.AccountID) AS AccountCount
FROM Customers c
JOIN Accounts a ON c.CustomerID = a.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING COUNT(a.AccountID) > 1;

-- Query to get the latest transaction for each account
SELECT t1.*
FROM Transactions t1
JOIN (
  SELECT AccountID, MAX(TransactionDate) AS LatestTransactionDate
  FROM Transactions
  GROUP BY AccountID
) t2 ON t1.AccountID = t2.AccountID AND t1.TransactionDate = t2.LatestTransactionDate;

-- Query to get the total loan amount and mortgage amount for each customer
SELECT c.CustomerID, c.FirstName, c.LastName,
       COALESCE(SUM(l.LoanAmount), 0) AS TotalLoanAmount,
       COALESCE(SUM(m.MortgageAmount), 0) AS TotalMortgageAmount
FROM Customers c
LEFT JOIN Loans l ON c.CustomerID = l.CustomerID
LEFT JOIN Mortgages m ON c.CustomerID = m.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName;
