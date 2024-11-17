-- Patient records (EHR/EMR)
CREATE TABLE Patients (
  PatientID INT AUTO_INCREMENT PRIMARY KEY,
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  DateOfBirth DATE,
  Gender ENUM('Male', 'Female', 'Other'),
  Address VARCHAR(255),
  PhoneNumber VARCHAR(15),
  Email VARCHAR(100),
  EmergencyContact VARCHAR(100),
  EmergencyContactPhone VARCHAR(15),
  MedicalHistory TEXT
);

-- Appointment scheduling
CREATE TABLE Appointments (
  AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
  PatientID INT,
  DoctorID INT,
  AppointmentDate DATETIME,
  ReasonForVisit VARCHAR(255),
  Status ENUM('Scheduled', 'Completed', 'Cancelled'),
  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
  FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Billing and insurance claims
CREATE TABLE Billing (
  BillingID INT AUTO_INCREMENT PRIMARY KEY,
  PatientID INT,
  AppointmentID INT,
  Amount DECIMAL(10, 2),
  BillingDate DATE,
  Status ENUM('Paid', 'Unpaid', 'Pending'),
  InsuranceClaimID INT,
  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
  FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);

CREATE TABLE InsuranceClaims (
  InsuranceClaimID INT AUTO_INCREMENT PRIMARY KEY,
  PatientID INT,
  InsuranceProvider VARCHAR(100),
  PolicyNumber VARCHAR(50),
  ClaimAmount DECIMAL(10, 2),
  ClaimDate DATE,
  Status ENUM('Submitted', 'Approved', 'Rejected'),
  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- Laboratory results
CREATE TABLE LaboratoryResults (
  LabResultID INT AUTO_INCREMENT PRIMARY KEY,
  PatientID INT,
  TestName VARCHAR(100),
  TestDate DATE,
  Result TEXT,
  DoctorID INT,
  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
  FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Medication tracking
CREATE TABLE Medications (
  MedicationID INT AUTO_INCREMENT PRIMARY KEY,
  PatientID INT,
  MedicationName VARCHAR(100),
  Dosage VARCHAR(50),
  StartDate DATE,
  EndDate DATE,
  PrescribingDoctorID INT,
  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
  FOREIGN KEY (PrescribingDoctorID) REFERENCES Doctors(DoctorID)
);

-- Doctors table for reference
CREATE TABLE Doctors (
  DoctorID INT AUTO_INCREMENT PRIMARY KEY,
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  Specialty VARCHAR(100),
  PhoneNumber VARCHAR(15),
  Email VARCHAR(100)
);

-- Query to find all patients who have had an appointment in the last 30 days
SELECT p.FirstName, p.LastName, a.AppointmentDate
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
WHERE a.AppointmentDate >= CURDATE() - INTERVAL 30 DAY;

-- Query to find the total amount billed to each patient
SELECT p.FirstName, p.LastName, SUM(b.Amount) AS TotalBilled
FROM Patients p
JOIN Billing b ON p.PatientID = b.PatientID
GROUP BY p.PatientID;

-- Query to find all doctors who have prescribed medications in the last 6 months
SELECT DISTINCT d.FirstName, d.LastName, d.Specialty
FROM Doctors d
JOIN Medications m ON d.DoctorID = m.PrescribingDoctorID
WHERE m.StartDate >= CURDATE() - INTERVAL 6 MONTH;

-- Query to find all patients with rejected insurance claims
SELECT p.FirstName, p.LastName, ic.InsuranceProvider, ic.ClaimAmount
FROM Patients p
JOIN InsuranceClaims ic ON p.PatientID = ic.PatientID
WHERE ic.Status = 'Rejected';

-- Query to find the average number of appointments per doctor
SELECT d.FirstName, d.LastName, COUNT(a.AppointmentID) / COUNT(DISTINCT a.DoctorID) AS AvgAppointments
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID;

-- Query to find all laboratory results for a specific patient
SELECT lr.TestName, lr.TestDate, lr.Result, d.FirstName AS DoctorFirstName, d.LastName AS DoctorLastName
FROM LaboratoryResults lr
JOIN Doctors d ON lr.DoctorID = d.DoctorID
WHERE lr.PatientID = 1; -- Replace with the specific PatientID
